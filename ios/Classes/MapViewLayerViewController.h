//
//  MapViewLayerViewController.h
//  arcgis_flutter
//
//  Created by John Ryan on 5/29/18.
//

#import <UIKit/UIKit.h>

@class MapLayer;

@protocol MapViewLayerDelegate

- (void)mapViewLayerDidComplete:(NSArray *)layers;

@end

@interface MapViewLayerViewController : UITableViewController

@property (nonatomic, weak) id<MapViewLayerDelegate> delegate;
@property (nonatomic, retain) NSArray *mapLayers;

@end
