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
@property (nonatomic, retain) AGSWebMap *map;
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
    
    AGSTiledMapServiceLayer *basemap = [AGSTiledMapServiceLayer tiledMapServiceLayerWithURL:[NSURL URLWithString:@"https://services.arcgisonline.com/ArcGIS/rest/services/World_Topo_Map/MapServer"]];
    [self.mapView insertMapLayer:basemap withName:@"Basemap" atIndex:0];
}

- (void)loadView {
    self.mapView = [[AGSMapView alloc] init];
    self.view = self.mapView;
    [self.plugin onMapReady];
}

- (void)setCamera:(CLLocationCoordinate2D)location zoom:(float)zoom {
    CLLocation *loc = [[CLLocation alloc] initWithLatitude:location.latitude longitude:location.longitude];
    [self.mapView zoomToScale:zoom withCenterPoint:[AGSPoint pointWithLocation:loc] animated:YES];
}

- (void)updateAnnotations:(NSArray *)annotations {
//    [self.mapView clear];
//    [self.markerIDLookup removeAllObjects];
    for (MapAnnotation *annotation in annotations) {
//        GMSMarker *marker = [self createMarkerForAnnotation:annotation];
//        marker.map = self.mapView;
//        [self.markers addObject:marker];
//        self.markerIDLookup[marker.userData] = marker;
    }
}

- (void)addAnnotation:(MapAnnotation *)annotation {
    AGSSimpleMarkerSymbol *marker = [[AGSSimpleMarkerSymbol alloc] initWithColor:annotation.color];
    
//    GMSMarker *marker = [self createMarkerForAnnotation:annotation];
//    marker.map = self.mapView;
//    self.markerIDLookup[marker.userData] = marker;
}

//- (void) webMapDidLoad:(AGSWebMap*) webMap {
//    [self.plugin onMapReady];
//}
//
//- (void) webMap:(AGSWebMap *)webMap didFailToLoadWithError:(NSError *)error {
//    //webmap data was not retrieved
//    //alert the user
//    NSLog(@"Error while loading webmap: %@",[error localizedDescription]);
//}
//
//-(void)didOpenWebMap:(AGSWebMap*)webMap intoMapView:(AGSMapView*)mapView{
//    //web map finished opening
//    printf("MAP LOADED");
//}
//
//-(void)webMap:(AGSWebMap*)wm didLoadLayer:(AGSLayer*)layer{
//    //layer in web map loaded properly
//}
//
//-(void)webMap:(AGSWebMap*)wm didFailToLoadLayer:(NSString*)layerTitle url:(NSURL*)url baseLayer:(BOOL)baseLayer federated:(BOOL)federated withError:(NSError*)error{
//    NSLog(@"Error while loading layer: %@",[error localizedDescription]);
//
//    //you can skip loading this layer
//    //[self.webMap continueOpenAndSkipCurrentLayer];
//
//    //or you can try loading it with proper credentials if the error was security related
//    //[self.webMap continueOpenWithCredential:credential];
//}

@end
