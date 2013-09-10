//
//  SendMessageController.m
//  OmyconfTest
//
//  Created by Artem Kondrashov on 10.09.13.
//  Copyright (c) 2013 Artem Kondrashov. All rights reserved.
//

#import "SendMessageController.h"

@interface SendMessageController ()
{
    NSString *receiverId;
    IBOutlet UILabel *lblReceiverName;
    IBOutlet UIButton *btnSend;
}

@property (strong, nonatomic) IBOutlet CTextView *textView;

@end

@implementation SendMessageController

#pragma mark - View lifecycle

- (id)initWithReceiverId:(NSString *)userId
{
    self = [super init];
    if (self)
    {
        self.title = @"Новое сообщение";
        receiverId = userId;
    }
    return self;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    btnSend.frame = CGRectMake(btnSend.x, self.textView.y + self.textView.height + 15, btnSend.width, btnSend.height);
    
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.textView setDelegate:self];
    [self.textView beginEdit];
    lblReceiverName.text = [Helpers getUserNameById:receiverId];
}

- (void)viewDidUnload
{
    [self setTextView:nil];
    lblReceiverName = nil;
    btnSend = nil;
    [super viewDidUnload];
}

#pragma mark - Parent methods

- (void)createGestures
{
    
}

#pragma mark - Actions

- (IBAction)onSend:(id)sender
{
    if(self.textView.text.length)
    {
        NSString *stringURL = [NSString stringWithFormat:@"%@%@?email=%@&password=%@&text=%@&sender=%@&receiver=%@",
                               BASE_URL,
                               MSG_CREATE,
                               [USER_EMAIL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                               [USER_PASSWORD stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                               [self.textView.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                               @"1", receiverId];
        
        [self.internetProvider requestWithURL:stringURL];
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:nil
                                    message:@"Введите текст сообщения"
                                   delegate:self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }    
}

- (void)connectionDidFinishLoading:(NSData*)responseData provider:(InternetProvider *)provider
{
    [super connectionDidFinishLoading:responseData provider:provider];
    
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:responseData
                                                             options:NSJSONReadingMutableContainers
                                                               error:nil];
    
    [[[UIAlertView alloc] initWithTitle:nil
                                message:[jsonDict objectForKey:@"message"]
                               delegate:self
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

@end
