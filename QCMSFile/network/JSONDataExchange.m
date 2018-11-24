//
//  JSONDataExchange.cpp
//  QCMSProject
//
//  Created by Ashish Tiwari on 20/05/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//

#import "JSONDataExchange.h"
#import "JSONStructure.h"
#import "NetworkConstant.h"
#import "JSONNetworkRequestData.h"
#import "ClientUserLogin.h"
#import "ClientLoginResponse.h"
#import "ClientMasterDetail.h"
#import "DotFormPost.h"
#import "ReportPostResponse.h"
#import "DocPostResponse.h"
#import "DocFormPostOfflineProcessing.h"
#import "DotForm.h"
#import "DotFormElement.h"
#import "DotReport.h"
#import "DotReportElement.h"
#import "SearchResponse.h"
#import "CommonRequestStruct.h"
#import "UpdateAppVersion.h"
#import "DotNotificationSend.h"
#import "NotificationDeviceRegister.h"
#import "CategoryResponse.h"
#import "ProductResponse.h"


static NSMutableDictionary* jsonStructures = nil;

@implementation JSONDataExchange

+ (void) initialize {
    if(jsonStructures == nil) {
        jsonStructures = [ [NSMutableDictionary alloc] init];
        
        
        [JSONDataExchange registerJsonStructures :0 : [[JSONNetworkRequestData alloc] init ]];
        [JSONDataExchange registerJsonStructures :1 : [[ClientUserLogin alloc] init ]];
        [JSONDataExchange registerJsonStructures :2 : [[ClientLoginResponse alloc] init ]];
        [JSONDataExchange registerJsonStructures :3 : [[ClientMasterDetail alloc] init ]];
        [JSONDataExchange registerJsonStructures :4 : [[DotFormPost alloc] init ]];
        [JSONDataExchange registerJsonStructures :5 : [[ReportPostResponse alloc] init ]];
        [JSONDataExchange registerJsonStructures :6 : [[DocPostResponse alloc] init ]];
        [JSONDataExchange registerJsonStructures :7 : [[DocFormPostOfflineProcessing alloc] init ]];
        [JSONDataExchange registerJsonStructures :8 : [[DotClientXmlMeta alloc] init ]];
        [JSONDataExchange registerJsonStructures :9 : [[SearchResponse alloc] init ]];
        [JSONDataExchange registerJsonStructures :10 : [[CommonRequestStruct alloc] init ]];
        
            //JSONDataExchange.registerJsonStructures(101, new DotFormMeta());
        [JSONDataExchange registerJsonStructures :102 : [[DotForm alloc] init ]];
        [JSONDataExchange registerJsonStructures :103 : [[DotFormElement alloc] init ]];
            //	JSONDataExchange.registerJsonStructures(104,new DotReportMeta());
        [JSONDataExchange registerJsonStructures :105 : [[DotReport alloc] init ]];
        [JSONDataExchange registerJsonStructures :106 : [[DotReportElement alloc] init ]];
        
        
        
        [JSONDataExchange registerJsonStructures :200 : [[UpdateAppVersion alloc] init ]];
        [JSONDataExchange registerJsonStructures :300 : [[NotificationDeviceRegister alloc] init ]];
        [JSONDataExchange registerJsonStructures :301 : [[DotNotificationSend alloc] init ]];
        [JSONDataExchange registerJsonStructures :302 : [[CategoryResponse alloc] init ]];
        [JSONDataExchange registerJsonStructures :303 : [[ProductResponse alloc] init ]];
        
        
    }
    
}

+(NSMutableDictionary*) getJsonStructures {
    return jsonStructures;
}


+(void) registerJsonStructures : (int) typeId :(id <JSONStructure>) handler {
    NSNumber* key = [NSNumber numberWithInt:typeId];
    
    [jsonStructures setObject:handler forKey:key];
}


