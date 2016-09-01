//
//  MapsViewController.m
//  DTUAdda
//
//  Created by Ravin Kohli on 04/02/16.
//  Copyright © 2016 Ravin Kohli. All rights reserved.
//

#import "MapsViewController.h"
#import <MapKit/MapKit.h>
#import <HSClusterMapView/HSClusterMapView.h>
#import <HSMapView.h>
#import "DemoClusterRenderer.h"

@import GoogleMaps;


@class Marker;

@interface MapsViewController () <CLLocationManagerDelegate,GMSMapViewDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic) HSClusterMapView *mapView;
//@property (nonatomic) GMSMapView *mapView;
//@property (nonatomic) NSMutableArray *annotations;
@property (nonatomic) UITextField *searchField;
@property (nonatomic) UITableView *searchView;
@property (nonatomic) NSArray *searchArray;
@property (nonatomic) NSMutableArray *searchAutoCompleteArray;

@end

@implementation MapsViewController 

- (void)markerLoad {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"map" ofType:@"json"];

    NSData *JSONData = [NSData dataWithContentsOfFile:filePath options:0 error:nil];

    NSError *error;
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingAllowFragments error:&error];
    //NSLog(@"%@",error.localizedDescription);
    
    self.markers = [[NSMutableArray alloc] init];

    NSArray *markerArray = [jsonObject   objectForKey:@"map"];
    
    for (NSDictionary *mDictionary in markerArray) {
        Marker *markerObject =[Marker markerWithTitle:[mDictionary objectForKey:@"title"]];
        markerObject.subTitle = [mDictionary objectForKey:@"subTitle"];
        markerObject.floor = [mDictionary objectForKey:@"floor"];
        markerObject.type = [mDictionary objectForKey:@"type"];
        NSString *latitude = [mDictionary objectForKey:@"latitude"];
        NSString *longitude = [mDictionary objectForKey:@"longitude"];
        markerObject.latitude = [latitude doubleValue];
        markerObject.longitude =[longitude doubleValue];
       // NSLog(@"%@", markerObject);
        [self.markers addObject:markerObject];
        
    }
}

