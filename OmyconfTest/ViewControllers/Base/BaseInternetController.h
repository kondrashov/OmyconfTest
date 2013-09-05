//
//  BaseInternetController.h
//  OmyconfTest
//
//  Created by Artem Kondrashov on 05.09.13.
//  Copyright (c) 2013 Artem Kondrashov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InternetProvider.h"

@interface BaseInternetController : UIViewController <InternetProviderDelegate>

@property (strong, nonatomic) InternetProvider *internetProvider;

@end
