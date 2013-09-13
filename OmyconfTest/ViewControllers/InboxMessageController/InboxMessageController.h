//
//  InboxMessageController.h
//  OmyconfTest
//
//  Created by Artem Kondrashov on 09.09.13.
//  Copyright (c) 2013 Artem Kondrashov. All rights reserved.
//

#import "UserListViewController.h"

@protocol InboxMessageDelegate <NSObject>

- (void)inboxDownloadDidFinish:(NSArray *)dataArray;

@end

@interface InboxMessageController : UserListViewController
{
    NSString *userId;
}

@property (weak, nonatomic) id delegate;

- (id)initWithUserId:(NSString *)userIdentifier;
- (void)filteringMessageByKey:(NSString *)key;

@end
