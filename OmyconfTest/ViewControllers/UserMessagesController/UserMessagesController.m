//
//  UserMessagesController.m
//  OmyconfTest
//
//  Created by Artem Kondrashov on 09.09.13.
//  Copyright (c) 2013 Artem Kondrashov. All rights reserved.
//

#import "UserMessagesController.h"
#import "InboxMessageController.h"
#import "OutboxMessageController.h"
#import "SendMessageController.h"
#import "MessageCell.h"
#import "NoMessageCell.h"

#define MESSAGE_CELL_ID     @"MessageCell"

@interface UserMessagesController () <InboxMessageDelegate, OutboxMessageDelegate>
{
    BOOL inboxDownloadFinished;
    BOOL outboxDownloadFinished;
    NSString *emptyErrorString;
}

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) UISegmentedControl *segBtn;
@property (strong, nonatomic) InboxMessageController *inboxMsgController;
@property (strong, nonatomic) OutboxMessageController *outboxMsgController;
@property (strong, nonatomic) NSMutableArray *chatArray;

@end

@implementation UserMessagesController

#pragma mark - View lifecycle

- (id)initWithUserName:(NSString *)userName userEmail:(NSString *)userEmail userId:(NSString *)userId
{
    self = [super initWithNibName:@"UserMessagesController" bundle:nil];
    if(self)
    {
        self.title = @"Сообщения";
        self.name = userName;
        self.email = userEmail;
        self.userId = userId;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [tableView setContentInset:UIEdgeInsetsMake(1.0, 0.0, 0.0, 0.0)];
    [self setupView];
    [self createObservers];
    self.chatArray = [NSMutableArray array];
    [self segmentChanged:self.segBtn];
    [self loadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Methods

- (void)createObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(msgSendSuccess:)
                                                 name:MsgSendSuccessNotification
                                               object:nil];
}

- (void)setupView
{
    self.segBtn = [[UISegmentedControl alloc] initWithItems:@[@"Переписка", @"Входящие", @"Исходящие"]];
    self.segBtn.tintColor = RGBCOLOR(148, 176, 16);
    self.segBtn.segmentedControlStyle = UISegmentedControlStyleBar;
    self.segBtn.selectedSegmentIndex = 0;
    [self.segBtn addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventValueChanged];

    self.segBtn.x = self.view.width / 2 - self.segBtn.width / 2;
    self.segBtn.y = tableView.y  / 2 - self.segBtn.height / 2;
    [self.segBtn frameRoundToInt];
    
    [self.view addSubview:self.segBtn];

}

- (void)loadData
{
    [super loadData];
    
    inboxDownloadFinished = NO;
    outboxDownloadFinished = NO;
    
    if(!self.inboxMsgController)
    {
        self.inboxMsgController = [[InboxMessageController alloc] initWithUserId:self.userId];
        self.inboxMsgController.delegate = self;
        self.inboxMsgController.view.frame = CGRectZero;
    }
    else
        [self.inboxMsgController loadData];
    
    if(!self.outboxMsgController)
    {
        self.outboxMsgController = [[OutboxMessageController alloc] initWithUserId:self.userId];
        self.outboxMsgController.delegate = self;
        self.outboxMsgController.view.frame = CGRectZero;
    }
    else
        [self.outboxMsgController loadData];
}

- (void)configureNavBar
{
    [super configureNavBar];
    
    UIBarButtonItem *addBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(onSendMsg)];

    UIBarButtonItem *updateBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(onUpdate)];
    
    [self.navigationItem setRightBarButtonItems:@[addBtn, updateBtn]];
}

- (void)createChatMessages
{
    [self.chatArray removeAllObjects];

    [self.chatArray addObjectsFromArray:self.inboxMsgController.dataArray];
    [self.chatArray addObjectsFromArray:self.outboxMsgController.dataArray];
    
    [self.chatArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2)
    {
        if ([[obj1 objectForKey:@"id"] integerValue] > [[obj2 objectForKey:@"id"] integerValue])
            return (NSComparisonResult)NSOrderedDescending;
        
        if ([[obj1 objectForKey:@"id"] integerValue] < [[obj2 objectForKey:@"id"] integerValue])
            return (NSComparisonResult)NSOrderedAscending;
        
        return (NSComparisonResult)NSOrderedSame;
    }];

    [tableView reloadData];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.dataArray.count - 1 inSection:0];
    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    
    loadNow = NO;
}

#pragma mark - TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.dataArray.count)
        return self.dataArray.count;
    else
        return 1;
}

- (UITableViewCell *)createCellWithIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if(self.dataArray.count)
    {
        MessageCell *messageCell = (MessageCell *)[self createCellWithNib:MESSAGE_CELL_ID
                                                             forTableView:tableView
                                                               withCellId:MESSAGE_CELL_ID];
        NSString *userName;
        
        if([self.dataArray[indexPath.row] objectForKey:@"sender"])
            userName = self.name;
        else
            userName = @"Я";
        
        [messageCell updateCellWithText:[self.dataArray[indexPath.row] objectForKey:@"text"] userId:userName];
        
        cell = messageCell;
    }
    else
    {
        NoMessageCell *noMsgCell = [[NoMessageCell alloc] initWithText:emptyErrorString reuseIdentifier:@"noMsgCell"];

        cell = noMsgCell;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)table heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.dataArray.count)
        return [MessageCell cellHeightWithText:[self.dataArray[indexPath.row] objectForKey:@"text"]];
    else
    {
        NSLog(@"%f", tableView.frame.size.height);
        return tableView.frame.size.height;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

#pragma mark - Actions

- (void)onSendMsg
{
    SendMessageController *sendMsgController = [[SendMessageController alloc] initWithReceiverId:self.userId];
    [self.navigationController pushViewController:sendMsgController animated:YES];
}

- (void)onUpdate
{
    if(!loadNow)
        [self loadData];
}

-(void)segmentChanged:(id)sender
{
    NSInteger selectedIndex = [(UISegmentedControl *)sender selectedSegmentIndex];
    
    switch (selectedIndex)
    {
        case 0:
        {
            self.dataArray = self.chatArray;
            emptyErrorString = @"У Вас нет переписки с этим пользователем";
        }
        break;
            
        case 1:
        {
            self.dataArray = self.inboxMsgController.dataArray;
            emptyErrorString = @"От этого пользователя нет входящих сообщений";
        }
        break;
            
        case 2:
        {
            self.dataArray = self.outboxMsgController.dataArray;
            emptyErrorString = @"Для этого пользователя нет исходящих сообщений";
        }
        break;
    }

    [tableView reloadData];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.dataArray.count - 1 inSection:0];
    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

#pragma mark - Notifications

- (void)msgSendSuccess:(NSNotification *)note
{
    self.segBtn.selectedSegmentIndex = 0;
    [self segmentChanged:self.segBtn];
    [self loadData];
}

#pragma mark - Inbox/Outbox delegate

- (void)inboxDownloadDidFinish:(NSArray *)dataArray
{
    inboxDownloadFinished = YES;
    
    if(outboxDownloadFinished)
        [self createChatMessages];
}

- (void)outboxDownloadDidFinish:(NSArray *)dataArray
{
    outboxDownloadFinished = YES;
    
    if(inboxDownloadFinished)
        [self createChatMessages];
}

@end
