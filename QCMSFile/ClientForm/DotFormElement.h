//
//  DotFormElement.h
//  QCMSProject
//
//  Created by Pradeep Singh on 5/21/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../Network/JSONStructure.h"

@interface DotFormElement : NSObject <JSONStructure>
{
@private
    int jsonStructureId;
    
    NSString* elementId;
    NSString* componentPosition;
    NSString* description;
    NSString* displayText;
    NSString* optional;
    NSString* dataType;
    NSString* length;
    NSString* defaultVal;
    NSString* isComponentDisplay;
    NSString* componentType;
    NSString* isHistoryCache;
    NSString* isCompDependOnOther;
    NSString* dependedCompName;
    NSString* dependedCompValue;
    NSString* valueSetCompName;
    NSString* format;
    NSString* componentStyle;
    NSString* masterValueMapping;
    NSString* columnConfig;
    NSString* extendedProperty;
    NSString* isUseForward;
    NSString* eventDetail;
    NSString* readonly;
    NSString* enableAll;
}


@property NSString* elementId;
@property NSString* componentPosition;
@property NSString* description;
@property NSString* displayText;
@property NSString* optional;
@property NSString* dataType;
@property NSString* length;
@property NSString* defaultVal;
@property NSString* isComponentDisplay;
@property NSString* componentType;
@property NSString* isHistoryCache;
@property NSString* isCompDependOnOther;
@property NSString* dependedCompName;
@property NSString* dependedCompValue;
@property NSString* valueSetCompName;
@property NSString* format;
@property NSString* componentStyle;
@property NSString* masterValueMapping;
@property NSString* columnConfig;
@property NSString* extendedProperty;
@property NSString* isUseForward;
@property NSString* eventDetail;
@property NSString* readonly;
@property NSString* enableAll;


-(BOOL) isComponentDisplayBool;
-(BOOL)isOptionalBool;
-(BOOL) isReadonly;
-(BOOL) isEnableAll;

@end
