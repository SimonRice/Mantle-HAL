/*
 Copyright (C) 2014 Simon Rice
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */

#import "MTLHALResource.h"

@interface MTLHALResource()

@property (nonatomic, strong, readonly) NSArray *curies;
@property (nonatomic, strong, readonly) NSDictionary *embedded;

@end

@implementation MTLHALResource

static NSMutableDictionary *p_classesForRelations;

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"links": @"_links",
             @"embedded": @"_embedded",
             @"curies": @"_links.curies",
             };
}

+ (NSValueTransformer *)curiesJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSArray *curieArray) {
        return [MTLJSONAdapter modelsOfClass:MTLHALLink.class fromJSONArray:curieArray error:nil];
    } reverseBlock:^id(NSArray *curies) {
        return [MTLJSONAdapter JSONArrayFromModels:(curies != nil ? curies : @[])];
    }];
}

+ (NSValueTransformer *)linksJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSDictionary *linksDictionary) {
        NSMutableDictionary *links = [NSMutableDictionary dictionary];
        
        for (NSString *key in linksDictionary.allKeys) {
            if (![@[@"curie", @"curies"] containsObject:key]) {
                NSArray *linksForKey = @[];
                
                if ([linksDictionary[key] isKindOfClass:NSArray.class]) {
                    linksForKey = [MTLJSONAdapter modelsOfClass:MTLHALLink.class fromJSONArray:linksDictionary[key] error:nil];
                } else if ([MTLJSONAdapter modelOfClass:MTLHALLink.class fromJSONDictionary:linksDictionary[key] error:nil]) {
                    linksForKey = @[[MTLJSONAdapter modelOfClass:MTLHALLink.class fromJSONDictionary:linksDictionary[key] error:nil]];
                }
                
                if (linksForKey) {
                    [links setObject:linksForKey forKey:key];
                }
            }
        }
        
        return links;
    } reverseBlock:^id(NSDictionary *links) {
        NSMutableDictionary *linksDictionary = [NSMutableDictionary dictionary];
        
        for (NSString *key in links.allKeys) {
            id linksForKey = nil;
            if ([links[key] count] > 1) {
                linksForKey = [MTLJSONAdapter JSONArrayFromModels:links[key]];
            } else {
                linksForKey = [MTLJSONAdapter JSONDictionaryFromModel:links[key][0]];
            }
            [linksDictionary setObject:linksForKey forKey:key];
        }
        
        return linksDictionary;
    }];
}

+ (NSValueTransformer *)embeddedJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSDictionary *embeddedDictionary) {
        NSMutableDictionary *allEmbedded = [NSMutableDictionary dictionary];
        
        for (NSString *key in embeddedDictionary.allKeys) {
            __unsafe_unretained Class targetClass = p_classesForRelations[key];
            if (!targetClass)
                targetClass = MTLHALResource.class;
            
            NSArray *resourcesForKey = nil;
            
            if ([embeddedDictionary[key] isKindOfClass:NSArray.class]) {
                
                resourcesForKey = [MTLJSONAdapter modelsOfClass:targetClass fromJSONArray:embeddedDictionary[key] error:nil];
            }
            else if ([MTLJSONAdapter modelOfClass:targetClass fromJSONDictionary:embeddedDictionary[key] error:nil]) {
                
                resourcesForKey = @[[MTLJSONAdapter modelOfClass:targetClass fromJSONDictionary:embeddedDictionary[key] error:nil]];
            }
            
            if (resourcesForKey) {
                
                for (MTLHALResource *resource in resourcesForKey) {
                    
                    [resource setValue:key forKey:@"resourceRelation"];
                }
                [allEmbedded setObject:resourcesForKey forKey:key];
            }
        }
        
        return allEmbedded;
    } reverseBlock:^id(NSDictionary *embedded) {
        NSMutableDictionary *embeddedDictionary = [NSMutableDictionary dictionary];
        
        for (NSString *key in embedded.allKeys) {
            id resourcesForKey = nil;
            
            if ([embedded[key] count] == 1)
                resourcesForKey = [MTLJSONAdapter JSONDictionaryFromModel:embedded[key][0]];
            else
                resourcesForKey = [MTLJSONAdapter JSONArrayFromModels:embedded[key]];
            
            [embeddedDictionary setObject:resourcesForKey forKey:key];
        }
        
        return embeddedDictionary;
    }];
}

- (NSString *)extendedHrefForRelation:(NSString *)relation {
    if ([relation isEqualToString:@"self"] && self.resourceRelation)
        relation = self.resourceRelation;
    
    NSArray *components = [relation componentsSeparatedByString:@":"];
    if (components.count < 2)
        return nil;
    
    MTLHALLink *curie = [self p_curieForNamespace:components[0]];
    NSString *relationParamter = [relation substringFromIndex:[components[0] length] + 1];
    
    return [curie.href stringByReplacingOccurrencesOfString:@"{rel}" withString:relationParamter];
}

- (MTLHALLink *)p_curieForNamespace:(NSString *)namespace {
    for (MTLHALLink *curie in self.curies) {
        if ([namespace isEqualToString:curie.name])
            return curie;
    }
    return nil;
}

- (NSArray *)resourcesForRelation:(NSString *)relation {
    if (self.embedded[relation] == [NSNull null])
        return nil;
    
    // Deal with curies being inherited
    NSMutableArray *resources = [NSMutableArray array];
    
    for (MTLHALResource *resource in self.embedded[relation]) {
        NSMutableArray *resourceCuries = [[resource valueForKey:@"curies"] mutableCopy];
        
        if (resourceCuries && resourceCuries.count > 0) {
            for (MTLHALLink *curie in self.curies) {
                MTLHALLink *resourceCurie = [resourceCuries filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name == %@", curie.name]].firstObject;
                
                if (!resourceCurie) {
                    [resourceCuries addObject:curie];
                }
            }
        } else
            resourceCuries = self.curies.mutableCopy;
        
        [resource setValue:resourceCuries forKey:@"curies"];
        [resources addObject:resource];
    }
    
    return resources;
}

- (MTLHALResource *)resourceForRelation:(NSString *)relation {

    if (self.embedded[relation] == [NSNull null]) {
        
        return nil;
    }
    else if (![self resourcesForRelation:relation]) {
        
        return nil;
    }
    else if ([self resourcesForRelation:relation].count == 0) {
        
        return nil;
    }
    else {
        
        return [[self resourcesForRelation:relation]firstObject];
    }
}

+ (void)registerClass:(__unsafe_unretained Class)targetClass forRelation:(NSString *)relation
{
    if (!p_classesForRelations)
        p_classesForRelations = [[NSMutableDictionary alloc] initWithObjects:@[targetClass] forKeys:@[relation]];
    else
        [p_classesForRelations setValue:targetClass forKey:relation];
}

+ (void)registerClassesForRelations:(NSDictionary *)classesForRelations
{
    for (NSString *relation in classesForRelations.allKeys) {
        [self registerClass:classesForRelations[relation] forRelation:relation];
    }
}

@end
