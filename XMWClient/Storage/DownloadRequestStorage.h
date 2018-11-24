//
//  DownloadRequestStorage.h
//  QCMSProject
//
//  Created by Pradeep Singh on 7/26/14.
//  Copyright (c) 2014 dotvik. All rights reserved.
//

#import "BaseDAO.h"
#import "DownloadItem.h"

@interface DownloadRequestStorage : BaseDAO

@property  NSString* dbFileName;
@property  NSMutableArray* recentList;


-(BOOL) createTable;
-(NSString*) getTableName;

-(DownloadItem*) getDocument : (int) docId;
-(int) insertDoc : (DownloadItem*) item;
-(BOOL) deleteDoc : (int) docId;
-(BOOL) updateDoc : (DownloadItem*) item;
-(NSMutableArray*)  getDownloadItems;
-(DownloadItem*) retrieveItem : (sqlite3_stmt *) statement;


// static method
+ (void) createInstance;
+ (BOOL) isInitialized;
+ (DownloadRequestStorage*) getInstance;    // for default instance;

@end
