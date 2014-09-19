//
//  Order.m
//  Mantle-HAL.Tests
//
//  Created by Simon Rice on 19/09/2014.
//  Copyright (c) 2014 Simon Rice. All rights reserved.
//

#import "Order.h"

@implementation Order

+ (NSValueTransformer *)statusJSONTransformer {
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{
                                                                           @"processing": @(OrderStatusProcessing),
                                                                           @"shipped": @(OrderStatusShipped)
                                                                           }];
}

@end
