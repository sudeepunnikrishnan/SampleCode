//
//  HSGReviewModel.h
//
//
//  Created by Sudeep Unnikrishnan on 28/05/2015
//  Copyright (c) 2015 Sudeep Unnikrishnan. All rights reserved.
//

#import <Foundation/Foundation.h> 
#import "HSGPlace.h"

@interface HSGReviewModel : NSObject

@property(strong, nonatomic)NSNumber *rating;
@property(strong, nonatomic)NSString *source;
@property(strong, nonatomic)NSNumber *time;
@property(strong, nonatomic)NSNumber *polarity;
@property(strong, nonatomic)NSString *text;
@property(strong, nonatomic)NSNumber *wordsCount;
@property(strong, nonatomic)HSGPlace *place;

@property(strong, nonatomic)NSString *reviewTime;
@property(strong, nonatomic)NSString *reviewDetailLink;
@property(strong, nonatomic)NSDate   *reviewDateTime;

- (instancetype)initWithDictionary:(NSDictionary*)dictionary;

@end