+ (id) convertFromJsonObject : (NSMutableDictionary*) jsonObject {
    //   System.out.println("jsonObject:====>"+jsonObject);
     @try {
         id obj = [jsonObject  objectForKey: NtwkConst_OBJECT_ID];
         
         if(obj!=nil) {
             NSNumber* objectId = (NSNumber*) obj;
             if(objectId.intValue == NtwkConst_OBJECT_ID_INTEGER)
             {
                 
                 return[jsonObject  objectForKey: NtwkConst_OBJECT_DATA];
                                   
             }
             else if(objectId.intValue == NtwkConst_OBJECT_ID_STRING)
             {
                 
                return[jsonObject  objectForKey: NtwkConst_OBJECT_DATA]; 
             }
             else if(objectId.intValue == NtwkConst_OBJECT_ID_FLOAT)
             {
                 return[jsonObject  objectForKey: NtwkConst_OBJECT_DATA];
             }
            /* else if(objectId.intValue == NtwkConst_OBJECT_ID_BOOLEAN)
             {
                  return[jsonObject  objectForKey: NtwkConst_OBJECT_DATA];
             }*/
             else if(objectId.intValue == NtwkConst_OBJECT_ID_ARRAY_LIST)
             {
                 
                 return [JSONDataExchange convertJSONArrayToArrayList: jsonObject];
                 
                 
             }
             else if (objectId.intValue == NtwkConst_OBJECT_ID_HASH_MAP)
             {
                 
                 return [JSONDataExchange convertJsonObjectToHashMap: jsonObject];
                 
             }
             else if (objectId.intValue == NtwkConst_OBJECT_ID_JSONSTRUCTURE)
             {
                NSString* typeId = (NSString*)[jsonObject  objectForKey: NtwkConst_JSON_STRUCTURE_ID];
                 
                 id <JSONStructure> handler = [jsonStructures  objectForKey: typeId];
                 NSMutableDictionary* structureObject = [jsonObject  objectForKey: NtwkConst_OBJECT_DATA];
                 
                 return [handler toBean:structureObject];
             }
             
         }
         else
         {
             return jsonObject;
         }
     }
    @catch (NSException* nse) {
        NSLog(@"Exception: %@", nse);
    }
    @finally {
        NSLog(@"finally");
    }
    return nil;
}


+(NSMutableArray*) convertJSONArrayToArrayList: (NSMutableDictionary*) jsonObject
{
 
    @try {
         NSMutableArray* jsonArrayToVector = [ [NSMutableArray alloc] init];
        NSMutableArray* arrayOfReq = [jsonObject  objectForKey: NtwkConst_OBJECT_DATA];
          for(int cntJsonArray = 0; cntJsonArray < [arrayOfReq count]; cntJsonArray++)
          {
              id objectOnVec = (id)[arrayOfReq objectAtIndex:cntJsonArray];
              if([objectOnVec isKindOfClass: [NSMutableDictionary class]])
              {
                [jsonArrayToVector addObject:[self convertFromJsonObject:objectOnVec]];
                  
              }
              else
              {
                  [jsonArrayToVector addObject : objectOnVec];
              }
          }
        
        return jsonArrayToVector;
              // return [jsonObject  objectForKey: arrayOfReq]];
    }
    @catch (NSException* nse) {
        NSLog(@"Exception: %@", nse);
    }
    return nil;
    
    
}


+(NSMutableDictionary*) convertJsonObjectToHashMap : (NSMutableDictionary*) jsonObject
{
    @try {
        NSMutableDictionary* jsonObjectData = [jsonObject objectForKey: NtwkConst_OBJECT_DATA];
       
        //Enumeration keyEnumJsonObject = jsonObjectData.keys();
        NSArray*  keys     =     [jsonObjectData allKeys];
        
        NSMutableDictionary* map = [[NSMutableDictionary alloc] init];
        for (int i=0; i<[keys count]; i++)
        {
         
            NSString *objKey = [keys objectAtIndex:i];
        
      // if(jsonObjectData.get(objectKey) instanceof JSONObject)
            id tObj = [jsonObjectData objectForKey: objKey ];
            
            if ([tObj isKindOfClass:[NSMutableDictionary class]]) {
               // [jsonObject setObject:objKey forKey:[jsonObjectData objectForKey: objKey]];
                // [JSONDataExchange convertFromJsonObject : tObj ];
                [map  setObject:[JSONDataExchange convertFromJsonObject : tObj] forKey : objKey];
            } else {
                [map  setObject:tObj forKey : objKey];
            }
            
        }
        return map;
    }
    @catch (NSException* nse) {
        NSLog(@"Exception: %@", nse);    }
    return nil;
    
      
}


