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

#define USER_MESSAGES_CELL_ID    @"UserMessagesCell"

@interface UserMessagesController ()

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) IBOutlet UILabel *lblUserName;
@property (strong, nonatomic) IBOutlet UILabel *lblUserEmail;

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
    [self loadData];
}

- (void)viewDidUnload
{
    [self setLblUserName:nil];
    [self setLblUserEmail:nil];
    [super viewDidUnload];
}

#pragma mark - Methods

- (void)loadData
{
    self.lblUserName.text = self.name;
    self.lblUserEmail.text = self.email;
    
    if(!self.dataArray)
    {
        self.dataArray = [NSMutableArray arrayWithObjects:  @"Входящие сообщения",
                                                            @"Исходящие сообщения",
                                                            @"Написать сообщение", nil];
    }
    [tableView reloadData];
}

#pragma mark - TableView

- (UITableViewCell *)createCellWithIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:USER_MESSAGES_CELL_ID];

    if(!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:USER_MESSAGES_CELL_ID];
    
    cell.textLabel.text = self.dataArray[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:17];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case 0: // Inbox messages
        {
            InboxMessageController *inboxMsgController = [[InboxMessageController alloc] initWithUserId:self.userId];
            [self.navigationController pushViewController:inboxMsgController animated:YES];
        }
        break;
            
        case 1: // Outbox messages
        {
            OutboxMessageController *outboxMessageController = [[OutboxMessageController alloc] initWithUserId:self.userId];
            [self.navigationController pushViewController:outboxMessageController animated:YES];
        }
        break;

        case 2: // Send message
        {
            SendMessageController *sendMsgController = [[SendMessageController alloc] initWithReceiverId:self.userId];
            [self.navigationController pushViewController:sendMsgController animated:YES];
        }
        break;

        default:
            break;
    }
}

@end
