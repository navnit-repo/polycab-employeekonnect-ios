//
//  DotFormElement.m
//  QCMSProject
//
//  Created by Pradeep Singh on 5/21/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//

#import "DotFormElement.h"
#import "JSONStructureConstant.h"
#import "NetworkConstant.h"
#import "JSONDataExchange.h"

@implementation DotFormElement


@synthesize elementId;
@synthesize componentPosition;
@synthesize description;
@synthesize displayText;
@synthesize optional;
@synthesize dataType;
@synthesize length;
@synthesize defaultVal;
@synthesize isComponentDisplay;
@synthesize componentType;
@synthesize isHistoryCache;
@synthesize isCompDependOnOther;
@synthesize dependedCompName;
@synthesize dependedCompValue;
@synthesize valueSetCompName;
@synthesize format;
@synthesize componentStyle;
@synthesize masterValueMapping;
@synthesize columnConfig;
@synthesize extendedProperty;
@synthesize isUseForward;
@synthesize eventDetail;
@synthesize readonly;
@synthesize enableAll;



- (id) toJSON {
    NSMutableDictionary* jsonObject = [[NSMutableDictionary alloc] init];
    
    [jsonObject setObject:elementId forKey:JsonStrucConst_ELEMENT_ID  ];
    [jsonObject setObject:componentPosition forKey:JsonStrucConst_ELEMENT_POSITION  ];
    [jsonObject setObject:description forKey:JsonStrucConst_DESCRIPTION  ];
    [jsonObject setObject:displayText forKey:JsonStrucConst_DISPLAY_TEXT  ];
    [jsonObject setObject:optional forKey:JsonStrucConst_OPTIONAL  ];
    [jsonObject setObject:dataType forKey:JsonStrucConst_DATA_TYPE  ];
    [jsonObject setObject:length forKey:JsonStrucConst_LENGTH  ];
    [jsonObject setObject:defaultVal forKey:JsonStrucConst_DEFAULT_VAL  ];
    [jsonObject setObject:isComponentDisplay forKey:JsonStrucConst_IS_ELEMENT_DISPLAY  ];
    [jsonObject setObject:componentType forKey:JsonStrucConst_ELEMENT_TYPE  ];
    [jsonObject setObject:isHistoryCache forKey:JsonStrucConst_IS_HISTORY_CACHE  ];
    [jsonObject setObject:isCompDependOnOther forKey:JsonStrucConst_IS_ELEMENT_DEPEND_ON_OTHER  ];
    [jsonObject setObject:dependedCompName forKey:JsonStrucConst_DEPENDED_ELEMENT_NAME  ];
    [jsonObject setObject:dependedCompValue forKey:JsonStrucConst_DEPENDED_ELEMENT_VALUE  ];
    [jsonObject setObject:valueSetCompName forKey:JsonStrucConst_VALUE_SET_ELEMENT_NAME  ];
    [jsonObject setObject:format forKey:JsonStrucConst_FORMAT  ];
    [jsonObject setObject:componentStyle forKey:JsonStrucConst_ELEMENT_STYLE  ];
    [jsonObject setObject:masterValueMapping forKey:JsonStrucConst_MASTER_VALUE_MAPPING  ];
    [jsonObject setObject:columnConfig forKey:JsonStrucConst_COLUMN_CONFIG  ];
    [jsonObject setObject:extendedProperty forKey:JsonStrucConst_EXTENDED_PROPERTY  ];
    [jsonObject setObject:isUseForward forKey:JsonStrucConst_IS_USE_FORWARD  ];
    [jsonObject setObject:eventDetail forKey:JsonStrucConst_EVENT_DETAIL  ];
    [jsonObject setObject:readonly forKey:JsonStrucConst_READ_ONLY  ];
    [jsonObject setObject:enableAll forKey:JsonStrucConst_ENABLE_ALL  ];

    
    return (jsonObject);
    
}

- (int) getJsonStructureId {
    jsonStructureId = 103;
    return jsonStructureId;
}

- (id) toBean:(id) jsonObject {
    
    DotFormElement* dotFormElement  = [[DotFormElement alloc] init];
    
    dotFormElement.elementId = (NSString*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_ELEMENT_ID : true];
    dotFormElement.componentPosition = (NSString*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_ELEMENT_POSITION : true];
    dotFormElement.description = (NSString*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_DESCRIPTION : true];
    dotFormElement.displayText = (NSString*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_DISPLAY_TEXT : true];
    dotFormElement.optional = (NSString*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_OPTIONAL : true];
    dotFormElement.dataType = (NSString*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_DATA_TYPE : true];
    dotFormElement.length = (NSString*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_LENGTH : true];
    dotFormElement.defaultVal = (NSString*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_DEFAULT_VAL : true];
    dotFormElement.isComponentDisplay = (NSString*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_IS_ELEMENT_DISPLAY : true];
    dotFormElement.componentType = (NSString*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_ELEMENT_TYPE : true];
    dotFormElement.isHistoryCache = (NSString*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_IS_HISTORY_CACHE : true];
    dotFormElement.isCompDependOnOther = (NSString*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_IS_ELEMENT_DEPEND_ON_OTHER : true];
    dotFormElement.dependedCompName = (NSString*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_DEPENDED_ELEMENT_NAME : true];
    dotFormElement.dependedCompValue = (NSString*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_DEPENDED_ELEMENT_VALUE : true];
    dotFormElement.valueSetCompName = (NSString*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_VALUE_SET_ELEMENT_NAME : true];
    dotFormElement.format = (NSString*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_FORMAT : true];
    dotFormElement.componentStyle = (NSString*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_ELEMENT_STYLE : true];
    dotFormElement.masterValueMapping = (NSString*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_MASTER_VALUE_MAPPING : true];
    dotFormElement.columnConfig = (NSString*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_COLUMN_CONFIG : true];
    dotFormElement.extendedProperty = (NSString*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_EXTENDED_PROPERTY : true];
    dotFormElement.isUseForward = (NSString*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_IS_USE_FORWARD : true];
    
    dotFormElement.eventDetail = (NSString*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_EVENT_DETAIL : true];
    
    dotFormElement.readonly = (NSString*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_READ_ONLY : true];
    
    dotFormElement.enableAll = (NSString*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_ENABLE_ALL : true];


    return dotFormElement;
}


-(BOOL) isComponentDisplayBool
{
    if([self.isComponentDisplay isEqualToString:JsonStrucConst_TRUE])
		return true;
	else
		return false;
}

-(BOOL)isOptionalBool
{
   
    if([self.optional isEqualToString:JsonStrucConst_TRUE])
			return true;
		else
			return false;
    
}


-(BOOL) isReadonly
{
    if(self.readonly==nil) {
        return NO;
    }
    
    if([self.readonly isEqualToString:@"1"]) {
        return YES;
    } else {
        return NO;
    }
}

-(BOOL) isEnableAll
{
    if(self.enableAll==nil) {
        return NO;
    }
    
    if([self.enableAll isEqualToString:@"1"]) {
        return YES;
    } else {
        return NO;
    }
}

@end
