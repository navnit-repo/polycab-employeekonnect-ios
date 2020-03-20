//
//  DotClientXmlMeta.m
//  QCMSProject
//
//  Created by Pradeep Singh on 5/21/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "JSONStructureConstant.h"
#import "JSONDataExchange.h"
#import "DotClientXmlMeta.h"

@implementation DotClientXmlMeta


@synthesize dotForms;
@synthesize dotReports;

- (id)init {
    if (self = [super init])
    {
        self.dotForms = [[NSMutableDictionary alloc] init];
        self.dotReports = [[NSMutableDictionary alloc] init];
    }
    return self;
}


- (id) toJSON {
    @try{

        NSMutableDictionary* jsonObject = [[NSMutableDictionary alloc] init];
        [jsonObject setObject:[JSONDataExchange convertDSToJSONObject : dotForms] forKey:JsonStrucConst_DOT_FORMS];
        
         [jsonObject setObject:[JSONDataExchange convertDSToJSONObject : dotReports] forKey:JsonStrucConst_DOT_REPORTS];
        
        return jsonObject;
    }
    @catch (NSException* nse)
    {
       NSLog(@"Exception: %@", nse);
    }
    return nil;
    
    }

- (int) getJsonStructureId {
    jsonStructureId = 8;
    return jsonStructureId;
}

- (id) toBean:(id) jsonObject {
    
    DotClientXmlMeta* myself  = [[DotClientXmlMeta alloc] init];
    
    myself.dotForms = (NSMutableDictionary*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_DOT_FORMS : false];
    myself.dotReports = (NSMutableDictionary*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_DOT_REPORTS : false];
    
       return myself;
}

@end
