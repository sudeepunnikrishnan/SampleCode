//
//  HSGReviewBusiness.m
//  TourGuide
//
//  Created by Sudeep Unnikrishnan on 5/28/15.
//  Copyright (c) 2015 Sudeep Unnikrishnan. All rights reserved.
//

#define CITY_CATEGORY_LIST_URL @"http://tour-pedia.org/api/getPlacesStatistics"
#define REVIEW_DETAIL_URL @"http://tour-pedia.org/api/getReviewDetails?id=%@"
#define REVIEW_LIST_URL @"http://tour-pedia.org/api/getReviews?location=%@&category=%@&startDate=%@&endDate=%@"
#define REVIEW_LIST_PLACE_URL @"http://tour-pedia.org/api/getReviewsByPlaceId?placeId=%@"



#import "HSGReviewBusiness.h"
#import "HSGWebConnectionHandler.h"
#import "HSGCityAndCategoryParser.h"
#import "HSGReviewParser.h"
#import "HSGUtility.h"

@implementation HSGReviewBusiness

-(void)fetchCityAndCategoryWithHandler:(void (^)(NSDictionary *dictionary,NSError *error))completionHandler
{
    
    if(![HSGUtility isNetworkReachable])
    {
        NSError *error = [[NSError alloc]initWithDomain:@"Check Your Internet Connectivity" code:kCFURLErrorNetworkConnectionLost userInfo:nil];
        
        completionHandler(nil,error);
        return;
    }
    HSGWebConnectionHandler *webC = [[HSGWebConnectionHandler alloc]init];
    NSMutableURLRequest *url = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:CITY_CATEGORY_LIST_URL]];
    [webC initWithRequest:url withSuccess:^(NSData *data, NSURLResponse *response) {
        if(data)
        {
            HSGCityAndCategoryParser *parserObj = [HSGCityAndCategoryParser new];
            NSDictionary *parsedDictionary = [parserObj parseCityAndCategoryData:[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil]];
            completionHandler(parsedDictionary,nil);
        }
    } andFailure:^(NSData *data, NSURLResponse *response, NSError *error) {
        completionHandler(nil,error);
    }];

    
}
-(void)fetchReviewForFilter:(HSGFilterModel*)filterObj withHandler:(void (^)(NSArray *array,NSError *error))completionHandler
{
    NSString *urlString = [NSString stringWithFormat:REVIEW_LIST_URL,filterObj.location,filterObj.category,filterObj.startDate,filterObj.endDate];
    if([filterObj.keyword length])
    {
        urlString = [urlString stringByAppendingFormat:@"&keyword=%@",filterObj.keyword];
    }
    HSGWebConnectionHandler *webC = [[HSGWebConnectionHandler alloc]init];
    NSMutableURLRequest *url = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [webC initWithRequest:url withSuccess:^(NSData *data, NSURLResponse *response) {
        if(data)
        {
            HSGReviewParser *parserObj = [HSGReviewParser new];
            NSArray *parsedDictionary = [parserObj parseReviewList:[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil]];
            completionHandler(parsedDictionary,nil);
        }
    } andFailure:^(NSData *data, NSURLResponse *response, NSError *error) {
        completionHandler(nil,error);
    }];
}
-(void)fetchReviewDetailForReview:(NSString*)reviewId withHandler:(void (^)(id data,NSError *error))completionHandler
{
    HSGWebConnectionHandler *webC = [[HSGWebConnectionHandler alloc]init];
    NSMutableURLRequest *url = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:reviewId]];
    [webC initWithRequest:url withSuccess:^(NSData *data, NSURLResponse *response) {
        if(data)
        {
            HSGReviewParser *parserObj = [HSGReviewParser new];
            id parsedDictionary = [parserObj parseReviewDetail:[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil]];
            completionHandler(parsedDictionary,nil);
        }
    } andFailure:^(NSData *data, NSURLResponse *response, NSError *error) {
        completionHandler(nil,error);
    }];
}
-(void)fetchReviewForPlace:(NSString*)placeId withHandler:(void (^)(NSArray *array,NSError *error))completionHandler
{
    HSGWebConnectionHandler *webC = [[HSGWebConnectionHandler alloc]init];
    NSMutableURLRequest *url = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:REVIEW_LIST_PLACE_URL,placeId]]];
    [webC initWithRequest:url withSuccess:^(NSData *data, NSURLResponse *response) {
        if(data)
        {
            HSGReviewParser *parserObj = [HSGReviewParser new];
            NSArray *parsedDictionary = [parserObj parseReviewList:[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil]];
            completionHandler(parsedDictionary,nil);
        }
    } andFailure:^(NSData *data, NSURLResponse *response, NSError *error) {
        completionHandler(nil,error);
    }];
}

@end
