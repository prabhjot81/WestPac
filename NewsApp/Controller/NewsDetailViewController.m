//
//  NewsDetailViewController.m
//  NewsApp
//
//  Created by Prabh Dhaliwal on 9/20/14.
//  Copyright (c) 2014 WestPac. All rights reserved.
//

#import "NewsDetailViewController.h"
#import "AppDelegate.h"

@interface NewsDetailViewController ()
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) AppDelegate *app;
@end


@implementation NewsDetailViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    _webView = [[UIWebView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [_webView setDelegate:self];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_newsUrl]]];
    [_webView.scrollView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    [self.view addSubview:_webView];
    [self setView:_webView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [_app.activityIndicator startAnimating];
    NSLog(@"Loading starts");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [_app.activityIndicator stopAnimating];
    NSLog(@"Loading ends");
}

- (void)viewWillDisappear:(BOOL)animated {
    if([_app.activityIndicator isAnimating])
       [_app.activityIndicator stopAnimating];
}

@end
