//
//  HSGReviewViewController.m
//  TourGuide
//
//  Created by Sudeep Unnikrishnan on 5/28/15.
//  Copyright (c) 2015 Sudeep Unnikrishnan. All rights reserved.
//

#import "HSGReviewViewController.h"
#import "HSGWebConnectionHandler.h"
#import "HSGReviewTableViewCell.h"
#import "HSGUtility.h"
#import "HSGStore.h"
#import "HSGReviewModel.h"
#import "HSGReviewDetailViewController.h"

@interface HSGReviewViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
{
    UIDatePicker *datePicker;
    __weak IBOutlet UIView *filterView;
    __weak IBOutlet UIView *filterHeaderView;
    __weak IBOutlet UITableView *reviewTableView;
    __weak IBOutlet UISearchBar *keySearchBar;
    __weak IBOutlet UIButton *filterButton;
    __weak IBOutlet UILabel *headerLabel;
    __weak IBOutlet UIButton *sortButton;
    __weak IBOutlet NSLayoutConstraint *searchBarTopConstraint;
    __weak IBOutlet UIButton *toDateButton;
    __weak IBOutlet UIButton *fromDateButton;
    BOOL isFilterViewVisible;
    NSArray *reviewArray;
    __weak IBOutlet UIView *errorView;
    __weak IBOutlet UILabel *errorLabel;
    
    __weak IBOutlet UILabel *categoryValueLabel;
    __weak IBOutlet UILabel *locationValueLabel;
    NSDate *pastDate;
    NSDate *futureDate;
    NSString * searchString;
    BOOL isDescending;
    
    NSArray *cityArray ,*categoryArray;
}
- (IBAction)filterAction:(id)sender;
- (IBAction)sortAction:(id)sender;
- (IBAction)categoryAction:(id)sender;
- (IBAction)locationAction:(id)sender;
- (IBAction)fromDateAction:(id)sender;
- (IBAction)toDateAction:(id)sender;


@end

@implementation HSGReviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateNavigationBar];
    [self performViewUpdate];
    [self fetchInitialData];
    [reviewTableView reloadData];
    
}

/**
 *  Method to update navigation bar color
 */
-(void)updateNavigationBar
{
    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:43.0/255.0 green:68/255.0 blue:134.0/255.0 alpha:1.0];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:43.0/255.0 green:68/255.0 blue:134.0/255.0 alpha:1.0];
    self.navigationController.navigationBar.tintColor =[UIColor colorWithRed:0 green:0 blue:0 alpha:1.0];
}

/**
 *  Method to fetch data
 */
-(void)fetchInitialData
{
    if([cityArray count])
    {
        [self fetchReviews];
    }
    else
    {
    [HSGUtility showHideLoadingView:YES withSpinner:YES withMessage:@"Loading"];
        [[HSGStore sharedInstance] fetchCityAndCategoryList:^(NSDictionary *dictionary, NSError *error) {
            if(dictionary)
            {
                cityArray = [dictionary valueForKey:@"CITY"];
                categoryArray = [dictionary valueForKey:@"CATEGORY"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self setInitialData];
                });
                [self fetchReviews];
            }
            else
            {
                           dispatch_async(dispatch_get_main_queue(), ^{
                [HSGUtility showHideLoadingView:NO withSpinner:YES withMessage:@"Loading"];
                errorView.alpha = 1.0;
                errorLabel.text = @"Sorry No Data Available Currently";
                
            });
 
            }
        }];
    }

}

/**
 *  Method to set UI data
 */
-(void)setInitialData
{
    categoryValueLabel.text = [categoryArray firstObject];
    locationValueLabel.text = [cityArray firstObject];
    [self updateHeaderLabel];
}

-(void)updateHeaderLabel
{
    headerLabel.text = locationValueLabel.text;
    headerLabel.text = [headerLabel.text stringByAppendingFormat:@" (%@)",categoryValueLabel.text];
}

/**
 *  Method to fetch reviews from service
 */
-(void)fetchReviews
{
    [HSGUtility showHideLoadingView:YES withSpinner:YES withMessage:@"Loading"];
    HSGFilterModel *filterModelObj = [HSGFilterModel new];
    filterModelObj.category = categoryValueLabel.text;
    filterModelObj.location = locationValueLabel.text;
    filterModelObj.startDate = [HSGUtility getFormattedDate:pastDate withFormat:@"dd-MM-yyyy"];
    filterModelObj.endDate = [HSGUtility getFormattedDate:futureDate withFormat:@"dd-MM-yyyy"];
    filterModelObj.keyword = searchString;
    [[HSGStore sharedInstance] fetchReviewListForFilter:filterModelObj withHandler:^(NSArray *array, NSError *error) {
        if(array && [array count])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                errorView.alpha = 0.0f;
                [HSGUtility showHideLoadingView:NO withSpinner:YES withMessage:@"Loading"];
                reviewArray = array;
                [reviewTableView reloadData];
                
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [HSGUtility showHideLoadingView:NO withSpinner:YES withMessage:@"Loading"];
                errorView.alpha = 1.0f;
                errorLabel.text = @"Currently No Reviews Available";
                                
            });
        }
    }];
     
}

