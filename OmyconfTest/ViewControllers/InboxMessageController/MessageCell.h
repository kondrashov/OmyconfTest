//
//  MessageCell.h
//  OmyconfTest
//
//  Created by Artem Kondrashov on 09.09.13.
//  Copyright (c) 2013 Artem Kondrashov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblMessage;

+ (CGFloat)cellHeightWithText:(NSString *)text;
- (void)updateCellWithText:(NSString *)text userId:(NSString *)userId;

@end
