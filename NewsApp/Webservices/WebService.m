//
//  WebService.m
//  NewsApp
//
//  Created by Prabh Dhaliwal on 9/20/14.
//  Copyright (c) 2014 WestPac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebService.h"

static NSString* const kGET = @"GET";
static NSString* const kNewsItems = @"items";
static NSString* const kURL = @"http://mobilatr.mob.f2.com.au/services/views/9.json";

@implementation WebService : NSObject 

dispatch_queue_t myBackgroundQueue;

+ (void) getNewsListOperationCompletion:(void (^)(id))completionHandler errorHandler:(OperationErrorHandler)errorHandler {
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:kURL]];
    myBackgroundQueue = dispatch_queue_create("com.westpac.newslist", NULL);
    
    NSOperationQueue *mainQueue = [[NSOperationQueue alloc] init];
    [mainQueue setMaxConcurrentOperationCount:1];
    
    dispatch_async(myBackgroundQueue, ^(void) {
        [NSURLConnection sendAsynchronousRequest:request queue:mainQueue completionHandler:^(NSURLResponse *response, NSData *responseData, NSError *error) {
            if (!error) {
                NSData *jsonData = responseData;
                NSError* error;
                NSDictionary *responseJSONDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
                completionHandler([responseJSONDictionary objectForKey:kNewsItems]);
            }
            else {
                errorHandler(error);
            }
        }];
    });
    
}

@end
