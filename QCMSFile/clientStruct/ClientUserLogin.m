//
//  ClientUserLogin.m
//  QCMProjectOnOBJC
//
//  Created by Ashish Tiwari on 09/05/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//  Purpose      :this is structure class for the User Login which Contain Login Detail and Add Device Info map for much and tracking device
//---------------------------------------------------------------

#import <Foundation/Foundation.h>
#import "JSONStructureConstant.h"
#import "ClientUserLogin.h"
#import "JSONDataExchange.h"
#import "CustomerClaimInvoiceFetchDetailsVC.h"




@implementation ClientUserLogin


@synthesize userName;
@synthesize password;
@synthesize moduleId;
@synthesize roleXmlCacheDate;
@synthesize language;
@synthesize deviceInfoMap;


- (id)init {
    if (self = [super init])
    {
        self.userName = @"";
        self.password = @"";
        self.moduleId = @"IND_1";
        self.language = @"en";
        self.roleXmlCacheDate = [[NSMutableDictionary alloc] init];
        self.deviceInfoMap = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (id) toJSON {
   @try {
    NSMutableDictionary* jsonObject = [[NSMutableDictionary alloc] init];
    [jsonObject setObject:userName forKey:JsonStrucConst_USER_NAME];
    [jsonObject setObject:password forKey:JsonStrucConst_PASSWORD];
    [jsonObject setObject:moduleId forKey:JsonStrucConst_MODULE_ID];
    [jsonObject setObject:language forKey:JsonStrucConst_LANGUAGE];
    [jsonObject setObject:[JSONDataExchange convertDSToJSONObject :roleXmlCacheDate] forKey:JsonStrucConst_ROLE_XML_CACHE_DATE];
    [jsonObject setObject:[JSONDataExchange convertDSToJSONObject :deviceInfoMap] forKey:JsonStrucConst_DEVICE_INFO_MAP];
    
  // [jsonObject setObject:[JSONDataExchange convertDSToJSONObject : roleXmlCacheDate] forKey:roleXmlCacheDate];
   //  [jsonObject setObject:[JSONDataExchange convertDSToJSONObject : deviceInfoMap] forKey:deviceInfoMap];
    return (jsonObject);
    }
    @catch(NSException* nse)
    {
        NSLog(@"Exception: %@", nse);
    }
    
    return nil;
}

- (int) getJsonStructureId {
    jsonStructureId = 1;
    return jsonStructureId;
}

- (id) toBean:(id) jsonObject {

    ClientUserLogin* myself  = [[ClientUserLogin alloc] init];
     
    myself.userName = (NSString*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_USER_NAME : true];
    myself.password = (NSString*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_PASSWORD : true];
    myself.moduleId = (NSString*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_MODULE_ID : true];
    myself.language = (NSString*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_LANGUAGE : true];
    myself.roleXmlCacheDate = (NSMutableDictionary*) [JSONDataExchange toBeanObject : jsonObject :JsonStrucConst_ROLE_XML_CACHE_DATE : false];
    myself.deviceInfoMap = (NSMutableDictionary*) [JSONDataExchange toBeanObject : jsonObject :JsonStrucConst_DEVICE_INFO_MAP : false];

    
    return myself;
}


@end
