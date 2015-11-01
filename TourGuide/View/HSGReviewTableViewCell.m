//
//  HSGReviewTableViewCell.m
//  TourGuide
//
//  Created by Sudeep Unnikrishnan on 5/28/15.
//  Copyright (c) 2015 Sudeep Unnikrishnan. All rights reserved.
//

#import "HSGReviewTableViewCell.h"

@implementation HSGReviewTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.contentView layoutIfNeeded];
    self.reviewTextLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.reviewTextLabel.frame);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
