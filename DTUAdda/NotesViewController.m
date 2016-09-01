//
//  NotesViewController.m
//  DTUAdda
//
//  Created by Ravin Kohli on 30/04/16.
//  Copyright © 2016 Ravin Kohli. All rights reserved.
//

#import "NotesViewController.h"

@interface NotesViewController () <UIWebViewDelegate>

@end

@implementation NotesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.backgroundColor = [UIColor brownColor];
    self.title = @"NOTES";
    self.notesWebView=[[UIWebView alloc]initWithFrame:self.view.bounds];
    self.notesWebView.delegate = self;
    NSString *url=@"https://drive.google.com/folderview?id=0B5WAUv2qkI6zZHBuVWNBNWNMYlE&usp=sharing";
    self.notesWebView.scalesPageToFit = YES;
    self.notesWebView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    NSURL *nsurl=[NSURL URLWithString:url];
    NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
    [self.notesWebView loadRequest:nsrequest];
    [self.view addSubview:self.notesWebView];
    self.indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.indicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
    self.indicator.center = self.view.center;
    [self.view addSubview:self.indicator];
    [self.indicator bringSubviewToFront:self.view];
    self.notesWebView.scrollView.bounces = NO;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = TRUE;
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    
    // Setting the swipe direction.
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    
    // Adding the swipe gesture on WebView
    [self.notesWebView addGestureRecognizer:swipeLeft];
    [self.notesWebView addGestureRecognizer:swipeRight];
    
    
}

- (void)handleSwipe:(UISwipeGestureRecognizer *)swipe {
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
        [self.notesWebView goForward];
    }
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
        [self.notesWebView goBack];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    [self.indicator startAnimating];

}
-(void) webViewDidFinishLoad:(UIWebView *)webView{
    [self.indicator setHidden:TRUE];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = false;

}
-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.indicator stopAnimating];
    [self.indicator setHidden:TRUE];
}
/*
 
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