-(void) viewDidLoad{
    [super viewDidLoad];
     //   HSClusterRenderer clusterRenderer = [HSClusterRenderer new];
    [self markerLoad];
    [self.navigationController setNavigationBarHidden:YES];
   // [self loadAnnotations];
    DemoClusterRenderer *clusterRenderer = [DemoClusterRenderer new];

    self.mapView = [[HSClusterMapView alloc] initWithFrame:CGRectZero renderer:clusterRenderer];
    
    self.searchView = [[UITableView alloc] initWithFrame:CGRectMake(20, 60,self.view.bounds.size.width - 40, 300)];
    self.searchView.delegate = self;
    self.searchView.dataSource = self;
    self.searchView.hidden = YES;
    self.searchView.scrollEnabled = YES;
    self.searchView.backgroundColor = [UIColor colorWithRed:0.663 green:0.816 blue:0.941 alpha:0.50];
    self.searchAutoCompleteArray = [[NSMutableArray alloc] init];
    [self checkLocationAuthorisation];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:28.75007207311156
                                                            longitude:77.11772996932268 zoom:18.0 bearing:30
                                                         viewingAngle:45];
    
    
    [MapsViewController removeGMSBlockingGestureRecognizerFromMapView:self.mapView];
    
    [self.mapView setCamera:camera];
    
    NSMutableArray *markers = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [self.markers count]; i++) {
        //[self.mapView addMarkers:[Marker markersFromMarkers:self.markers]];
       // GMSMarker *marker = [Marker markerFromMarkers:self.markers];
        GMSMarker *markerObject = [[GMSMarker alloc] init];
        Marker *marker = [self.markers objectAtIndex:i];
        if (marker.subTitle) {
            markerObject.title = [marker.title stringByAppendingFormat:@", %@",marker.subTitle];
        } else {
            markerObject.title = marker.title;
        }
        markerObject.position = CLLocationCoordinate2DMake(marker.latitude, marker.longitude);
        if (marker.type && marker.floor) {
            markerObject.snippet = [marker.type stringByAppendingFormat:@"  %@",marker.floor];
        } else if(marker.floor) {
            markerObject.snippet = marker.floor;
        }else{
            markerObject.snippet = marker.type;
        }
        markerObject.map = self.mapView;
        markerObject.appearAnimation = kGMSMarkerAnimationPop;
        [markers addObject:markerObject];
    };
    
    self.mapView.delegate = self;
    [self.mapView addMarkers:markers];
    [self.mapView cluster];
    //NSLog(@"%@ unclustered", [self.mapView unclusteredMarkers]);
    
    [self.mapView setMinZoom:17 maxZoom:kGMSMaxZoomLevel];
   // NSLog(@"Idhar pahunch gaye");
    //self.mapView = [HSClusterMapView mapWithFrame:CGRectZero camera:camera];
    
    self.searchField = [[UITextField alloc] initWithFrame:CGRectMake(20, 20, self.view.bounds.size.width - 40, 40)];
    self.searchField.placeholder = @"  Search";
    self.searchField.delegate = self;
    self.searchField.backgroundColor = [UIColor colorWithWhite:1 alpha:0.50];
    self.searchField.userInteractionEnabled = YES;
    self.searchField.borderStyle = UITextBorderStyleBezel;
    self.searchField.font = [UIFont fontWithName:@"Lucida Grande" size:12];
    [self.searchField canBecomeFirstResponder];
    
    UIEdgeInsets mapInsets = UIEdgeInsetsMake(CGRectGetHeight(self.navigationController.navigationBar.frame) +10.0 +CGRectGetHeight(self.searchField.frame), 0.0, CGRectGetHeight(self.tabBarController.tabBar.frame), 0.0);
    self.mapView.padding = mapInsets;
    
    self.mapView.myLocationEnabled = YES;
    self.mapView.settings.compassButton = YES;
    self.mapView.settings.myLocationButton = YES;
    
    self.mapView.clusteringEnabled = YES;
    self.mapView.minimumMarkerCountPerCluster = 4;
    self.view = self.mapView;
   
    
    UITextView *searchView = [[UITextView alloc] init];
    [searchView addSubview:self.searchField];
    [self.view addSubview:self.searchField];

    [self.mapView cluster];

//    GMSMarker *currentMarker = [GMSMarker markerWithPosition:self.mapView.myLocation.coordinate];
//    currentMarker.icon = [GMSMarker markerImageWithColor: [UIColor blueColor]];
    
}

-(void)currentLocationIdentifier
{
    //---- For getting current gps location
    //NSLog(@"yes available");
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    [self.locationManager startUpdatingLocation];
    //------
}

-(void) checkLocationAuthorisation{
    
    self.locationManager = [[CLLocationManager alloc] init];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        [self.locationManager requestWhenInUseAuthorization];
    if ([CLLocationManager locationServicesEnabled]) {
        [self currentLocationIdentifier];
        [self.locationManager requestAlwaysAuthorization];
        //NSLog(@"yes available");
        
    }else{
        //UIAlertController *alert = [UIAlertController  ]
        }
    }
    
}

-(void) mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position{
    if (self.mapView.clusteringEnabled == NO) {
        self.mapView.clusteringEnabled = YES;
    }
    [self.mapView cluster];

    //self.mapView.
}

+ (void)removeGMSBlockingGestureRecognizerFromMapView:(GMSMapView *)mapView //Google blocks gestures.
{
    for (id gestureRecognizer in mapView.gestureRecognizers)
    {
        //NSLog(@"mapview recognizer %@",gestureRecognizer);
        if (![gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]])
        {
            [mapView removeGestureRecognizer:gestureRecognizer];
        }
    }
}

