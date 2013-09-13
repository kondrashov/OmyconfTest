//
//  CTextField.h
//  OmyconfTest
//
//  Created by Artem Kondrashov on 12.09.13.
//  Copyright (c) 2013 Artem Kondrashov. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    CTFError,
    CTFOK,
    CTFNormal
} CTFState;

@interface CTextField : UITextField

@property (nonatomic) CTFState state;

@end