/**
 *  Initial Update of View with default data
 */
-(void)performViewUpdate
{
    pastDate = [[HSGStore sharedInstance]getDefaultPastDate];
    futureDate = [[HSGStore sharedInstance] getDefaultFutureDate];
    [fromDateButton setTitle:[HSGUtility getFormattedDate:pastDate withFormat:@"MMM dd,yyyy"]forState:UIControlStateNormal];
    [toDateButton setTitle:[HSGUtility getFormattedDate:futureDate withFormat:@"MMM dd,yyyy"] forState:UIControlStateNormal];
    
    if(!isFilterViewVisible)
    {
        searchBarTopConstraint.constant = 0.0f;
        [self updateViewConstraints];
    }
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
    if(datePicker || [keySearchBar isFirstResponder])
    {
        [self updateView];
        return;
    }
    if(isFilterViewVisible)
    {
        [self filterAction:nil];
    }
    HSGReviewDetailViewController *detailController = (HSGReviewDetailViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"HSGReviewDetailViewController"];
    [self.navigationController pushViewController:detailController animated:YES];
    HSGReviewModel *modelObj = [reviewArray objectAtIndex:indexPath.row];
    detailController.reviewID = modelObj.reviewDetailLink;
    
}

/**
 *  Method to make changes to view while actions over the view
 */
-(void)updateView
{
    if(datePicker || [keySearchBar isFirstResponder])
    {
        [datePicker removeFromSuperview];
        reviewTableView.scrollEnabled = YES;
        datePicker = nil;
        [keySearchBar resignFirstResponder];
    }
}

/**
 *  Method to show filter
 *
 *  @param sender <#sender description#>
 */
- (IBAction)filterAction:(id)sender {
    [self updateView];
    if(isFilterViewVisible)
    {
        isFilterViewVisible = NO;
        [UIView animateWithDuration:0.6 delay:0.0 usingSpringWithDamping:1.0 initialSpringVelocity:4.0 options:0 animations:^{
                                searchBarTopConstraint.constant = 0;
                                 [self.view layoutIfNeeded];
                            }
                         completion:^(BOOL finished) {
                             //Completion Block
                         }];
        
    }
    else
    {
        isFilterViewVisible = YES;
        [UIView animateWithDuration:1.0 delay:0.0 usingSpringWithDamping:0.45 initialSpringVelocity:7.0 options:0 animations:^{
            searchBarTopConstraint.constant = 95;
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            
        }];
    }
}

/**
 *  method to perform sorting operation
 *
 *  @param sender <#sender description#>
 */
- (IBAction)sortAction:(id)sender {
    [self updateView];
    if(isDescending)
    {
        isDescending = NO;
        reviewArray = [[HSGStore sharedInstance]performReviewSort:reviewArray isDescending:isDescending];
    }
    else
    {
        isDescending = YES;
        reviewArray = [[HSGStore sharedInstance]performReviewSort:reviewArray isDescending:isDescending];
    }
    [reviewTableView reloadData];
}

/**
 *  show category list for selection
 *
 *  @param sender <#sender description#>
 */
- (IBAction)categoryAction:(id)sender {
    
    if([categoryArray count])
    {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle: @"Select Category"
                                                       delegate: self
                                              cancelButtonTitle: nil
                                         destructiveButtonTitle: nil
                                              otherButtonTitles: nil];
    sheet.tag = 99;
    
    for( NSString *title in categoryArray)  {
        [sheet addButtonWithTitle:title];
    }
    
    [sheet addButtonWithTitle:@"Cancel"];
    sheet.cancelButtonIndex = [categoryArray count];
    
    [sheet showInView:self.view];
    }
    else
    {
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Currently No Other Category Available" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}

/**
 *  method to show location list
 *
 *  @param sender <#sender description#>
 */
- (IBAction)locationAction:(id)sender {
    
    if([cityArray count])
    {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle: @"Select Location"
                                                       delegate: self
                                              cancelButtonTitle: nil
                                         destructiveButtonTitle: nil
                                              otherButtonTitles: nil];
    sheet.tag = 100;
    
    for( NSString *title in cityArray)  {
        [sheet addButtonWithTitle:title];
    }
    
    [sheet addButtonWithTitle:@"Cancel"];
    sheet.cancelButtonIndex = [cityArray count];
    
    [sheet showInView:self.view];
    }
    else
    {
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Currently No Other City Available" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}

/**
 *  show from date selection
 *
 *  @param sender <#sender description#>
 */
- (IBAction)fromDateAction:(id)sender
{
    if(datePicker)
    {
        [datePicker removeFromSuperview];
        datePicker = nil;
    }
    datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 35, 30, 30)];
    datePicker.frame = CGRectMake(datePicker.frame.origin.x
                                      ,filterView.frame.origin.y+filterView.frame.size.height , datePicker.frame.size.width, datePicker.frame.size.height);
    
    if(pastDate)
        datePicker.date = pastDate;
    datePicker.backgroundColor = [UIColor whiteColor];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker addTarget:self action:@selector(fromServiceDateSelected) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:datePicker];
    reviewTableView.scrollEnabled = NO;
}

