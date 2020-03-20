//
//  DotReportElement.h
//  QCMSProject
//
//  Created by Pradeep Singh on 5/21/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../Network/JSONStructure.h"

@interface DotReportElement : NSObject <JSONStructure>
{
@private
    int jsonStructureId;
    
    NSString* elementId;
    NSString* elementPosition;
    NSString* description;
    NSString* displayText;
    NSString* optional;
    NSString* dataType;
    NSString* length;
    NSString* defaultVal;
    NSString* isComponentDisplay;
    NSString* place;
    NSString* valueDependOn;
    NSString* isUseForward;
    NSString* componentStyle;
    NSString* componentType;
    NSString* extendedProperty;
    NSString* format;
}


@property NSString* elementId;
@property NSString* elementPosition;
@property NSString* description;
@property NSString* displayText;
@property NSString* optional;
@property NSString* dataType;
@property NSString* length;
@property NSString* defaultVal;
@property NSString* isComponentDisplay;
@property NSString* place;
@property NSString* valueDependOn;
@property NSString* isUseForward;
@property NSString* componentStyle;
@property NSString* componentType;
@property NSString* extendedProperty;
@property NSString* format;

-(BOOL) isComponentDisplayBool;
-(BOOL)isUseForwardBool;
@end
