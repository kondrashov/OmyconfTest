//
//  CTextField.m
//  OmyconfTest
//
//  Created by Artem Kondrashov on 12.09.13.
//  Copyright (c) 2013 Artem Kondrashov. All rights reserved.
//

#import "CTextField.h"

@implementation CTextField

@synthesize state = _state;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

- (CGRect)textRectForBounds:(CGRect)bounds
{
    return CGRectInset( bounds , 10 , 0 );
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return CGRectInset( bounds , 10 , 0 );
}

- (void)setState:(CTFState)state
{
    NSString *imageName;
    switch (state)
    {
        case CTFNormal:
            imageName = @"textfieldNormal.png";
            break;
        case CTFError:
            imageName = @"textfieldError.png";
            break;
        case CTFOK:
            imageName = @"textfieldOk.png";
            break;
        default:
            break;
    }
    [self setBackground:[UIImage imageNamed:imageName]];
    _state = state;
}

@end
