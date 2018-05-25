#import "MapViewController.h"
#import "ArcgisFlutterPlugin.h"
#import <ArcGIS/ArcGIS.h>
#import "MapAnnotation.h"


@interface MapViewController ()

@property (nonatomic, retain) NSMutableArray *markers;
@property (nonatomic, assign) ArcgisFlutterPlugin *plugin;
@property (nonatomic, retain) NSArray *navigationItems;
@property (nonatomic, retain) NSMutableDictionary *markerIDLookup;
@property (nonatomic, retain) AGSMapView *mapView;
@property (nonatomic, retain) AGSMap *map;
@property (nonatomic, retain) AGSGraphicsOverlay *graphicsOverlay;
@property (nonatomic, assign) int mapViewType;
@end

@implementation MapViewController

- (id)initWithPlugin:(ArcgisFlutterPlugin *)plugin navigationItems:(NSArray *)items {
    self = [super init];
    if (self) {
        self.plugin = plugin;
        self.navigationItems = items;
        self.markerIDLookup = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItems = self.navigationItems;

    self.map = [[AGSMap alloc] initWithBasemap:AGSBasemap.topographicBasemap];
    self.mapView.map = self.map;
    self.graphicsOverlay = [[AGSGraphicsOverlay alloc] init];
    [self.mapView.graphicsOverlays insertObject:self.graphicsOverlay atIndex:0];
}

- (void)loadView {
    self.mapView = [[AGSMapView alloc] init];
    
    self.view = self.mapView;
    [self.plugin onMapReady];
}

- (void)setCamera:(CLLocationCoordinate2D)location zoom:(float)zoom {
    CLLocation *loc = [[CLLocation alloc] initWithLatitude:location.latitude longitude:location.longitude];
    AGSPoint *point = [AGSPoint pointWithCLLocationCoordinate2D:location];
    AGSViewpoint *viewPoint = [[AGSViewpoint alloc] initWithCenter:point scale:zoom];
    [self.mapView setViewpoint:viewPoint];
}

- (void)updateAnnotations:(NSArray *)annotations {
    for (MapAnnotation *annotation in annotations) {
        [self addAnnotation:annotation];
    }
}

- (void)addAnnotation:(MapAnnotation *)annotation {
    AGSSimpleMarkerSymbol *symbol = [[AGSSimpleMarkerSymbol alloc] initWithStyle:AGSSimpleMarkerSymbolStyleCircle color:annotation.color size:8.0f];
    AGSPoint *point = AGSPointMakeWGS84(annotation.coordinate.latitude, annotation.coordinate.longitude);
    AGSGraphic *graphic = [[AGSGraphic alloc] initWithGeometry:point symbol:symbol attributes:nil];
    [self.graphicsOverlay.graphics addObject:graphic];
}

- (CLLocationCoordinate2D) centerLocation {
    AGSViewpoint *viewpoint = [self.mapView currentViewpointWithType:AGSViewpointTypeCenterAndScale];
    AGSPoint *center = viewpoint.targetGeometry.extent.center;
    AGSGeometry *coord = [AGSGeometryEngine projectGeometry:center toSpatialReference:AGSSpatialReference.WGS84];
    return CLLocationCoordinate2DMake(coord.extent.center.y, coord.extent.center.x);
}

- (float) zoomLevel {
    return [self.mapView mapScale];
}

@end
