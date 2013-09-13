//
//  Helper.h
//  OmyconfTest
//
//  Created by Artem Kondrashov on 05.09.13.
//  Copyright (c) 2013 Artem Kondrashov. All rights reserved.
//

#import <Foundation/Foundation.h>

#define EMAIL_ERROR         @"Некорректный формат электронной почты"
#define PASSWORD_ERROR      @"Введите от 6 до 12 латинских символов или цифр"
#define FIRST_NAME_ERROR    @"Используйте кириллические символы."
#define LAST_NAME_ERROR     @"Используйте кириллические символы."

@interface Validator : NSObject

+ (BOOL)checkEmail:(NSString *)email;
+ (BOOL)checkPassword:(NSString *)password;
+ (BOOL)checkName:(NSString *)name;
+ (void)showError:(NSString *)errorText;

@end
