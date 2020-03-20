//
//  LoginUtils.m
//  QCMSProject
//
//  Created by Ashish Tiwari on 29/05/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//

#import "LoginUtils.h"
#import "ClientVariable.h"
#import "ClientMasterDetail.h"
#import "ClientLoginResponse.h"
#import "DVAppDelegate.h"
#import "ObjectStorage.h"
#import "AppConstants.h"
#import "LanguageConstant.h"

@implementation LoginUtils


+(BOOL) setClientVariables : (ClientLoginResponse*) clientLoginResponse : (NSString*) inUsername {
    
    
   ClientVariable *clientVariables = [ClientVariable getInstance:[DVAppDelegate currentModuleContext]];
    
	if(clientVariables != nil) {
        clientVariables.CLIENT_LOGIN_RESPONSE = clientLoginResponse;
        clientVariables.CLIENT_MASTERDETAIL = clientLoginResponse.clientMasterDetail;
        clientVariables.CLIENT_APP_MASTER_DATA =clientLoginResponse.clientMasterDetail.masterData;

        clientVariables.DOT_FORM_MAP = clientLoginResponse.clientMasterDetail.dotClientXmlMeta.dotForms ;
        clientVariables.DOT_REPORT_MAP = clientLoginResponse.clientMasterDetail.dotClientXmlMeta.dotReports ;
        clientVariables.CLIENT_APP_MASTER_DATA = [LoginUtils makeMasterMap : inUsername];
     
        clientVariables.DOT_FORM_DRAW = [[DotFormDraw alloc] init];
        
        [LoginUtils setMaxDocNumber];
		[LoginUtils copyUserSpectoMaster];
     
     }
    // ClientVariable.EVENT_LISTENER_UTIL = new EventListenerUtil();
    // StyleConstant.initScreenConstant();
    // Next Menu Screen Activity Call here
    return true;
    
}
+(NSMutableDictionary*) makeMasterMap : (NSString*) userId
{
    ClientVariable* clientVariables = [ClientVariable getInstance : [DVAppDelegate currentModuleContext]];
	ClientMasterDetail* clientMasterDetail = clientVariables.CLIENT_MASTERDETAIL;
    NSMutableDictionary* clientMasterMap = clientMasterDetail.masterData;
    NSMutableDictionary* clientMasterRefershMap = clientMasterDetail.masterDataRefresh;
	[clientMasterMap setObject:userId forKey:@"USER_ID"];
	
    NSArray* keys = [clientMasterRefershMap allKeys];
		
    for(int i=0; i<[keys count]; i++)
	 {
		 NSString* keyMaster = [keys objectAtIndex:i];
         [clientMasterMap setObject:[clientMasterRefershMap objectForKey:keyMaster] forKey:keyMaster];
    }
    return clientMasterMap;
    
}


+(void) copyUserSpectoMaster
{   
    ClientVariable *clientVariables = [ClientVariable getInstance:[DVAppDelegate currentModuleContext]];
    
    NSMutableDictionary *userSpecData = clientVariables.CLIENT_MASTERDETAIL.masterDataRefresh;
    
    NSArray *keyOfUserSpecData = [userSpecData allKeys];
    for(int i = 0; i<[keyOfUserSpecData count];i++)
    {
        NSString *key = (NSString*) [keyOfUserSpecData objectAtIndex: i];
        [clientVariables.CLIENT_APP_MASTER_DATA setObject:[userSpecData objectForKey:key] forKey:key];
    }
	
}

+(void) setMaxDocNumber
{
    ClientVariable* clientVariables = [ClientVariable getInstance : [DVAppDelegate currentModuleContext]];
    clientVariables.MAX_DOC_ID_CREATED = [clientVariables.CLIENT_LOGIN_RESPONSE.maxUserDocNumber intValue];
    NSMutableDictionary* userLoginMaxNumber = [[ObjectStorage getInstance] readJsonObject :AppConst_STORAGE_MAX_DOC_ID];
	
  
    if (userLoginMaxNumber)
    {
        if([userLoginMaxNumber objectForKey:clientVariables.CLIENT_USER_LOGIN.userName] != userLoginMaxNumber)
        {
    		NSString* maxDocLocal = [userLoginMaxNumber objectForKey:clientVariables.CLIENT_USER_LOGIN.userName];
    		int maxLocalStoreValue;
            maxLocalStoreValue = [maxDocLocal intValue];
			if(maxLocalStoreValue > clientVariables.MAX_DOC_ID_CREATED)
            {
				clientVariables.MAX_DOC_ID_CREATED = maxLocalStoreValue;
			}
    	}
    } else {
        clientVariables.MAX_DOC_ID_CREATED = clientVariables.MAX_DOC_ID_CREATED + 1;
    	
    }
    [clientVariables.CLIENT_APP_MASTER_DATA setObject:clientVariables.CLIENT_USER_LOGIN.userName forKey:LangConst_USER_NAME];
    
}

@end
