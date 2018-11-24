//
//  DotClientXmlMeta.h
//  QCMSProject
//
//  Created by Pradeep Singh on 5/21/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../Network/JSONStructure.h"

@interface DotClientXmlMeta : NSObject <JSONStructure>
{
@private
    int jsonStructureId;
    
    NSMutableDictionary* dotForms;
    NSMutableDictionary* dotReports;
}

@property NSMutableDictionary* dotForms;
@property NSMutableDictionary* dotReports;


@end
