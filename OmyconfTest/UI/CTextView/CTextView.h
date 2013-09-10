//
//  CTextView.h
//  OmyconfTest
//
//  Created by Artem Kondrashov on 10.09.13.
//  Copyright (c) 2013 Artem Kondrashov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTextView : UIView
{
    UITextView *textView;
}

+ (CGFloat)defaultWidth;
+ (CGFloat)defaultHeight;
- (NSString *)text;
- (void)setText:(NSString *)text;
- (void)setDelegate:(id)delegate;
- (void)beginEdit;

@end
