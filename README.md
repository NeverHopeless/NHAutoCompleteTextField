<strong>NHAutoCompleteTextField</strong>
=======================

You can find the brief details on blog here:
http://journeytoios.wordpress.com/2015/01/03/nhautocompletetextfield/

<img src="https://journeytoios.files.wordpress.com/2015/01/ios-simulator-screen-shot-03-jan-2015-4-38-10-am.png" alt="Runtime View">

<b>How to integrate:</b>

All you have to take care of the two protocols
NHAutoCompleteTextFieldDataSourceDelegate and
NHAutoCompleteTextFieldDataFilterDelegate, first one for preparing and
dealing with the datasource and second one is to filter from the data
source. Two protocols may help to turn this control into simple drop
down and selection control.

<pre>
@protocol NHAutoCompleteTextFieldDataFilterDelegate

@optional

/**
If you wants to filter out records. It should return YES.
*/
-(BOOL)shouldFilterDataSource:(NHAutoCompleteTextField
*)autoCompleteTextBox;

/**
This function will help out to keep the filtered records only.
*/
-(void)autoCompleteTextBox:(NHAutoCompleteTextField
*)autoCompleteTextBox didFilterSourceUsingText:(NSString *)text;

@end

@protocol NHAutoCompleteTextFieldDataSourceDelegate

@required;

/**
Depicts the items available in the list.
*/
- (NSInteger)autoCompleteTextBox:(NHAutoCompleteTextField
*)autoCompleteTextBox numberOfRowsInSection:(NSInteger)section;

/**
Create a customized cell as per your need.
*/
- (UITableViewCell *)autoCompleteTextBox:(NHAutoCompleteTextField
*)autoCompleteTextBox cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
</pre>

Include just one file in your view-controller:

<pre>
#import "NHMainHeader.h"
@interface ViewController : UIViewController
{

}
</pre>

Flexibility to control the drop down direction of the control:

<pre>
typedef enum
{
NHDropDownDirectionUp,
NHDropDownDirectionDown

} NHDropDownDirection;
</pre>

<b>Example:</b>

<pre>
- (void)viewDidLoad
{
[super viewDidLoad];

autoCompleteTextField = [[NHAutoCompleteTextField alloc]
initWithFrame:CGRectMake((kScreenSize.width - controlWidth) / 2, 120,
controlWidth, 18)];
[autoCompleteTextField setDropDownDirection:NHDropDownDirectionDown];
[autoCompleteTextField setDataSourceDelegate:self];
[autoCompleteTextField setDataFilterDelegate:self];
}

#pragma mark - NHAutoComplete DataSource delegate functions

- (NSInteger)autoCompleteTextBox:(NHAutoCompleteTextField
*)autoCompleteTextBox numberOfRowsInSection:(NSInteger)section
{

}

- (UITableViewCell *)autoCompleteTextBox:(NHAutoCompleteTextField
*)autoCompleteTextBox cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

}

#pragma mark - NHAutoComplete Filter data source delegate functions

-(BOOL)shouldFilterDataSource:(NHAutoCompleteTextField
*)autoCompleteTextBox
{

}

-(void)autoCompleteTextBox:(NHAutoCompleteTextField
*)autoCompleteTextBox didFilterSourceUsingText:(NSString *)text
{

}
</pre>
