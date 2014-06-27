//
//  RouteViewController.h
//  mapSample
//
//  Created by Kquane Ingram on 6/27/14.
//  Copyright (c) 2014 King Blk Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface RouteViewController : UIViewController <MKMapViewDelegate>
@property (strong, nonatomic) IBOutlet MKMapView *routeMap;
@property (strong, nonatomic) MKMapItem *destination;

@end
