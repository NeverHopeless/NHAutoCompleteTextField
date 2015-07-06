//
//  NHAutoCompleteTextBox.m
//  NHAutoCompleteTextBox
//
//  Created by Shahan on 12/12/2014.
//  Copyright (c) 2014 Shahan. All rights reserved.
//

#import "NHAutoCompleteTextField.h"
#import "UIView+NHExtension.h"

@implementation NHAutoCompleteTextField

@synthesize suggestionListView;
@synthesize suggestionTextField;
@synthesize dataSourceDelegate;
@synthesize dataFilterDelegate;
@synthesize dropDownDirection;
@synthesize filterString;

#pragma mark - Initializer functions

-(id)init
{
    if(self = [super init])
    {
        [self initialize];
    }
    
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
    {
        [self initialize];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self initialize];
    }
    
    return self;
}

#pragma mark - Helper functions

-(void)initialize
{
    // Background appears behind the following textfield
     UIView *backGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self addSubview:backGroundView];
    [backGroundView setBackgroundColor:[UIColor lightGrayColor]];
    
    suggestionTextField = [[UITextField alloc] initWithFrame:CGRectMake(kListLeftMargin / 2,
                                                                        kTextMarginTop,
                                                                        self.frame.size.width - kListLeftMargin,
                                                                        self.frame.size.height - (kTextMarginTop * 2))];
    [suggestionTextField setBackgroundColor:[UIColor textBoxColor]];
    [suggestionTextField setDelegate:self];
    
    [self addSubview:suggestionTextField];
    [self setBackgroundColor:[UIColor clearColor]];
     dropDownDirection = NHDropDownDirectionDown;
}

-(void)adjustListFrameForDirection:(NHDropDownDirection)direction
{
    if(direction == NHDropDownDirectionUp)
    {
        [self.suggestionListView setY:self.frame.origin.y - kExpansionHeight + 0.5];
    }
    else
    {
        [self.suggestionListView setY:self.frame.origin.y + self.frame.size.height - 0.5];
    }
    [((UIViewController *)self.dataSourceDelegate).view bringSubviewToFront:suggestionListView];
}

-(void)setupSuggestionList
{
    if(!suggestionListView)
    {
        suggestionListView = [[UITableView alloc] initWithFrame:CGRectMake(self.frame.origin.x + kListLeftMargin,
                                                                           self.frame.origin.y + suggestionTextField.frame.origin.y +
                                                                           suggestionTextField.frame.size.height + kListSeparatorHeight,
                                                                           self.frame.size.width - (kListLeftMargin * 2),
                                                                           kExpansionHeight)];
        [suggestionListView setDelegate:self];
        [suggestionListView setDataSource:self];
        [suggestionListView setBackgroundColor:[UIColor textBoxColor]];
        [[suggestionListView backgroundView] setAlpha:0.0f];
        [suggestionListView setShowsVerticalScrollIndicator:NO];
        [suggestionListView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [suggestionListView setBounces:NO];
    }
}

#pragma mark - UITableView delegate functions

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([dataSourceDelegate respondsToSelector:@selector(autoCompleteTextBox:numberOfRowsInSection:)])
    {
        return [dataSourceDelegate autoCompleteTextBox:self numberOfRowsInSection:section];
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([dataSourceDelegate respondsToSelector:@selector(autoCompleteTextBox:cellForRowAtIndexPath:)])
    {
        UITableViewCell *cell = [dataSourceDelegate autoCompleteTextBox:self cellForRowAtIndexPath:indexPath];
        
        return cell;
    }
    
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [suggestionTextField setText:[[[self.suggestionListView cellForRowAtIndexPath:indexPath] textLabel] text]];
    [self endEditing:YES];
}

#pragma mark - UITextfield delegate functions

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self setupSuggestionList];
    [suggestionListView setHidden:NO];
    
    // Add list to the super view.
    if(self.dataSourceDelegate && [self.dataSourceDelegate isKindOfClass:UIViewController.class])
    {
        [((UIViewController *)self.dataSourceDelegate).view addSubview:suggestionListView];
    }
    
    // Setup list as per the given direction
    [self adjustListFrameForDirection:dropDownDirection];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [suggestionListView setHidden:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if([textField isFirstResponder])
    {
        [textField resignFirstResponder];
    }
    
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    filterString = suggestionTextField.text;
    if([string length] == 0)
    {
        filterString = [filterString substringToIndex:MAX([filterString length] - 1, 0)];
    }
    else
    {
        filterString = [NSString stringWithFormat:@"%@%@", suggestionTextField.text, string];
    }
    
    if([self.dataFilterDelegate respondsToSelector:@selector(shouldFilterDataSource:)] &&
       [self.dataFilterDelegate shouldFilterDataSource:self])
    {
        if([self.dataFilterDelegate respondsToSelector:@selector(autoCompleteTextBox:didFilterSourceUsingText:)])
        {
            [self.dataFilterDelegate autoCompleteTextBox:self didFilterSourceUsingText:filterString];
            [self.suggestionListView reloadData];
        }
    }
    
    return YES;
}

@end