//-(void)textFieldDidBeginEditing:(UITextField *)textField{
//    
//  //  self.searchArray = [Marker markersFromMarkers:self.markers];
//    
//    
//    //    [self.mapView addSubview:searchView];
//}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    Marker *marker =[self.searchAutoCompleteArray objectAtIndex:indexPath.row];
    //NSLog(@" Auto Complete Array %@", self.searchAutoCompleteArray[indexPath.row]);
    cell.textLabel.text = marker.title;
    cell.backgroundColor = [UIColor colorWithWhite:0.97 alpha:0.50];
    return cell;
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.searchAutoCompleteArray.count;
}

- (void)searchAutocompleteEntriesWithSubstring:(NSString *)substring {
    // Put anything that starts with this substring into the autocompleteUrls array
    // The items in this array is what will show up in the table view
    [self.searchAutoCompleteArray removeAllObjects];
    for(Marker *marker in self.markers) {
        NSString *curString = marker.title;
        NSRange substringRange = [curString rangeOfString:substring];
        if (substringRange.location == 0) {
           // NSLog(@"curString:%@",curString);
            [self.searchAutoCompleteArray addObject:marker];
            //NSLog(@"autocompletearray:%@",self.searchAutoCompleteArray);
        }
    }
    [self.searchView reloadData];
    
}
//- (void)searchAutocompleteEntriesWithSubstring:(NSString *)substring {
//    // Put anything that starts with this substring into the autocompleteUrls array
//    // The items in this array is what will show up in the table view
//    [self.searchAutoCompleteArray removeAllObjects];
//    for(NSString *curString in self.searchArray) {
//        NSRange substringRange = [curString rangeOfString:substring];
//        if (substringRange.location == 0) {
//            NSLog(@"curString:%@",curString);
//            [self.searchAutoCompleteArray addObject:curString];
//            NSLog(@"autocompletearray:%@",self.searchAutoCompleteArray);
//        }
//    }
//    [self.searchView reloadData];
//    
//}

- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string {
    self.searchView.hidden = NO;
    [self.view addSubview:self.searchView];
    
    NSString *substring = [NSString stringWithString:textField.text];
    substring = [substring
                 stringByReplacingCharactersInRange:range withString:string];
   
    //NSLog(@"%@",substring);

    [self searchAutocompleteEntriesWithSubstring:substring];
    return YES;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.searchView setHidden:YES];
    Marker *marker  = [self.searchAutoCompleteArray objectAtIndex:indexPath.row];
    GMSMarker *markerObject = [Marker markerFromMarker:marker];
    [self.searchField resignFirstResponder];
    
    GMSCameraPosition *position = [GMSCameraPosition cameraWithTarget:markerObject.position zoom:kGMSMaxZoomLevel];
    [self.mapView setCamera:position];
    self.mapView.clusteringEnabled = NO;
    [self.mapView setSelectedMarker:markerObject];
}

-(BOOL) mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker{
    
    return NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self.searchView removeFromSuperview];
    textField.text = @"";
    
    return NO;
}

//- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
//{
//
//    self.currentLocation  = [locations objectAtIndex:0];
//    [self.locationManager stopUpdatingLocation];
//    
//    NSLog(@"%@",self.currentLocation);
//    self.locationManager = [[CLLocationManager alloc] init];
//    self.locationManager.delegate = self;
//    self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
//    
//
//    GMSCameraPosition *camera = [GMSCameraPosition cameraWithTarget:self.currentLocation.coordinate zoom:18.0];
//    
//    self.mapView = [HSClusterMapView mapWithFrame:CGRectZero camera:camera];
//    
//    GMSMarker *currentMarker = [GMSMarker markerWithPosition:self.currentLocation.coordinate];
//    currentMarker.icon =[GMSMarker markerImageWithColor: [UIColor blueColor]];
//    currentMarker.map = self.mapView;
//   
//    self.view = self.mapView;
//}

//-(void) loadAnnotations{
//    
//    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
//    for(int i = 0; i<self.markers.count; i++){
//        GMSMarker *marker = [Marker markerFromMarkers:self.markers];
//        annotation.coordinate = marker.position;
//        annotation.title = marker.title;
//        annotation.subtitle = marker.snippet;
//        [self.annotations addObject:annotation];
//    }
//    
//}
@end
