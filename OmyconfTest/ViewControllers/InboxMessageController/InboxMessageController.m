//
//  InboxMessageController.m
//  OmyconfTest
//
//  Created by Artem Kondrashov on 09.09.13.
//  Copyright (c) 2013 Artem Kondrashov. All rights reserved.
//

#import "InboxMessageController.h"
#import "MessageCell.h"

#define MESSAGE_CELL_ID     @"MessageCell"

@interface InboxMessageController ()
{
    NSString *userId;
}

@end

@implementation InboxMessageController

#pragma mark - View lifecycle

- (id)initWithUserId:(NSString *)userIdentifier;
{
    self = [super initWithNibName:@"UserListViewController" bundle:nil];
    if (self)
    {
        userId = userIdentifier;
        self.title = @"Входящие сообщения";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - Parent methods

- (NSString *)getRequestURL
{
    return MSG_LIST;
}

- (void)loadingDataFinished
{
    lblNoData.text = @"От этого пользователя нет входящих сообщений";
    [self filteringMessageBySender];
}

- (void)configureTable
{
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - Private methods

- (void)filteringMessageBySender
{
    NSArray *tempArray = [NSArray arrayWithArray:self.dataArray];
    [self.dataArray removeAllObjects];
    
    for(NSDictionary *dict in tempArray)
    {
        if([[dict objectForKey:@"sender"] integerValue] == [userId integerValue])
            [self.dataArray addObject:dict];
    }
}

#pragma mark - TableView

- (UITableViewCell *)createCellWithIndexPath:(NSIndexPath *)indexPath
{
    MessageCell *messageCell = (MessageCell *)[self createCellWithNib:MESSAGE_CELL_ID
                                                        forTableView:tableView
                                                          withCellId:MESSAGE_CELL_ID];

    [messageCell updateCellWithText:[self.dataArray[indexPath.row] objectForKey:@"text"]];
    return messageCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [MessageCell cellHeightWithText:[self.dataArray[indexPath.row] objectForKey:@"text"]];
}

- (void)tableView:(UITableView *)table didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

@end
