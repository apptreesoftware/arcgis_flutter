#import "ArcgisFlutterPlugin.h"
#import "MapViewController.h"
#import <ArcGIS/ArcGIS.h>
#import "MapAnnotation.h"

@implementation ArcgisFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"com.apptreesoftware.arcgis_flutter_plugin"
            binaryMessenger:[registrar messenger]];
    UIViewController *host = UIApplication.sharedApplication.delegate.window.rootViewController;
    ArcgisFlutterPlugin* instance = [[ArcgisFlutterPlugin alloc] initWithHost:host channel:channel];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (id)initWithHost:(UIViewController *)host channel:(FlutterMethodChannel *)channel {
    if (self = [super init]) {
        self.host = host;
        self.channel = channel;
    }
    return self;
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"setApiKey" isEqualToString:call.method]) {
        result(@YES);
    } else if ([@"show" isEqualToString:call.method]) {
        NSDictionary *args = call.arguments;
        NSDictionary *mapOptions = args[@"mapOptions"];
        
        MapViewController *vc = [[MapViewController alloc] initWithPlugin:self
                                 navigationItems:[self buttonItemsFromActions:args[@"actions"]]
                                 ];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc];
        navController.navigationBar.translucent = NO;
        [self.host presentViewController:navController animated:true completion:nil];
        self.mapViewController = vc;
        result(@YES);
    } else if ([@"dismiss" isEqualToString:call.method]) {
        if (self.mapViewController) {
            [self.host dismissViewControllerAnimated:true completion:nil];
        }
        self.mapViewController = nil;
    } else if ([@"addAnnotation" isEqualToString:call.method]) {
            [self handleSetAnnotations:call.arguments];
            result(@YES);
    } else if ([@"addAnnotation" isEqualToString:call.method]) {
        [self handleAddAnnotation:call.arguments];
        result(@YES);
    } else if ([@"removeAnnotation" isEqualToString:call.method]) {
//        [self handleRemoveAnnotation:call.arguments];
        result(@YES);
    } else if ([@"setCamera" isEqualToString:call.method]) {
        [self handleSetCamera:call.arguments];
        result(@YES);
    
    } else if ([@"getCenter" isEqualToString:call.method]) {
//        CLLocationCoordinate2D location = self.mapViewController.centerLocation;
//        result(@{@"latitude": @(location.latitude), @"longitude": @(location.longitude)});
        result(@{});
    } else if ([@"getZoomLevel" isEqualToString:call.method]) {
//        result(@(self.mapViewController.zoomLevel));
        result(@12.0);
    } else if ([@"setLayers" isEqualToString:call.method]) {
        result(@YES);
        
    } else {
    result(FlutterMethodNotImplemented);
  }
}

- (void)handleSetCamera:(NSDictionary *)cameraUpdate {
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([cameraUpdate[@"latitude"] doubleValue], [cameraUpdate[@"longitude"] doubleValue]);
    [self.mapViewController setCamera:coordinate zoom:[cameraUpdate[@"zoom"] floatValue]];
}

- (void)onMapReady {
    [self.channel invokeMethod:@"onMapReady" arguments:nil];
}

- (void)handleAddAnnotation:(NSDictionary *)dict {
    MapAnnotation *annotation = [MapAnnotation annotationFromDictionary:dict];
    if (annotation) {
        [self.mapViewController addAnnotation:annotation];
    }
}

-(void)handleSetAnnotations:(NSDictionary *)annotations {
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *aDict in annotations) {
        MapAnnotation *annotation = [MapAnnotation annotationFromDictionary:aDict];
        if (annotation) {
            [array addObject:annotation];
        }
    }
    [self.mapViewController updateAnnotations:array];
}

- (NSArray *)buttonItemsFromActions:(NSArray *)actions {
    NSMutableArray *buttons = [NSMutableArray array];
    if (actions) {
        for (NSDictionary *action in actions) {
            UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:[action valueForKey:@"title"]
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:self
                                                                      action:@selector(handleToolbar:)];
            button.tag = [[action valueForKey:@"identifier"] intValue];
            [buttons addObject:button];
        }
    }
    return buttons;
}

- (void)handleToolbar:(UIBarButtonItem *)item {
    [self.channel invokeMethod:@"onToolbarAction" arguments:@(item.tag)];
}

@end
