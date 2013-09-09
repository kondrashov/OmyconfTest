//
//  Helper.h
//  OmyconfTest
//
//  Created by Artem Kondrashov on 05.09.13.
//  Copyright (c) 2013 Artem Kondrashov. All rights reserved.
//

#import <Foundation/Foundation.h>

#define EMAIL_ERROR         @"Некорректный формат электронной почты"
#define PASSWORD_ERROR      @"Пароль должен содержать от 6 до 12 латинских букв, цифр или символов !@#$%^&*()-=_+."
#define FIRST_NAME_ERROR    @"Некорректный формат имени. Пожалуйста, используйте кириллические буквы."
#define LAST_NAME_ERROR     @"Некорректный формат фамилии. Пожалуйста, используйте кириллические буквы."

@interface Validator : NSObject

+ (BOOL)checkEmail:(NSString *)email;
+ (BOOL)checkPassword:(NSString *)password;
+ (BOOL)checkName:(NSString *)name;
+ (void)showError:(NSString *)errorText;

@end
