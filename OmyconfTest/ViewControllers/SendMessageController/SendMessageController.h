//
//  SendMessageController.h
//  OmyconfTest
//
//  Created by Artem Kondrashov on 10.09.13.
//  Copyright (c) 2013 Artem Kondrashov. All rights reserved.
//

#import "BaseInputController.h"
#import "CTextView.h"

@interface SendMessageController : BaseInputController

- (id)initWithReceiverId:(NSString *)receiverId;

- (IBAction)onSend:(id)sender;

@end
