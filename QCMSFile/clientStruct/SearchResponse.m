//
//  SearchResponse.m
//  QCMSProject
//
//  Created by Ashish Tiwari on 11/06/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "SearchResponse.h"
#import "JSONStructureConstant.h"
#import "JSONDataExchange.h"

@implementation SearchResponse


@synthesize searchMessage;
@synthesize searchDataForSubmit;
@synthesize searchHeaderDetail;
@synthesize searchDataForDisplay;
@synthesize searchRecord;






NSString *searchMessage = nil;
NSString *searchDataForSubmit = nil;
NSMutableArray *searchHeaderDetail = nil ;
NSMutableArray *searchDataForDisplay = nil;
NSMutableArray *searchRecord = nil;





-(int) getJsonStructureId
{
    int jsonStructureId  = 9;
    return jsonStructureId;

}


- (id) toJSON {
    NSMutableDictionary* jsonObject = [[NSMutableDictionary alloc] init];
    @try {
        [jsonObject setObject: searchMessage forKey:JsonStrucConst_SEARCH_MESSAGE];
                      
        [jsonObject setObject:[JSONDataExchange convertDSToJSONObject:searchHeaderDetail] forKey:JsonStrucConst_SEARCH_HEADER_DETAIL];
        [jsonObject setObject: searchDataForSubmit forKey : JsonStrucConst_SEARCH_DATA_FOR_SUBMIT];
        
        [jsonObject setObject:[JSONDataExchange convertDSToJSONObject:searchDataForDisplay] forKey:JsonStrucConst_SEARCH_DATA_FOR_DISPLAY];
        [jsonObject setObject:[JSONDataExchange convertDSToJSONObject:searchRecord] forKey:JsonStrucConst_SEARCH_RECORD];
        
            
        return jsonObject;
    }
    @catch (NSException* nse) {
        NSLog(@"Exception: %@", nse);
    }
    
    return nil;
    
}



- (id) toBean:(id) jsonObject {
    
    SearchResponse* myself  = [[SearchResponse alloc] init];
    myself.searchMessage = (NSString*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_SEARCH_MESSAGE : true];
    
    myself.searchHeaderDetail= (NSMutableArray*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_SEARCH_HEADER_DETAIL : false];
       
    myself.searchDataForSubmit = (NSString*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_SEARCH_DATA_FOR_SUBMIT : true];
    
    myself.searchDataForDisplay = (NSString*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_SEARCH_DATA_FOR_DISPLAY : false];
            
    myself.searchRecord = (NSMutableArray*) [JSONDataExchange toBeanObject : jsonObject :JsonStrucConst_SEARCH_RECORD : false];
       
    return myself;
    
    
}








@end
