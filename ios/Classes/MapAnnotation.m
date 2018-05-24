//
// Created by Matthew Smith on 10/30/17.
//

#import "MapAnnotation.h"
#import "UIColor+Extensions.h"


@implementation MapAnnotation {
    
}
- (instancetype) initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.identifier = dictionary[@"id"];
        self.title = dictionary[@"title"];
        self.coordinate = CLLocationCoordinate2DMake([dictionary[@"latitude"] doubleValue], [dictionary[@"longitude"] doubleValue]);
        self.color = [UIColor colorFromDictionary:dictionary[@"color"]];
    }
    return self;
}

+ (instancetype)annotationFromDictionary:(NSDictionary *)dictionary {
    NSString *type = dictionary[@"type"];
    if (!type) {
        return nil;
    }

    return [[MapAnnotation alloc] initWithDictionary:dictionary];
    
    return nil;
}

@end
