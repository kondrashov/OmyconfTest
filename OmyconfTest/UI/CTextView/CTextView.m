//
//  CTextView.m
//  OmyconfTest
//
//  Created by Artem Kondrashov on 10.09.13.
//  Copyright (c) 2013 Artem Kondrashov. All rights reserved.
//

#import "CTextView.h"
#import "QuartzCore/QuartzCore.h"

#define BACKGROUND_IMAGE    [UIImage imageNamed:@"msgImg"]
#define DEFAULT_TOP_INSET   11
#define DEFAULT_LEFT_INSET  8

@implementation CTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y,
                                           [CTextView defaultWidth],
                                           frame.size.height ? MAX(frame.size.height, [CTextView defaultHeight]) : [CTextView defaultHeight])];
    if (self)
    {
        [self setupView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,
                                [CTextView defaultWidth],
                                self.frame.size.height ? MAX(self.frame.size.height, [CTextView defaultHeight]) : [CTextView defaultHeight]);
        [self setupView];        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame tag:(NSInteger)tag
{
    self = [self initWithFrame:frame];
    if(self)
    {
        textView.tag = tag;
    }
    return self;
}

- (void)setupView
{
    [self frameRoundToInt];
    self.clipsToBounds = YES;
    
    UIImageView *background = [[UIImageView alloc] initWithFrame:self.bounds];
    background.image = [BACKGROUND_IMAGE safeResizableImageWithCapInsets:UIEdgeInsetsMake(8, 8, 8, 8) resizingMode:UIImageResizingModeStretch];
    
    textView = [[UITextView alloc] initWithFrame:self.bounds];
    textView.textAlignment = UITextAlignmentLeft;
    textView.font = [UIFont systemFontOfSize:15];
    textView.textColor = [UIColor blackColor];
    textView.backgroundColor = [UIColor clearColor];
    textView.showsHorizontalScrollIndicator = NO;
    textView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    textView.bounces = NO;
    [self setContentInsetTop:14 left:14 bottom:0 right:0];
    background.autoresizingMask = textView.autoresizingMask;

    [self addSubview:background];
    [self addSubview:textView];
}

- (void)setContentInsetTop:(CGFloat)top left:(CGFloat)left bottom:(CGFloat)bottom right:(CGFloat)rigth
{
    textView.contentInset = UIEdgeInsetsMake(top - DEFAULT_TOP_INSET, left - DEFAULT_LEFT_INSET, bottom, rigth);
}

- (NSString *)text
{
    return textView.text;
}

- (void)setText:(NSString *)text
{
    textView.text = text;
}

+ (CGFloat)defaultWidth
{
    return BACKGROUND_IMAGE.size.width;
}

+ (CGFloat)defaultHeight
{
    return BACKGROUND_IMAGE.size.height;
}

- (void)setDelegate:(id)delegate
{
    textView.delegate = delegate;
}

- (void)beginEdit
{
    [textView becomeFirstResponder];
}

@end
