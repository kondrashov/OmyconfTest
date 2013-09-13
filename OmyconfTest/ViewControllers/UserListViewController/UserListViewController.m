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

#define USER_CELL_ID        @"UserListCell"
#define MSG_PROVIDER_TAG    2

@interface UserListViewController ()

@property (strong, nonatomic) InternetProvider *msgInetProvider;

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

- (void)viewWillAppear:(BOOL)animated
{
    [self loadData];    
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.msgInetProvider = [InternetProvider new];
    [self.msgInetProvider setTag:MSG_PROVIDER_TAG];
    self.msgInetProvider.delegate = self;
}

- (void)viewDidUnload
{
    lblNoData = nil;
    [super viewDidUnload];
}

#pragma mark - Methods

- (void)configureNavBar
{
    [super configureNavBar];
    
    UIBarButtonItem *addBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(onUpdate)];
    [self.navigationItem setRightBarButtonItem:addBtn];
}

- (NSString *)getRequestURL
{
    return USER_LIST;
}

- (void)loadingDataFinished
{
    [self loadMoreData];
}

- (void)visualConfigureFinished
{
    
}

- (void)saveData:(id)data
{
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:UserListKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)loadMoreData
{
    NSString *stringURL = [NSString stringWithFormat:@"%@%@?email=%@&password=%@",
                           BASE_URL,
                           MSG_LIST,
                           [USER_EMAIL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                           [USER_PASSWORD stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];

    [self.msgInetProvider requestWithURL:stringURL];
}

- (void)loadData
{
    [super loadData];
    NSString *stringURL = [NSString stringWithFormat:@"%@%@?email=%@&password=%@",
                           BASE_URL,
                           [self getRequestURL],
                           [USER_EMAIL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                           [USER_PASSWORD stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
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
    userCell.userId = [self.dataArray[indexPath.row] objectForKey:@"id"];
    userCell.msgNoViewCount = [[self.dataArray[indexPath.row] objectForKey:@"noViewed"] integerValue];
    [userCell updateUI];
    
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

#pragma mark - InetProvider handlers

- (void)defaultProviderHandler:(NSDictionary *)jsonDict
{
    if([[jsonDict objectForKey:@"error"] integerValue] == 0)
    {
        NSDictionary *data = [jsonDict objectForKey:@"data"];
        [self saveData:data];
        
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
            [dataDict setObject:dataKeys[i] forKey:@"id"];
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
        [self visualConfigureFinished];
    }
}

- (void)msgProviderHandler:(NSDictionary *)jsonDict
{
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
        

        NSMutableArray *msgCountArray = [NSMutableArray array];
        
        for(int i = 0; i < self.dataArray.count; i++)
            [msgCountArray addObject:[NSNumber numberWithInt:0]];
        
        
        for(int i = 0; i < dataKeys.count; i++)
        {
            NSMutableDictionary *dataDict = [data objectForKey:dataKeys[i]];
            
            if([[dataDict objectForKey:@"viewed"] integerValue] == 0)
            {
                NSInteger index = [[dataDict objectForKey:@"sender"] integerValue] - 1;
                NSInteger count = [msgCountArray[index] integerValue];
                msgCountArray[index] = [NSNumber numberWithInt:count + 1];
            }
        }
        
        for(int i = 0; i < self.dataArray.count; i++)
        {
            NSMutableDictionary *dict = self.dataArray[i];
            [dict setObject:msgCountArray[i] forKey:@"noViewed"];
        }

        [self.dataArray sortUsingComparator:^NSComparisonResult(NSDictionary *obj1, NSDictionary *obj2)
        {
            if ([[obj1 objectForKey:@"noViewed"] integerValue] > [[obj2 objectForKey:@"noViewed"] integerValue])
                return (NSComparisonResult)NSOrderedAscending;
            
            if ([[obj1 objectForKey:@"noViewed"] integerValue] < [[obj2 objectForKey:@"noViewed"] integerValue])
                return (NSComparisonResult)NSOrderedDescending;
            
            return (NSComparisonResult)NSOrderedSame;
        }];
    }
    [tableView reloadData];
}

#pragma mark - InternetProvider Delegate

- (void)connectionDidFinishLoading:(NSData*)responseData provider:(InternetProvider *)provider
{
    NSMutableDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:responseData
                                                                    options:NSJSONReadingMutableContainers
                                                                      error:nil];
    switch (provider.tag)
    {
        case DEFAULT_PROVIDER_TAG:
        {
            [self defaultProviderHandler:jsonDict];
        }
        break;
            
        case MSG_PROVIDER_TAG:
        {
            loadNow = NO;
            [SVProgressHUD dismiss];
            [self msgProviderHandler:jsonDict];
        }
        break;
    }
}

#pragma mark - Actions

- (void)onUpdate
{
    if(!loadNow)
        [self loadData];
}

@end
