//
//  ViewController.h
//  NHAutoCompleteTextBox
//
//  Created by Shahan on 12/12/2014.
//  Copyright (c) 2014 Shahan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NHMainHeader.h"
#import "DataManager.h"

@interface ViewController : UIViewController<NHAutoCompleteTextFieldDataSourceDelegate, NHAutoCompleteTextFieldDataFilterDelegate>
{
    NHAutoCompleteTextField *autoCompleteTextField;
    DataManager *manager;
    NSArray *inUseDataSource;
}

@end
