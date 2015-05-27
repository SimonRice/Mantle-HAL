#import "MTLHALResource.h"

#import "Address.h"

@interface Contact : MTLHALResource

@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;

@property (nonatomic, strong, readonly) Address *homeAddress;
@property (nonatomic, strong, readonly) Address *workAddress;

@end
