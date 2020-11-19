//
//  NetworkHelper.m
//  QCMSProject
//
//  Created by Pradeep Singh on 7/10/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//

#import "NetworkHelper.h"

#import "JSONNetworkRequestData.h"
#import "JSONDataExchange.h"
#import "SBJson.h"
#import "XmwcsConstant.h"
#import "ReportPostResponse.h"

#include "iconv.h"
#import "DVAppDelegate.h"
#import "ClientVariable.h"
#import "SWRevealViewController.h"
@interface NetworkHelper ()
{
    NSURLConnection* urlConnection;
   


}

@end

@implementation NetworkHelper
@synthesize AUTH_TOKEN_VALUE;


NSString *g_DeviceSessionId = nil;


- (id) init {
    if (self = [super init])
    {
        responseData = nil;
        xmwRequestObject = nil;
        responseHandler = nil;
        xmwRequestCallname = nil;
        sessionId = nil;
        self.serviceURLString = @"";
        
    }
    return self;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    // NSLog (@"Not implemented : - (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error %@", [error description]);
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setDictionary:error.userInfo];
    [responseHandler httpFailureHandler:xmwRequestCallname :[dict valueForKey:@"NSLocalizedDescription"]];
   // [responseHandler httpFailureHandler:xmwRequestCallname :[error description]];
    
}


- (NSInputStream *)connection:(NSURLConnection *)connection needNewBodyStream:(NSURLRequest *)request {
    // NSLog(@"Not implemented : - (NSInputStream *)connection:(NSURLConnection *)connection needNewBodyStream:(NSURLRequest *)request");
    
    return nil;
}


- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite {
    
    // NSLog(@"Not implemented : - (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite");
    
    
}


// there will be repeat calls and data needs to be appended
// Sent as a connection loads data incrementally.
// The newly available data. The delegate should concatenate the contents of each data object
// delivered to build up the complete data for a URL load.
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSLog(@"To be implemented : - (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data");
    NSLog(@"Data Received = %d", data.length);
    
    // NSLog(@"%@", [[NSString alloc ] initWithData:data encoding:NSUTF8StringEncoding]);
    
    [responseData appendData:data];
}


// Sent when the connection has received sufficient data to construct the URL response for its request.
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    NSLog(@"To be implemented : - (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response");
    
    // – expectedContentLength
    // – suggestedFilename
    // – MIMEType
    // – textEncodingName
    //  – URL
    
    NSLog(@"expectedContentLength = %lld", response.expectedContentLength);
    NSLog(@"MIMEType = %@", response.MIMEType);
    NSLog(@"textEncodingName = %@", response.textEncodingName);
    
    if(response.expectedContentLength>0) {
        responseData = [[NSMutableData alloc] initWithCapacity: response.expectedContentLength ];
    } else {
        responseData = [[NSMutableData alloc] init];
    }
    
    //  NSDictionary* headers = [(NSHTTPURLResponse *)response allHeaderFields];
    
    NSArray<NSHTTPCookie *>* cookies = [NSHTTPCookie cookiesWithResponseHeaderFields:[(NSHTTPURLResponse *)response allHeaderFields] forURL:connection.currentRequest.URL];
    
    NSHTTPCookieStorage* cookiesStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    [cookiesStorage setCookies:cookies forURL:connection.currentRequest.URL mainDocumentURL:connection.currentRequest.mainDocumentURL];
    
}


// Sent before the connection stores a cached response in the cache, to give the delegate an opportunity to alter it.
- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse {
    
    NSLog(@"May not implemented : - (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse");
    
    
    
    return nil;
}



// Sent when the connection determines that it must change URLs in order to continue loading a request.
- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponse {
    
    NSLog(@"May not implement: - (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponse ");
    
    return request;
}


//Sent when a connection has finished loading successfully. (required)

//- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
//    NSLog(@"(void)connectionDidFinishLoading:(NSURLConnection *)connection");
//    NSLog(@"All content received = %d", responseData.length);
//
//    SBJsonParser* sbParser = [[SBJsonParser alloc] init];
//
//
//    // now parse the content to get json data, and notify to response handler.
//    NSString *jsonResponseStr = [[NSString alloc ] initWithData:[self cleanUTF8 : responseData] encoding:NSUTF8StringEncoding];
//    id parsedJsonResponseObject = [sbParser objectWithString :jsonResponseStr];
//
//    NSLog(@ "Our Data = %@" , jsonResponseStr);
//
//
//
//
//    //  NSLog(@"%@", [[NSString alloc ] initWithData:responseData encoding:NSUTF8StringEncoding]);
//
//    // id parsedJsonResponseObject = [sbParser objectWithData:responseData];
//    JSONNetworkRequestData* networkReqResObj = [JSONDataExchange convertFromJsonObject:parsedJsonResponseObject];
//
//    /*
//    if(networkReqResObj!=nil) {
//        if(networkReqResObj.dServiceId !=nil && ![networkReqResObj isKindOfClass:[NSNull class]]) {
//            g_DeviceSessionId =  networkReqResObj.dServiceId;
//        }
//    }
//     */
//
//    // ClientLoginResponse* clientLoginResponse =  (ClientLoginResponse*) networkReqResObj.responseData;
//    if(responseHandler != nil) {
//
//        if(networkReqResObj!=nil && [networkReqResObj isKindOfClass:[JSONNetworkRequestData class]]) {
//
//            if(networkReqResObj.dServiceId !=nil && ![networkReqResObj isKindOfClass:[NSNull class]]) {
//                g_DeviceSessionId =  networkReqResObj.dServiceId;
//            }
//
//            if( [networkReqResObj.status compare:@"SUCCESS" options:NSCaseInsensitiveSearch]==0) {
//                if([responseHandler respondsToSelector:@selector(httpResponseObjectHandler:::)]) {
//                    [responseHandler httpResponseObjectHandler:xmwRequestCallname : networkReqResObj.responseData :xmwRequestObject];
//                }
//            } else if( [networkReqResObj.status compare:@"FAIL" options:NSCaseInsensitiveSearch]==0) {
//
//                // ERROR_TYPE:3$ERROR_SUB_TYPE:5$ERROR_MSG:Error Send the correct data to submit!
//
//                NSArray* parts = [networkReqResObj.message componentsSeparatedByString:@"$"];
//                if([parts count]==1) {
//                    if([responseHandler respondsToSelector:@selector(httpFailureHandler::)]) {
//                        [responseHandler httpFailureHandler:xmwRequestCallname : networkReqResObj.message];
//                    }
//                    return;
//                }
//
//                NSMutableString* errorMessage = [[NSMutableString alloc] init];
//
//                for(int i=0; i<[parts count]; i++) {
//                    NSString* line = [parts objectAtIndex:i];
//                    NSArray* keyVal = [line componentsSeparatedByString:@":"];
//                    if([keyVal count]==2) {
//                        if([[keyVal objectAtIndex:0] isEqualToString:@"ERROR_MSG"]) {
//                            [errorMessage appendString:[keyVal objectAtIndex:1]];
//                            if([responseHandler respondsToSelector:@selector(httpFailureHandler::)]) {
//                                [responseHandler httpFailureHandler:xmwRequestCallname : errorMessage];
//                            }
//                            return;
//                        }
//                    }
//                }
//                if([responseHandler respondsToSelector:@selector(httpFailureHandler::)]) {
//                    [responseHandler httpFailureHandler:xmwRequestCallname : networkReqResObj.message];
//                }
//                return;
//            }
//
//        } else  if([networkReqResObj isKindOfClass:[NSDictionary class]]) {
//
//            if([responseHandler respondsToSelector:@selector(httpResponseObjectHandler:::)]) {
//                [responseHandler httpResponseObjectHandler:xmwRequestCallname :networkReqResObj :xmwRequestObject];
//            }
//        }
//
//
//    }
//}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"(void)connectionDidFinishLoading:(NSURLConnection *)connection");
    NSLog(@"All content received = %d", responseData.length);
    
    NSError* error;
    
    NSDictionary *parsedJsonResponseObject = [NSJSONSerialization JSONObjectWithData:[NetworkHelper cleanUTF8:responseData] options:NSJSONReadingMutableContainers error:&error];
    
    if(error!=nil) {
        NSLog(@"Error in JSON Serialization: %@", [error description]);
    }
    
    
    NSString *jsonFormatDataString = [[NSString alloc] initWithData:[NetworkHelper cleanUTF8:responseData] encoding:NSUTF8StringEncoding];
    NSLog(@"jsonFormatDataString: %@", jsonFormatDataString);
        
    // now parse the content to get json data, and notify to response handler.
   //  NSString *jsonResponseStr = [[NSString alloc ] initWithData:[NetworkHelper cleanUTF8 : responseData] encoding:NSUTF8StringEncoding];
   // id parsedJsonResponseObject = [sbParser objectWithString :jsonResponseStr];
    
   // NSLog(@ "Our Data = %@" , jsonResponseStr);
    
    JSONNetworkRequestData* networkReqResObj = [JSONDataExchange convertFromJsonObject:parsedJsonResponseObject];
    
    if(networkReqResObj!=nil && [networkReqResObj isKindOfClass:[JSONNetworkRequestData class]]) {
        if(networkReqResObj.dServiceId !=nil && ![networkReqResObj isKindOfClass:[NSNull class]]) {
            g_DeviceSessionId =  networkReqResObj.dServiceId;
        }
    }
    
    // ClientLoginResponse* clientLoginResponse =  (ClientLoginResponse*) networkReqResObj.responseData;
    if(responseHandler != nil ) {
        if([networkReqResObj isKindOfClass:[JSONNetworkRequestData class]]) {
            if( [networkReqResObj.status compare:@"SUCCESS" options:NSCaseInsensitiveSearch]==0) {
                
                [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"SERVER_UNDER_MAINTENANCE"];
                [[NSUserDefaults standardUserDefaults]  synchronize];

                if([responseHandler respondsToSelector:@selector(httpResponseObjectHandler:::)]) {
                    [responseHandler httpResponseObjectHandler:xmwRequestCallname : networkReqResObj.responseData :xmwRequestObject];
                }
            } else if( [networkReqResObj.status compare:@"FAIL" options:NSCaseInsensitiveSearch]==0) {
                
                // ERROR_TYPE:3$ERROR_SUB_TYPE:5$ERROR_MSG:Error Send the correct data to submit!
                
                NSArray* parts = [networkReqResObj.message componentsSeparatedByString:@"$"];
                if([parts count]==1) {
                    if([responseHandler respondsToSelector:@selector(httpFailureHandler::)]) {
                        [responseHandler httpFailureHandler:xmwRequestCallname : networkReqResObj.message];
                    }
                    return;
                }
                //
                // for session expire
                // "ERROR_TYPE:3$ERROR_SUB_TYPE:3$ERROR_MSG:Your Session expired , Please Login Again!
                //
                
                NSMutableDictionary* failDataDict = [[NSMutableDictionary alloc] init];
                
                for(int i=0; i<[parts count]; i++) {
                    NSString* line = [parts objectAtIndex:i];
                    NSArray* keyVal = [line componentsSeparatedByString:@":"];
                    
                                        if([keyVal count]==1) {
                        [failDataDict setObject:[keyVal objectAtIndex:0] forKey:[keyVal objectAtIndex:0]];
                    } else if([keyVal count]==2) {
                         [failDataDict setObject:[keyVal objectAtIndex:1] forKey:[keyVal objectAtIndex:0]];
                    } else if([keyVal count]>2) {
                        NSUInteger location = [line rangeOfString:@":"].location + 1;
                        NSString* otherPart = [line substringFromIndex:location];
                        [failDataDict setObject:otherPart forKey:[keyVal objectAtIndex:0]];
                    }
                }
                [self serverFailMessageHandler:failDataDict];
            }
        } else if([networkReqResObj isKindOfClass:[NSDictionary class]]) {
        
                    // API call is not authorized :==> No auth Token Found." ERROR HANDLING
                    if ([[networkReqResObj valueForKey:@"message"] isEqualToString:@"API call is not authorized :==> No auth Token Found."]) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self defaultSessionExpireHandler];
                        });
        
                    }
                    else
                    {
                        if([responseHandler respondsToSelector:@selector(httpResponseObjectHandler:::)]) {
                                       [responseHandler httpResponseObjectHandler:xmwRequestCallname :networkReqResObj :xmwRequestObject];
                                   }
                    }
        
                }
    }
}