-(void)fromServiceDateSelected
{
    if([futureDate compare:datePicker.date] == NSOrderedAscending)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"From Date should be less than To Date" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if ([HSGUtility getNumberOfDaysBetweenStartDate:datePicker.date andEndDate:futureDate shouldIgnoreTime:YES]>32)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please select a time interval of 1 month or less" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }

    else
    {
        pastDate = datePicker.date;
        [fromDateButton setTitle:[HSGUtility getFormattedDate:pastDate withFormat:@"MMM dd,yyyy"]forState:UIControlStateNormal];
        [self fetchInitialData];
    
    }
    [datePicker removeFromSuperview];
    reviewTableView.scrollEnabled = YES;
    datePicker = nil;
    
}
/**
 *  show from date selection
 *
 *  @param sender <#sender description#>
 */
- (IBAction)toDateAction:(id)sender
{
    if(datePicker)
    {
        [datePicker removeFromSuperview];
        datePicker = nil;
    }
    datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 35, 30, 30)];
    datePicker.frame = CGRectMake(datePicker.frame.origin.x
                                   ,filterView.frame.origin.y+filterView.frame.size.height , datePicker.frame.size.width, datePicker.frame.size.height);

    if(futureDate)
        datePicker.date = futureDate;
    
    datePicker.backgroundColor = [UIColor whiteColor];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker addTarget:self action:@selector(toServiceDateSelected) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:datePicker];
    reviewTableView.scrollEnabled = NO;
}

-(void)toServiceDateSelected
{
    
    if([pastDate compare:datePicker.date] == NSOrderedDescending)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"To Date should be greater than From Date" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if ([HSGUtility getNumberOfDaysBetweenStartDate:pastDate andEndDate:datePicker.date shouldIgnoreTime:YES]>30)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please select a time interval of 1 month or less" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        futureDate = datePicker.date;
        [toDateButton setTitle:[HSGUtility getFormattedDate:futureDate withFormat:@"MMM dd,yyyy"] forState:UIControlStateNormal];
            [self fetchInitialData];
       
    }
    
    [datePicker removeFromSuperview];
    reviewTableView.scrollEnabled = YES;
    datePicker = nil;
}

/**
 *  Delegate used to handle datepicker and keyboard on views
 *
 *  @param touches <#touches description#>
 *  @param event   <#event description#>
 */
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if(datePicker)
    {
        [datePicker removeFromSuperview];
        reviewTableView.scrollEnabled = YES;
        datePicker = nil;
    }
    if([keySearchBar isFirstResponder])
    {
        [keySearchBar resignFirstResponder];
        return;
    }
}

#pragma UISearchBar delegates
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
    if(![searchText isEqualToString:@""])
    {
        if([searchText length]>4){
          searchString = searchText;
          [self fetchInitialData];
        }
    }
    else
    {
        searchString = @"";
        [self fetchInitialData];
    }
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    if([searchBar.text isEqualToString:@""])
    {
        searchString = @"";
    }
    
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    if(![searchBar.text isEqualToString:@""])
    {
        searchString = searchBar.text;
        [self fetchInitialData];
    }
    [searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if(![searchBar.text isEqualToString:@""])
    {
        searchString = searchBar.text;
        [self fetchInitialData];
    }
    [searchBar resignFirstResponder];
    // You can write search code Here
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchString = @"";
    searchBar.text = searchString;
    [searchBar resignFirstResponder];
}

#pragma UIActionsheet delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(![[[actionSheet buttonTitleAtIndex:buttonIndex] uppercaseString] isEqualToString:@"CANCEL"])
    {
    if (actionSheet.tag == 99) {
        categoryValueLabel.text = [actionSheet buttonTitleAtIndex:buttonIndex];
    }
    else if (actionSheet.tag == 100){
        locationValueLabel.text = [actionSheet buttonTitleAtIndex:buttonIndex];
    }
    [self updateHeaderLabel];
    [self fetchInitialData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
