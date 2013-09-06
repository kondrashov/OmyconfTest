//
//  SignUpViewController.m
//  OmyconfTest
//
//  Created by Artem Kondrashov on 04.09.13.
//  Copyright (c) 2013 Artem Kondrashov. All rights reserved.
//

#import "SignUpViewController.h"

#define EMAIL           0
#define PASSWORD        1
#define FIRST_NAME      2
#define LAST_NAME       3

@interface SignUpViewController ()
{
    BOOL signUpSuccess;
}

@property (strong, nonatomic) IBOutlet UIButton *btnSignUp;
@property (strong, nonatomic) IBOutlet UILabel *lblEmail;

@end

@implementation SignUpViewController

#pragma mark - View lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = NSLocalizedString(@"Sign Up", nil);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    scrollView.contentSize = CGSizeMake(self.view.width, self.btnSignUp.y + self.btnSignUp.height + self.lblEmail.x);
}

- (void)viewDidUnload
{
    [self setBtnSignUp:nil];
    [self setLblEmail:nil];
    [super viewDidUnload];
}

#pragma mark - TextField delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField.tag < 4)
        [textFields[textField.tag] becomeFirstResponder];
    else
    {
        [textField resignFirstResponder];
        [self onSignUp:nil];
    }
    
    return YES;
}

#pragma mark - Private methods

- (BOOL)checkEmail
{
    NSString* regEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regEx];
    return [test evaluateWithObject:[textFields[EMAIL] text]];
}

- (BOOL)checkPassword
{
    NSString* regEx = @"[A-Z0-9a-z!@#$%^&*()-=_+]{6,12}";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regEx];
    return [test evaluateWithObject:[textFields[PASSWORD] text]];
}

- (BOOL)checkName:(NSString *)name
{
    NSString* regEx = @"[А-Яа-я-]{1,255}";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regEx];
    return [test evaluateWithObject:name];
}

- (BOOL)inputValidation
{
    if([Validator checkEmail:[textFields[EMAIL] text]])
    {
        if([Validator checkPassword:[textFields[PASSWORD] text]])
        {
            if([Validator checkName:[textFields[FIRST_NAME] text]])
            {
                if([Validator checkName:[textFields[LAST_NAME] text]])
                    return YES;
                else
                    [Validator showError:LAST_NAME_ERROR];
            }
            else
                [Validator showError:FIRST_NAME_ERROR];
        }
        else
            [Validator showError:PASSWORD_ERROR];
    }
    else
        [Validator showError:EMAIL_ERROR];

    return NO;
}

#pragma mark - Actions

- (IBAction)onSignUp:(id)sender
{
    if([self inputValidation])
    {
        NSString *stringURL = [NSString stringWithFormat:@"%@%@?first_name=%@&last_name=%@&email=%@&password=%@",
                               BASE_URL,
                               USER_CREATE_URL,
                               [[textFields[FIRST_NAME] text] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                               [[textFields[LAST_NAME] text] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                               [[textFields[EMAIL] text] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                               [[textFields[PASSWORD] text] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];

        [self.internetProvider requestWithURL:stringURL];
    }
}

#pragma mark - InternetProvider Delegate

- (void)connectionDidFinishLoading:(NSData *)responseData
{
    NSString *dataString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", dataString);
    
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:responseData
                                                             options:NSJSONReadingMutableContainers
                                                               error:nil];

    if([[jsonDict objectForKey:@"error"] integerValue] == 0)
        signUpSuccess = YES;
    else
        signUpSuccess = NO;

    [[[UIAlertView alloc] initWithTitle:nil
                                message:[jsonDict objectForKey:@"message"]
                               delegate:self
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

#pragma mark - AlertView delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(signUpSuccess)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:SignUpDidFinishedNotification object:[textFields[EMAIL] text]];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
