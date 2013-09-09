//
//  Helper.m
//  OmyconfTest
//
//  Created by Artem Kondrashov on 05.09.13.
//  Copyright (c) 2013 Artem Kondrashov. All rights reserved.
//

#import "Validator.h"

@implementation Validator

+ (BOOL)checkEmail:(NSString *)email
{
    NSString* regEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regEx];
    return [test evaluateWithObject:email];
}

+ (BOOL)checkPassword:(NSString *)password
{
    NSString* regEx = @"[A-Z0-9a-z!@#$%^&*()-=_+]{6,12}";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regEx];
    return [test evaluateWithObject:password];
}

+ (BOOL)checkName:(NSString *)name
{
    NSString* regEx = @"[А-Яа-я-]{1,255}";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regEx];
    return [test evaluateWithObject:name];
}

+ (void)showError:(NSString *)errorText
{
    [[[UIAlertView alloc] initWithTitle:@"Ошибка"
                                message:errorText
                               delegate:nil
                      cancelButtonTitle:@"ОК"
                      otherButtonTitles:nil] show];
}


@end