-(void) serverFailMessageHandler:(NSDictionary*) failDataDict
{
       NSString* errorType = [failDataDict objectForKey:@"ERROR_TYPE"];
       NSString* errorSubType = [failDataDict objectForKey:@"ERROR_SUB_TYPE"];
       NSString* errorMessage = [failDataDict objectForKey:@"ERROR_MSG"];
       
       if(errorType!=nil && [errorType isEqualToString:@"3"]) {
           if(errorSubType!=nil) {
                
               if([errorSubType isEqualToString:@"3"]) {
                    // session Expired
                    g_DeviceSessionId = nil;
                    // we need to remove all module context
                    NSString* context = [DVAppDelegate currentModuleContext];
                    while(![context isEqualToString:@""]) {
                        [ClientVariable removeInstance: context];
                        [DVAppDelegate popModuleContext];
                        context = [DVAppDelegate currentModuleContext];
                    }
                    if([responseHandler respondsToSelector:@selector(httpServerSessionExpired)]) {
                        [responseHandler httpServerSessionExpired];
                        return;
                    } else {
                        [self defaultSessionExpireHandler];
                        return;
                    }
               } else if([errorSubType isEqualToString:@"13"]) {
                   // maintainenance
                   [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"SERVER_UNDER_MAINTENANCE"];
                   [[NSUserDefaults standardUserDefaults]  synchronize];
                   
                   if([responseHandler respondsToSelector:@selector(httpFailureHandler::)]) {
                       [responseHandler httpFailureHandler:xmwRequestCallname : errorMessage];
                   } else {
                       [self serverUnderMaintenance:errorMessage];
                   }
               }
            } else {
                if(errorMessage!=nil && [errorMessage length]>0) {
                    if([responseHandler respondsToSelector:@selector(httpFailureHandler::)]) {
                        [responseHandler httpFailureHandler:xmwRequestCallname : errorMessage];
                    }
                    return;
                } else {
                    if([responseHandler respondsToSelector:@selector(httpFailureHandler::)]) {
                        [responseHandler httpFailureHandler:xmwRequestCallname : @"Unknown Network Error"];
                    }
                    return;
                }
            }
       } else {
           if(errorMessage!=nil && [errorMessage length]>0) {
               if([responseHandler respondsToSelector:@selector(httpFailureHandler::)]) {
                   [responseHandler httpFailureHandler:xmwRequestCallname : errorMessage];
               }
               return;
           } else {
               if([responseHandler respondsToSelector:@selector(httpFailureHandler::)]) {
                   [responseHandler httpFailureHandler:xmwRequestCallname : @"Unknown Network Error"];
               }
               return;
           }
       }
}

