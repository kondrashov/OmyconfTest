//
//  MessageCell.m
//  OmyconfTest
//
//  Created by Artem Kondrashov on 09.09.13.
//  Copyright (c) 2013 Artem Kondrashov. All rights reserved.
//

#import "MessageCell.h"
#import <QuartzCore/QuartzCore.h>

#define TEXT_FONT               [UIFont systemFontOfSize:15];
#define CAPTION_FONT            [UIFont boldSystemFontOfSize:12];
#define LABEL_FRAME             LABEL_INSET, LABEL_TOP_INSET, CELL_WIDTH - LABEL_INSET * 2, CELL_HEIGHT - LABEL_INSET * 2
#define CELL_WIDTH              320
#define CELL_HEIGHT             44
#define LABEL_INSET             25
#define LABEL_TOP_INSET         33
#define BACKG_IMG_TOP_INSET     20
#define BACKG_IMG_INSET         10

@implementation MessageCell
{
    UIImageView *msgImgView;
    UILabel *lblUserName;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        msgImgView = [[UIImageView alloc] init];
        lblUserName = [UILabel new];
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

    return lblText.height + LABEL_TOP_INSET + LABEL_INSET;
}

- (void)updateCellWithText:(NSString *)text userId:(NSString *)userId
{
    if([userId isEqualToString:@"Я"])
    {
        msgImgView.image = [[UIImage imageNamed:@"bubbleMine.png"] stretchableImageWithLeftCapWidth:15 topCapHeight:14];
    }
    else
    {
        msgImgView.image = [[UIImage imageNamed:@"bubbleSomeone.png"] stretchableImageWithLeftCapWidth:21 topCapHeight:14];
    }
    
    if(msgImgView.superview != self.contentView)
       [self.contentView insertSubview:msgImgView belowSubview:self.lblMessage];
    
    if(lblUserName.superview != self.contentView)
        [self.contentView addSubview:lblUserName];
        
    self.lblMessage.frame = CGRectMake(LABEL_FRAME);
    self.lblMessage.font = TEXT_FONT;
    self.lblMessage.text = text;
    [self.lblMessage sizeToFit];
    msgImgView.frame = CGRectMake(BACKG_IMG_INSET, BACKG_IMG_TOP_INSET, CELL_WIDTH - BACKG_IMG_INSET * 2, self.lblMessage.height + BACKG_IMG_INSET * 2);
    
    lblUserName.font = CAPTION_FONT;
    lblUserName.text = [NSString stringWithFormat:@"%@", userId];
    [lblUserName sizeToFit];
    lblUserName.frame = CGRectMake(LABEL_INSET, 2, lblUserName.width, lblUserName.height);
}



@end
