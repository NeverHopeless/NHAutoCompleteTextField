//
//  UILabel+Boldify.m
//  NHAutoCompleteTextBox
//
//  Created by Shahan on 02/01/2015.
//  Copyright (c) 2015 Shahan. All rights reserved.
//

#import "UILabel+Boldify.h"

@implementation UILabel (Boldify)

- (void)boldRange:(NSRange)range
{
    if (![self respondsToSelector:@selector(setAttributedText:)])
    {
        return;
    }
    
    NSMutableAttributedString *attributedText;
    if (!self.attributedText)
    {
        attributedText = [[NSMutableAttributedString alloc] initWithString:self.text];
    }
    else
    {
        attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    }
    
    [attributedText setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:self.font.pointSize]} range:range];
     self.attributedText = attributedText;
}

- (void)boldSubstring:(NSString*)substring
{
    NSRange range = [[self.text lowercaseString] rangeOfString:[substring lowercaseString]];
    [self boldRange:range];
}

- (void)normalizeRange:(NSRange)range
{
    if (![self respondsToSelector:@selector(setAttributedText:)])
    {
        return;
    }
    
    NSMutableAttributedString *attributedText;
    if (!self.attributedText)
    {
        attributedText = [[NSMutableAttributedString alloc] initWithString:self.text];
    }
    else
    {
        attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    }
    
    [attributedText setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:self.font.pointSize]} range:range];
     self.attributedText = attributedText;
}

- (void)normalizeSubstring:(NSString*)substring
{
     NSRange range = [[self.text lowercaseString] rangeOfString:[substring lowercaseString]];
    [self normalizeRange:range];
}

@end
