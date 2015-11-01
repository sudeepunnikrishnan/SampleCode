//
//  HSGReviewBusiness.h
//  TourGuide
//
//  Created by Sudeep Unnikrishnan on 5/28/15.
//  Copyright (c) 2015 Sudeep Unnikrishnan. All rights reserved.
//
#import "HSGFilterModel.h"
#import <Foundation/Foundation.h>

@interface HSGReviewBusiness : NSObject


-(void)fetchCityAndCategoryWithHandler:(void (^)(NSDictionary *dictionary,NSError *error))completionHandler;
-(void)fetchReviewForFilter:(HSGFilterModel*)filterObj withHandler:(void (^)(NSArray *array,NSError *error))completionHandler;
-(void)fetchReviewDetailForReview:(NSString*)reviewId withHandler:(void (^)(id data,NSError *error))completionHandler;
-(void)fetchReviewForPlace:(NSString*)placeId withHandler:(void (^)(NSArray *array,NSError *error))completionHandler;


@end
