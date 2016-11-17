//
//  WebServiceRequest.h
//  BBCRadio4Schedule
//
//  Created by Juliana Cipa on 26/06/2016.
//  Copyright © 2016 Super Cool Start-up. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^WebServiceRequestHandler)(NSDictionary *responseData,
                                         NSError *error);
typedef void (^DataTaskHandler)(NSData *data, NSURLResponse *response,
                                NSError *error);

@interface WebServiceRequest : NSObject

+ (void)startGetRequestWithFileName:(NSString *)fileName
                            handler:(WebServiceRequestHandler)handler;

@end
