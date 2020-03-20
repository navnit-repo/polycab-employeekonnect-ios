//
//  DotForm.m
//  QCMSProject
//
//  Created by Pradeep Singh on 5/21/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//

#import "DotForm.h"
#import "JSONStructureConstant.h"
#import "NetworkConstant.h"
#import "JSONDataExchange.h"
#import "XmwUtils.h"
#import "XmwcsConstant.h"
#import "DotFormDraw.h"

@implementation DotForm


@synthesize formId;
@synthesize screenDesc;
@synthesize screenName;;
@synthesize screenHeader;
@synthesize screenMenuConfig;

@synthesize formType;
@synthesize formSubType;

@synthesize adapterType;
@synthesize submitAdapterId;
@synthesize viewAdapterId;
@synthesize extendedPropertyForm;
@synthesize formElements;

@synthesize  extendedPropertyMap;
@synthesize  addRowColumn;
@synthesize  tableName;
@synthesize  subGroupInfo;


-(id) init {
    if (self = [super init])
    {
        self.formElements = [[NSMutableDictionary alloc] init];
        self.extendedPropertyMap = [[NSMutableDictionary alloc] init];
        
    }
    return self;
}


- (id) toJSON {
    NSMutableDictionary* jsonObject = [[NSMutableDictionary alloc] init];
    
    [jsonObject setObject:formId forKey:JsonStrucConst_FORM_ID];
    
    [jsonObject setObject:screenName forKey:JsonStrucConst_SCREEN_NAME];
    
    [jsonObject setObject:screenDesc forKey:JsonStrucConst_SCREEN_DESC];
    
    [jsonObject setObject:screenHeader forKey:JsonStrucConst_SCREEN_HEADER];
    
    [jsonObject setObject:screenMenuConfig forKey:JsonStrucConst_SCREEN_MENU_CONFIG];
    
    [jsonObject setObject:formType forKey:JsonStrucConst_FORM_TYPE];
    
    [jsonObject setObject:formSubType forKey:JsonStrucConst_FORM_SUB_TYPE];
    
    [jsonObject setObject:adapterType forKey:JsonStrucConst_ADAPTER_TYPE];
    
    [jsonObject setObject:submitAdapterId forKey:JsonStrucConst_SUBMIT_ADAPTER_ID];
    
    [jsonObject setObject:viewAdapterId forKey:JsonStrucConst_VIEW_ADAPTER_ID];
    
    [jsonObject setObject:extendedPropertyForm forKey:JsonStrucConst_EXTENDED_PROPERTY];
    
    
    [jsonObject setObject:[JSONDataExchange convertDSToJSONObject : formElements] forKey:JsonStrucConst_ELEMENTS];
    return (jsonObject);
    
}

- (int) getJsonStructureId {
    jsonStructureId = 102;
    return jsonStructureId;
}

- (id) toBean:(id) jsonObject {
    
    DotForm* dotFrm  = [[DotForm alloc] init];
    
    dotFrm.formId = (NSString*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_FORM_ID : true];
    dotFrm.screenName = (NSString*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_SCREEN_NAME : true];
    dotFrm.screenDesc = (NSString*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_SCREEN_DESC : true];
    dotFrm.screenHeader = (NSString*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_SCREEN_HEADER : true];
    dotFrm.screenMenuConfig = (NSString*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_SCREEN_MENU_CONFIG : true];
    dotFrm.formType = (NSString*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_FORM_TYPE : true];
    dotFrm.formSubType = (NSString*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_FORM_SUB_TYPE : true];
    dotFrm.adapterType = (NSString*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_ADAPTER_TYPE : true];
    dotFrm.submitAdapterId = (NSString*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_SUBMIT_ADAPTER_ID : true];
    dotFrm.viewAdapterId = (NSString*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_VIEW_ADAPTER_ID : true];
    dotFrm.extendedPropertyForm = (NSString*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_EXTENDED_PROPERTY : true];
    dotFrm.formElements = (NSMutableDictionary*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_ELEMENTS :false];
    
    [self initTagOnRequest : dotFrm];
    
    return dotFrm;

}


- (void) initTagOnRequest : (DotForm*) dotFrm
{
    if ((dotFrm.extendedPropertyForm != nil) && ([dotFrm.extendedPropertyForm compare:@""] !=0) ) {
        dotFrm.extendedPropertyMap = [XmwUtils getExtendedPropertyMap : dotFrm.extendedPropertyForm];
        // for the Setting the Left and  Right Menu Value from the Menu Config
        dotFrm.addRowColumn = [XmwUtils getPropertyFromMap : dotFrm.extendedPropertyMap : XmwcsConst_DF_EXTENDED_PROPERTY_ADD_ROW_COLUMN];
                                          
        dotFrm.tableName = [XmwUtils getPropertyFromMap : dotFrm.extendedPropertyMap : XmwcsConst_DF_EXTENDED_PROPERTY_TABLE_NAME];
        dotFrm.subGroupInfo = [XmwUtils getPropertyFromMap : dotFrm.extendedPropertyMap : XmwcsConst_DF_EXTENDED_PROPERTY_SUB_GROUP];
    }
}


-(NSArray*) addRowFormElements
{
    NSMutableArray* formElementsArray = [[NSMutableArray alloc] init];
    
    NSString* addRowFieldsString = [self.extendedPropertyMap objectForKey:@"ADD_ROW_FIELD"];
    NSArray *addRowFields = nil;
    if(addRowFieldsString!=nil) {
        addRowFields = [XmwUtils breakStringTokenAsVector : addRowFieldsString : @"$"];
    } else {
        addRowFields = [[NSArray alloc] init];
    }
    
    NSMutableArray *sortedElements =[DotFormDraw sortFormComponents : self.formElements];
    
    int cntElement = 0;
    for(cntElement = 0; cntElement < [sortedElements count] ; cntElement++)
    {
        DotFormElement* dotFormElement = (DotFormElement *)[self.formElements objectForKey:[sortedElements objectAtIndex:cntElement]];
        if([XmwUtils exists:dotFormElement.elementId InArray:addRowFields]) {
            [formElementsArray addObject:dotFormElement];
        }
    }
    return formElementsArray;
}


-(NSArray*) nonAddRowFormElements
{
    NSMutableArray* formElementsArray = [[NSMutableArray alloc] init];
    
    NSString* addRowFieldsString = [self.extendedPropertyMap objectForKey:@"NON_ADD_ROW_FIELD"];
    NSArray *addRowFields = nil;
    if(addRowFieldsString!=nil) {
        addRowFields = [XmwUtils breakStringTokenAsVector : addRowFieldsString : @"$"];
    } else {
        addRowFields = [[NSArray alloc] init];
    }
    
    NSMutableArray *sortedElements =[DotFormDraw sortFormComponents : self.formElements];
    
    int cntElement = 0;
    for(cntElement = 0; cntElement < [sortedElements count] ; cntElement++)
    {
        DotFormElement* dotFormElement = (DotFormElement *)[self.formElements objectForKey:[sortedElements objectAtIndex:cntElement]];
        if([XmwUtils exists:dotFormElement.elementId InArray:addRowFields]) {
            [formElementsArray addObject:dotFormElement];
        }
    }
    
    return formElementsArray;
}


@end