-(void) makeXmwNetworkCall:(id) requestObject :(id <HttpEventListener>) responseListener :(NSString *)in_SessionId :(NSString*) callName
{
    xmwRequestObject = requestObject;
    responseHandler = responseListener;
    xmwRequestCallname = callName;
    sessionId = in_SessionId;
    
    
    JSONNetworkRequestData* nwRequest = [[JSONNetworkRequestData alloc] init];
    nwRequest.requestData = requestObject;
    nwRequest.callName = callName;
    nwRequest.osVersion = [[UIDevice currentDevice] systemVersion];
    
    if(g_DeviceSessionId == nil)
        nwRequest.dServiceId = sessionId;
    else
        nwRequest.dServiceId =  g_DeviceSessionId;
    
    
    id uljsonObj = [JSONDataExchange makeBeanToJSONObect: nwRequest];
    
    SBJsonWriter* jsonWriter = [[SBJsonWriter alloc] init];
    NSString* jsonStr = [jsonWriter stringWithObject: uljsonObj ];
    
    // using our serialized object
    NSString *postData = jsonStr;
    //******************
    
    // NSLog(@"Post Data = %@",postData);
    
    NSString *postDataLength        = [NSString stringWithFormat:@"%d",[postData length]];
    NSURL *url = nil;
    if((self.serviceURLString!=nil) && (self.serviceURLString.length>0)) {
        url = [NSURL URLWithString: self.serviceURLString];
    } else {
        url = [NSURL URLWithString: XmwcsConst_SERVICE_URL];
    }
    
    NSMutableURLRequest *request    = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:postDataLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPShouldHandleCookies:YES];
    
    NSHTTPCookieStorage* cookiesStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    [request setAllHTTPHeaderFields:[NSHTTPCookie requestHeaderFieldsWithCookies:cookiesStorage.cookies]];
    
    // adding custom headers
    if(self.customerHeaders!=nil && [self.customerHeaders isKindOfClass:[NSDictionary class]]) {
        NSArray* headerKeys = self.customerHeaders.allKeys;
        for(NSString* key in headerKeys) {
            [request setValue:[[self.customerHeaders objectForKey:key] copy] forHTTPHeaderField:[key copy]];
        }
    }
    
    NSData *requestData = [NSData dataWithBytes:[postData UTF8String] length:[postData length]];
    
    [request setHTTPBody:requestData];
    
    urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [urlConnection start];
    
}