+(NSMutableDictionary*) convertDSToJSONObject: (id) objectToConvertInJSONObject
{
    if(objectToConvertInJSONObject == nil)
        return nil;
    
    if ([objectToConvertInJSONObject conformsToProtocol:@protocol(JSONStructure)]) {
        id<JSONStructure> jsonStructure = objectToConvertInJSONObject;
        return [JSONDataExchange makeBeanToJSONObect :jsonStructure ];
    }
    
    if ([objectToConvertInJSONObject isKindOfClass:[NSMutableDictionary class]])
    {
        
        return [JSONDataExchange convertHashMapToJSONObject : objectToConvertInJSONObject];
        
    } else if([objectToConvertInJSONObject isKindOfClass:[NSString class]]) {
        
        return [JSONDataExchange convertPrimitiveObjectToJSONObject : objectToConvertInJSONObject : NtwkConst_OBJECT_ID_STRING];
        
    } else  if([objectToConvertInJSONObject isKindOfClass:[NSNumber class]]) {
        NSNumber* numberObj = (NSNumber*) objectToConvertInJSONObject;
        
        
        if(strcmp(numberObj.objCType, @encode(float)) == 0) {  // // for float
               return [JSONDataExchange convertPrimitiveObjectToJSONObject : objectToConvertInJSONObject : NtwkConst_OBJECT_ID_FLOAT];
            
        } else if(strcmp(numberObj.objCType, @encode(int)) == 0) {  // for int
            return [JSONDataExchange convertPrimitiveObjectToJSONObject : objectToConvertInJSONObject : NtwkConst_OBJECT_ID_INTEGER];
        } else if(strcmp(numberObj.objCType, @encode(Boolean)) == 0) {  // for boolean
            return [JSONDataExchange convertPrimitiveObjectToJSONObject : objectToConvertInJSONObject : NtwkConst_OBJECT_ID_BOOLEAN];
        }
    } else if([objectToConvertInJSONObject isKindOfClass:[NSMutableArray class]]) {
        return [JSONDataExchange convertListToJSONObject : (NSMutableArray*) objectToConvertInJSONObject ];
    }
    
    return nil;
}


+ (id) toBeanObject: (NSMutableDictionary*) object : (NSString*) key :(Boolean) isReturnDirectObject {
    
    @try
    {
        id objectFromKey = [object objectForKey : key];
        if(objectFromKey != nil){
            if(isReturnDirectObject)
                return objectFromKey;
            else
                return [JSONDataExchange convertFromJsonObject : objectFromKey];
        }else
            return nil;
    }
    @catch(NSException* nse){
         NSLog(@"Exception: %@", nse);
    }

    return nil;
}


+ (id) convertHashMapToJSONObject : (NSMutableDictionary*) mapToConvert {
    
    @try
    {
        NSMutableDictionary* jsonObjectMap = [[NSMutableDictionary alloc] init];
        
        NSNumber* objectIdHashMap = [[NSNumber alloc] initWithInt:NtwkConst_OBJECT_ID_HASH_MAP];
        [jsonObjectMap setObject:objectIdHashMap forKey:NtwkConst_OBJECT_ID];
        
    
        NSMutableDictionary* innerJSONObject = [[NSMutableDictionary alloc] init];
        
        NSArray*  keys     =     [mapToConvert allKeys];
        
        for (int i=0; i<[keys count]; i++)
        {
            
            NSString *objKey = [keys objectAtIndex:i];
            
            // if(jsonObjectData.get(objectKey) instanceof JSONObject)
            id tObj = [mapToConvert objectForKey: objKey ];
            
            if ([tObj conformsToProtocol:@protocol(JSONStructure)]) {
                
                [innerJSONObject setObject:[JSONDataExchange convertDSToJSONObject : tObj] forKey: objKey];
                
            } else {
                if ([tObj isKindOfClass:[NSMutableDictionary class]]) {
                    
                    [innerJSONObject setObject:[JSONDataExchange convertDSToJSONObject : tObj] forKey: objKey];
                    
                   // innerJSONObject.put(keyMap,convertDSToJSONObject(mapToConvert.get(keyMap)));
                } else {
                    [innerJSONObject setObject:tObj forKey: objKey];
                }
            }
        }
        
        [jsonObjectMap setObject:innerJSONObject forKey: NtwkConst_OBJECT_DATA];
        
        return jsonObjectMap;
    }
    @catch(NSException* nse){
        NSLog(@"Exception: %@", nse);
    }
    
    return nil;
}


