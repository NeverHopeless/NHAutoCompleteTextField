//
//  DataManager.h
//  NHAutoCompleteTextBox
//
//  Created by Shahan on 14/12/2014.
//  Copyright (c) 2014 Shahan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataManager : NSObject
{
    
}

@property (nonatomic, retain) NSMutableArray * dataSource;

-(id)fetchDataSynchronously;

@end
