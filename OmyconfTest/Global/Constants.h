//
//  Constants.h
//  OmyconfTest
//
//  Created by Artem Kondrashov on 05.09.13.
//  Copyright (c) 2013 Artem Kondrashov. All rights reserved.
//

#define BASE_URL            @"http://testapi.rogotest.ru/"
#define USER_CREATE_URL     @"user/create"
#define USER_AUTH           @"user/auth"
#define USER_LIST           @"user/list"
#define MSG_LIST            @"msg/list"
#define MSG_MY              @"msg/my"
#define MSG_CREATE          @"msg/create"
#define MSG_UPDATE          @"msg/update/"

#define SignUpDidFinishedNotification   @"SignUpDidFinishedNotification"
#define MsgSendSuccessNotification      @"MsgSendSuccessNotification"
#define UserEmailKey                    @"UserEmail"
#define UserPasswordKey                 @"UserPassword"
#define UserListKey                     @"UserList"

#define USER_EMAIL          [[NSUserDefaults standardUserDefaults] objectForKey:UserEmailKey]
#define USER_PASSWORD       [[NSUserDefaults standardUserDefaults] objectForKey:UserPasswordKey]
