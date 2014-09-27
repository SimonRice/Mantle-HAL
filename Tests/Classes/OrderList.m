#import "OrderList.h"

@implementation OrderList

- (NSArray *)orders {
    return [self resourcesForRelation:@"ea:order"];
}

@end
