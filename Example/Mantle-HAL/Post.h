//
//  Post.h
//  Mantle-HAL
//
//  Created by Simon Rice on 13/09/2014.
//  Copyright (c) 2014 Simon Rice. All rights reserved.
//

#import "MTLHALResource.h"

@interface Post : MTLHALResource

@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong, readonly) NSDate *createdAt;

@end
