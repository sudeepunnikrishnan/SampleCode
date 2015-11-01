//
//  HSGReviewModel.m
//
//  Created by Sudeep Unnikrishnan on 28/05/2015
//  Copyright (c) 2015 Sudeep Unnikrishnan. All rights reserved.
//

#import "HSGReviewModel.h"
#import "HSGUtility.h"

@interface HSGReviewModel (){
}

@end

@implementation HSGReviewModel

- (instancetype)initWithDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    if(self != nil)
    {
        self.polarity = [HSGUtility objectOrNilForKey:@"polarity" fromDictionary:dictionary];
        self.rating = [HSGUtility objectOrNilForKey:@"rating" fromDictionary:dictionary];
        self.source = [HSGUtility objectOrNilForKey:@"source" fromDictionary:dictionary];
        self.text = [HSGUtility objectOrNilForKey:@"text" fromDictionary:dictionary];
        id timeObject = [HSGUtility objectOrNilForKey:@"time" fromDictionary:dictionary];
        if(timeObject && [timeObject isKindOfClass:[NSString class]])
        {
            self.reviewTime = timeObject;
        }
        else if(timeObject && [timeObject isKindOfClass:[NSNumber class]])
        {
            NSNumber *time = [HSGUtility objectOrNilForKey:@"time" fromDictionary:dictionary];
            NSDate *date  = [NSDate dateWithTimeIntervalSince1970:[time doubleValue]];
            self.reviewTime = [HSGUtility getFormattedDate:date withFormat:@"YYYY-MM-dd"];
        }
        self.reviewDateTime = [HSGUtility getFormattedDateFromString:self.reviewTime withFormat:@"YYYY-MM-dd"];
        self.wordsCount = [HSGUtility objectOrNilForKey:@"wordsCount" fromDictionary:dictionary];
        self.reviewDetailLink = [HSGUtility objectOrNilForKey:@"details" fromDictionary:dictionary];
        if([HSGUtility isObjectOrNilForKey:@"place" fromDictionary:dictionary])
        {
        self.place = [HSGPlace new];
        self.place.placeID = [NSString stringWithFormat:@"%@",[HSGUtility objectOrNilForKey:@"id" fromDictionary:[dictionary valueForKey:@"place"]]];
        self.place.name = [HSGUtility objectOrNilForKey:@"name" fromDictionary:[dictionary valueForKey:@"place"]];
        self.place.location = [HSGUtility objectOrNilForKey:@"location" fromDictionary:[dictionary valueForKey:@"place"]];
        self.place.category = [HSGUtility objectOrNilForKey:@"category" fromDictionary:[dictionary valueForKey:@"place"]];
        }
    }
    return self;
    
}
@end
