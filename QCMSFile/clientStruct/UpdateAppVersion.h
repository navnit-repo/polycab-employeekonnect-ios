//
//  UpdateAppVersion.h
//  QCMSProject
//
//  Created by Pradeep Singh on 4/22/14.
//  Copyright (c) 2014 dotvik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../Network/JSONStructure.h"

@interface UpdateAppVersion : NSObject <JSONStructure>
{
@private
    int jsonStructureId;    // structure id 200
    NSNumber* minorVersion;
	NSNumber* majorVersion;
    NSNumber* forceUpdate;
	NSString* downloadUrl;
}


@property NSNumber* minorVersion;
@property NSNumber* majorVersion;
@property NSNumber* forceUpdate;
@property NSString* downloadUrl;


@end
