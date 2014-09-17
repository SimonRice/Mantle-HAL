//
//  Contact.m
//  Mantle-HAL.Tests
//
//  Created by Simon Rice on 17/09/2014.
//  Copyright (c) 2014 Simon Rice. All rights reserved.
//

#import "Contact.h"

@implementation Contact

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSMutableDictionary *keyPaths = [super JSONKeyPathsByPropertyKey].mutableCopy;
    
    [keyPaths addEntriesFromDictionary:@{
                                         @"firstName": @"first_name",
                                         @"lastName": @"last_name"
                                         }];
    
    return keyPaths;
}

- (Address *)homeAddress {
    return (Address *)[self resourceForRelation:@"addr:home"];
}

- (Address *)workAddress {
    return (Address *)[self resourceForRelation:@"addr:work"];
}

@end
