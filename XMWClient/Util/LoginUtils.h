//
//  LoginUtils.h
//  QCMSProject
//
//  Created by Ashish Tiwari on 29/05/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ClientLoginResponse.h"

@interface LoginUtils : NSObject
{

}


+(BOOL) setClientVariables : (ClientLoginResponse*) clientLoginResponse : (NSString*) inUsername;

+(void)copyUserSpectoMaster;

+(NSMutableDictionary*) makeMasterMap : (NSString*) userId;
+(void) setMaxDocNumber;

@end
