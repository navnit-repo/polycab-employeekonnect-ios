//
//  ClientVariable.m
//  QCMSProject
//
//  Created by Ashish Tiwari on 29/05/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//
#import "ClientVariable.h"


// static variable
// LanguageMap not needed right now, using iOS Localizable.strings concept

static NSMutableDictionary* ClientVariable_QUOTE_MAP = nil;
static NSString* ClientVariable_WRITE_AS = @"";
static BOOL ClientVariable_SPACE_ALLOW = true;
static NSMutableDictionary* ClientVariable_INSTANCE_MAP = nil;
static ClientVariable* ClientVariable_DEFAULT_INSTANCE = nil;


@interface ClientVariable ()
{
    NSMutableDictionary* m_CustomFormVCMap;
    NSMutableDictionary* m_CustomReportVCMap;
}
@end


@implementation ClientVariable


@synthesize CLIENT_LOGIN_RESPONSE;
@synthesize CLIENT_MASTERDETAIL;
@synthesize CLIENT_APP_MASTER_DATA;
@synthesize DOT_FORM_MAP;
@synthesize DOT_REPORT_MAP;
@synthesize DOT_FORM_DRAW;
@synthesize MAX_DOC_ID_CREATED; 
@synthesize CLIENT_USER_LOGIN;



-(id)init {
    self = [super init];
    if (self) {
        m_CustomFormVCMap = [[NSMutableDictionary alloc] init];
        m_CustomReportVCMap = [[NSMutableDictionary alloc] init];
    }
    return self;
}


+ (id) createInstance  :(NSString *) contextId :(BOOL) isDefault
{
    ClientVariable *newInstance = [[ClientVariable alloc] init];
    
    if(ClientVariable_INSTANCE_MAP == nil )
    {
        ClientVariable_INSTANCE_MAP = [[NSMutableDictionary alloc] init];
    }
    
    [ClientVariable_INSTANCE_MAP setObject:newInstance forKey:contextId];
    
    if(isDefault) {
        ClientVariable_DEFAULT_INSTANCE = newInstance;
    }
    
    return newInstance;
}


+ (ClientVariable*) getInstance  : (NSString *) contextId {
    
    if(ClientVariable_INSTANCE_MAP != nil) {
        return [ClientVariable_INSTANCE_MAP objectForKey:contextId];
	}
	return nil;
}


+ (ClientVariable*) getInstance {
    return ClientVariable_DEFAULT_INSTANCE;
}

+ (void) removeInstance:(NSString *) contextId {
    if(ClientVariable_INSTANCE_MAP != nil) {
        [ClientVariable_INSTANCE_MAP removeObjectForKey:contextId];
    }
}
+ (NSMutableDictionary*) getQuoteMap {
    if(ClientVariable_QUOTE_MAP == nil) {
        ClientVariable_QUOTE_MAP = [[NSMutableDictionary alloc] init];
    }
     return ClientVariable_QUOTE_MAP;
}

+ (NSString*) getWriteAs {
    return ClientVariable_WRITE_AS;
}


+ (void) setWriteAs : (NSString*) inWriteAs
{
    ClientVariable_WRITE_AS = inWriteAs;
}


+ (BOOL) getSpaceAllow {
    return ClientVariable_SPACE_ALLOW;
}


+ (void) setSpaceAllow : (BOOL) inSpace
{
    ClientVariable_SPACE_ALLOW = inSpace;
}


-(void) registerFormVCClass:(NSString*) className forId:(NSString*) formId
{
    [m_CustomFormVCMap setObject:className forKey:formId];
}

-(void) registerReportVCClass:(NSString*) className forId:(NSString*) reportId
{
    [m_CustomReportVCMap setObject:className forKey:reportId];
}

-(FormVC*) formVCForId:(NSString*) formId
{
    FormVC* formVC = nil;
    
    NSString* className = [m_CustomFormVCMap objectForKey:formId];
    
    if(className!=nil) {
        formVC = [[NSClassFromString(className) alloc] init];
    } else {
        formVC = [[FormVC alloc] initWithNibName:FORMVC bundle:nil];
    }
    return formVC;
}


-(ReportVC*) reportVCForId:(NSString*) reportId
{
    ReportVC *reportVC = nil;
    NSString* className = [m_CustomReportVCMap objectForKey:reportId];
    
    if(className!=nil) {
        reportVC = [[NSClassFromString(className) alloc] init];
    } else {
        reportVC = [[ReportVC alloc] initWithNibName:REPORTVC bundle:nil];
    }
    return reportVC;
}

@end
