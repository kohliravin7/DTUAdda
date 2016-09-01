//
//  ContactsCollectionViewCell.m
//  DTUAdda
//
//  Created by Ravin Kohli on 02/05/16.
//  Copyright © 2016 Ravin Kohli. All rights reserved.
//

#import "ContactsCollectionViewCell.h"

@implementation ContactsCollectionViewCell

-(void) setPhotoURL:(NSString *)photoURL{
    
    _photoURL = photoURL;
    
    NSURL *imageURL = [NSURL URLWithString:photoURL];
    UIActivityIndicatorView *activityIndicator;
    activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.frame = CGRectMake((self.contentView.bounds.size.width - 30)/2,(self.contentView.bounds.size.height - 30)/2, 40.0, 40.0);
    [self.imageView addSubview: activityIndicator];
    
    
    // This line starts the activity indicator in the status bar
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    // This line starts the activity indicator on the view
    [activityIndicator startAnimating];
    
   
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data= [NSData dataWithContentsOfURL:imageURL];
        self.image = [UIImage imageWithData:data];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image = self.image ;
            [activityIndicator stopAnimating];
        });
        [UIApplication sharedApplication].networkActivityIndicatorVisible = false;
        // This line stops the activity indicator in the status bar
        // This line stops the activity indicator on the view, in this case the table view
    });
}
-(void) setNameString:(NSString *)nameString{
    _nameString = nameString;
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    self.nameLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
    self.nameLabel.text = [NSString stringWithFormat:@" %@",self.nameString];
    self.nameLabel.textColor = [UIColor colorWithWhite:0.96 alpha:1];
    self.nameLabel.backgroundColor = [UIColor colorWithRed:0.647 green:0.486 blue:0.361 alpha:1.00];
}

-(id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] init];
        self.nameLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.nameLabel];
    }
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(0, 0, self.contentView.bounds.size.width, self.contentView.bounds.size.height - 20);
    self.nameLabel.frame = CGRectMake(0,self.contentView.bounds.size.height - 20, self.contentView.bounds.size.width,20);
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.imageView.bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) cornerRadii:CGSizeMake(10.0, 10.0)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.imageView.bounds;
    maskLayer.path  = maskPath.CGPath;
    self.imageView.layer.mask = maskLayer;
    
    UIBezierPath *maskPath2 = [UIBezierPath bezierPathWithRoundedRect:self.nameLabel.bounds byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight) cornerRadii:CGSizeMake(10.0, 10.0)];
    CAShapeLayer *nameLabelMaskLayer = [[CAShapeLayer alloc] init];
    nameLabelMaskLayer.frame = self.nameLabel.bounds;
    nameLabelMaskLayer.path = maskPath2.CGPath;
    self.nameLabel.layer.mask = nameLabelMaskLayer;
}



@end

