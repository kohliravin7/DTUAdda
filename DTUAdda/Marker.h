//
//  Marker.h
//  
//
//  Created by Ravin Kohli on 04/02/16.
//
//

#import <Foundation/Foundation.h>
@import CoreLocation;
@import GoogleMaps;

@interface Marker : NSObject


@property (nonatomic) NSString *title;
@property (nonatomic) NSString *subTitle;
@property (nonatomic) NSString *floor;
@property (nonatomic) CLLocationDegrees latitude;
@property (nonatomic) CLLocationDegrees longitude;
@property (nonatomic) NSString *type;

-(id) initWithTitle:(NSString *) title;
+(id) markerWithTitle:(NSString *) title;
//+(NSArray *)markersFromMarkers:(NSMutableArray *)markers;
+(GMSMarker *)  markerFromMarkers:(NSMutableArray *)markers;
//+(GMSMarker *) markerWithPosition:(CLLocationCoordinate2D)position fromMarkers:(NSMutableArray *)markers;
+(GMSMarker *) markerFromMarker:(Marker *) marker;

@end
