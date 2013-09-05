//
//  ViewController.m
//  OmyconfTest
//
//  Created by Artem Kondrashov on 04.09.13.
//  Copyright (c) 2013 Artem Kondrashov. All rights reserved.
//

#import "StartViewController.h"

@interface StartViewController ()

@end

@implementation StartViewController

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - Actions

- (IBAction)onLogin:(id)sender
{
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:loginVC animated:YES];
}

- (IBAction)onSignUp:(id)sender
{
    SignUpViewController *signUpVC = [[SignUpViewController alloc] init];
    [self.navigationController pushViewController:signUpVC animated:YES];
}

@end
