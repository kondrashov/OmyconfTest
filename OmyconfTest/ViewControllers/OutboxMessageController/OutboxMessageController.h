//
//  OutboxMessageController.h
//  OmyconfTest
//
//  Created by Artem Kondrashov on 09.09.13.
//  Copyright (c) 2013 Artem Kondrashov. All rights reserved.
//

#import "InboxMessageController.h"

@protocol OutboxMessageDelegate <NSObject>

- (void)outboxDownloadDidFinish:(NSArray *)dataArray;

@end

@interface OutboxMessageController : InboxMessageController

@end
