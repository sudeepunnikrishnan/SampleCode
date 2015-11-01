//
//  HSGWebConnectionHandler.m
//  TourGuide
//
//  Created by Sudeep Unnikrishnan on 5/27/15.
//  Copyright (c) 2015 Sudeep Unnikrishnan. All rights reserved.
//

#import "HSGWebConnectionHandler.h"

@interface HSGWebConnectionHandler()<NSURLSessionDelegate,NSURLSessionTaskDelegate,NSURLSessionDataDelegate>

@property (strong,nonatomic) NSURLSession *session;
@property (strong,nonatomic) NSURLSessionDataTask *dataTask;
@property (nonatomic,copy) successHandler successBlock;
@property (nonatomic,copy) failureHandler failureBlock;




@end

@implementation HSGWebConnectionHandler
-(void)initWithRequest:(NSMutableURLRequest*)request withSuccess:(successHandler)successHandler andFailure:(failureHandler)failureHandler
{
    self.successBlock = successHandler;
    self.failureBlock = failureHandler;
    
    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    [mutableRequest setTimeoutInterval:30.0f];
    
    self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
    
    self.dataTask = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if(!error)
        {
            successHandler(data,response);
        }
        else
        {
            failureHandler(data,response,error);
        }
    }];
    [self.dataTask resume];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data
{
    
}


- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
   didSendBodyData:(int64_t)bytesSent
    totalBytesSent:(int64_t)totalBytesSent
totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend
{
    
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(NSError *)error
{
    
}


@end
