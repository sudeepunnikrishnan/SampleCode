//
//  HSGWebConnectionHandler.h
//  TourGuide
//
//  Created by Sudeep Unnikrishnan on 5/27/15.
//  Copyright (c) 2015 Sudeep Unnikrishnan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSGWebConnectionHandler : NSObject

typedef void (^successHandler)(NSData *data,NSURLResponse *response);
typedef void (^failureHandler)(NSData *data,NSURLResponse *response,NSError *error);


-(void)initWithRequest:(NSMutableURLRequest*)request withSuccess:(successHandler)successHandler andFailure:(failureHandler)failureHandler;

@end

