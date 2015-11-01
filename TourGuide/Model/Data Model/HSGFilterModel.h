//
//  HSGFilterModel.h
//  TourGuide
//
//  Created by Sudeep Unnikrishnan on 5/29/15.
//  Copyright (c) 2015 Sudeep Unnikrishnan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSGFilterModel : NSObject

@property(strong, nonatomic)NSString *keyword;
@property(strong, nonatomic)NSString *location;
@property(strong, nonatomic)NSString *category;
@property(strong, nonatomic)NSString *startDate;
@property(strong, nonatomic)NSString *endDate;

@end
