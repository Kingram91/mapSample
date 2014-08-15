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
    
    zoomCount =0;
    
    //Make this controller the delegate for the map view.
    self.mapView.delegate = self;
    
    //Control User Location on MAP
    //Ensure that we can view our own location in the map view
    if ([CLLocationManager locationServicesEnabled])
    {
        _mapView.showsUserLocation = YES;
        [_mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    }
    
    //Instantiate a location object.
    locationManager = [[CLLocationManager alloc] init];
    
    //Make this controller the delegate for the location manager.
    [locationManager setDelegate:self];
    

    
    
    //Set some paramater for the location object.
    [locationManager setDistanceFilter:kCLDistanceFilterNone];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    
    //Set the first launch instance variable to allow the map to zoom on the user location when first launched.
    firstLaunch=YES;
    
        _userLocation = _mapView.userLocation;
    
    /*set the region of the map view.
     The region is the portion of the map that is currently being displayed.
     It consists of a center coordinate and a distance in latitude and longitude
     surrounding the center coordinate to be shown.
     In My case, the region I want to show is the users locaiton
     */
    
    _region = MKCoordinateRegionMakeWithDistance(_userLocation.location.coordinate, 10000, 10000);
    

    
    // Add button for controlling user locaiton tracking
    // With this new addition, users can manually pan the map and get back to tracking their location with a tap of the new bar button.
    MKUserTrackingBarButtonItem *trackingButton = [[MKUserTrackingBarButtonItem alloc]initWithMapView:_mapView];
    
    zoomButton = [[UIBarButtonItem alloc]initWithTitle:@"Zoom" style:UIBarButtonItemStylePlain target:self action:@selector(zoomIn)];
    
    mapTypeButton = [[UIBarButtonItem alloc]initWithTitle:@"SatelliteMap" style:UIBarButtonItemStylePlain target:self action:@selector(changeMapType)];
    
    [_mapToolbar setItems:[NSArray arrayWithObjects:trackingButton,zoomButton,mapTypeButton, nil]animated:YES];
    
    
    //Set the first launch instance variable to allow the map to zoom on the user location when first launched.
    firstLaunch=YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)zoomIn {
    zoomCount++;
    if (zoomCount%2 !=0) {
        zoomButton.title = @"Zoom Out";
        _region = MKCoordinateRegionMakeWithDistance ( _userLocation.location.coordinate, 1000, 1000);
        [_mapView setRegion:self.region animated:NO];
    }else{
        zoomButton.title = @"Zoom In";
        _region = MKCoordinateRegionMakeWithDistance ( _userLocation.location.coordinate, 10000, 10000);
        [_mapView setRegion:self.region animated:NO];
    }
}

- (void)changeMapType{
    if (_mapView.mapType == MKMapTypeStandard)
    {
        mapTypeButton.title = @"HybridMap";
        _mapView.mapType = MKMapTypeSatellite;
    }
    else if (_mapView.mapType == MKMapTypeSatellite)
    {
        mapTypeButton.title = @"StandardMap";
        _mapView.mapType = MKMapTypeHybrid;
    }
    else
    {
        mapTypeButton.title = @"SatelliteMap";
        _mapView.mapType = MKMapTypeStandard;
    }
    
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
    //request.region = _mapView.region;
    
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

- (void)mapView:(MKMapView *)mv didAddAnnotationViews:(NSArray *)views
{
    
    //Zoom back to the user location after adding a new set of annotations.
    
    //Get the center point of the visible map.
    CLLocationCoordinate2D centre = [mv centerCoordinate];
    
    MKCoordinateRegion region;
    
    //If this is the first launch of the app then set the center point of the map to the user's location.
    if (firstLaunch) {
        region = MKCoordinateRegionMakeWithDistance(locationManager.location.coordinate,1000,1000);
        firstLaunch=NO;
    }else {
        //Set the center point to the visible region of the map and change the radius to match the search radius passed to the Google query string.
        region = MKCoordinateRegionMakeWithDistance(centre,currenDist,currenDist);
    }
    
    //Set the visible region of the map.
    [mv setRegion:region animated:YES];
    
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ResultsTableViewController *destination = [segue destinationViewController];
    destination.mapItems = _matchingItems;
}

@end