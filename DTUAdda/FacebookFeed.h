//
//  FacebookFeed.h
//  FBDemo
//
//  Created by Ravin Kohli on 22/04/16.
//  Copyright © 2016 Ravin Kohli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FacebookFeed : NSObject

@property (nonatomic) NSURL *imageURL;
@property (nonatomic) NSString *message;
@property (nonatomic) NSString *story;
@property (nonatomic) NSString *date;
@property (nonatomic) NSURL *sharedLink;

-(id)initWithMessage:(NSString *)message;
+(id) facebookFeedWithMessage:(NSString *)message;

-(NSString *)formattedDate;

@end
