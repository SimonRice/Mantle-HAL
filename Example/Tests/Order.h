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
