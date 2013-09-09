//
//  BaseTableController.m
//  OmyconfTest
//
//  Created by Artem Kondrashov on 07.09.13.
//  Copyright (c) 2013 Artem Kondrashov. All rights reserved.
//

#import "BaseTableController.h"

@interface BaseTableController ()

@end

@implementation BaseTableController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureTable];
}

#pragma mark - Methods

- (UITableViewCell *)createCellWithNib:(NSString *)nibName
                          forTableView:(UITableView *)table
                            withCellId:(NSString *)cellId
{
    UITableViewCell *cell = [table dequeueReusableCellWithIdentifier:cellId];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    return cell;
}

#pragma mark - TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self createCellWithIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

#pragma mark - Overrride in child class

- (void)configureTable
{

}

- (UITableViewCell *)createCellWithIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

@end
