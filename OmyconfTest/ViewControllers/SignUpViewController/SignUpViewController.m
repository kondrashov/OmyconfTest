//
//  SignUpViewController.m
//  OmyconfTest
//
//  Created by Artem Kondrashov on 04.09.13.
//  Copyright (c) 2013 Artem Kondrashov. All rights reserved.
//

#import "SignUpViewController.h"

@interface SignUpViewController ()

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
        [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - Private methods

- (BOOL)checkEmail
{
    NSString* regEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regEx];
    return [test evaluateWithObject:[textFields[0] text]];
}

- (BOOL)checkPassword
{
    NSString* regEx = @"[A-Z0-9a-z!@#$%^&*()-=_+]{6,12}";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regEx];
    return [test evaluateWithObject:[textFields[1] text]];
}

- (BOOL)checkName:(NSString *)name
{
    NSString* regEx = @"[А-Яа-я-]{1,255}";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regEx];
    BOOL a = [test evaluateWithObject:name];
    return a;
}

- (void)showError:(NSString *)errorText
{
    [[[UIAlertView alloc] initWithTitle:@"Error"
                                message:errorText
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

- (BOOL)inputValidation
{
    if([self checkEmail])
    {
        if([self checkPassword])
        {
            if([self checkName:[textFields[2] text]])
            {
                if([self checkName:[textFields[3] text]])
                {
                    return YES;
                }
                else
                    [self showError:@"Incorrect last name. Please use cyrillic characters."];
            }
            else
                [self showError:@"Incorrect first name. Please use cyrillic characters."];
        }
        else
            [self showError:@"Password must contain 6-12 latin characters, numbers or symbols !@#$%^&*()-=_+."];
    }
    else
        [self showError:@"Incorrect email address. Please try again."];

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
                               [[textFields[2] text] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                               [[textFields[3] text] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                               [[textFields[0] text] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                               [[textFields[1] text] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];

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
    [[[UIAlertView alloc] initWithTitle:nil
                                message:[jsonDict objectForKey:@"message"]
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

@end
