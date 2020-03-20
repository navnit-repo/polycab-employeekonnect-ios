//
//  ClientMasterDetail.m
//  QCMSProject
//
//  Created by Pradeep Singh on 5/21/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "JSONStructureConstant.h"
#import "JSONDataExchange.h"
#import "ClientMasterDetail.h"


@implementation ClientMasterDetail



@synthesize masterUpdateDetail;
//user master data which are refresh every time when use login
@synthesize masterDataRefresh;
@synthesize masterData;
@synthesize dotClientXmlMeta;

- (id)init {
    if (self = [super init])
    {
        self.masterDataRefresh = [[NSMutableDictionary alloc] init];
        self.masterData = [[NSMutableDictionary alloc] init];
        self.masterUpdateDetail = [[NSMutableDictionary alloc] init];
    }
    return self;
}


- (id) toJSON {
    NSMutableDictionary* jsonObject = [[NSMutableDictionary alloc] init];
    
  
    
    @try {
       
        [jsonObject setObject:[JSONDataExchange convertDSToJSONObject : masterUpdateDetail] forKey:JsonStrucConst_MODULE_UPDATE_DETAIL];
          [jsonObject setObject:[JSONDataExchange convertDSToJSONObject : masterDataRefresh] forKey:JsonStrucConst_MASTER_DATA_REFRESH];
        
          [jsonObject setObject:[JSONDataExchange convertDSToJSONObject : masterData] forKey:JsonStrucConst_MASTER_DATA];
        [jsonObject setObject:[JSONDataExchange convertDSToJSONObject : dotClientXmlMeta] forKey:JsonStrucConst_DOT_CLIENT_XML_DATA];
            return jsonObject;
    }
    @catch (NSException* nse) {
        NSLog(@"Exception: %@", nse);

    }
    return nil;
    
     
    
    
    
}

- (int) getJsonStructureId {
    jsonStructureId = 3;
    return jsonStructureId;
}

- (id) toBean:(id) jsonObject {
    
    ClientMasterDetail* myself  = [[ClientMasterDetail alloc] init];
    
    
    myself.masterUpdateDetail = (NSMutableDictionary*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_MODULE_UPDATE_DETAIL : false];
    myself.masterDataRefresh = (NSMutableDictionary*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_MASTER_DATA_REFRESH : false];
    myself.masterData = (NSMutableDictionary*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_MASTER_DATA : false];
    myself.dotClientXmlMeta = (DotClientXmlMeta*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_DOT_CLIENT_XML_DATA : false];
       return myself;
    
}
  
@end
