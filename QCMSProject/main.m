//
//  main.m
//  QCMSProject
//
//  Created by Ashish Tiwari on 20/05/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBJson.h"
#import "ClientUserLogin.h"
#import "JSONNetworkRequestData.h"
#import "XmwcsConstant.h"
#import "JSONDataExchange.h"

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        
        // insert code here...
        NSLog(@"Hello, World!");
        ClientUserLogin* userLogin = [[ClientUserLogin alloc] init];
        userLogin.userName = @"hapharzd";
        userLogin.password = @"sarah987";
        
        
        JSONNetworkRequestData* nwRequest = [[JSONNetworkRequestData alloc] init];
        nwRequest.requestData = userLogin;
        nwRequest.callName = XmwcsConst_CALL_NAME_FOR_LOGIN;
        nwRequest.dServiceId = @"98123456";
        
        id uljsonObj = [JSONDataExchange makeBeanToJSONObect: nwRequest];
        
        SBJsonWriter* jsonWriter = [[SBJsonWriter alloc] init];
        NSString* jsonStr = [jsonWriter stringWithObject: uljsonObj ];
        
        NSLog(@"JSONString: %@", jsonStr);
        NSLog(@"Length: %ld", [jsonStr length]);
        
        SBJsonParser* sbParser = [[SBJsonParser alloc] init];
        id parsedJsonResponseObject = [sbParser objectWithString :jsonStr];
        
        JSONNetworkRequestData* responseData = [JSONDataExchange convertFromJsonObject:parsedJsonResponseObject];
        
        NSLog(@"Hello, i got it %@", responseData.status);

    }
    return 0;
}

