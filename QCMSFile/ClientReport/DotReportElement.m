//
//  DotReportElement.m
//  QCMSProject
//
//  Created by Pradeep Singh on 5/21/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//

#import "DotReportElement.h"
#import "JSONStructureConstant.h"
#import "JSONDataExchange.h"

@implementation DotReportElement


@synthesize elementId;
@synthesize elementPosition;
@synthesize description;
@synthesize displayText;
@synthesize optional;
@synthesize dataType;
@synthesize length;
@synthesize defaultVal;
@synthesize isComponentDisplay;
@synthesize place;
@synthesize valueDependOn;
@synthesize isUseForward;
@synthesize componentStyle;
@synthesize componentType;
@synthesize extendedProperty;
@synthesize format;



- (id) toJSON {
    NSMutableDictionary* jsonObject = [[NSMutableDictionary alloc] init];
        
    //jsonObject.put(ROLE_XML_CACHE_DATE,JSONDataExchange.convertDSToJSONObject(roleXmlCacheDate));
    //jsonObject.put(DEVICE_INFO_MAP,JSONDataExchange.convertDSToJSONObject(deviceInfoMap));
    
    [jsonObject setObject:elementId forKey:JsonStrucConst_ELEMENT_ID];
    // jsonObject.put(ELEMENT_ID, elementId);
    
    [jsonObject setObject:elementPosition forKey:JsonStrucConst_ELEMENT_POSITION];
    
    [jsonObject setObject:description forKey:JsonStrucConst_DESCRIPTION];
    
    [jsonObject setObject:displayText forKey:JsonStrucConst_DISPLAY_TEXT];
    
    [jsonObject setObject:optional forKey:JsonStrucConst_OPTIONAL];
    
    [jsonObject setObject:dataType forKey:JsonStrucConst_DATA_TYPE];
    
    [jsonObject setObject:length forKey:JsonStrucConst_LENGTH];
    
    [jsonObject setObject:defaultVal forKey:JsonStrucConst_DEFAULT_VAL];
    
    [jsonObject setObject:isComponentDisplay forKey:JsonStrucConst_IS_ELEMENT_DISPLAY];

    //place ,valueDependOn
    [jsonObject setObject:place forKey:JsonStrucConst_PLACE];
    
    [jsonObject setObject:valueDependOn forKey:JsonStrucConst_VALUE_DEPEND_ON];
    
    [jsonObject setObject:componentType forKey:JsonStrucConst_ELEMENT_TYPE];
    
    [jsonObject setObject:format forKey:JsonStrucConst_FORMAT];
    
    [jsonObject setObject:componentStyle forKey:JsonStrucConst_ELEMENT_STYLE];
    
    [jsonObject setObject:extendedProperty forKey:JsonStrucConst_EXTENDED_PROPERTY];
    
    [jsonObject setObject:isUseForward forKey:JsonStrucConst_IS_USE_FORWARD];
    return (jsonObject);
    
}

- (int) getJsonStructureId {
    jsonStructureId = 106;
    return jsonStructureId;
}

- (id) toBean:(id) jsonObject {
        
    DotReportElement* dotReportElement = [[DotReportElement alloc] init];
    
    @try {
        dotReportElement.elementId = (NSString*) [JSONDataExchange toBeanObject :jsonObject : JsonStrucConst_ELEMENT_ID :true];
        dotReportElement.elementPosition = (NSString*) [JSONDataExchange toBeanObject :jsonObject : JsonStrucConst_ELEMENT_POSITION :true];
        dotReportElement.description = (NSString*) [JSONDataExchange toBeanObject :jsonObject : JsonStrucConst_DESCRIPTION :true];
        dotReportElement.displayText = (NSString*) [JSONDataExchange toBeanObject :jsonObject : JsonStrucConst_DISPLAY_TEXT :true];
        dotReportElement.optional = (NSString*) [JSONDataExchange toBeanObject :jsonObject : JsonStrucConst_OPTIONAL :true];
        dotReportElement.dataType = (NSString*) [JSONDataExchange toBeanObject :jsonObject : JsonStrucConst_DATA_TYPE : true];
        dotReportElement.length = (NSString*) [JSONDataExchange toBeanObject :jsonObject : JsonStrucConst_LENGTH : true];
        dotReportElement.defaultVal = (NSString*) [JSONDataExchange toBeanObject :jsonObject : JsonStrucConst_DEFAULT_VAL : true];
        dotReportElement.isComponentDisplay = (NSString*) [JSONDataExchange toBeanObject :jsonObject : JsonStrucConst_IS_ELEMENT_DISPLAY : true];
        dotReportElement.componentType = (NSString*) [JSONDataExchange toBeanObject :jsonObject : JsonStrucConst_ELEMENT_TYPE : true];
        dotReportElement.place = (NSString*) [JSONDataExchange toBeanObject :jsonObject : JsonStrucConst_PLACE : true];
        dotReportElement.valueDependOn = (NSString*) [JSONDataExchange toBeanObject :jsonObject : JsonStrucConst_VALUE_DEPEND_ON : true];
        dotReportElement.format = (NSString*) [JSONDataExchange toBeanObject :jsonObject : JsonStrucConst_FORMAT : true];
        dotReportElement.componentStyle = (NSString*) [JSONDataExchange toBeanObject :jsonObject : JsonStrucConst_ELEMENT_STYLE : true];
        dotReportElement.extendedProperty = (NSString*) [JSONDataExchange toBeanObject :jsonObject : JsonStrucConst_EXTENDED_PROPERTY : true];
        dotReportElement.isUseForward = (NSString*) [JSONDataExchange toBeanObject :jsonObject : JsonStrucConst_IS_USE_FORWARD : true];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    return dotReportElement;
    
}


-(BOOL) isComponentDisplayBool
{
    if([self.isComponentDisplay isEqualToString:JsonStrucConst_TRUE])
        return true;
    else
        return false;
    
}
-(BOOL)isUseForwardBool{
	if([self.isUseForward isEqualToString:JsonStrucConst_TRUE])
        return true;
    else
        return false;
}


@end
