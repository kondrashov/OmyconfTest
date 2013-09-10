//
//  UserListCell.m
//  OmyconfTest
//
//  Created by Artem Kondrashov on 07.09.13.
//  Copyright (c) 2013 Artem Kondrashov. All rights reserved.
//

#import "UserListCell.h"

@implementation UserListCell
{
    UILabel *lblMsgCount;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        lblMsgCount = [UILabel new];
        [self.contentView addSubview:lblMsgCount];
    }
    return self;
}

- (void)updateUI
{
    if(self.msgNoViewCount)
        lblMsgCount.text = [NSString stringWithFormat:@"%d", self.msgNoViewCount];
    else
        lblMsgCount.text = @"";

    lblMsgCount.font = [UIFont boldSystemFontOfSize:15];
    lblMsgCount.textColor = [UIColor redColor];
    [lblMsgCount sizeToFit];
    lblMsgCount.frame = CGRectMake(self.contentView.width - lblMsgCount.width - 10, self.contentView.height / 2 - lblMsgCount.height / 2, lblMsgCount.width, lblMsgCount.height);
}

@end
