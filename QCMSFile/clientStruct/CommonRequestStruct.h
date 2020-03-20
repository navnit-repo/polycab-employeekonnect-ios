//
//  CommonRequestStruct.h
//  QCMSProject
//
//  Created by Pradeep Singh on 4/22/14.
//  Copyright (c) 2014 dotvik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../Network/JSONStructure.h"

@interface CommonRequestStruct : NSObject <JSONStructure>
{
@private
    int jsonStructureId;   // structure id is 10
    
    NSString* requestId;
	NSMutableDictionary* postData;
	id extraData;
	NSString* extraString;
    
}


@property NSString* requestId;
@property NSMutableDictionary* postData;
@property id extraData;
@property NSString* extraString;



@end
