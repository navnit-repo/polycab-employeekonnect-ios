//
//  DotReport.m
//  QCMSProject
//
//  Created by Pradeep Singh on 5/21/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//

#import "DotReport.h"
#import "JSONDataExchange.h"
#import "JSONStructureConstant.h"
#import "XmwUtils.h"
#import "XmwcsConstant.h"


@implementation DotReport

 
@synthesize reportId;//Unique Report Id
@synthesize screenName;//Name Of Report
@synthesize screenHeader;//Report Header
@synthesize screenMenuConfig;
@synthesize reportType;
@synthesize reportPlaces;
@synthesize adapterType;
@synthesize viewAdapterId;
@synthesize isDrillDown;
@synthesize drilldownDetail;
@synthesize extendedProperty;
@synthesize reportElements;
@synthesize sortedOnField;

//For the extended property map
@synthesize extendedPropertyMap;
@synthesize clickEventOn;
@synthesize legendColorOn;
@synthesize legendNameOn;

//For the property of Drill  Down
@synthesize ddAdapterId;
@synthesize ddAdapterType;
@synthesize ddNetworkFieldOfTable;
@synthesize ddNetworkFieldOfHeader;
@synthesize ddNetworkFieldOfFooter;
@synthesize ddCallName;
@synthesize ddMiddleScrMsg;
@synthesize isddNetworkCall;
@synthesize isddReportDispayAsExpand;
@synthesize urlField;
@synthesize ddActionType;
@synthesize ddActionFormId;
@synthesize ddServerCacheFlag;



- (id) toJSON {
    NSMutableDictionary* jsonObject = [[NSMutableDictionary alloc] init];
    
    [jsonObject setObject:reportId forKey:JsonStrucConst_REPORT_ID];
    [jsonObject setObject:screenName forKey:JsonStrucConst_SCREEN_NAME];    
    [jsonObject setObject:screenHeader forKey:JsonStrucConst_SCREEN_HEADER];
    
    [jsonObject setObject:screenMenuConfig forKey:JsonStrucConst_SCREEN_MENU_CONFIG];
    
    [jsonObject setObject:reportType forKey:JsonStrucConst_REPORT_TYPE];
    
    [jsonObject setObject:reportPlaces forKey:JsonStrucConst_REPORT_PLACES];
    
    [jsonObject setObject:adapterType forKey:JsonStrucConst_ADAPTER_TYPE];
    
    [jsonObject setObject:viewAdapterId forKey:JsonStrucConst_VIEW_ADAPTER_ID];
    
    [jsonObject setObject:isDrillDown forKey:JsonStrucConst_IS_DRILL_DOWN];
        
    [jsonObject setObject:drilldownDetail forKey:JsonStrucConst_DRILLDOWN_DETAIL];
    
    [jsonObject setObject:extendedProperty forKey:JsonStrucConst_EXTENDED_PROPERTY];

    [jsonObject setObject:[JSONDataExchange convertDSToJSONObject : reportElements] forKey:JsonStrucConst_REPORT_ELEMENT];
    
    return (jsonObject);
    
}

- (int) getJsonStructureId {
    jsonStructureId = 105;
    return jsonStructureId;
}

