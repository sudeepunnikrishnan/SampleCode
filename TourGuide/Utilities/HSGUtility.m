//
//  HSGUtility.m
//  TourGuide
//
//  Created by Sudeep Unnikrishnan on 5/30/15.
//  Copyright (c) 2015 Sudeep Unnikrishnan. All rights reserved.
//
#import "Reachability.h"
#import "HSGUtility.h"
#import "HSGAppDelegate.h"

const int kSixtySeconds =    60;
const int kSixtyMinutes =    60;
const int kTwentyFourHours = 24;
const int kHourinSeconds =   3600;

UIView *loadingView1;
HSGAppDelegate *appDelObj;
BOOL isViewOn;

@implementation HSGUtility

+ (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}

+ (BOOL)isObjectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? NO : YES;
}

+(BOOL)isNetworkReachable
{
    Reachability *reachabilityObj = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachabilityObj currentReachabilityStatus];
    
    if(networkStatus == NotReachable)
    {
        return NO;
    }
    return YES;
}

+(void)showHideLoadingView :(BOOL)isViewReqd withSpinner:(BOOL)isSpinnerReqd withMessage:(NSString*)message
{
    if(!appDelObj)
        appDelObj = (HSGAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    UIView *alreadyPresentView = (UIView*)[appDelObj.window viewWithTag:90909];
    
    if(alreadyPresentView)
    {
        [alreadyPresentView removeFromSuperview];
        isViewOn = NO;
        loadingView1 = nil;
    }
    
    if(isViewReqd && !isViewOn)
    {
        
        UIView *loadingView1 = [[UIView alloc]initWithFrame:appDelObj.window.bounds];
        isViewOn = YES;
        [loadingView1 setTag:90909];
        [loadingView1 setBackgroundColor:[UIColor grayColor]];
        loadingView1.alpha = 0.3f;
        
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        activityIndicator.alpha = 1.0;
        activityIndicator.center = loadingView1.center;
        //activityIndicator.hidesWhenStopped = NO;
        [loadingView1 addSubview:activityIndicator];
        [activityIndicator startAnimating];
        [appDelObj.window addSubview:loadingView1];
        isViewOn = YES;
    }
    else if(!isViewReqd)
    {
        if(isViewOn)
        {
            [loadingView1 removeFromSuperview];
            isViewOn = NO;
        }
    }
    

}


+ (int) getNumberOfDaysBetweenStartDate:(NSDate*) startDate andEndDate:(NSDate*) endDate shouldIgnoreTime:(BOOL) isIgnoreTime
{
    if(!startDate || !endDate)
        return 0;
    
    //GET # OF DAYS
    NSDateFormatter *df = [NSDateFormatter new];
    if(isIgnoreTime)
    {
        [df setDateFormat:@"MM dd yyyy"]; //Remove the time part
    }
    else
    {
        [df setDateFormat:@"MM dd yyyy 'at' HH:mm"];
    }
    
    NSString *startDateString = [df stringFromDate:startDate];
    NSString *endDateString = [df stringFromDate:endDate];
    NSTimeInterval time = [[df dateFromString:endDateString] timeIntervalSinceDate:[df dateFromString:startDateString]];
    
    int days = time / kSixtyMinutes / kSixtySeconds/ kTwentyFourHours;
    
    return days;
}

+ (NSString*)getFormattedDate:(NSDate*)date withFormat:(NSString*)format
{
    NSString *dateString;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    dateString =  [dateFormatter stringFromDate:date];
    dateFormatter = nil;
    return dateString;
}

+ (NSDate*)getFormattedDateFromString:(NSString*)stringDate withFormat:(NSString*)format
{
    NSDate *dateString;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    dateString =  [dateFormatter dateFromString:stringDate];
    dateFormatter = nil;
    return dateString;
}

@end
