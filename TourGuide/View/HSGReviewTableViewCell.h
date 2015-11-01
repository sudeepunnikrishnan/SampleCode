//
//  HSGReviewTableViewCell.h
//  TourGuide
//
//  Created by Sudeep Unnikrishnan on 5/28/15.
//  Copyright (c) 2015 Sudeep Unnikrishnan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSGReviewTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *ratingValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *reviewTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *sourceLabel;

@end