- (id) toBean:(id) jsonObject {
    DotReport* dotFrm  = [[DotReport alloc] init];
    
    @try {
        dotFrm.reportId = (NSString*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_REPORT_ID :true];
        dotFrm.screenName = (NSString*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_SCREEN_NAME : true];
        dotFrm.screenHeader = (NSString*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_SCREEN_HEADER :true];
        dotFrm.screenMenuConfig = (NSString*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_SCREEN_MENU_CONFIG :true];
        
        dotFrm.reportType = (NSString*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_REPORT_TYPE :true];
        dotFrm.reportPlaces = (NSString*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_REPORT_PLACES :true];
        
        dotFrm.adapterType = (NSString*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_ADAPTER_TYPE :true];
        dotFrm.viewAdapterId = (NSString*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_VIEW_ADAPTER_ID :true];
        
        dotFrm.isDrillDown = (NSString*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_IS_DRILL_DOWN :true];
        dotFrm.drilldownDetail = (NSString*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_DRILLDOWN_DETAIL :true];
        dotFrm.extendedProperty = (NSString*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_EXTENDED_PROPERTY :true];
        dotFrm.reportElements = (NSMutableDictionary*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_REPORT_ELEMENT :false];
        
        [self initExtendedPropertyTagOnRequest : dotFrm];
        if([dotFrm isFindDrillDown])
        {
            
            [self initDrillDownPropertyTagOnRequest : dotFrm];
            
            
        }

    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    return dotFrm;
}

-(void)initExtendedPropertyTagOnRequest : (DotReport *) dotReport
{
    if(dotReport.extendedProperty != nil && ![dotReport.extendedProperty isEqualToString:@""])
    {
        dotReport.extendedPropertyMap = [XmwUtils getExtendedPropertyMap:dotReport.extendedProperty];
        // for the Setting the Left and  Right Menu Value from the Menu Config
        dotReport.clickEventOn = [XmwUtils getPropertyFromMap:dotReport.extendedPropertyMap :XmwcsConst_REPORT_EXTENDED_CLICK_EVENT_ON];
        dotReport.legendColorOn = [XmwUtils getPropertyFromMap:dotReport.extendedPropertyMap :XmwcsConst_REPORT_EXTENDED_LEGEND_COLOR_ON];
        dotReport.legendNameOn = [XmwUtils getPropertyFromMap:dotReport.extendedPropertyMap :XmwcsConst_REPORT_EXTENDED_LEGEND_NAME_ON];
    }
    
    
}

-(void)initDrillDownPropertyTagOnRequest : (DotReport *) dotReport
{
    
    if (dotReport.drilldownDetail != nil && ![dotReport.drilldownDetail isEqualToString:@""])
    {
        NSMutableDictionary *drillDownPropertyMap = [XmwUtils getExtendedPropertyMap:dotReport.drilldownDetail];
        
        // for the Setting the Left and  Right Menu Value from the Menu Config
        dotReport.ddAdapterId = [XmwUtils getPropertyFromMap : drillDownPropertyMap : XmwcsConst_REPORT_DD_PROP_ADAPTER_ID];
        dotReport.ddAdapterType = [XmwUtils getPropertyFromMap : drillDownPropertyMap : XmwcsConst_REPORT_DD_PROP_ADAPTER_TYPE];
        dotReport.ddCallName = [XmwUtils getPropertyFromMap : drillDownPropertyMap : XmwcsConst_REPORT_DD_PROP_CALL_NAME];
        dotReport.ddMiddleScrMsg = [XmwUtils getPropertyFromMap : drillDownPropertyMap :  XmwcsConst_REPORT_DD_PROP_MIDDLE_SCR_MSG];
        
        dotReport.isddNetworkCall = [XmwUtils getPropertyFromMap : drillDownPropertyMap : XmwcsConst_REPORT_DD_PROP_IS_NETWORK_CALL];
        dotReport.isddReportDispayAsExpand = [XmwUtils getPropertyFromMap : drillDownPropertyMap : XmwcsConst_REPORT_DD_PROP_IS_DISPLAY_ON_EXPAND];
        
        
        dotReport.ddNetworkFieldOfHeader = [XmwUtils getPropertyFromMap : drillDownPropertyMap : XmwcsConst_REPORT_DD_PROP_NETWORK_FIELD_HEADER];
        dotReport.ddNetworkFieldOfTable =  [XmwUtils getPropertyFromMap : drillDownPropertyMap : XmwcsConst_DD_PROP_NETWORK_FIELD_TABLE];
        dotReport.ddNetworkFieldOfFooter = [XmwUtils getPropertyFromMap : drillDownPropertyMap : XmwcsConst_REPORT_DD_PROP_NETWORK_FIELD_FOOTER ];
        dotReport.urlField = [XmwUtils getPropertyFromMap : drillDownPropertyMap : XmwcsConst_REPORT_DD_PROP_URL_FIELD ];
    
        NSString* drilldownAction = [XmwUtils getPropertyFromMap : drillDownPropertyMap : XmwcsConst_REPORT_DD_PROP_ACTION ];
    
        
        if(drilldownAction!=nil & drilldownAction.length>0) {
            // it can have two more properties (name:value) separated by $, TYPE and FORM_ID
            // suppose to be used for VIEW_EDIT form
            // line item of table row report data will fetch drilldown data and this data can be made
            // editable in the dotform identified by form_id
            
            NSDictionary* actionProp = [XmwUtils xmwNameValuePair:drilldownAction ];
            dotReport.ddActionType = [actionProp objectForKey:XmwcsConst_REPORT_DD_PROP_ACTION_TYPE];
            dotReport.ddActionFormId = [actionProp objectForKey:XmwcsConst_REPORT_DD_PROP_ACTION_FORM_ID];
        }
        
        dotReport.ddServerCacheFlag = [XmwUtils getPropertyFromMap : drillDownPropertyMap : XmwcsConst_REPORT_DD_PROP_SERVER_CACHE ];
    
    }

}

-(BOOL)isFindDrillDown
{
    if (isDrillDown != nil && [isDrillDown isEqualToString: JsonStrucConst_TRUE])
    {
        return true;
    } else {
        return false;
    }
    
}

-(BOOL) isDdNetworkCallBool
{
   
    if([isddNetworkCall isEqualToString:JsonStrucConst_FALSE])
    {
		return false;
	} else {
		return true;
	}
}

-(NSString*)getDdMiddleScrMsg
{
	if(ddMiddleScrMsg==0) {
		ddMiddleScrMsg = @"";
	}
	return ddMiddleScrMsg;
}
@end
