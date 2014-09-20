//
//  OrderList.m
//  Mantle-HAL.Tests
//
//  Created by Simon Rice on 19/09/2014.
//  Copyright (c) 2014 Simon Rice. All rights reserved.
//

#import "OrderList.h"

@implementation OrderList

- (NSArray *)orders {
    return [self resourcesForRelation:@"ea:order"];
}

@end
