//
//  RecentRequestStorage.h
//  QCMSProject
//
//  Created by Pradeep Singh on 7/6/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseDAO.h"
#import "RecentRequestItem.h"

@interface RecentRequestStorage : BaseDAO
{
    NSString* dbFileName;
	NSString* contextId;
	NSMutableArray* recentList;
}

@property  NSString* dbFileName;
@property  NSString* contextId;
@property  NSMutableArray* recentList;


-(id) initWithContext : (NSString*) inContextId : (NSString*) dbName;
-(BOOL) createTable;
-(NSString*) getTableName;


-(int) insertDoc : (RecentRequestItem*) recentRequest;
-(BOOL) deleteDoc : (int) docId;
-(BOOL) updateDoc : (RecentRequestItem*) recentRequest;
-(NSMutableArray*)  getRecentDocuments;
-(NSMutableArray*) getRecentDocuments : (NSString*) user : (NSString*) module;
-(NSMutableDictionary*) getRecentDocumentsAsMap : (NSString*) user : (NSString*) module;
-(NSMutableDictionary*) getMaxDocIdDocumentAsMap : (NSString*)  user : (NSString*)  module : (int) maxDocId;
-(RecentRequestItem*) getDocument : (int) docId;
-(void) deleteData : (NSString*) user : (NSString*) module : (int) maxDocNo;
-(RecentRequestItem*) retrieveItem : (sqlite3_stmt *) statement;


// static method
+ (void) createInstance : (NSString*) contextId :  (BOOL) isDefault;
+ (BOOL) isInitialized : (NSString*) contextId;
+ (RecentRequestStorage*) getInstance;    // for default instance;
+ (RecentRequestStorage*) getInstance : (NSString*) contextId;

@end
