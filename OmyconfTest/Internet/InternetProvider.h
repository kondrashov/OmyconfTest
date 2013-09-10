//
//  InternetProvider.h
//  OmyconfTest
//
//  Created by Artem Kondrashov on 05.09.13.
//  Copyright (c) 2013 Artem Kondrashov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class InternetProvider;
@protocol InternetProviderDelegate <NSObject>

- (void)connectionDidReceiveResponse;
- (void)connectionDidFinishLoading:(NSData*)responseData provider:(InternetProvider *)provider;

@optional
- (void)connectiondidFailWithError:(NSError *)error;

@end

@interface InternetProvider : NSObject <NSURLConnectionDelegate>

@property (strong, nonatomic) NSMutableData *responseData;
@property (weak, nonatomic) id<InternetProviderDelegate> delegate;
@property (assign, nonatomic) NSInteger tag;

- (void)requestWithURL:(NSString*)stringURL;

@end
