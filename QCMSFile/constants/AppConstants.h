//
//  AppConstants.h
//  QCMSProject
//
//  Created by Ashish Tiwari on 03/07/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppConstants : NSObject
{
    
}

FOUNDATION_EXPORT NSString *const AppConst_SERVICE_URL;  
//  static String SERVICE_URL = "http://dev.dotvik.com:8080/xmwcs_1/feed";
//  static String SERVICE_URL = "http://dev.dotvik.com:8080/xmwcs/feed";


FOUNDATION_EXPORT NSString *const AppConst_LANGUAGE_DEFAULT ;
FOUNDATION_EXPORT NSString *const AppConst_MOBILET_ID_DEFAULT ;
FOUNDATION_EXPORT NSString *const AppConst_STORAGE_CLIENT_ID ;
FOUNDATION_EXPORT NSString *const AppConst_STORAGE_MAX_DOC_ID ;
FOUNDATION_EXPORT NSString *const AppConst_STORAGE_KEY_XML ;

FOUNDATION_EXPORT NSString *const AppConst_STORAGE_KEY_MASTER ;
FOUNDATION_EXPORT NSString *const AppConst_STORAGE_DATA_UPDATE_TRACKER_MAP ;
FOUNDATION_EXPORT NSString *const AppConst_STORAGE_DATA_MAP ;
FOUNDATION_EXPORT NSString *const AppConst_IS_SUPPORT_MULTI_LANG ;

FOUNDATION_EXPORT int const AppConst_SCREEN_ID_SPLASH ;
FOUNDATION_EXPORT int const AppConst_SCREEN_ID_LOGIN ;
FOUNDATION_EXPORT int const AppConst_SCREEN_ID_MAIN_MENU ;
FOUNDATION_EXPORT int const AppConst_SCREEN_ID_SIMPLE_FORM ;
FOUNDATION_EXPORT int const AppConst_SCREEN_ID_REPORT ;
FOUNDATION_EXPORT int const AppConst_SCREEN_ID_APPLICATION ;

FOUNDATION_EXPORT int const AppConst_COMMAND_EXIT ;
FOUNDATION_EXPORT int const AppConst_COMMAND_BACK ;
FOUNDATION_EXPORT int const AppConst_COMMAND_ABOUT ;
FOUNDATION_EXPORT int const AppConst_COMMAND_CANCEL;
FOUNDATION_EXPORT int const AppConst_COMMAND_LOGOUT ;

FOUNDATION_EXPORT NSString *const AppConst_COMMAND_TEXT_BACK ;
FOUNDATION_EXPORT NSString *const AppConst_COMMAND_TEXT_EXIT ;
FOUNDATION_EXPORT NSString *const AppConst_COMMAND_TEXT_CANCEL ;
FOUNDATION_EXPORT NSString *const AppConst_COMMAND_TEXT_LOGOUT ;


FOUNDATION_EXPORT NSString *const AppConst_MAIN_MENU_SCREEN_TITLE ;
FOUNDATION_EXPORT NSString *const AppConst_SIMPLESCREEN_TITLE ;



@end
