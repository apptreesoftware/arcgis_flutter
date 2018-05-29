//
//  MapViewLayerViewController.m
//  arcgis_flutter
//
//  Created by John Ryan on 5/29/18.
//

#import "MapViewLayerViewController.h"
#import "MapLayer.h"


@interface MapViewLayerViewController ()

@end

@implementation MapViewLayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.mapLayers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell =  [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    MapLayer *layer = [self.mapLayers objectAtIndex:indexPath.row];
    cell.textLabel.text = layer.name;
    if (layer.visible) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MapLayer *layer = [self.mapLayers objectAtIndex:indexPath.row];
    layer.visible = !layer.visible;
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}


- (void)done:(id)sender {
    [self.delegate mapViewLayerDidComplete:self.mapLayers];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
