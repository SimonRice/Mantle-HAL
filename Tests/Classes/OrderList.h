//
//  OrderList.h
//  Mantle-HAL.Tests
//
//  Created by Simon Rice on 19/09/2014.
//  Copyright (c) 2014 Simon Rice. All rights reserved.
//

#import "MTLHALResource.h"

@interface OrderList : MTLHALResource

@property (nonatomic, readonly) NSInteger currentlyProcessing;
@property (nonatomic, readonly) NSInteger shippedToday;

@property (nonatomic, strong, readonly) NSArray *orders;

@end
