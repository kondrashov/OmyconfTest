//
//  UIImage+Helpers.h
//  OmyconfTest
//
//  Created by Artem Kondrashov on 09.09.13.
//  Copyright (c) 2013 Artem Kondrashov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Helpers)

- (UIImage*)safeResizableImageWithCapInsets:(UIEdgeInsets)edgeInsets
                               resizingMode:(UIImageResizingMode)resizingMode;

@end
