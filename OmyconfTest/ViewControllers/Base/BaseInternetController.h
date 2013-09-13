//
//  BaseInternetController.h
//  OmyconfTest
//
//  Created by Artem Kondrashov on 05.09.13.
//  Copyright (c) 2013 Artem Kondrashov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InternetProvider.h"

#define DEFAULT_PROVIDER_TAG  1

@interface BaseInternetController : UIViewController <InternetProviderDelegate>
{
    BOOL loadNow;
}

@property (strong, nonatomic) InternetProvider *internetProvider;

- (void)loadData;

@end
