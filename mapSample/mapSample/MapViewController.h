//
//  ViewController.h
//  mapSample
//
//  Created by Kquane Ingram on 6/27/14.
//  Copyright (c) 2014 King Blk Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "ResultsTableViewController.h"

@interface MapViewController : UIViewController <MKMapViewDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UITextField *searchText;
@property (strong, nonatomic) IBOutlet UIToolbar*mapToolbar;
@property (strong, nonatomic) NSMutableArray *matchingItems;
@property (nonatomic) MKCoordinateRegion region;
@property (strong, nonatomic) MKUserLocation *userLocation;
- (void)zoomIn;
- (void)changeMapType;
- (void)detailsBtnClick;
- (IBAction)textFieldReturn:(id)sender;



@end