//
//  LoginViewController.m
//  OmyconfTest
//
//  Created by Artem Kondrashov on 04.09.13.
//  Copyright (c) 2013 Artem Kondrashov. All rights reserved.
//

#import "LoginViewController.h"
#import "UserListViewController.h"
#import "CTextField.h"

#define EMAIL       0
#define PASSWORD    1

@interface LoginViewController ()
{
    BOOL loginSuccess;
    BOOL loginPress;
}

@property (strong, nonatomic) IBOutlet UIButton *btnSignUp;
@property (strong, nonatomic) IBOutlet UILabel *lblEmailError;
@property (strong, nonatomic) IBOutlet UILabel *lblPassError;

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
    
//#warning !!!! REMOVE BEFORE RELEASE !!!!
//    [textFields[EMAIL] setText:@"ally1308@yandex.ru"];
//    [textFields[PASSWORD] setText:@"1234567"];
}

- (void)viewDidUnload
{
    [self setBtnSignUp:nil];
    [self setLblEmailError:nil];
    [self setLblPassError:nil];
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    textField.text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    SEL validationSeector;
    switch (textField.tag)
    {
        case 1:
            validationSeector = @selector(checkEmail);
            break;
            
        case 2:
            validationSeector = @selector(checkPass);
            break;
    }
    
    [self validateTextField:(CTextField *)textField selector:validationSeector];
    return NO;
}


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

- (BOOL)checkEmail
{
    return [Validator checkEmail:[textFields[EMAIL] text]];
}

- (BOOL)checkPass
{
    return [Validator checkPassword:[textFields[PASSWORD] text]];
}

- (BOOL)validateTextField:(CTextField *)textField selector:(SEL)selector
{
    BOOL valid;
    UILabel *errorLabel;
    
    switch (textField.tag)
    {
        case 1:
            errorLabel = self.lblEmailError;
            errorLabel.text = EMAIL_ERROR;
            break;
            
        case 2:
            errorLabel = self.lblPassError;
            errorLabel.text = PASSWORD_ERROR;
            break;
    }
    
    if([textField text].length == 0)
    {
        if(loginPress)
        {
            [textField setState:CTFError];
            errorLabel.hidden = NO;
        }
        else
        {
            [textField setState:CTFNormal];
            errorLabel.hidden = YES;
        }
        valid = NO;
    }
    else if([self performSelector:selector])
    {
        [textField setState:CTFOK];
        errorLabel.hidden = YES;
        valid = YES;
    }
    else
    {
        [textField setState:CTFError];
        errorLabel.hidden = NO;
        valid = NO;
    }
    
    return valid;
}


- (BOOL)inputValidation
{
    BOOL emailValid = [self validateTextField:textFields[EMAIL] selector:@selector(checkEmail)];
    BOOL passValid = [self validateTextField:textFields[PASSWORD] selector:@selector(checkPass)];
    
    loginPress = NO;
    return (emailValid && passValid);
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
    [(CTextField *)textFields[EMAIL] setText:note.object];
    [(CTextField *)textFields[PASSWORD] setText:@""];
    
    loginPress = NO;
    [self inputValidation];
    [textFields[PASSWORD] becomeFirstResponder];
}

#pragma mark - Actions

- (IBAction)onLogin:(id)sender
{
    loginPress = YES;
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

- (void)connectionDidFinishLoading:(NSData*)responseData provider:(InternetProvider *)provider
{
    [super connectionDidFinishLoading:responseData provider:provider];
    
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
    else
    {
        [textFields[EMAIL] setState:CTFError];
        [textFields[PASSWORD] setState:CTFError];
    }
}

@end
