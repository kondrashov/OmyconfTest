//
//  LoginViewController.m
//  OmyconfTest
//
//  Created by Artem Kondrashov on 04.09.13.
//  Copyright (c) 2013 Artem Kondrashov. All rights reserved.
//

#import "LoginViewController.h"
#import "UserListViewController.h"

#define EMAIL       0
#define PASSWORD    1

@interface LoginViewController ()
{
    BOOL loginSuccess;
}

@property (strong, nonatomic) IBOutlet UIButton *btnSignUp;

@end

@implementation LoginViewController

#pragma mark - View lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = NSLocalizedString(@"Login", nil);

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    scrollView.contentSize = CGSizeMake(self.view.width, self.btnSignUp.y + self.btnSignUp.height);
    
#warning !!!! REMOVE BEFORE RELEASE !!!!
    [textFields[EMAIL] setText:@"user01@gmail.com"];
    [textFields[PASSWORD] setText:@"123456"];
}

- (void)viewDidUnload
{
    [self setBtnSignUp:nil];
    [super viewDidUnload];
}

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

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - TextField delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField.tag < 2)
        [textFields[textField.tag] becomeFirstResponder];
    else
    {
        [textField resignFirstResponder];
        [self onLogin:nil];
    }
    
    return YES;
}

#pragma mark - Private methods

- (BOOL)inputValidation
{
    if([Validator checkEmail:[textFields[EMAIL] text]])
    {
        if([Validator checkPassword:[textFields[PASSWORD] text]])
            return YES;
        else
            [Validator showError:PASSWORD_ERROR];
    }
    else
        [Validator showError:EMAIL_ERROR];
    
    return NO;
}

- (void)createObservers
{
    [super createObservers];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(signUpDidFinished:)
                                                 name:SignUpDidFinishedNotification
                                               object:nil];
}

#pragma mark - Notifications

- (void)signUpDidFinished:(NSNotification *)note
{
    [(UITextField *)textFields[EMAIL] setText:note.object];
    [(UITextField *)textFields[PASSWORD] setText:@""];
    [textFields[PASSWORD] becomeFirstResponder];
}

#pragma mark - Actions

- (IBAction)onLogin:(id)sender
{
    if([self inputValidation])
    {
        NSString *stringURL = [NSString stringWithFormat:@"%@%@?email=%@&password=%@",
                               BASE_URL,
                               USER_AUTH,
                               [[textFields[EMAIL] text] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                               [[textFields[PASSWORD] text] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        [self.internetProvider requestWithURL:stringURL];
    }
}

- (IBAction)onSignUp:(id)sender
{
    SignUpViewController *signUpVC = [[SignUpViewController alloc] init];
    [self.navigationController pushViewController:signUpVC animated:YES];
}

#pragma mark - InternetProvider Delegate

- (void)connectionDidFinishLoading:(NSData *)responseData
{
    [super connectionDidFinishLoading:responseData];
    
    NSString *dataString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", dataString);
    
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:responseData
                                                             options:NSJSONReadingMutableContainers
                                                               error:nil];
    
    if([[jsonDict objectForKey:@"error"] integerValue] == 0)
        loginSuccess = YES;
    else
        loginSuccess = NO;

    [[[UIAlertView alloc] initWithTitle:nil
                                message:[jsonDict objectForKey:@"message"]
                               delegate:self
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

#pragma mark - AlertView delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(loginSuccess)
    {
        [[NSUserDefaults standardUserDefaults] setObject:[textFields[EMAIL] text] forKey:UserEmailKey];
        [[NSUserDefaults standardUserDefaults] setObject:[textFields[PASSWORD] text] forKey:UserPasswordKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        UserListViewController *userListVC = [[UserListViewController alloc] init];
        [self.navigationController pushViewController:userListVC animated:YES];
    }
}

@end
