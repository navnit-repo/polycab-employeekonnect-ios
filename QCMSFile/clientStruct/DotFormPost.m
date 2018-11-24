//
//  DotFormPost.m
//  QCMSProject
//
//  Created by Pradeep Singh on 5/21/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//
//
#import <Foundation/Foundation.h>
#import "JSONStructureConstant.h"
#import "JSONDataExchange.h"
#import "DotFormPost.h"

@implementation DotFormPost

@synthesize moduleId;
@synthesize docId;
@synthesize docDesc;
@synthesize adapterType;
@synthesize adapterId;
@synthesize reportCacheRefresh;
@synthesize postData;
@synthesize displayData;
@synthesize maxDocId;


- (id)init {
    if (self = [super init])
    {
        self.displayData = [[NSMutableDictionary alloc] init];
        self.postData = [[NSMutableDictionary alloc] init];
        self.maxDocId = [[NSNumber alloc] initWithInt:0];
        self.reportCacheRefresh = @"false";
    }
    return self;
}

- (id) toJSON {
    @try
    {
    NSMutableDictionary* jsonObject = [[NSMutableDictionary alloc] init];
  
        [jsonObject setObject:moduleId forKey:JsonStrucConst_MODULE_ID];
        
        if(docId!=nil) {
            [jsonObject setObject:docId forKey:JsonStrucConst_DOC_ID];
        }
        
        if(docDesc!=nil) {
            [jsonObject setObject:docDesc forKey:JsonStrucConst_DOC_DESC];
        }
        
        if(adapterType!=nil) {
            [jsonObject setObject:adapterType forKey:JsonStrucConst_ADAPTER_TYPE];
        }
        
        if(adapterId!=nil) {
            [jsonObject setObject:adapterId forKey:JsonStrucConst_ADAPTER_ID];
        }
        
        if(reportCacheRefresh!=nil) {
            [jsonObject setObject:reportCacheRefresh forKey:JsonStrucConst_REPORT_CACHE_REFRESH];
        }
        
        if(postData!=nil) {
            [jsonObject setObject:[JSONDataExchange convertDSToJSONObject :postData] forKey:JsonStrucConst_POST_DATA];
        }
            
        if(maxDocId!=nil) {
            [jsonObject setObject:maxDocId forKey:JsonStrucConst_MAX_DOC_NO];
        }
        
          return jsonObject;
    }
    @catch (NSException* nse) {
        NSLog(@"Exception: %@", nse);
    }
    return nil;
    
     
    
}

- (int) getJsonStructureId {
    jsonStructureId = 4;
    return jsonStructureId;
}

- (id) toBean:(id) jsonObject {
    
    DotFormPost* myself  = [[DotFormPost alloc] init];
 
    myself.moduleId = (NSString*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_MODULE_ID : true];
    myself.docId = (NSString*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_DOC_ID : true];
    myself.docDesc = (NSString*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_DOC_DESC : true];
    myself.adapterType = (NSString*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_ADAPTER_TYPE : true];
    myself.adapterId = (NSString*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_ADAPTER_ID : true];
    myself.reportCacheRefresh = (NSString*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_REPORT_CACHE_REFRESH : true];
    myself.postData = (NSMutableDictionary*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_POST_DATA : false];
    
    myself.maxDocId = (NSNumber*) [JSONDataExchange toBeanObject : jsonObject :JsonStrucConst_MAX_DOC_NO : true];
    
           return myself;
}
-(DotFormPost*) cloneObject
{
    id jsonObj = [self toJSON];
    return [self toBean:jsonObj];
}

@end