-(void) registerDevice : (id) requestObject : (id <HttpEventListener>) responseListener : (NSString*) callName
{
    xmwRequestObject = requestObject;
    responseHandler = responseListener;
    xmwRequestCallname = callName;
    
    
    JSONNetworkRequestData* nwRequest = [[JSONNetworkRequestData alloc] init];
    nwRequest.requestData = requestObject;
    nwRequest.callName = callName;
    
    if(g_DeviceSessionId == nil)
        nwRequest.dServiceId = sessionId;
    else
        nwRequest.dServiceId =  g_DeviceSessionId;
    
    
    id uljsonObj = [JSONDataExchange makeBeanToJSONObect: nwRequest];
    
    SBJsonWriter* jsonWriter = [[SBJsonWriter alloc] init];
    NSString* jsonStr = [jsonWriter stringWithObject: uljsonObj ];
    
    NSLog(@"Send Data : %@", jsonStr);
    // using our serialized object
    NSString *postData = jsonStr;
    //******************
    
    NSString *postDataLength        = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSURL *url                      = [NSURL URLWithString: XmwcsConst_SERVICE_URL_NOTIFY_CONTEXT];
    NSMutableURLRequest *request    = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:postDataLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPShouldHandleCookies:YES];
    
    NSHTTPCookieStorage* cookiesStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    [request setAllHTTPHeaderFields:[NSHTTPCookie requestHeaderFieldsWithCookies:cookiesStorage.cookies]];
    
    // adding custom headers
    if(self.customerHeaders!=nil && [self.customerHeaders isKindOfClass:[NSDictionary class]]) {
        NSArray* headerKeys = self.customerHeaders.allKeys;
        for(NSString* key in headerKeys) {
            [request setValue:[[self.customerHeaders objectForKey:key] copy] forHTTPHeaderField:[key copy]];
        }
    }
    
    
    NSData *requestData = [NSData dataWithBytes:[postData UTF8String] length:[postData length]];
    
    [request setHTTPBody:requestData];
    
    urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [urlConnection start];
    
}
-(void) makeXmwNetworkCallForImagePost : (id) requestObject : (id <HttpEventListener>) responseListener : (NSString *)in_SessionId: (NSString*) callName :(NSData *)imageData
{
    
    NSString *formID= [requestObject valueForKey:@"formID"];

    NSString *imageID= [requestObject valueForKey:@"image_id"];
    NSString *imageName= [imageID stringByAppendingString:@".jpg"];
    
    AUTH_TOKEN_VALUE= [[NSUserDefaults standardUserDefaults]valueForKey:@"AUTH_TOKEN"];
    // BASEAPI_URL_RGUSER
    xmwRequestObject = requestObject;
    responseHandler = responseListener;
    xmwRequestCallname = callName;

    NSString *urlString = nil;
   
    if((self.serviceURLString!=nil) && (self.serviceURLString.length>0)) {
        urlString = XmwcsConst_FILE_UPLOAD_URL;
    } else {
        urlString = XmwcsConst_FILE_UPLOAD_URL;
    }
    
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    
    NSDictionary* infoDict = [[NSBundle mainBundle] infoDictionary];
    NSMutableData *body = [NSMutableData data];
    NSString *boundary = [NSString stringWithString:@"---------------------------14737809831466499882746641449"];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
//    [request addValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
  
    
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"file\"; filename=\"%@\"\r\n",imageName] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:@"Content-Type: image/jpeg\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:imageData]];
    [body appendData:[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    // formID parameter
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"formId\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[formID dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    
    
    
    // auth token parameter
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"authToken\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[[NSUserDefaults standardUserDefaults] objectForKey:@"AUTH_TOKEN"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
   
    
    // close form
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSString *jsonResponseStr = [[NSString alloc ] initWithData:[self cleanUTF8 : body] encoding:NSUTF8StringEncoding];
    NSLog(@"%@",jsonResponseStr);
    // set request body
    [request setHTTPBody:body];
    NSString *postDataLength        = [NSString stringWithFormat:@"%lu",(unsigned long)[body length]];
    [request setValue:postDataLength forHTTPHeaderField:@"Content-Length"];
    urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [urlConnection start];
    
    
}


-(void) genericRequestWith:(id) requestObject :(id <HttpEventListener>) responseListener :(NSString*) callName
{
    xmwRequestObject = requestObject;
    responseHandler = responseListener;
    xmwRequestCallname = callName;
    
    JSONNetworkRequestData* nwRequest = [[JSONNetworkRequestData alloc] init];
    nwRequest.requestData = requestObject;
    nwRequest.callName = callName;
    
    if(g_DeviceSessionId == nil)
        nwRequest.dServiceId = sessionId;
    else
        nwRequest.dServiceId =  g_DeviceSessionId;
    
    id uljsonObj = [JSONDataExchange makeBeanToJSONObect: nwRequest];
    
    SBJsonWriter* jsonWriter = [[SBJsonWriter alloc] init];
    NSString* jsonStr = [jsonWriter stringWithObject: uljsonObj ];
    
    NSLog(@"Send Data : %@", jsonStr);
    // using our serialized object
    NSString *postData = jsonStr;
    //******************
    
    NSString *postDataLength        = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
   // NSURL *url                      = [NSURL URLWithString: XmwcsConst_SERVICE_URL_NOTIFY_CONTEXT];
    
    NSURL *url = nil;
    if((self.serviceURLString!=nil) && (self.serviceURLString.length>0)) {
        url = [NSURL URLWithString: self.serviceURLString];
    } else {
        url = [NSURL URLWithString: XmwcsConst_SERVICE_URL_NOTIFY_CONTEXT];
    }
    NSMutableURLRequest *request    = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:postDataLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [request setHTTPShouldHandleCookies:YES];
    
    NSHTTPCookieStorage* cookiesStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    [request setAllHTTPHeaderFields:[NSHTTPCookie requestHeaderFieldsWithCookies:cookiesStorage.cookies]];
    
    // adding custom headers
    if(self.customerHeaders!=nil && [self.customerHeaders isKindOfClass:[NSDictionary class]]) {
        NSArray* headerKeys = self.customerHeaders.allKeys;
        for(NSString* key in headerKeys) {
            [request setValue:[[self.customerHeaders objectForKey:key] copy] forHTTPHeaderField:[key copy]];
        }
    }
    
    
    NSData *requestData = [NSData dataWithBytes:[postData UTF8String] length:[postData length]];
    
    [request setHTTPBody:requestData];
    
    urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [urlConnection start];
    
}



-(void) genericJSONPayloadRequestWith:(id) requestObject :(id <HttpEventListener>) responseListener :(NSString*) callName
{
    xmwRequestObject = requestObject;
    responseHandler = responseListener;
    xmwRequestCallname = callName;
    

    SBJsonWriter* jsonWriter = [[SBJsonWriter alloc] init];
    NSString* jsonStr = [jsonWriter stringWithObject: xmwRequestObject ];
    
    NSLog(@"Send Data : %@", jsonStr);
    // using our serialized object
    NSString *postData = jsonStr;
    //******************
    
    NSString *postDataLength        = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    // NSURL *url                      = [NSURL URLWithString: XmwcsConst_SERVICE_URL_NOTIFY_CONTEXT];
    
    NSURL *url = nil;
    if((self.serviceURLString!=nil) && (self.serviceURLString.length>0)) {
        url = [NSURL URLWithString: self.serviceURLString];
    } else {
        url = [NSURL URLWithString: XmwcsConst_SERVICE_URL_NOTIFY_CONTEXT];
    }
    NSMutableURLRequest *request    = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:postDataLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [request setHTTPShouldHandleCookies:YES];
    
    NSHTTPCookieStorage* cookiesStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    [request setAllHTTPHeaderFields:[NSHTTPCookie requestHeaderFieldsWithCookies:cookiesStorage.cookies]];
    
    // adding custom headers
    if(self.customerHeaders!=nil && [self.customerHeaders isKindOfClass:[NSDictionary class]]) {
        NSArray* headerKeys = self.customerHeaders.allKeys;
        for(NSString* key in headerKeys) {
            [request setValue:[[self.customerHeaders objectForKey:key] copy] forHTTPHeaderField:[key copy]];
        }
    }
    
//    NSData *requestData = [NSData dataWithBytes:[postData UTF8String] length:[postData length]];
    NSData *requestData = [postData dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:requestData];
    
    urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [urlConnection start];
}


-(void) versionCheck:(id) requestObject :(id <HttpEventListener>) responseListener :(NSString*) callName
{
    xmwRequestObject = requestObject;
    responseHandler = responseListener;
    xmwRequestCallname = callName;
    
    sessionId = @"";
    
    
    JSONNetworkRequestData* nwRequest = [[JSONNetworkRequestData alloc] init];
    nwRequest.requestData = requestObject;
    nwRequest.callName = callName;
    
    if(g_DeviceSessionId == nil || [g_DeviceSessionId length]==0)
        nwRequest.dServiceId = sessionId;
    else
        nwRequest.dServiceId =  g_DeviceSessionId;
    
    
    id uljsonObj = [JSONDataExchange makeBeanToJSONObect: nwRequest];
    
    SBJsonWriter* jsonWriter = [[SBJsonWriter alloc] init];
    NSString* jsonStr = [jsonWriter stringWithObject: uljsonObj ];
    
    NSLog(@"Send Data : %@", jsonStr);
    // using our serialized object
    NSString *postData = jsonStr;
    //******************
    
    NSString *postDataLength        = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSURL *url                      = [NSURL URLWithString: XmwcsConst_SERVICE_URL_APP_CONTROL];
    NSMutableURLRequest *request    = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:postDataLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [request setHTTPShouldHandleCookies:YES];
    
    NSHTTPCookieStorage* cookiesStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    [request setAllHTTPHeaderFields:[NSHTTPCookie requestHeaderFieldsWithCookies:cookiesStorage.cookies]];
    
    // adding custom headers
    if(self.customerHeaders!=nil && [self.customerHeaders isKindOfClass:[NSDictionary class]]) {
        NSArray* headerKeys = self.customerHeaders.allKeys;
        for(NSString* key in headerKeys) {
            [request setValue:[[self.customerHeaders objectForKey:key] copy] forHTTPHeaderField:[key copy]];
        }
    }
    
    NSData *requestData = [NSData dataWithBytes:[postData UTF8String] length:[postData length]];
    
    [request setHTTPBody:requestData];
    
    urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [urlConnection start];
    
}


- (NSData *)cleanUTF8:(NSData *)data {
    iconv_t cd = iconv_open("UTF-8", "UTF-8"); // convert to UTF-8 from UTF-8
    int one = 1;
    iconvctl(cd, ICONV_SET_DISCARD_ILSEQ, &one); // discard invalid characters
    
    size_t inbytesleft, outbytesleft;
    inbytesleft = outbytesleft = data.length;
    char *inbuf  = (char *)data.bytes;
    char *outbuf = malloc(sizeof(char) * data.length);
    char *outptr = outbuf;
    if (iconv(cd, &inbuf, &inbytesleft, &outptr, &outbytesleft)
        == (size_t)-1) {
        NSLog(@"this should not happen, seriously");
        return nil;
    }
    NSData *result = [NSData dataWithBytes:outbuf length:data.length - outbytesleft];
    iconv_close(cd);
    free(outbuf);
    return result;
}


-(void) resetDeviceSessionId
{
    g_DeviceSessionId = nil;
}

-(void) defaultSessionExpireHandler
{
//    g_DeviceSessionId = nil;
     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Your Session expired, Please login again !" preferredStyle:UIAlertControllerStyleAlert];
     
     UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * action)
                                                         {
                                                            LogInVC *vc = [[LogInVC alloc] initWithNibName:@"LogInVC" bundle:nil];
                                                  vc.password.text = @"";
                                                                                               UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
                                                                                               [UIApplication.sharedApplication.keyWindow setRootViewController:nav];
                                                               
                                                         }];
     
     [alertController addAction:defaultAction];
     
     
      UIViewController* root = [[[[UIApplication sharedApplication]windows]objectAtIndex:0] rootViewController];
             UIViewController *assignViewController = nil;
             
             if ([root isKindOfClass:[SWRevealViewController class]]) {
                         SWRevealViewController *reveal = (SWRevealViewController*)root;
                         UINavigationController *check =(UINavigationController*)reveal.frontViewController;
                         NSArray* viewsList = check.viewControllers;
                         UIViewController *checkView = (UIViewController *) [viewsList objectAtIndex:viewsList.count - 1];
                 assignViewController = checkView;
             }
             else
             {
                 assignViewController = root;
             }
             
             [assignViewController presentViewController:alertController animated:YES completion:nil];
}



