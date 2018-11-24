//
//  ClientMasterDetail.h
//  QCMSProject
//
//  Created by Pradeep Singh on 5/21/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../Network/JSONStructure.h"
#import "DotClientXmlMeta.h"


@interface ClientMasterDetail : NSObject <JSONStructure>
{
@private
    int jsonStructureId;
    
     NSMutableDictionary* masterUpdateDetail;
    //user master data which are refresh every time when use login
     NSMutableDictionary* masterDataRefresh;
     NSMutableDictionary* masterData;
     DotClientXmlMeta* dotClientXmlMeta;
}

@property NSMutableDictionary* masterUpdateDetail;
//user master data which are refresh every time when use login
@property NSMutableDictionary* masterDataRefresh;
@property NSMutableDictionary* masterData;
@property DotClientXmlMeta* dotClientXmlMeta;



@end
