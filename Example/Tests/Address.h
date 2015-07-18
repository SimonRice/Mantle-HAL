#import "MTLHALResource.h"

@interface Address : MTLHALResource

@property (nonatomic, strong) NSString *street;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *state;

@end
