//
//  DotReport.h
//  QCMSProject
//
//  Created by Pradeep Singh on 5/21/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../Network/JSONStructure.h"

@interface DotReport : NSObject <JSONStructure>
{
@private
    int jsonStructureId;
    
    NSString* reportId;//Unique Report Id
    NSString* screenName;//Name Of Report
    NSString* screenHeader;//Report Header
    NSString* screenMenuConfig;
    NSString* reportType;
    NSString* reportPlaces;
    NSString* adapterType;
    NSString* viewAdapterId;
    NSString* isDrillDown;
    NSString* drilldownDetail;
    NSString* extendedProperty;
    NSMutableDictionary* reportElements;
    NSString* sortedOnField;
  
   //For the extended property map
    NSMutableDictionary *extendedPropertyMap;
    NSString *clickEventOn;
    NSString *legendColorOn;
    NSString *legendNameOn;
    
    //For the property of Drill  Down
    NSString *ddAdapterId;
    NSString *ddAdapterType;
    NSString *ddNetworkFieldOfTable;
    NSString *ddNetworkFieldOfHeader;
    NSString *ddNetworkFieldOfFooter;
    NSString *ddCallName;
    NSString *ddMiddleScrMsg;
    NSString *isddNetworkCall;
    NSString *isddReportDispayAsExpand;
    NSString *urlField;
    
    NSString *ddActionType;
    NSString *ddActionFormId;
    NSString *ddServerCacheFlag;
    
       
}


@property NSString* reportId;//Unique Report Id
@property NSString* screenName;//Name Of Report
@property NSString* screenHeader;//Report Header
@property NSString* screenMenuConfig;
@property NSString* reportType;
@property NSString* reportPlaces;
@property NSString* adapterType;
@property NSString* viewAdapterId;
@property NSString* isDrillDown;
@property NSString* drilldownDetail;
@property NSString* extendedProperty;
@property NSMutableDictionary* reportElements;
@property NSString* sortedOnField;
//For the extended property map
@property NSMutableDictionary *extendedPropertyMap;
@property NSString *clickEventOn;
@property NSString *legendColorOn;
@property NSString *legendNameOn;

//For the property of Drill  Down
@property NSString *ddAdapterId;
@property NSString *ddAdapterType;
@property NSString *ddNetworkFieldOfTable;
@property NSString *ddNetworkFieldOfHeader;
@property NSString *ddNetworkFieldOfFooter;
@property NSString *ddCallName;
@property NSString *ddMiddleScrMsg;
@property NSString *isddNetworkCall;
@property NSString *isddReportDispayAsExpand;
@property NSString *urlField;

@property NSString *ddActionType;
@property NSString *ddActionFormId;
@property NSString *ddServerCacheFlag;



-(void)initExtendedPropertyTagOnRequest : (DotReport *) dotReport;
-(void)initDrillDownPropertyTagOnRequest : (DotReport *) dotReport;
-(BOOL)isFindDrillDown;
-(BOOL) isDdNetworkCallBool;
-(NSString*)getDdMiddleScrMsg;

@end
