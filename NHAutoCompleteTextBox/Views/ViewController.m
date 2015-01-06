//
//  ViewController.m
//  NHAutoCompleteTextBox
//
//  Created by Shahan on 12/12/2014.
//  Copyright (c) 2014 Shahan. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

#define kCellIdentifier @"cellIdentifier"

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
 
     UIImageView *imgView = [[UIImageView alloc] initWithFrame:self.view.frame];
     imgView.image = [UIImage imageNamed:@"Maple Leaf@2x.png"];
    [self.view addSubview:imgView];
    
     CGFloat controlWidth = 200;
     UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((kScreenSize.width - 150) / 2, 30, 150, 30)];
    [titleLabel setFont:[UIFont fontWithName:titleLabel.font.fontName size:13.0f]];
    [titleLabel setText:@"Auto complete Demo"];

     UILabel *subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake((kScreenSize.width - controlWidth) / 2, 95, controlWidth, 30)];
    [subTitleLabel setFont:[UIFont fontWithName:subTitleLabel.font.fontName size:12.0f]];
    [subTitleLabel setText:@"Find Countries and their capitals"];
    
     // Setup auto complete text field
     autoCompleteTextField = [[NHAutoCompleteTextField alloc] initWithFrame:CGRectMake((kScreenSize.width - controlWidth) / 2, 120, controlWidth, 18)];
    [autoCompleteTextField setDropDownDirection:NHDropDownDirectionDown];
    [autoCompleteTextField setDataSourceDelegate:self];
    [autoCompleteTextField setDataFilterDelegate:self];
    
    [self.view addSubview:titleLabel];
    [self.view addSubview:subTitleLabel];
    [self.view addSubview:autoCompleteTextField];
    
     manager = [[DataManager alloc] init];
     inUseDataSource = [manager fetchDataSynchronously];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - NHAutoComplete DataSource delegate functions

- (NSInteger)autoCompleteTextBox:(NHAutoCompleteTextField *)autoCompleteTextBox numberOfRowsInSection:(NSInteger)section
{
    return [inUseDataSource count];
}

- (UITableViewCell *)autoCompleteTextBox:(NHAutoCompleteTextField *)autoCompleteTextBox cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [autoCompleteTextBox.suggestionListView dequeueReusableCellWithIdentifier:kCellIdentifier];
    
    // Create cell, you can use the most recent way to create a cell.
    if(!cell)
    {
         cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kCellIdentifier];
        [cell.textLabel setFont:[UIFont fontWithName:cell.textLabel.font.fontName size:13.5f]];
        [cell.detailTextLabel setFont:[UIFont fontWithName:cell.detailTextLabel.font.fontName size:11.0f]];
        
        [cell.textLabel setTextColor:[UIColor brownColor]];
        [cell.detailTextLabel setTextColor:[UIColor grayColor]];
        [cell setBackgroundColor:[UIColor textBoxColor]];
    }
    
     // Set text
    [cell.textLabel setText:[inUseDataSource[indexPath.row] objectForKey:@"CountryName"]];
    [cell.detailTextLabel setText:[inUseDataSource[indexPath.row] objectForKey:@"Capital"]];
    
     // Clear previously highlighted text
    [cell.textLabel normalizeSubstring:cell.textLabel.text];
    [cell.detailTextLabel normalizeSubstring:cell.detailTextLabel.text];
    
     // Highlight the selection
    if(autoCompleteTextBox.filterString)
    {
        [cell.textLabel boldSubstring:autoCompleteTextBox.filterString];
        [cell.detailTextLabel boldSubstring:autoCompleteTextBox.filterString];
    }
    
    return cell;
}

#pragma mark - NHAutoComplete Filter data source delegate functions

-(BOOL)shouldFilterDataSource:(NHAutoCompleteTextField *)autoCompleteTextBox
{
    return YES;
}

-(void)autoCompleteTextBox:(NHAutoCompleteTextField *)autoCompleteTextBox didFilterSourceUsingText:(NSString *)text
{
    if ([text length] == 0)
    {
        inUseDataSource = [[manager dataSource] mutableCopy];
        return;
    }
    
    NSPredicate *predCountry = [NSPredicate predicateWithFormat:@"%K CONTAINS[cd] %@", @"CountryName", text];
    NSPredicate *predCapital = [NSPredicate predicateWithFormat:@"%K CONTAINS[cd] %@", @"Capital", text];
    
    // Want to look the matches in both country name and capital
    NSCompoundPredicate *compoundPred = [[NSCompoundPredicate alloc] initWithType:NSOrPredicateType subpredicates:[NSArray arrayWithObjects:predCountry, predCapital, nil]];
    
    NSArray *filteredArr = [[manager dataSource] filteredArrayUsingPredicate:compoundPred];
    inUseDataSource = filteredArr;
}

@end
