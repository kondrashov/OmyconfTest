//
//  NoMessageCell.m
//  OmyconfTest
//
//  Created by Artem Kondrashov on 13.09.13.
//  Copyright (c) 2013 Artem Kondrashov. All rights reserved.
//

#import "NoMessageCell.h"

@implementation NoMessageCell

- (id)initWithText:(NSString *)text reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.textLabel.text = text;
        self.textLabel.font = [UIFont systemFontOfSize:16];
        self.textLabel.numberOfLines = 0;
        self.textLabel.textAlignment = UITextAlignmentCenter;
    }
    return self;
}

@end
