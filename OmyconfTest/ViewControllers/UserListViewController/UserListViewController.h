//
//  UserListViewController.h
//  OmyconfTest
//
//  Created by Artem Kondrashov on 07.09.13.
//  Copyright (c) 2013 Artem Kondrashov. All rights reserved.
//

#import "BaseTableController.h"

@interface UserListViewController : BaseTableController
{    
    IBOutlet UILabel *lblNoData;
}

- (NSString *)getRequestURL;
- (void)loadingDataFinished;
- (void)visualConfigureFinished;

@end
