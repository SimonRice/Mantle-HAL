//
//  Order.h
//  Mantle-HAL.Tests
//
//  Created by Simon Rice on 19/09/2014.
//  Copyright (c) 2014 Simon Rice. All rights reserved.
//

#import "MTLHALResource.h"

@interface Order : MTLHALResource

typedef enum : NSUInteger {
    OrderStatusProcessing,
    OrderStatusShipped
} OrderStatus;

@property (nonatomic, readonly) float total;
@property (nonatomic, readonly) OrderStatus status;

@property (nonatomic, strong, readonly) NSString *currency;

@end
