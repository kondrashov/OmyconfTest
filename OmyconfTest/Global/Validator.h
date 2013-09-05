//
//  Helper.h
//  OmyconfTest
//
//  Created by Artem Kondrashov on 05.09.13.
//  Copyright (c) 2013 Artem Kondrashov. All rights reserved.
//

#import <Foundation/Foundation.h>

#define EMAIL_ERROR         @"Incorrect email address. Please try again."
#define PASSWORD_ERROR      @"Password must contain 6-12 latin characters, numbers or symbols !@#$%^&*()-=_+."
#define FIRST_NAME_ERROR    @"Incorrect first name. Please use cyrillic characters."
#define LAST_NAME_ERROR     @"Incorrect last name. Please use cyrillic characters."

@interface Validator : NSObject

+ (BOOL)checkEmail:(NSString *)email;
+ (BOOL)checkPassword:(NSString *)password;
+ (BOOL)checkName:(NSString *)name;
+ (void)showError:(NSString *)errorText;

@end
