
//
//  Created by Pradeep Singh on 5/21/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//

#import "JSONNetworkRequestData.h"
#import "NetworkConstant.h"
#import "JSONDataExchange.h"

@implementation JSONNetworkRequestData


@synthesize callName;
@synthesize dServiceId;
@synthesize requestData;
@synthesize responseData;
@synthesize status;
@synthesize message;
@synthesize osVersion;

- (id) toJSON {
    NSMutableDictionary* jsonObject = [[NSMutableDictionary alloc] init];
    
    @try
    {
        [jsonObject setObject:dServiceId forKey:NtwkConst_DSERVICE_ID];
        
        [jsonObject setObject:callName forKey:NtwkConst_CALL_NAME];
        if(requestData!=nil) {
            [jsonObject setObject:[JSONDataExchange convertDSToJSONObject:requestData] forKey:NtwkConst_REQUEST_DATA];
        }
        if(responseData!=nil) {
            [jsonObject setObject:[JSONDataExchange convertDSToJSONObject:responseData] forKey:NtwkConst_RESPONSE_DATA];
        }
        if(status!=nil) {
            [jsonObject setObject:status forKey:NtwkConst_STATUS];
        }
        if(message!=nil) {
            [jsonObject setObject:message forKey:NtwkConst_MESSAGE];
        }
        if(osVersion!=nil) {
            [jsonObject setObject:osVersion forKey:NtwkConst_OSVERSION];
        }
        return jsonObject;
    }
    @catch (NSException* nse) {
        
    }
    return (jsonObject);
    
}

- (int) getJsonStructureId {
    jsonStructureId = 0;
    return jsonStructureId;
}

- (id) toBean:(id) jsonObject {
    
    JSONNetworkRequestData* myself  = [[JSONNetworkRequestData alloc] init];
    
    myself.dServiceId = (NSString*) [JSONDataExchange toBeanObject :jsonObject :NtwkConst_DSERVICE_ID :true];
    myself.callName = (NSString*) [JSONDataExchange toBeanObject :jsonObject  :NtwkConst_CALL_NAME  :true];
    myself.requestData = [JSONDataExchange toBeanObject :jsonObject :NtwkConst_REQUEST_DATA :false];
    myself.responseData = [JSONDataExchange toBeanObject :jsonObject :NtwkConst_RESPONSE_DATA :false];
    myself.status = (NSString*) [JSONDataExchange toBeanObject :jsonObject :NtwkConst_STATUS :true];
    myself.message = (NSString*) [JSONDataExchange toBeanObject :jsonObject :NtwkConst_MESSAGE :true];
    
    
    return myself;
}

@end
