//
//  DemoClusterRenderer.m
//  DTUAdda
//
//  Created by Ravin Kohli on 17/02/16.
//  Copyright © 2016 Ravin Kohli. All rights reserved.
//

#import "DemoClusterRenderer.h"

@implementation DemoClusterRenderer

- (UIImage *)imageForClusterWithCount:(NSUInteger)count {
    // Get the number of digits in the count
    NSString *countString = [NSString stringWithFormat:@"%d", (int)count];
    
    // Set up the cluster view
    CGFloat widthAndHeight = 25 + (5 * countString.length);
    UIView *clusterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, widthAndHeight, widthAndHeight)];
    clusterView.backgroundColor = [UIColor whiteColor];
    clusterView.layer.masksToBounds = YES;
    clusterView.layer.borderColor = [[UIColor blackColor] CGColor];
    clusterView.layer.borderWidth = 1;
    clusterView.layer.cornerRadius = clusterView.bounds.size.width / 2.0;
    
    // Add the number label
    UILabel *numberLabel = [[UILabel alloc] initWithFrame:clusterView.frame];
    numberLabel.font = [UIFont fontWithName:@"Helvetica-Neue" size:18];
    numberLabel.textColor = [UIColor redColor];
    numberLabel.text = countString;
    numberLabel.textAlignment = NSTextAlignmentCenter;
    [clusterView addSubview:numberLabel];
    
    // Generate an image from the view
    UIGraphicsBeginImageContextWithOptions(clusterView.bounds.size, NO, 0.0);
    [clusterView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *icon = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return icon;
}

@end
