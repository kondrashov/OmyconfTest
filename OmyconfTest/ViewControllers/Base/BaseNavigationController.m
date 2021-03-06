//
//  BaseNavigationController.m
//  OmyconfTest
//
//  Created by Artem Kondrashov on 07.09.13.
//  Copyright (c) 2013 Artem Kondrashov. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureNavBar];
}

- (void)configureNavBar
{
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.tintColor = DEFAULT_COLOR;
    self.navigationItem.titleView = [self getTitleView];
    self.navigationItem.title = @"Назад";
}

-(UIView *)getTitleView
{
    UILabel *label = [UILabel new];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextAlignment:UITextAlignmentCenter];
    [label setTextColor:RGBCOLOR(70, 73, 80)];
    [label setText:self.title];
    [label setFont:[UIFont boldSystemFontOfSize:17]];
    [label sizeToFit];
    return label;
}

@end
