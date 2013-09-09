//
//  InboxMessageController.h
//  OmyconfTest
//
//  Created by Artem Kondrashov on 09.09.13.
//  Copyright (c) 2013 Artem Kondrashov. All rights reserved.
//

#import "UserListViewController.h"

@interface InboxMessageController : UserListViewController
{
    NSString *userId;
}

- (id)initWithUserId:(NSString *)userIdentifier;
- (void)filteringMessageByKey:(NSString *)key;

@end
