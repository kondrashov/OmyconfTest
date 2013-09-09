//
//  BaseTableController.h
//  OmyconfTest
//
//  Created by Artem Kondrashov on 07.09.13.
//  Copyright (c) 2013 Artem Kondrashov. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseTableController : BaseNavigationController <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView *tableView;
}

@property (strong, nonatomic) NSMutableArray *dataArray;

- (void)configureTable;
- (UITableViewCell *)createCellWithIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCell *)createCellWithNib:(NSString *)nibName
                          forTableView:(UITableView *)table
                            withCellId:(NSString *)cellId;
@end
