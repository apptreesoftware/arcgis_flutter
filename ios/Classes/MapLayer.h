#import <Foundation/Foundation.h>

#import <CoreLocation/CoreLocation.h>

@interface MapLayer : NSObject
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *url;
@property (nonatomic, readwrite) BOOL visible;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end
