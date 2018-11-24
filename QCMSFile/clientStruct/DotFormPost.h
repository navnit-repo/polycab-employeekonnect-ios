//
//  DotFormPost.h
//  QCMSProject
//
//  Created by Pradeep Singh on 5/21/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../Network/JSONStructure.h"

@interface DotFormPost : NSObject <JSONStructure>
{
@private
    int jsonStructureId;
    NSNumber* maxDocId;
    NSString* moduleId;
    NSString* docId;
    NSString* docDesc;
    NSString* adapterType;
    NSString* adapterId;
    NSString* reportCacheRefresh;
    NSMutableDictionary* postData;
    NSMutableDictionary* displayData;
    
}

@property NSString* moduleId;
@property NSString* docId;
@property NSString* docDesc;
@property NSString* adapterType;
@property NSString* adapterId;
@property NSString* reportCacheRefresh;
@property NSNumber* maxDocId;
@property NSMutableDictionary* postData;
@property NSMutableDictionary* displayData;
-(DotFormPost*) cloneObject;
@end