-(void) serverUnderMaintenance:(NSString*) message
{
//    g_DeviceSessionId = nil;
     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
     
     UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * action)
                         {
                            LogInVC *vc = [[LogInVC alloc] initWithNibName:@"LogInVC" bundle:nil];
                            vc.password.text = @"";
         
                            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
                            [UIApplication.sharedApplication.keyWindow setRootViewController:nav];
                         }];
     
     [alertController addAction:defaultAction];
     
     
      UIViewController* root = [[[[UIApplication sharedApplication]windows]objectAtIndex:0] rootViewController];
             UIViewController *assignViewController = nil;
             
             if ([root isKindOfClass:[SWRevealViewController class]]) {
                         SWRevealViewController *reveal = (SWRevealViewController*)root;
                         UINavigationController *check =(UINavigationController*)reveal.frontViewController;
                         NSArray* viewsList = check.viewControllers;
                         UIViewController *checkView = (UIViewController *) [viewsList objectAtIndex:viewsList.count - 1];
                 assignViewController = checkView;
             }
             else
             {
                 assignViewController = root;
             }
             
             [assignViewController presentViewController:alertController animated:YES completion:nil];
}

+ (NSData *)cleanUTF8:(NSData *)data {
    iconv_t cd = iconv_open("UTF-8", "UTF-8"); // convert to UTF-8 from UTF-8
    int one = 1;
    iconvctl(cd, ICONV_SET_DISCARD_ILSEQ, &one); // discard invalid characters
    
    size_t inbytesleft, outbytesleft;
    inbytesleft = outbytesleft = data.length;
    char *inbuf  = (char *)data.bytes;
    char *outbuf = malloc(sizeof(char) * data.length);
    char *outptr = outbuf;
    if (iconv(cd, &inbuf, &inbytesleft, &outptr, &outbytesleft)
        == (size_t)-1) {
        NSLog(@"this should not happen, seriously");
        return nil;
    }
    NSData *result = [NSData dataWithBytes:outbuf length:data.length - outbytesleft];
    iconv_close(cd);
    free(outbuf);
    return result;
}


