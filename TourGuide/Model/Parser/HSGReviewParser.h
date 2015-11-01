//
//  HSGReviewParser.h
//  TourGuide
//
//  Created by Sudeep Unnikrishnan on 5/30/15.
//  Copyright (c) 2015 Sudeep Unnikrishnan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSGReviewModel.h"

@interface HSGReviewParser : NSObject

-(NSArray*)parseReviewList:(NSDictionary*)dataDictionary;
-(HSGReviewModel*)parseReviewDetail:(NSDictionary*)dataDictionary;

@end
