//
//  RGUserRequestStorage.h
//  RateGain
//
//  Created by RateGain on 3/27/14.
//  Copyright (c) 2014 RateGain. All rights reserved.
//
#import "BaseDAO.h"
#import "NotificationRequestItem.h"

@interface NotificationRequestStorage : BaseDAO
{
    NSString* dbFileName;
	NSString* contextId;
	NSMutableArray* notificationList;
}

@property  NSString* dbFileName;
@property  NSString* contextId;
@property  NSMutableArray* notificationList;


-(id) initWithContext : (NSString*) inContextId : (NSString*) dbName;
-(BOOL) createTable;
-(NSString*) getTableName;


-(int) insertDoc : (NotificationRequestItem*) notificationRequest;
-(BOOL) deleteDoc : (int) docId;
-(BOOL) updateDoc : (NotificationRequestItem*) notificationRequest;
-(NSMutableArray*)  getRecentDocumentsData : (NSString *)delete_stringFlag;
-(NSMutableArray*)  getRecentDocuments  :(NSString *)notify_logId;
-(NSMutableArray*)  getRecentDocuments  : (BOOL) archived :(NSString *)propertyId_1 :(NSString*) propertyId_2 :(NSString*)lockTile;

//-(NSMutableArray*) getRecentDocuments : (NSString*) KEY_TITLE : (NSString*) KEY_URL;
-(NSMutableDictionary*) getRecentDocumentsAsMap : (NSString*) KEY_TITLE : (NSString*) KEY_URL;
-(NSMutableDictionary*) getMaxDocIdDocumentAsMap : (NSString*)  KEY_TITLE : (NSString*)  KEY_URL : (int) maxDocId;
-(NotificationRequestItem*) getDocument : (int) docId;
-(void) deleteData :  (NSString*) KEY_TITLE : (NSString*) KEY_URL ;//: (int) maxDocNo;
-(NotificationRequestItem*) retrieveItem : (sqlite3_stmt *) statement;
-(void) deleteRowData : (int) keyId;//added for RateGain Project
-(void) deleteTable; //added for Rategain Project
// static method
+ (void) createInstance : (NSString*) contextId :  (BOOL) isDefault;
+ (BOOL) isInitialized : (NSString*) contextId;
+ (NotificationRequestStorage*) getInstance;    // for default instance;
+ (NotificationRequestStorage*) getInstance : (NSString*) contextId;

-(NSMutableArray*)  getTotalUnreadCountOfCMSAlertRecentDocuments  : (BOOL) archived :(NSString *)propertyId_1 :(NSString*) propertyId_2 :(NSString*)lockTile : (NSString *)unRead;

@end