//
//  ClientVariable.h
//  QCMSProject
//
//  Created by Ashish Tiwari on 29/05/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "XmwUtils.h"
#import "ClientLoginResponse.h"
#import "ClientMasterDetail.h"
#import "LoginUtils.h"
#import "ClientUserLogin.h"
#import "DotFormDraw.h"


@interface ClientVariable : NSObject
{
@private
    ClientLoginResponse* CLIENT_LOGIN_RESPONSE;
    ClientMasterDetail* CLIENT_MASTERDETAIL; 
    NSMutableDictionary* CLIENT_APP_MASTER_DATA; 
    NSMutableDictionary* DOT_FORM_MAP;
    NSMutableDictionary* DOT_REPORT_MAP; 
    DotFormDraw* DOT_FORM_DRAW;
    
    int MAX_DOC_ID_CREATED;
    ClientUserLogin* CLIENT_USER_LOGIN;
   

}


@property ClientUserLogin* CLIENT_USER_LOGIN;
@property  ClientLoginResponse* CLIENT_LOGIN_RESPONSE;
@property ClientMasterDetail* CLIENT_MASTERDETAIL;
@property  NSMutableDictionary* CLIENT_APP_MASTER_DATA;
@property  NSMutableDictionary* DOT_FORM_MAP;
@property  NSMutableDictionary* DOT_REPORT_MAP;
@property  int MAX_DOC_ID_CREATED;
@property  DotFormDraw* DOT_FORM_DRAW;



+ (id) createInstance : (NSString *) contextId : (BOOL) isDefault;
+ (ClientVariable*) getInstance  : (NSString *) contextId;
+ (ClientVariable*) getInstance;


// handles for static objects

+ (NSMutableDictionary*) getQuoteMap;
+ (NSString*) getWriteAs;
+ (void) setWriteAs : (NSString*) inWriteAs;
+ (BOOL) getSpaceAllow;
+ (void) setSpaceAllow : (BOOL) inSpace;

-(void) registerFormVCClass:(NSString*) className forId:(NSString*) formId;
-(void) registerReportVCClass:(NSString*) className forId:(NSString*) reportId;
-(FormVC*) formVCForId:(NSString*) formId;
-(ReportVC*) reportVCForId:(NSString*) reportId;


@end
