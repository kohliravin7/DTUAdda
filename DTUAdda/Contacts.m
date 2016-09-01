//
//  Contacts.m
//  DTUAdda
//
//  Created by Ravin Kohli on 02/05/16.
//  Copyright © 2016 Ravin Kohli. All rights reserved.
//

#import "Contacts.h"

@implementation Contacts

-(id) initWithTitle:(NSString *)title{
    self = [super init];
    if (self) {
        _title = title;
        _descriptions = nil;
        _image = nil;
        _contact = nil;
    }
    
    return self;
}

+(id) contactWithTitle:(NSString *)title{
    return [[self alloc] initWithTitle:title];
}

@end
