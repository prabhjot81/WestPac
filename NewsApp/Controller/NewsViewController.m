//
//  NewsViewController.m
//  NewsApp
//
//  Created by Prabh Dhaliwal on 9/20/14.
//  Copyright (c) 2014 WestPac. All rights reserved.
//


#import "NewsViewController.h"
#import "WebService.h"
#import "News.h"
#import "NewsDetailViewController.h"
#import "AppDelegate.h"

dispatch_queue_t myBackgroundQueue;

static NSString* const kUserCellIdentifier = @"UserCellIdentifier";

@interface NewsViewController ()
@property (nonatomic, retain) NSArray *newsListArray;
@property (nonatomic, retain) NSMutableDictionary *newsListImageDictionary;
@property (nonatomic, strong) AppDelegate *app;

@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"News";

    _app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    _newsListImageDictionary = [[NSMutableDictionary alloc] init];
    // add refresh button
    UIBarButtonItem *refreshItem = [[UIBarButtonItem alloc] initWithTitle:@"Refresh" style:UIBarButtonItemStylePlain target:self action:@selector(fetchNews)];
    self.navigationItem.leftBarButtonItem = refreshItem;

    [self fetchNews];
}

- (void) reloadTableView {
    [_app.activityIndicator stopAnimating];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma Fetching news from web service

- (void) fetchNews {
    [_app.activityIndicator startAnimating];
    [WebService getNewsListOperationCompletion:^(id requestList) {
        _newsListArray = [News arrayFromJSONArray:requestList];
        NSLog(@"%@", _newsListArray);
        [self performSelectorOnMainThread:@selector(reloadTableView) withObject:Nil waitUntilDone:NO];
        
    }
                                  errorHandler:^(NSError *error) {
                                      NSLog(@"%@", error.userInfo);
                                      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!!!" message:error.description delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                                      [alert show];
                                  }];
    
}

#pragma TableView delegates/datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_newsListArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    News *newsItem = _newsListArray[indexPath.row];
    
    NSString *cellIdentifier = [NSString stringWithFormat:@"CellIdentifier%ld", (long)[indexPath row]];
    
    UITableViewCell * newsCell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (newsCell == nil)
    {
        newsCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        [newsCell.textLabel setText:newsItem.headline];
        [newsCell.detailTextLabel setText:newsItem.slugLine];
        [newsCell.detailTextLabel setNumberOfLines:3];
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicator.frame = CGRectMake(35, 25, 30, 30);
        [activityIndicator startAnimating];
        [activityIndicator setTag:[indexPath row]];
        [newsCell.imageView addSubview:activityIndicator];
        
        if (![_newsListImageDictionary objectForKey:[NSString stringWithFormat:@"%ld", (long)[indexPath row]]] && newsItem.thumbnailImageHref && ![newsItem.thumbnailImageHref isKindOfClass:[NSNull class]] ) {
            if ([newsItem.thumbnailImageHref length] != 0) {
               [newsCell.imageView setImage:[UIImage imageNamed:@"blank"]];
                [newsCell.imageView setFrame:CGRectMake(10, 10, 60, 60)];
                myBackgroundQueue = dispatch_queue_create("com.westpac.photo", NULL);
                dispatch_async(myBackgroundQueue, ^(void) {
                    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:newsItem.thumbnailImageHref]];
                    dispatch_async(dispatch_get_main_queue(), ^(void) {
                        [newsCell.imageView setImage:[UIImage imageWithData:imageData]];
                        [activityIndicator stopAnimating];
                        [_newsListImageDictionary setObject:imageData forKey:[NSString stringWithFormat:@"%ld", (long)[indexPath row]]];
                    });
                });
            }
        } else {
            [newsCell.imageView setImage:[UIImage imageWithData:[_newsListImageDictionary objectForKey:[NSString stringWithFormat:@"%ld", (long)[indexPath row]]]]];
        }
    }
    return newsCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NewsDetailViewController *nav = [[NewsDetailViewController alloc] init];
    News * selectedNewsItem = [_newsListArray objectAtIndex:[indexPath row]];
    [nav setNewsUrl:selectedNewsItem.tinyUrl];
    [self.navigationController pushViewController:nav animated:YES];

}

@end