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
    self.internetProvider.delegate = self;
}

#pragma mark - InternetProvider Delegate

- (void)connectiondidFailWithError:(NSError *)error
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"%@", error.localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    
    NSLog(@"Error connection - %@", error);
}

- (void)connectionDidFinishLoading:(NSData *)responseData
{
    // Override in child
}

@end
