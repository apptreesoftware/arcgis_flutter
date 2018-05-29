#import <Flutter/Flutter.h>

@class MapViewController;

@interface ArcgisFlutterPlugin : NSObject<FlutterPlugin>
@property (nonatomic, assign) UIViewController *host;
@property (nonatomic, assign) FlutterMethodChannel *channel;
@property (nonatomic, retain) MapViewController *mapViewController;
@property (nonatomic, retain) NSString *redImageKey;
@property (nonatomic, retain) NSString *layerImageKey;

- (void)onMapReady;

@end
