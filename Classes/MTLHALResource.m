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
    return [MTLValueTransformer transformerWithBlock:^(NSArray *curieArray) {
        return [MTLJSONAdapter modelsOfClass:MTLHALLink.class fromJSONArray:curieArray error:nil];
    }];
}

+ (NSValueTransformer *)linksJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(NSDictionary *links) {
        NSMutableDictionary *allLinks = [NSMutableDictionary dictionary];
        
        for (NSString *key in links.allKeys) {
            if (![@[@"curie", @"curies"] containsObject:key]) {
                NSArray *linksForKey = @[];
                
                if ([links[key] isKindOfClass:NSArray.class])
                    linksForKey = [MTLJSONAdapter modelsOfClass:MTLHALLink.class fromJSONArray:links[key] error:nil];
                else
                    linksForKey = @[[MTLJSONAdapter modelOfClass:MTLHALLink.class fromJSONDictionary:links[key] error:nil]];
                
                [allLinks setObject:linksForKey forKey:key];
            }
        }
        
        return allLinks;
    }];
}

+ (NSValueTransformer *)embeddedJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(NSDictionary *embeddeDictionary) {
        NSMutableDictionary *allEmbedded = [NSMutableDictionary dictionary];
        
        for (NSString *key in embeddeDictionary.allKeys) {
            __unsafe_unretained Class targetClass = p_classesForRelations[key];
            if (!targetClass)
                targetClass = MTLHALResource.class;
            
            NSArray *resourcesForKey = nil;
            
            if ([embeddeDictionary[key] isKindOfClass:NSArray.class])
                resourcesForKey = [MTLJSONAdapter modelsOfClass:targetClass fromJSONArray:embeddeDictionary[key] error:nil];
            else
                resourcesForKey = @[[MTLJSONAdapter modelOfClass:targetClass fromJSONDictionary:embeddeDictionary[key] error:nil]];
            
            for (MTLHALResource *resource in resourcesForKey)
                [resource setValue:key forKey:@"resourceRelation"];
            
            [allEmbedded setObject:resourcesForKey forKey:key];
        }
        
        return allEmbedded;
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
    return [self resourcesForRelation:relation][0];
}

+ (void)registerClass:(__unsafe_unretained Class)class forRelation:(NSString *)relation
{
    if (!p_classesForRelations)
        p_classesForRelations = [[NSMutableDictionary alloc] initWithObjects:@[class] forKeys:@[relation]];
    else
        [p_classesForRelations setValue:class forKey:relation];
}

@end
