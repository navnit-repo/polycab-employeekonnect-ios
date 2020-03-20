//
//  ReportPostResponse.m
//  QCMSProject
//
//  Created by Pradeep Singh on 5/21/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "JSONStructureConstant.h"
#import "JSONDataExchange.h"
#import "ReportPostResponse.h"

@implementation ReportPostResponse


@synthesize viewReportId;
@synthesize submitMessage;
@synthesize headerData;
@synthesize tableData;
@synthesize subHeaderData;
@synthesize footerData;

- (id) toJSON {
    @try
    {
    NSMutableDictionary* jsonObject = [[NSMutableDictionary alloc] init];
    
        [jsonObject setObject:viewReportId forKey:JsonStrucConst_VIEW_REPORT_ID];
        [jsonObject setObject:submitMessage forKey:JsonStrucConst_SUBMIT_MESSAGE];
        
        [jsonObject setObject:[JSONDataExchange convertDSToJSONObject :headerData] forKey:JsonStrucConst_HEADER_DATA];
        
        [jsonObject setObject:[JSONDataExchange convertDSToJSONObject :tableData] forKey:JsonStrucConst_TABLE_DATA];
    
        
        [jsonObject setObject:[JSONDataExchange convertDSToJSONObject :subHeaderData] forKey:JsonStrucConst_SUB_HEADER_DATA];
        [jsonObject setObject:[JSONDataExchange convertDSToJSONObject : footerData] forKey:JsonStrucConst_FOOTER_DATA];
        return jsonObject;
    }
    @catch (NSException* nse)
    {
        NSLog(@"Exception: %@", nse);

    }
    return nil;
    
    
    
}

- (int) getJsonStructureId {
    jsonStructureId = 5 ;
    return jsonStructureId;
}

- (id) toBean:(id) jsonObject {
    
    ReportPostResponse* myself  = [[ReportPostResponse alloc] init];
    
    myself.viewReportId = (NSString*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_VIEW_REPORT_ID : true];
    myself.submitMessage = (NSString*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_SUBMIT_MESSAGE : true];
    myself.headerData = (NSMutableDictionary*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_HEADER_DATA : false];
    myself.tableData = (NSMutableArray*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_TABLE_DATA : false];
    
    myself.subHeaderData = (NSMutableArray*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_SUB_HEADER_DATA : false];
    
    myself.footerData = (NSMutableDictionary*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_FOOTER_DATA : false];
         
    return myself;
}

@end
