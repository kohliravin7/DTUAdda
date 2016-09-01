//
//  FacebookFeed.m
//  FBDemo
//
//  Created by Ravin Kohli on 22/04/16.
//  Copyright © 2016 Ravin Kohli. All rights reserved.
//

#import "FacebookFeed.h"

@implementation FacebookFeed

-(id)initWithMessage:(NSString *)message{
    self = [super init];
    if(self){
        _message = message;
        _imageURL=nil;
        _story=nil;
        _date=nil;
        _sharedLink = nil;
    }
    return self;
}
+(id) facebookFeedWithMessage:(NSString *)message{
    return [[self alloc ]initWithMessage:message];
}



-(NSString *)formattedDate{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH-mm-ss"];
    NSDate *tempDate = [dateFormatter dateFromString:self.date];
    [dateFormatter setDateFormat:@"EE MMM,dd"];
    return [dateFormatter stringFromDate:tempDate];
}

@end
