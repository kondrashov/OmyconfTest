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

@property (strong, nonatomic) NSMutableArray *inetProvidersArray;

@end

@implementation InboxMessageController

#pragma mark - View lifecycle

- (id)initWithUserId:(NSString *)userIdentifier;
{
    self = [super initWithNibName:@"UserListViewController" bundle:nil];
    if (self)
    {
        userId = userIdentifier;
        self.title = @"Входящие";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadData];
}

#pragma mark - Parent methods

- (NSString *)getRequestURL
{
    return MSG_LIST;
}

- (void)loadingDataFinished
{
    lblNoData.text = @"От этого пользователя нет входящих сообщений";
    [self filteringMessageByKey:@"sender"];
    [self viewMessages];
    
    if([self.delegate respondsToSelector:@selector(inboxDownloadDidFinish:)])
        [self.delegate inboxDownloadDidFinish:self.dataArray];
}

- (void)visualConfigureFinished
{
    [SVProgressHUD dismiss];
    [tableView reloadData];
}

- (void)saveData:(id)data
{
    
}

- (void)loadMoreData
{
    
}

- (void)configureTable
{
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - Private methods

- (void)viewMessages
{
    if(!self.inetProvidersArray)
        self.inetProvidersArray = [NSMutableArray array];
    else
        [self.inetProvidersArray removeAllObjects];
    
    for(NSDictionary *dict in self.dataArray)
    {
        if([[dict objectForKey:@"viewed"] integerValue] == 0)
        {
            InternetProvider *inetProvider = [InternetProvider new];
            [inetProvider setDelegate:nil];
            
            NSString *stringURL = [NSString stringWithFormat:@"%@%@/%@?email=%@&password=%@",
                                   BASE_URL,
                                   MSG_UPDATE,
                                   [dict objectForKey:@"id"],
                                   [USER_EMAIL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                                   [USER_PASSWORD stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            
            [inetProvider requestWithURL:stringURL];
            [self.inetProvidersArray addObject:inetProvider];
        }
    }
}

#pragma mark - Private methods

- (void)filteringMessageByKey:(NSString *)key
{
    NSArray *tempArray = [NSArray arrayWithArray:self.dataArray];
    [self.dataArray removeAllObjects];
    
    for(NSDictionary *dict in tempArray)
    {
        if([[dict objectForKey:key] integerValue] == [userId integerValue])
            [self.dataArray addObject:dict];
    }
}

#pragma mark - TableView

- (UITableViewCell *)createCellWithIndexPath:(NSIndexPath *)indexPath
{
    MessageCell *messageCell = (MessageCell *)[self createCellWithNib:MESSAGE_CELL_ID
                                                        forTableView:tableView
                                                          withCellId:MESSAGE_CELL_ID];

    [messageCell updateCellWithText:[self.dataArray[indexPath.row] objectForKey:@"text"] userId:[Helpers getUserNameById:userId]];
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
