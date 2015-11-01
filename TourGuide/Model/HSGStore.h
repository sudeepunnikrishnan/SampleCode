//
//  HSGStore.h
//  TourGuide
//
//  Created by Sudeep Unnikrishnan on 5/28/15.
//  Copyright (c) 2015 Sudeep Unnikrishnan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSGFilterModel.h"

@interface HSGStore : NSObject

-(void)fetchCityAndCategoryList:(void (^)(NSDictionary *dictionary,NSError *error))completionHandler;
+(HSGStore*)sharedInstance;
-(void)fetchReviewListForFilter:(HSGFilterModel*)filterModel withHandler:(void (^)(NSArray *array,NSError *error))completionHandler;
-(void)fetchReviewDetail:(NSString*)detailID withHandler:(void (^)(id data,NSError *error))completionHandler;
-(void)fetchReviewListForPlace:(NSString*)placeID withHandler:(void (^)(NSArray *array,NSError *error))completionHandler;
-(NSDate*)getDefaultPastDate;
-(NSDate*)getDefaultFutureDate;
-(NSArray*)performReviewSort:(NSArray*)reviewArray isDescending:(BOOL)isDescending;

@end
