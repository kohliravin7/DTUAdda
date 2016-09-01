//
//  Marker.m
//  
//
//  Created by Ravin Kohli on 04/02/16.
//
//

#import "Marker.h"
@import GoogleMaps;

@implementation Marker

-(id) initWithTitle:(NSString *) title{
    
    self = [super init];
    
    if (self) {
        _title = title;
        _subTitle = nil;
        _floor = nil;
        _latitude = 0;
        _longitude = 0;
        _type = nil;
    }
  
    return self;
}

+(id) markerWithTitle:(NSString *) title{
    
    return [[self alloc] initWithTitle:title];
    
}

//+(NSArray *)  markersFromMarkers:(NSMutableArray *)markers
//{
//    NSMutableArray *markerSearch = [[NSMutableArray alloc] init];
//    for (int i = 0; i<markers.count; i++) {
//    Marker *marker = [markers objectAtIndex:i];
//        if (marker.subTitle) {
//            [markerSearch addObject:[marker.title stringByAppendingFormat:@", %@",marker.subTitle]];
//        } else {
//           [markerSearch addObject:marker.title];
//        }
//
//    }
//    return markerSearch;
//}

+(GMSMarker *)  markerFromMarkers:(NSMutableArray *)markers
{
    GMSMarker *markerObject = [[GMSMarker alloc] init];
    static int count = 0;
    Marker *marker = [markers objectAtIndex:count];
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
    count++;
    return markerObject;
}
+(GMSMarker *) markerFromMarker:(Marker *) marker{
    
    GMSMarker *markerObject = [[GMSMarker alloc] init];
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
    return markerObject;

}
@end
