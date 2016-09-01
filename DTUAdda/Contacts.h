//
//  Contacts.h
//  DTUAdda
//
//  Created by Ravin Kohli on 02/05/16.
//  Copyright © 2016 Ravin Kohli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Contacts : NSObject

@property (nonatomic) NSString *title;
@property (nonatomic) NSString *descriptions;
@property (nonatomic) NSDictionary *contact;
@property (nonatomic) NSString *image;

-(id) initWithTitle:(NSString *)title;
+(id) contactWithTitle:(NSString *)title;

@end
