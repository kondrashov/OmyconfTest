//
//  MessageCell.m
//  OmyconfTest
//
//  Created by Artem Kondrashov on 09.09.13.
//  Copyright (c) 2013 Artem Kondrashov. All rights reserved.
//

#import "MessageCell.h"
#import <QuartzCore/QuartzCore.h>

#define TEXT_FONT           [UIFont systemFontOfSize:15];
#define LABEL_FRAME         LABEL_INSET, LABEL_INSET, CELL_WIDTH - LABEL_INSET * 2, CELL_HEIGHT - LABEL_INSET * 2
#define CELL_WIDTH          320
#define CELL_HEIGHT         44
#define LABEL_INSET         20

@implementation MessageCell
{
    UIImageView *msgImgView;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        UIImage *img = [[UIImage imageNamed:@"msgImg"] safeResizableImageWithCapInsets:UIEdgeInsetsMake(8, 8, 8, 8)
                                                                          resizingMode:UIImageResizingModeStretch];
        msgImgView = [[UIImageView alloc] initWithImage:img];
    }
    return self;
}

+ (CGFloat)cellHeightWithText:(NSString *)text
{
    UILabel *lblText = [[UILabel alloc] initWithFrame:CGRectMake(LABEL_FRAME)];
    lblText.font = TEXT_FONT;
    lblText.text = text;
    lblText.numberOfLines = 0;
    [lblText sizeToFit];

    return lblText.height + LABEL_INSET * 2;
}

- (void)updateCellWithText:(NSString *)text
{
    if(msgImgView.superview != self.contentView)
       [self.contentView insertSubview:msgImgView belowSubview:self.lblMessage];
    
    self.lblMessage.frame = CGRectMake(LABEL_FRAME);
    self.lblMessage.font = TEXT_FONT;
    self.lblMessage.text = text;
    [self.lblMessage sizeToFit];
    msgImgView.frame = CGRectMake(LABEL_INSET / 2, LABEL_INSET / 2, CELL_WIDTH - LABEL_INSET, self.lblMessage.height + LABEL_INSET);
}



@end
