//
//  MapsViewController.h
//  DTUAdda
//
//  Created by Ravin Kohli on 04/02/16.
//  Copyright © 2016 Ravin Kohli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Marker.h"

@import GoogleMaps;

@interface MapsViewController : UIViewController

@property (nonatomic) NSMutableArray *markers;
@property (nonatomic) CLLocationManager *locationManager;
@property (nonatomic) CLLocation *currentLocation;

+ (void)removeGMSBlockingGestureRecognizerFromMapView:(GMSMapView *)mapView;

@end
