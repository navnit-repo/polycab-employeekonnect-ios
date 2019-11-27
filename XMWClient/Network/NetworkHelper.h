//
//  NetworkHelper.h
//  QCMSProject
//
//  Created by Pradeep Singh on 7/10/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpEventListener.h"

@interface NetworkHelper : NSObject <NSURLConnectionDelegate,HttpEventListener>
{
@private    
   NSMutableData* responseData;
    id xmwRequestObject;
    id<HttpEventListener> responseHandler;
    NSString* xmwRequestCallname;
    NSString * sessionId;
    NSString *AUTH_TOKEN_VALUE;
}

-(void) makeXmwNetworkCall : (id) requestObject : (id<HttpEventListener>) responseListener :(NSString *)in_SessionId : (NSString*) callName;
-(void) registerDevice : (id) requestObject : (id <HttpEventListener>) responseListener : (NSString*) callName;
-(void) genericRequestWith:(id) requestObject :(id <HttpEventListener>) responseListener :(NSString*) callName;
-(void) genericJSONPayloadRequestWith:(id) requestObject :(id <HttpEventListener>) responseListener :(NSString*) callName;
-(void) resetDeviceSessionId;
-(void) makeXmwNetworkCallForImagePost:(id) requestObject :(id <HttpEventListener>) responseListener :(NSString *)in_SessionId :(NSString*) callName :(NSData *)imageData;

-(void) versionCheck:(id) requestObject :(id <HttpEventListener>) responseListener :(NSString*) callName;

@property (weak, nonatomic) NSString* serviceURLString;
@property NSString *AUTH_TOKEN_VALUE;
@property (strong, nonatomic) NSDictionary* customerHeaders;

-(void) serverFailMessageHandler:(NSDictionary*) failDataDict;
-(void) defaultSessionExpiredHandler;


@end
