//
//  UserListCell.m
//  OmyconfTest
//
//  Created by Artem Kondrashov on 07.09.13.
//  Copyright (c) 2013 Artem Kondrashov. All rights reserved.
//

#import "UserListCell.h"

@implementation UserListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
