//
//  WebServiceRequest.m
//  BBCRadio4Schedule
//
//  Created by Juliana Cipa on 26/06/2016.
//  Copyright © 2016 Super Cool Start-up. All rights reserved.
//

#import "WebServiceRequest.h"

static NSString *const kEndPoint = @"http://www.bbc.co.uk/radio4/programmes/schedules/fm/";

@implementation WebServiceRequest

#pragma mark - Private methods

+ (void)populateHandler:(WebServiceRequestHandler)handler
               withData:(NSData *)data
               andError:(NSError *)error {
    if (error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            handler(nil, error);
        });
    } else {
        NSError *deserializationError = nil;
        id jsonObject = [NSJSONSerialization JSONObjectWithData:data
                                                        options:NSJSONReadingMutableContainers
                                                          error:&deserializationError];
        
        if (deserializationError) {
            dispatch_async(dispatch_get_main_queue(), ^{
                handler(nil, deserializationError);
            });
        } else {
            NSDictionary *responseDict = (NSDictionary *)jsonObject;
            
            if (responseDict) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    handler(responseDict, nil);
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    handler(nil, nil);
                });
            }
        }
    }
}

+ (NSMutableURLRequest *)requestForURL:(NSString *)urlString {
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request addValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [request setHTTPMethod:@"GET"];
    
    return request;
}

+ (void)startRequest:(NSURLRequest *)request withHandler:(WebServiceRequestHandler)handler {
    DataTaskHandler dataTaskHandler = ^(NSData *data, NSURLResponse * __unused response, NSError *error) {
        [WebServiceRequest populateHandler:handler withData:data andError:error];
    };
    
    NSURLSession *sharedSession = [NSURLSession sharedSession];
    [[sharedSession dataTaskWithRequest:request completionHandler:dataTaskHandler] resume];
}

#pragma mark - Public methods

+ (void)startGetRequestWithFileName:(NSString *)fileName
                            handler:(WebServiceRequestHandler)handler {
    if (handler) {
        NSString *url = [NSString stringWithFormat:@"%@%@.json", kEndPoint, fileName];
        NSMutableURLRequest *request = [WebServiceRequest requestForURL:url];
        
        [WebServiceRequest startRequest:request withHandler:handler];
    }
}

@end
