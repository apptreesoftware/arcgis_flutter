#import "MapViewController.h"
#import "ArcgisFlutterPlugin.h"
#import <ArcGIS/ArcGIS.h>
#import "MapAnnotation.h"
#import "MapLayer.h"

@interface MapViewController ()

@property (nonatomic, retain) NSMutableArray *markers;
@property (nonatomic, assign) ArcgisFlutterPlugin *plugin;
@property (nonatomic, retain) NSArray *navigationItems;
@property (nonatomic, retain) NSMutableDictionary *markerIDLookup;
@property (nonatomic, retain) AGSMapView *mapView;
@property (nonatomic, retain) AGSMap *map;
@property (nonatomic, retain) AGSGraphicsOverlay *graphicsOverlay;
@property (nonatomic, assign) int mapViewType;
@property (nonatomic, retain) NSArray<MapLayer *> *mapLayers;
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
    UIButton *layerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [layerButton setTitle:@"Layers" forState:UIControlStateNormal];
    [layerButton setTitleColor:[UIColor colorWithWhite:0 alpha:1.0] forState:UIControlStateNormal];
    [layerButton sizeToFit];
    [layerButton addTarget:self action:@selector(showLayers:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:layerButton];
    [self.plugin onMapReady];
}

- (void)setCamera:(CLLocationCoordinate2D)location zoom:(float)zoom {
    CLLocation *loc = [[CLLocation alloc] initWithLatitude:location.latitude longitude:location.longitude];
    AGSPoint *point = [AGSPoint pointWithCLLocationCoordinate2D:location];
    AGSViewpoint *viewPoint = [[AGSViewpoint alloc] initWithCenter:point scale:zoom];
    [self.mapView setViewpoint:viewPoint];
}

- (void)showLayers:(id)sender {
    MapViewLayerViewController *layerController = [[MapViewLayerViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:layerController];
    layerController.delegate = self;
    layerController.mapLayers = self.mapLayers;
    [self.navigationController presentViewController:navController animated:YES completion:nil];
}

- (void)updateAnnotations:(NSArray *)annotations {
    for (MapAnnotation *annotation in annotations) {
        [self addAnnotation:annotation];
    }
}

- (void)addAnnotation:(MapAnnotation *)annotation {
    NSString *path = [[NSBundle mainBundle] pathForResource:self.plugin.redImageKey ofType:nil];
    AGSMarkerSymbol *symbol = [[AGSPictureMarkerSymbol alloc] initWithImage:[UIImage imageWithContentsOfFile:path]];
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

- (void)setLayers:(NSArray<MapLayer *> *)mapLayers {
    self.mapLayers = mapLayers;
}

- (void)mapViewLayerDidComplete:(NSArray *)layers {
    [self.mapView.map.operationalLayers removeAllObjects];
    for (int i = 0; i < layers.count; i++) {
        MapLayer *layer = layers[i];
        if (!layer.visible) {
            continue;
        }
        NSURL *url = [[NSURL alloc] initWithString:layer.url];
        AGSServiceFeatureTable *sft = [[AGSServiceFeatureTable alloc] initWithURL:url];
        AGSFeatureLayer *featureLayer = [[AGSFeatureLayer alloc] initWithFeatureTable:sft];
        [self.mapView.map.operationalLayers addObject:featureLayer];
//        [newLayers addObject:featureLayer];
    }
    NSLog(@"operationalLayers = %@", self.mapView.map.operationalLayers);
    
//    self.mapview.map.operationalLayers = newLayers;
    NSLog(@"Done");
}

@end
