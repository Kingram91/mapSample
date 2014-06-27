//
//  ResultsTableViewController.h
//  mapSample
//
//  Created by Kquane Ingram on 6/27/14.
//  Copyright (c) 2014 King Blk Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "ResultsTableCell.h"
#import "RouteViewController.h"
@interface ResultsTableViewController : UITableViewController
@property (strong, nonatomic) NSArray *mapItems;
@end
