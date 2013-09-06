//
//  BaseInputController.m
//  OmyconfTest
//
//  Created by Artem Kondrashov on 04.09.13.
//  Copyright (c) 2013 Artem Kondrashov. All rights reserved.
//

#import "BaseInputController.h"

@interface BaseInputController ()

@end

@implementation BaseInputController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createGestures];
    [self createObservers];    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Methods

- (void)createGestures
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapScrollView)];
    tap.cancelsTouchesInView = NO;
    [scrollView addGestureRecognizer:tap];
}

- (void)createObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - Notifications

- (void)keyboardWillShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    
    UITextField *activeField = (UITextField *)[self.view findFirstResponder];

    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
    
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, activeField.frame.origin))
    {
        CGPoint scrollPoint = CGPointMake(0.0, activeField.frame.origin.y - kbSize.height + 10);
        [scrollView setContentOffset:scrollPoint animated:YES];
    }
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    NSNumber *duration = [[aNotification userInfo ] objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    
    [UIView animateWithDuration:[duration doubleValue] animations:^
     {
         scrollView.contentOffset = CGPointZero;
     }
     completion:^(BOOL finished)
     {
         scrollView.contentInset = UIEdgeInsetsZero;
         scrollView.scrollIndicatorInsets = UIEdgeInsetsZero;
     }];
}

#pragma mark - Actions

- (void)tapScrollView
{
    [self.view endEditing:YES];
}

@end
