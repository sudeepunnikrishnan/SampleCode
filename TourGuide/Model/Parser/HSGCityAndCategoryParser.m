//
//  HSGCityAndCategoryParser.m
//  TourGuide
//
//  Created by Sudeep Unnikrishnan on 5/30/15.
//  Copyright (c) 2015 Sudeep Unnikrishnan. All rights reserved.
//

#import "HSGCityAndCategoryParser.h"

@implementation HSGCityAndCategoryParser

/**
 *  Method to parse city and category
 *
 *  @param dataDictionary response being converted
 *
 *  @return dictionary of arrays
 */
-(NSDictionary*)parseCityAndCategoryData:(NSDictionary*)dataDictionary
{
    if(dataDictionary)
    {
        NSArray *cityList = [dataDictionary allKeys];
        NSArray *categoryList = [[dataDictionary valueForKey:[cityList firstObject]] allKeys];
        
        NSMutableDictionary *filterDictionary = [NSMutableDictionary new];
        [filterDictionary setObject:cityList forKey:@"CITY"];
        [filterDictionary setObject:categoryList forKey:@"CATEGORY"];
        
        return filterDictionary;
    }
    return nil;
}

@end
