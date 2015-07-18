//
//  Post.m
//  Mantle-HAL
//
//  Created by Simon Rice on 13/09/2014.
//  Copyright (c) 2014 Simon Rice. All rights reserved.
//

#import "Post.h"

@implementation Post

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSMutableDictionary *keyPaths = [super JSONKeyPathsByPropertyKey].mutableCopy;
    
    [keyPaths addEntriesFromDictionary:@{
                                         @"createdAt": @"created_at"
                                         }];
    
    return keyPaths;
}

+ (NSValueTransformer *)createdAtJSONTransformer {
    static dispatch_once_t onceMark;
    static NSDateFormatter *dateFormatter = nil;
    
    dispatch_once(&onceMark, ^{
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.locale = locale;
        dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZZZZ";
    });
    
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *str) {
        return [dateFormatter dateFromString:str];
    } reverseBlock:^(NSDate *date) {
        return [dateFormatter stringFromDate:date];
    }];
}

@end
