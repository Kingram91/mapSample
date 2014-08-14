//
//  ViewController.m
//  mapSample
//
//  Created by Kquane Ingram on 6/27/14.
//  Copyright (c) 2014 King Blk Studios. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //make the view controller be the map view’s delegate
    self.mapView.delegate = self;
    _userLocation = _mapView.userLocation;
    
    /*set the region of the map view.
     The region is the portion of the map that is currently being displayed.
     It consists of a center coordinate and a distance in latitude and longitude
     surrounding the center coordinate to be shown.
     In My case, the region I want to show is the users locaiton
     */
    
    _region = MKCoordinateRegionMakeWithDistance(_userLocation.location.coordinate, 10000, 10000);
    
    //Control User Location on MAP
    if ([CLLocationManager locationServicesEnabled]) {
        _mapView.showsUserLocation = YES;
        [_mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    }
    
    // Add button for controlling user locaiton tracking
    // With this new addition, users can manually pan the map and get back to tracking their location with a tap of the new bar button.
    MKUserTrackingBarButtonItem *trackingButton = [[MKUserTrackingBarButtonItem alloc]initWithMapView:_mapView];
    
    UIBarButtonItem *zoomButton = [[UIBarButtonItem alloc]initWithTitle:@"Zoom" style:UIBarButtonItemStylePlain target:self action:@selector(zoomIn)];
    
    UIBarButtonItem *mapTypeButton = [[UIBarButtonItem alloc]initWithTitle:@"Type" style:UIBarButtonItemStylePlain target:self action:@selector(changeMapType)];
    
    [_mapToolbar setItems:[NSArray arrayWithObjects:trackingButton,zoomButton,mapTypeButton, nil]animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)zoomIn {
    _region = MKCoordinateRegionMakeWithDistance ( _userLocation.location.coordinate, 1000, 1000);
    [_mapView setRegion:self.region animated:NO];
}

- (void)changeMapType{
    if (_mapView.mapType == MKMapTypeStandard) _mapView.mapType = MKMapTypeSatellite;
    else if (_mapView.mapType == MKMapTypeSatellite)
        _mapView.mapType = MKMapTypeHybrid;
    else
        _mapView.mapType = MKMapTypeStandard;
}



- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:
(MKUserLocation *)userLocation
{
    _mapView.centerCoordinate = userLocation.location.coordinate;
}

- (IBAction)textFieldReturn:(id)sender {
    [sender resignFirstResponder];
    [_mapView removeAnnotations:[_mapView annotations]]; [self performSearch];
}

- (void)performSearch
{
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = _searchText.text;
    request.region = _mapView.region;
    
    _matchingItems = [[NSMutableArray alloc] init];
    
    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error)
     {
         if (response.mapItems.count == 0) {
             NSLog(@"NO Matches");
         }else
         {
             for (MKMapItem *item in response.mapItems)
             {
                 [_matchingItems addObject:item];
                 MKPointAnnotation *annotation = [[MKPointAnnotation alloc]init];
                 annotation.coordinate = item.placemark.coordinate;
                 annotation.title = item.name;
                 [_mapView addAnnotation:annotation];
             }
         }
     }];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ResultsTableViewController *destination = [segue destinationViewController];
    destination.mapItems = _matchingItems;
}

@end