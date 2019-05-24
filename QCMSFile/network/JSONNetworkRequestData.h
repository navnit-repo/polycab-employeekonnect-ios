//
//  JSONNetworkRequestData.h
//  QCMSProject
//
//  Created by Pradeep Singh on 5/21/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONStructure.h"

// JSON Structure id here is 0

@interface JSONNetworkRequestData : NSObject <JSONStructure>
{
    
@private
    int jsonStructureId;    
    NSString* callName;
    NSString* dServiceId;
    id requestData;
    id responseData;
    NSString* status;
    NSString* message;
    NSString* osVersion;
}

@property NSString* callName;
@property NSString* dServiceId;
@property id requestData;
@property id responseData;
@property NSString* status;
@property NSString* message;
@property NSString* osVersion;

@end
