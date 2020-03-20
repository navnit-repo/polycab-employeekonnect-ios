//
//  UpdateAppVersion.m
//  QCMSProject
//
//  Created by Pradeep Singh on 4/22/14.
//  Copyright (c) 2014 dotvik. All rights reserved.
//

#import "UpdateAppVersion.h"
#import "../Network/JSONStructure.h"
#import "JSONStructureConstant.h"
#import "JSONDataExchange.h"

@implementation UpdateAppVersion 

@synthesize minorVersion;
@synthesize majorVersion;
@synthesize forceUpdate;
@synthesize downloadUrl;


- (id) toJSON {
    
    NSMutableDictionary* jsonObject = [[NSMutableDictionary alloc] init];
    @try
    {
        [jsonObject setObject:minorVersion forKey:JsonStrucConst_APP_UPDATE_MINOR_VERSION];
        [jsonObject setObject:majorVersion forKey:JsonStrucConst_APP_UPDATE_MAJOR_VERSION];
        [jsonObject setObject:forceUpdate forKey:JsonStrucConst_APP_UPDATE_FORCE];
        [jsonObject setObject:downloadUrl forKey:JsonStrucConst_APP_UPDATE_APP_DOWNLOAD_URL];
    }
    @catch (NSException* nse)
    {
        NSLog(@"Exception: %@", nse);
    }
    return jsonObject;
}

- (int) getJsonStructureId {
    jsonStructureId = 200;
    return jsonStructureId;
}


- (id) toBean:(id) jsonObject {
    UpdateAppVersion* myself = [[UpdateAppVersion alloc] init];
    
    myself.minorVersion = (NSNumber*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_APP_UPDATE_MINOR_VERSION :true];
    myself.majorVersion = (NSNumber*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_APP_UPDATE_MAJOR_VERSION :true];
    myself.forceUpdate = (NSNumber*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_APP_UPDATE_FORCE :true];
    myself.downloadUrl = (NSString*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_APP_UPDATE_APP_DOWNLOAD_URL :true];
    
    return myself;
}


@end
