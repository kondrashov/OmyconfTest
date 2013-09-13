//
//  SignUpViewController.m
//  OmyconfTest
//
//  Created by Artem Kondrashov on 04.09.13.
//  Copyright (c) 2013 Artem Kondrashov. All rights reserved.
//

#import "SignUpViewController.h"
#import "CTextField.h"

#define EMAIL           0
#define PASSWORD        1
#define FIRST_NAME      2
#define LAST_NAME       3

@interface SignUpViewController ()
{
    BOOL signUpSuccess;
    BOOL signUpPress;
}

@property (strong, nonatomic) IBOutlet UIButton *btnSignUp;
@property (strong, nonatomic) IBOutlet UILabel *lblEmail;
@property (strong, nonatomic) IBOutlet UILabel *lblEmailError;
@property (strong, nonatomic) IBOutlet UILabel *lblPassError;
@property (strong, nonatomic) IBOutlet UILabel *lblFirstNameError;
@property (strong, nonatomic) IBOutlet UILabel *lblLastNameError;

@end

@implementation SignUpViewController

#pragma mark - View lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = NSLocalizedString(@"Регистрация", nil);
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
    [self setLblEmailError:nil];
    [self setLblPassError:nil];
    [self setLblFirstNameError:nil];
    [self setLblLastNameError:nil];
    [super viewDidUnload];
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

        case 3:
            validationSeector = @selector(checkFirstName);
            break;

        case 4:
            validationSeector = @selector(checkLastName);
            break;
    }
    
    [self validateTextField:(CTextField *)textField selector:validationSeector];
    return NO;
}

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
    return [Validator checkEmail:[textFields[EMAIL] text]];
}

- (BOOL)checkPass
{
    return [Validator checkPassword:[textFields[PASSWORD] text]];
}

- (BOOL)checkFirstName
{
    return [Validator checkName:[textFields[FIRST_NAME] text]];
}

- (BOOL)checkLastName
{
    return [Validator checkName:[textFields[LAST_NAME] text]];
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
            
        case 3:
            errorLabel = self.lblFirstNameError;
            errorLabel.text = FIRST_NAME_ERROR;
            break;
            
        case 4:
            errorLabel = self.lblLastNameError;
            errorLabel.text = LAST_NAME_ERROR;
            break;
    }
    
    if([textField text].length == 0)
    {
        if(signUpPress)
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
    BOOL firstNameValid = [self validateTextField:textFields[FIRST_NAME] selector:@selector(checkFirstName)];
    BOOL lastNameValid = [self validateTextField:textFields[LAST_NAME] selector:@selector(checkLastName)];
    
    signUpPress = NO;
    return (emailValid && passValid && firstNameValid && lastNameValid);
}

#pragma mark - Actions

- (IBAction)onSignUp:(id)sender
{
    signUpPress = YES;
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

- (void)connectionDidFinishLoading:(NSData*)responseData provider:(InternetProvider *)provider
{
   [super connectionDidFinishLoading:responseData provider:provider];
    
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
    else
    {
        [textFields[EMAIL] setState:CTFError];
    }
}

@end
