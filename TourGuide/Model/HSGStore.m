//
//  HSGStore.m
//  TourGuide
//
//  Created by Sudeep Unnikrishnan on 5/28/15.
//  Copyright (c) 2015 Sudeep Unnikrishnan. All rights reserved.
//

#import "HSGStore.h"
#import "HSGFilterModel.h"
#import "HSGReviewBusiness.h"

@interface HSGStore()
{
    
}

@end

@implementation HSGStore

/**
 * Method to create singleton object
 *
 *  @return Singleton Object
 */
+(HSGStore*)sharedInstance
{
    static dispatch_once_t onceToken;
    static HSGStore *storeObj;
    dispatch_once(&onceToken, ^{
        storeObj = [[self alloc]init];
    });
    return storeObj;
}

/**
 *  Method to fetch city and category list
 *
 *  @param completionHandler returns dictionary of arrays
 */

-(void)fetchCityAndCategoryList:(void (^)(NSDictionary *dictionary,NSError *error))completionHandler
{
    HSGReviewBusiness *reviewBusinessObj = [[HSGReviewBusiness alloc]init];
    [reviewBusinessObj fetchCityAndCategoryWithHandler:^(NSDictionary *dictionary, NSError *error) {
        if(dictionary)
        {
            
            completionHandler(dictionary,nil);
        }
        else
        {
            completionHandler(nil,error);
        }
    }];
}

/**
 *  Method to fetch Review list
 *
 *  @param filterModel       parameters passed for fetching list
 *  @param completionHandler returns array of HSGReviewModel objects
 */
-(void)fetchReviewListForFilter:(HSGFilterModel*)filterModel withHandler:(void (^)(NSArray *array,NSError *error))completionHandler
{
    HSGReviewBusiness *reviewBusinessObj = [[HSGReviewBusiness alloc]init];
    [reviewBusinessObj fetchReviewForFilter:filterModel withHandler:^(NSArray *array, NSError *error) {
        if(array && [array count])
        {
            completionHandler(array,nil);
        }
        else
        {
            completionHandler(nil,error);
        }
    }];
}

/**
 *  Method to fetch Review detail using detail link
 *
 *  @param detailID          the review detail link
 *  @param completionHandler returns object
 */

-(void)fetchReviewDetail:(NSString*)detailID withHandler:(void (^)(id data,NSError *error))completionHandler
{
    HSGReviewBusiness *reviewBusinessObj = [[HSGReviewBusiness alloc]init];
    [reviewBusinessObj fetchReviewDetailForReview:detailID withHandler:^(id data, NSError *error) {
        if(data)
        {
            completionHandler(data,nil);
        }
        else
        {
            completionHandler(nil,data);
        }
    }];
}

/**
 *  Method to fetch review with respect to place of opened detailed review
 *
 *  @param placeID           place id of currently reviewed place
 *  @param completionHandler returns array of HSGReviewModel objects
 */
-(void)fetchReviewListForPlace:(NSString*)placeID withHandler:(void (^)(NSArray *array,NSError *error))completionHandler
{
    HSGReviewBusiness *reviewBusinessObj = [[HSGReviewBusiness alloc]init];
    [reviewBusinessObj fetchReviewForPlace:placeID withHandler:^(NSArray *array, NSError *error) {
        if(array && [array count]>1)
        {
            completionHandler(array,nil);
        }else
        {
            completionHandler(nil,error);
        }
        
    }];
}

/**
 *  Method to set initial dates to filter
 *
 *  @return returns date
 */
-(NSDate*)getDefaultPastDate
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:2014];
    [components setMonth:1];
    [components setDay:1];
    NSDate *defaultDate = [calendar dateFromComponents:components];
    return defaultDate;
}

/**
 *  Method to set initial dates to filter
 *
 *  @return returns date
 */
-(NSDate*)getDefaultFutureDate
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:2014];
    [components setMonth:2];
    [components setDay:1];
    NSDate *defaultDate = [calendar dateFromComponents:components];
    return defaultDate;
}
/**
 *  Method to perform sorting
 *
 *  @param reviewArray  array to sort
 *  @param isDescending order of sorting  by date
 *
 *  @return sorted array
 */

-(NSArray*)performReviewSort:(NSArray*)reviewArray isDescending:(BOOL)isDescending
{
    NSSortDescriptor *descriptor=[[NSSortDescriptor alloc] initWithKey:@"self.reviewDateTime" ascending:!isDescending];
    NSArray *descriptors=[NSArray arrayWithObject: descriptor];
    reviewArray=[reviewArray sortedArrayUsingDescriptors:descriptors];
    return reviewArray;
}
@end
