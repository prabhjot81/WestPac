//
//  WebService.h
//  NewsApp
//
//  Created by Prabh Dhaliwal on 9/20/14.
//  Copyright (c) 2014 WestPac. All rights reserved.
//

typedef void (^OperationErrorHandler)(NSError* error);

#import <Foundation/Foundation.h>

@interface WebService : NSObject

+ (void) getNewsListOperationCompletion:(void (^)(id))completionHandler errorHandler:(OperationErrorHandler)errorHandler;

@end
