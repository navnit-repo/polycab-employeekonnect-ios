//
//  ReportPostResponse.h
//  QCMSProject
//
//  Created by Pradeep Singh on 5/21/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../Network/JSONStructure.h"

@interface ReportPostResponse : NSObject <JSONStructure>
{
@private
    int jsonStructureId;
    
    NSString* viewReportId;
    NSString* submitMessage;
    NSMutableDictionary* headerData;
    NSMutableArray* tableData;
    NSMutableArray* subHeaderData;
    NSMutableDictionary* footerData;
}


@property NSString* viewReportId;
@property NSString* submitMessage;
@property NSMutableDictionary* headerData;
@property NSMutableArray* tableData;
@property NSMutableArray* subHeaderData;
@property NSMutableDictionary* footerData;


@end
