//
//  Contact.h
//  Mantle-HAL.Tests
//
//  Created by Simon Rice on 17/09/2014.
//  Copyright (c) 2014 Simon Rice. All rights reserved.
//

#import <Mantle-HAL/MTLHALResource.h>

#import "Address.h"

@interface Contact : MTLHALResource

@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;

@property (nonatomic, strong, readonly) Address *homeAddress;
@property (nonatomic, strong, readonly) Address *workAddress;

@end
