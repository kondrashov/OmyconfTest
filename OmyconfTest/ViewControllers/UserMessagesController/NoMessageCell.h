//
//  NoMessageCell.h
//  OmyconfTest
//
//  Created by Artem Kondrashov on 13.09.13.
//  Copyright (c) 2013 Artem Kondrashov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoMessageCell : UITableViewCell

@property (strong, nonatomic) UILabel *label;

- (id)initWithText:(NSString *)text reuseIdentifier:(NSString *)reuseIdentifier;

@end
