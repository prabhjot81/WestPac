//
//  News.m
//  NewsApp
//
//  Created by Prabh Dhaliwal on 9/20/14.
//  Copyright (c) 2014 WestPac. All rights reserved.
//

#import "News.h"

static NSString* const kHeadLine = @"headLine";
static NSString* const kSlugLine = @"slugLine";
static NSString* const kThumbnailImageHref = @"thumbnailImageHref";
static NSString* const kTinyUrl = @"tinyUrl";

@implementation News

+ (NSArray*) arrayFromJSONArray:(NSArray*)inArrayOfJSONObjects
{
    if ([inArrayOfJSONObjects class] == [NSNull class])
        inArrayOfJSONObjects = nil;
    
    NSMutableArray * resultArray = [NSMutableArray array];
    
    for (NSDictionary * jsonObject in inArrayOfJSONObjects)
    {
        News * news = [[self alloc] initWithJSONData:jsonObject];
        if (news)
        {
            [resultArray addObject:news];
        }
    }
    
    return resultArray;
}

-(News *)initWithJSONData:(NSDictionary*)inDict
{
    self = [self init];
    
    NSAssert(self != nil, @"Unable to initialize User");
    
    if (self)
    {
        _headline           = [inDict objectForKey:kHeadLine];
        _slugLine           = [inDict objectForKey:kSlugLine];
        _thumbnailImageHref = [inDict objectForKey:kThumbnailImageHref];
        _tinyUrl            = [inDict objectForKey:kTinyUrl];
    }
    
    return self;
}

@end
