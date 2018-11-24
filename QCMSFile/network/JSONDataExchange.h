//
//  JSONDataExchange.h
//  QCMSProject
//
//  Created by Ashish Tiwari on 20/05/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//

#ifndef __QCMSProject__JSONDataExchange__
#define __QCMSProject__JSONDataExchange__

#import <Foundation/Foundation.h>
#import "JSONStructure.h"

/*
 For details refer to java me / blackberry / android implementation
 */
@interface JSONDataExchange : NSObject
{
    
}

+(NSMutableDictionary*) getJsonStructures;


+(void) registerJsonStructures : (int) typeId : (id <JSONStructure>) handler;
+ (id) convertFromJsonObject : (NSMutableDictionary*) jsonObject;
+(NSMutableArray*) convertJSONArrayToArrayList: (NSMutableDictionary*) jsonObject;
+(NSMutableDictionary*) convertJsonObjectToHashMap : (NSMutableDictionary*) jsonObject;
+(NSMutableDictionary*) convertDSToJSONObject: (id) objectToConvertInJSONObject;
+ (id) toBeanObject: (NSMutableDictionary*) object : (NSString*) key :(Boolean) isReturnDirectObject;
+ (id) convertHashMapToJSONObject: (NSMutableDictionary*) mapToConvert;
+ (id) convertPrimitiveObjectToJSONObject: (id)requiredStrValue : (int)objectId;
+ (id) convertListToJSONObject: (NSMutableArray*) requiredListObject;
+ (id) makeBeanToJSONObect: (id<JSONStructure>) jsonStructure;


@end



#endif /* defined(__QCMSProject__JSONDataExchange__) */
