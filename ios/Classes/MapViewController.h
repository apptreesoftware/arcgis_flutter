#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <ArcGIS/ArcGIS.h>
#import "MapAnnotation.h"

@class ArcgisFlutterPlugin;

@interface MapViewController : UIViewController <AGSWebMapDelegate>

- (id)initWithPlugin:(ArcgisFlutterPlugin *)plugin
     navigationItems:(NSArray *)items;

- (void)setCamera:(CLLocationCoordinate2D)location zoom:(float)zoom;
- (void)addAnnotation:(MapAnnotation *)annotation;
- (void)updateAnnotations:(NSArray *)annotations;

@end