//
//  UserListViewController.m
//  OmyconfTest
//
//  Created by Artem Kondrashov on 07.09.13.
//  Copyright (c) 2013 Artem Kondrashov. All rights reserved.
//

#import "UserListViewController.h"
#import "UserListCell.h"
#import "UserMessagesController.h"

#define USER_CELL_ID    @"UserListCell"

@interface UserListViewController ()

@end

@implementation UserListViewController

#pragma mark - View lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = NSLocalizedString(@"Список пользователей", nil);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadData];
}

- (void)viewDidUnload
{
    lblNoData = nil;
    [super viewDidUnload];
}

#pragma mark - Methods

- (NSString *)getRequestURL
{
    return USER_LIST;
}

- (void)loadingDataFinished
{
    [tableView reloadData];
}

- (void)loadData
{
    NSString *userEmail = [[NSUserDefaults standardUserDefaults] objectForKey:UserEmailKey];
    NSString *userPassword = [[NSUserDefaults standardUserDefaults] objectForKey:UserPasswordKey];
    
    NSString *stringURL = [NSString stringWithFormat:@"%@%@?email=%@&password=%@",
                           BASE_URL,
                           [self getRequestURL],
                           [userEmail stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                           [userPassword stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    [self.internetProvider requestWithURL:stringURL];
}

#pragma mark - TableView

- (UITableViewCell *)createCellWithIndexPath:(NSIndexPath *)indexPath
{
    UserListCell *userCell = (UserListCell *)[self createCellWithNib:USER_CELL_ID
                                                        forTableView:tableView
                                                          withCellId:USER_CELL_ID];
    
    NSString *firstName = [self.dataArray[indexPath.row] objectForKey:@"first_name"];
    NSString *lastName = [self.dataArray[indexPath.row] objectForKey:@"last_name"];
    NSString *email = [self.dataArray[indexPath.row] objectForKey:@"email"];
    
    if(!firstName.length)
        firstName = @"Empty";

    if(!lastName.length)
        lastName = @"Empty";

    userCell.lblName.text = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
    userCell.lblEmail.text = email;
    userCell.userId = [NSString stringWithFormat:@"%d", indexPath.row + 1];
    
    return userCell;
}

- (void)tableView:(UITableView *)table didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserListCell *cell = (UserListCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    UserMessagesController *userMsgController = [[UserMessagesController alloc] initWithUserName:cell.lblName.text
                                                                                       userEmail:cell.lblEmail.text
                                                                                          userId:cell.userId];
    [self.navigationController pushViewController:userMsgController animated:YES];
}

#pragma mark - InternetProvider Delegate

- (void)connectionDidFinishLoading:(NSData *)responseData
{
    [super connectionDidFinishLoading:responseData];
    
    NSString *dataString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", dataString);
    
    NSMutableDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:responseData
                                                             options:NSJSONReadingMutableContainers
                                                               error:nil];
    if([[jsonDict objectForKey:@"error"] integerValue] == 0)
    {
        NSDictionary *data = [jsonDict objectForKey:@"data"];
        NSArray *dataKeys = [[data allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2)
        {
            if ([obj1 integerValue] > [obj2 integerValue])
                return (NSComparisonResult)NSOrderedDescending;
                        
            if ([obj1 integerValue] < [obj2 integerValue])
                return (NSComparisonResult)NSOrderedAscending;
            
            return (NSComparisonResult)NSOrderedSame;
        }];
        
        if(!self.dataArray)
            self.dataArray = [NSMutableArray array];
        else
            [self.dataArray removeAllObjects];
        
        for(int i = 0; i < dataKeys.count; i++)
        {
            NSMutableDictionary *dataDict = [data objectForKey:dataKeys[i]];
//            [dataDict setObject:dataKeys[i] forKey:@"id"];
            [self.dataArray addObject:dataDict];
        }

        [self loadingDataFinished];
        
        if(self.dataArray.count)
        {
            lblNoData.hidden = YES;
            tableView.userInteractionEnabled = YES;
        }
        else
        {
            lblNoData.hidden = NO;
            tableView.userInteractionEnabled = NO;
        }
        [tableView reloadData];
    }
}

@end
