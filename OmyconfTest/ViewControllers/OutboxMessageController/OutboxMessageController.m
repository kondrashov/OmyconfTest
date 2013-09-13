//
//  OutboxMessageController.m
//  OmyconfTest
//
//  Created by Artem Kondrashov on 09.09.13.
//  Copyright (c) 2013 Artem Kondrashov. All rights reserved.
//

#import "OutboxMessageController.h"

@interface OutboxMessageController ()

@end

@implementation OutboxMessageController

#pragma mark - View lifecycle

- (id)initWithUserId:(NSString *)userIdentifier;
{
    self = [super initWithNibName:@"UserListViewController" bundle:nil];
    if (self)
    {
        userId = userIdentifier;
        self.title = @"Исходящие";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - Methods

- (NSString *)getRequestURL
{
    return MSG_MY;
}

- (void)loadingDataFinished
{
    lblNoData.text = @"Для этого пользователя нет исходящих сообщений";
    [self filteringMessageByKey:@"receiver"];
    
    if([self.delegate respondsToSelector:@selector(outboxDownloadDidFinish:)])
        [self.delegate outboxDownloadDidFinish:self.dataArray];

}

@end
