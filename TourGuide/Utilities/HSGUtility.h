//
//  HSGUtility.h
//  TourGuide
//
//  Created by Sudeep Unnikrishnan on 5/30/15.
//  Copyright (c) 2015 Sudeep Unnikrishnan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSGUtility : NSObject

+(void)showHideLoadingView :(BOOL)isViewReqd withSpinner:(BOOL)isSpinnerReqd withMessage:(NSString*)message;

+ (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

+ (BOOL)isObjectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

+ (BOOL)isNetworkReachable;

+ (int) getNumberOfDaysBetweenStartDate:(NSDate*) startDate andEndDate:(NSDate*) endDate shouldIgnoreTime:(BOOL) isIgnoreTime;

+ (NSString*)getFormattedDate:(NSDate*)date withFormat:(NSString*)format;

+ (NSDate*)getFormattedDateFromString:(NSString*)stringDate withFormat:(NSString*)format;
@end
