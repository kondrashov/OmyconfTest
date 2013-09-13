//
//  BaseInternetController.m
//  OmyconfTest
//
//  Created by Artem Kondrashov on 05.09.13.
//  Copyright (c) 2013 Artem Kondrashov. All rights reserved.
//

#import "BaseInternetController.h"

@interface BaseInternetController ()

@end

@implementation BaseInternetController

@synthesize internetProvider;

#pragma mark - Load

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.internetProvider = [InternetProvider new];
    [self.internetProvider setTag:DEFAULT_PROVIDER_TAG];
    self.internetProvider.delegate = self;
}

#pragma mark - Methods

- (void)loadData
{
    loadNow = YES;
}

#pragma mark - InternetProvider Delegate

- (void)connectionDidReceiveResponse
{
    [SVProgressHUD showWithStatus:@"Загрузка..." maskType:SVProgressHUDMaskTypeNone];
}

- (void)connectiondidFailWithError:(NSError *)error
{
    loadNow = NO;
    [SVProgressHUD dismiss];
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Ошибка" message:[NSString stringWithFormat:@"%@", error.localizedDescription] delegate:nil cancelButtonTitle:@"ОК" otherButtonTitles: nil];
    [alert show];
}

- (void)connectionDidFinishLoading:(NSData*)responseData provider:(InternetProvider *)provider
{
    loadNow = NO;
    [SVProgressHUD dismiss];

    // Override in child    
}

@end