- (void)makeXmwNetworkCallForDocumentPost:(id)requestObject :(id<HttpEventListener>)responseListener :(NSString *)in_SessionId :(NSString *)callName :(NSData *)imageData
{
    
    NSString *formID= [requestObject valueForKey:@"formID"];

    NSString *imageID= [requestObject valueForKey:@"image_id"];
//    NSString *imageName= [imageID stringByAppendingString:@".jpg"];
     NSString *imageName= imageID;
    
    AUTH_TOKEN_VALUE= [[NSUserDefaults standardUserDefaults]valueForKey:@"AUTH_TOKEN"];
    // BASEAPI_URL_RGUSER
    xmwRequestObject = requestObject;
    responseHandler = responseListener;
    xmwRequestCallname = callName;

    NSString *urlString = nil;
   
    if((self.serviceURLString!=nil) && (self.serviceURLString.length>0)) {
        urlString = XmwcsConst_FILE_UPLOAD_URL;
    } else {
        urlString = XmwcsConst_FILE_UPLOAD_URL;
    }
    
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    
    NSDictionary* infoDict = [[NSBundle mainBundle] infoDictionary];
    NSMutableData *body = [NSMutableData data];
    NSString *boundary = [NSString stringWithString:@"---------------------------14737809831466499882746641449"];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
//    [request addValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
  
    
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"file\"; filename=\"%@\"\r\n",imageName] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:@"Content-Type: image/jpeg\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:imageData]];
    [body appendData:[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    // formID parameter
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"formId\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[formID dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    
    
    
    // auth token parameter
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"authToken\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[[NSUserDefaults standardUserDefaults] objectForKey:@"AUTH_TOKEN"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
   
    
    // close form
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSString *jsonResponseStr = [[NSString alloc ] initWithData:[self cleanUTF8 : body] encoding:NSUTF8StringEncoding];
    NSLog(@"%@",jsonResponseStr);
    // set request body
    [request setHTTPBody:body];
    NSString *postDataLength        = [NSString stringWithFormat:@"%lu",(unsigned long)[body length]];
    [request setValue:postDataLength forHTTPHeaderField:@"Content-Length"];
    urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [urlConnection start];
    
    
}
@end

