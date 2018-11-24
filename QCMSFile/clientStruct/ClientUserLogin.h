//
//  ClientUserLogin.h
//  QCMProjectOnOBJC
//
//  Created by Ashish Tiwari on 09/05/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../Network/JSONStructure.h"

// jsonStructureId = 1

@interface ClientUserLogin : NSObject <JSONStructure>
{
    
    @private
        int jsonStructureId;
        NSString* userName;
        NSString* password;
        NSString* moduleId;
        NSMutableDictionary* roleXmlCacheDate;
        NSString* language;
        NSMutableDictionary* deviceInfoMap;
    //There should be information like Device Pin(DEVICE_PIN)
    
}

@property NSString* userName;
@property NSString* password;
@property NSString* moduleId;
@property NSMutableDictionary* roleXmlCacheDate;
@property NSString* language;
@property NSMutableDictionary* deviceInfoMap;



@end

