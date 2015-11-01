//
//  HSGReviewDetailViewController.m
//  TourGuide
//
//  Created by Sudeep Unnikrishnan on 5/31/15.
//  Copyright (c) 2015 Sudeep Unnikrishnan. All rights reserved.
//

#import "HSGReviewDetailViewController.h"
#import "HSGStore.h"
#import "HSGReviewModel.h"
#import "HSGReviewTableViewCell.h"
#import "HSGUtility.h"
@interface HSGReviewDetailViewController ()
{
    NSArray *reviewArray;
}
@property (weak, nonatomic) IBOutlet UILabel *ratingValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityValuLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *reviewLabel;
@property (weak, nonatomic) IBOutlet UILabel *sourceValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateValueLabel;
@property (weak, nonatomic) IBOutlet UITableView *reviewTableView;
@property (weak, nonatomic) IBOutlet UIView *errorView;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (weak, nonatomic) IBOutlet UIButton *moreReviewButton;

- (IBAction)moreReviewAction:(id)sender;
@end

@implementation HSGReviewDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    self.navigationItem.title = @"Place Review";
    // Do any additional setup after loading the view.
    [self fetchData];
}

/**
 *  Method to fetch Data
 */
-(void)fetchData
{
    [HSGUtility showHideLoadingView:YES withSpinner:YES withMessage:@"Loading"];
    [[HSGStore sharedInstance]fetchReviewDetail:self.reviewID withHandler:^(id data, NSError *error) {
        if(data && [data isKindOfClass:[HSGReviewModel class]])
        {
            [self updateViewData:data];
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
            _moreReviewButton.alpha = 0.5;
            _moreReviewButton.userInteractionEnabled = NO;
            });
            NSLog(@"No data available");
        }
    }];
}

/**
 *  Method to update UI after service response
 *
 *  @param modelObj response object
 */
-(void)updateViewData:(HSGReviewModel*)modelObj
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [HSGUtility showHideLoadingView:NO withSpinner:NO withMessage:@""];
        self.ratingValueLabel.text = [NSString stringWithFormat:@"%@",modelObj.rating];
        self.placeValueLabel.text = modelObj.place.name;
        self.cityValuLabel.text = modelObj.place.location;
        self.sourceValueLabel.text = modelObj.source;
        if([modelObj.text length])
        {
        NSAttributedString * attributedText = [[NSAttributedString alloc] initWithData:[modelObj.text dataUsingEncoding:NSUTF8StringEncoding]
                                                                               options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType}
                                                                    documentAttributes:nil
                                                                                 error:nil];
        self.reviewLabel.attributedText = attributedText;
            self.reviewLabel.font = [UIFont fontWithName:@"Helvetica Neue-Regular" size:15.0];
        }
        else
        {
            modelObj.text = @"";
        }
        self.categoryValueLabel.text = modelObj.place.category;
        self.dateValueLabel.text = modelObj.reviewTime;
        self.placeID = modelObj.place.placeID;
        
    });

}

#pragma mark - UITableview delegates and Datasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-  (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [reviewArray count];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    NSArray *topLevelObjects;
    UITableViewCell *commonCell = nil;
    static NSString *cellIdentifier = @"reviewCell";
    
    HSGReviewTableViewCell *cell = (HSGReviewTableViewCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"HSGReviewTableViewCell" owner:nil options:nil];
        
        for (id currentObject in topLevelObjects)
        {
            if ([currentObject isKindOfClass:[UITableViewCell class]])
            {
                cell =  (HSGReviewTableViewCell *) currentObject;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                break;
            }
        }
    }
    if([reviewArray count])
    {
        _moreReviewButton.alpha = 0.5;
        _moreReviewButton.userInteractionEnabled = NO;
        HSGReviewModel *modelObj = [reviewArray objectAtIndex:indexPath.row];
        
        cell.ratingValueLabel.text =[NSString stringWithFormat:@"%@",modelObj.rating];
        
        cell.sourceLabel.text = modelObj.source;
        cell.dateLabel.text = modelObj.reviewTime;
        
        if([modelObj.text length])
        {
         NSAttributedString * attributedText = [[NSAttributedString alloc] initWithData:[modelObj.text dataUsingEncoding:NSUTF8StringEncoding]
                                                                               options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType}
                                                                    documentAttributes:nil
                                                                                 error:nil];
        
         cell.reviewTextLabel.attributedText = attributedText;
         cell.reviewTextLabel.font = [UIFont fontWithName:@"Helvetica Neue-Regular" size:15.0];
        }
        else
        {
            cell.reviewTextLabel.text = @"";
        }
        
    }
    commonCell = cell;
    [commonCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return commonCell;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //static NSString *cellIdentifier;
    UIView *header = [[UIView alloc]initWithFrame:CGRectZero];
    
    return header;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return  0.01f ;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HSGReviewModel *modelObj = [reviewArray objectAtIndex:indexPath.row];
    self.reviewID = modelObj.reviewDetailLink;
    [self fetchData];
}

/**
 *  Method to fetch review list based on same place
 *
 *  @param sender <#sender description#>
 */
- (IBAction)moreReviewAction:(id)sender {
    
    [HSGUtility showHideLoadingView:YES withSpinner:YES withMessage:@"Loading"];
    [[HSGStore sharedInstance]fetchReviewListForPlace:self.placeID withHandler:^(NSArray *array, NSError *error) {
        if(array && [array count])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                _errorView.alpha = 0.0f;
                [HSGUtility showHideLoadingView:NO withSpinner:YES withMessage:@"Loading"];
                reviewArray = array;
                [_reviewTableView reloadData];
                
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [HSGUtility showHideLoadingView:NO withSpinner:YES withMessage:@"Loading"];
                _errorView.alpha = 1.0f;
                _errorLabel.text = @"Currently No More Reviews Available";
                  
                
            });
        }

    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
