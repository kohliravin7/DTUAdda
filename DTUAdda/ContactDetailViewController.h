//
//  ContactDetailViewController.h
//  DTUAdda
//
//  Created by Ravin Kohli on 02/05/16.
//  Copyright © 2016 Ravin Kohli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Contacts.h"

@interface ContactDetailViewController : UIViewController

@property (nonatomic) UIImageView *imageView;
@property (nonatomic) UILabel *nameLabel;
@property (nonatomic) UITextView *descriptionView;


@property (nonatomic) Contacts *contacts;

@end
