//
//  HSGReviewParser.m
//  TourGuide
//
//  Created by Sudeep Unnikrishnan on 5/30/15.
//  Copyright (c) 2015 Sudeep Unnikrishnan. All rights reserved.
//

#import "HSGReviewParser.h"
#import "HSGUtility.h"

@implementation HSGReviewParser

/**
 *  Parsing of review list response
 *
 *  @param dataDictionary response converted to dic
 *
 *  @return array of reviews
 */

-(NSArray*)parseReviewList:(NSDictionary*)dataDictionary
{
    if(dataDictionary)
    {
        NSMutableArray *reviewArray = [NSMutableArray new];
        for(NSDictionary *dict in dataDictionary)
        {
            HSGReviewModel *modelObj = [[HSGReviewModel alloc]initWithDictionary:dict];
            [reviewArray addObject:modelObj];
        }
        
        return reviewArray;
    }
    return nil;
}
/**
 *  parsing of review detail response
 *
 *  @param dataDictionary rrsponse converted to dic
 *
 *  @return HSGReviewModel object
 */
-(HSGReviewModel*)parseReviewDetail:(NSDictionary*)dataDictionary
{    
    if(dataDictionary)
    {
        HSGReviewModel *modelObj = [[HSGReviewModel alloc]initWithDictionary:dataDictionary];
        
        return modelObj;
    }
    return nil;
}

@end
