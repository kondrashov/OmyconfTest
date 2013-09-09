//
//  UserMessagesController.h
//  OmyconfTest
//
//  Created by Artem Kondrashov on 09.09.13.
//  Copyright (c) 2013 Artem Kondrashov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableController.h"

@interface UserMessagesController : BaseTableController

- (id)initWithUserName:(NSString *)userName
             userEmail:(NSString *)userEmail
                userId:(NSString *)userId;

@end
