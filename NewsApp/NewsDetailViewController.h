//
//  NewsDetailViewController.h
//  NewsApp
//
//  Created by Prabh Dhaliwal on 9/20/14.
//  Copyright (c) 2014 WestPac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsDetailViewController : UIViewController <UIWebViewDelegate>

@property(strong, nonatomic) NSString * newsUrl;

@end
