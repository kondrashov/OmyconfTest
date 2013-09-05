//
//  LoginViewController.h
//  OmyconfTest
//
//  Created by Artem Kondrashov on 04.09.13.
//  Copyright (c) 2013 Artem Kondrashov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import "SignUpViewController.h"
#import "BaseInputController.h"

@interface LoginViewController : BaseInputController

- (IBAction)onLogin:(id)sender;
- (IBAction)onSignUp:(id)sender;

@end