+ (id) convertPrimitiveObjectToJSONObject: (id)requiredStrValue : (int)objectId
{
    @try
    {
        NSMutableDictionary* jsonObjectStr = [[NSMutableDictionary alloc] init];
        NSNumber* objectIdHashMap = [[NSNumber alloc] initWithInt:objectId];
       [jsonObjectStr setObject:objectIdHashMap forKey:NtwkConst_OBJECT_ID ];
       [jsonObjectStr setObject:requiredStrValue forKey:NtwkConst_OBJECT_DATA ];
        return jsonObjectStr;
    }
    @catch (NSException* nse)
    {
        NSLog(@"Exception: %@", nse);
    }
    return nil;
    
}




+   (id) convertListToJSONObject : (NSMutableArray*) requiredListObject {
    @try
    {
        NSMutableDictionary* jsonObjectList = [[NSMutableDictionary alloc] init  ];
        
        NSNumber* objectIdHashMap = [[NSNumber alloc] initWithInt:NtwkConst_OBJECT_ID_ARRAY_LIST];
        [jsonObjectList setObject:objectIdHashMap forKey:NtwkConst_OBJECT_ID ];
        NSMutableArray *jsonArray = [[NSMutableArray alloc]init];
        for(int cntVec = 0;cntVec <[requiredListObject count]; cntVec++)
        {
            id objectOfVec = [requiredListObject objectAtIndex:cntVec];
            if([objectOfVec conformsToProtocol:@protocol(JSONStructure)] || [objectOfVec isKindOfClass:[NSMutableDictionary class]] || [objectOfVec isKindOfClass:[NSMutableArray class]])
            {
              // jsonArray.put(convertDSToJSONObject(objectOfVec));
                [jsonArray addObject:[self convertDSToJSONObject:objectOfVec]];
               
            }
            else
            {
                // jsonArray.put(objectOfVec);
                [jsonArray addObject:objectOfVec];
            }
            
        }
               
        [jsonObjectList setObject:jsonArray forKey:NtwkConst_OBJECT_DATA ];
    
        return jsonObjectList;
    }
    @catch(NSException* nse){
        NSLog(@"Exception: %@", nse);
    }
    return nil;
    
       
}

+ (id) makeBeanToJSONObect: (id<JSONStructure>) jsonStructure;
{
    
    if(jsonStructure != nil)
    {
        @try
        {
            NSMutableDictionary* jsonObjectStructure = [[NSMutableDictionary alloc] init  ];
            
            NSNumber* objectIdHashMap = [[NSNumber alloc] initWithInt:NtwkConst_OBJECT_ID_JSONSTRUCTURE];
            [jsonObjectStructure setObject:objectIdHashMap forKey:NtwkConst_OBJECT_ID];
            
            objectIdHashMap = [[NSNumber alloc] initWithInt:[jsonStructure getJsonStructureId]];
            [jsonObjectStructure  setObject:objectIdHashMap forKey :NtwkConst_JSON_STRUCTURE_ID];
            
            [jsonObjectStructure  setObject:[jsonStructure toJSON] forKey :NtwkConst_OBJECT_DATA];
            
            return jsonObjectStructure;
        }
        @catch (NSException* nse) {
            NSLog(@"Exception: %@", nse);
        }
    }
    return nil;
}




@end
