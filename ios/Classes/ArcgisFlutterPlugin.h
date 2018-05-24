#import <Flutter/Flutter.h>

@class MapViewController;

@interface ArcgisFlutterPlugin : NSObject<FlutterPlugin>
@property (nonatomic, assign) UIViewController *host;
@property (nonatomic, assign) FlutterMethodChannel *channel;
@property (nonatomic, retain) MapViewController *mapViewController;
- (void)onMapReady;

@end
