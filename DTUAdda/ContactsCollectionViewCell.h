//
//  ContactsCollectionViewCell.h
//  DTUAdda
//
//  Created by Ravin Kohli on 02/05/16.
//  Copyright © 2016 Ravin Kohli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactsCollectionViewCell : UICollectionViewCell

@property (nonatomic) UIImageView *imageView;
@property (nonatomic) UIImage *image;
@property (nonatomic) NSString *photoURL;
@property (nonatomic) UILabel *nameLabel;
@property (nonatomic) NSString *nameString;

@end
