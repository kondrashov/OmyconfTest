//
//  Helpers.m
//  OmyconfTest
//
//  Created by Artem Kondrashov on 07.09.13.
//  Copyright (c) 2013 Artem Kondrashov. All rights reserved.
//

#import "Helpers.h"

@implementation Helpers

+ (NSString *)getUserNameById:(NSString *)userId
{
    NSDictionary *userDict = [[NSUserDefaults standardUserDefaults] objectForKey:UserListKey];
    NSDictionary *user = [userDict objectForKey:userId];
    NSString *userName = [NSString stringWithFormat:@"%@ %@", [user objectForKey:@"first_name"], [user objectForKey:@"last_name"]];
    return userName;
}

@end
