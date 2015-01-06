//
//  UILabel+Boldify.h
//  NHAutoCompleteTextBox
//
//  Created by Shahan on 02/01/2015.
//  Copyright (c) 2015 Shahan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Boldify)
{
    
}

- (void)boldSubstring: (NSString*) substring;
- (void)boldRange: (NSRange) range;
- (void)normalizeRange:(NSRange)range;
- (void)normalizeSubstring:(NSString*)substring;

@end
