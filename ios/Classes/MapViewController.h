#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <ArcGIS/ArcGIS.h>
#import "MapAnnotation.h"
#import "MapLayer.h"
#import "MapViewLayerViewController.h"

@class ArcgisFlutterPlugin;

@interface MapViewController : UIViewController<MapViewLayerDelegate>

- (id)initWithPlugin:(ArcgisFlutterPlugin *)plugin
     navigationItems:(NSArray *)items;

- (void)setCamera:(CLLocationCoordinate2D)location zoom:(float)zoom;
- (void)addAnnotation:(MapAnnotation *)annotation;
- (void)updateAnnotations:(NSArray *)annotations;
- (CLLocationCoordinate2D) centerLocation;
- (float) zoomLevel;
- (void)setLayers:(NSArray<MapLayer *> *)mapLayers;

@end
