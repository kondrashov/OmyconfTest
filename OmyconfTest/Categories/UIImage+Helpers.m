//
//  UIImage+Helpers.m
//  OmyconfTest
//
//  Created by Artem Kondrashov on 09.09.13.
//  Copyright (c) 2013 Artem Kondrashov. All rights reserved.
//

#import "UIImage+Helpers.h"

@implementation UIImage (Helpers)

- (UIImage*)safeResizableImageWithCapInsets:(UIEdgeInsets)edgeInsets
                               resizingMode:(UIImageResizingMode)resizingMode
{
    if ([UIImage resolveInstanceMethod:@selector(resizableImageWithCapInsets:)])
        return [self resizableImageWithCapInsets:edgeInsets resizingMode:UIImageResizingModeStretch];
    else
        return [self stretchableImageWithLeftCapWidth:edgeInsets.left topCapHeight:edgeInsets.top];
    
    return nil;
}

@end
