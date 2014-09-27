#import "MTLHALResource.h"

@interface OrderList : MTLHALResource

@property (nonatomic, readonly) NSInteger currentlyProcessing;
@property (nonatomic, readonly) NSInteger shippedToday;

@property (nonatomic, strong, readonly) NSArray *orders;

@end
