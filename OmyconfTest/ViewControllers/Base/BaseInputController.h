//
//  BaseInputController.h
//  OmyconfTest
//
//  Created by Artem Kondrashov on 04.09.13.
//  Copyright (c) 2013 Artem Kondrashov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseInternetController.h"

@interface BaseInputController : BaseInternetController  <UITextFieldDelegate>
{
    IBOutlet UIScrollView *scrollView;
    IBOutletCollection(UITextField) NSArray *textFields;
}

- (void)createGestures;
- (void)createObservers;

@end
