//
//  RecentRequestStorage.m
//  QCMSProject
//
//  Created by Pradeep Singh on 7/6/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//

#import "RecentRequestStorage.h"
#import "XmwcsConstant.h"

static NSMutableDictionary* INSTANCE_MAP = 0;
static RecentRequestStorage* DEFAULT_INSTANCE = 0;
static NSString* BASE_FOLDER = nil;


@implementation RecentRequestStorage


@synthesize dbFileName;
@synthesize contextId;
@synthesize recentList;


-(id) initWithContext : (NSString*) inContextId : (NSString*) dbName {
    self = [super initWithDBName:dbName];
    if(self !=nil) {
        self.contextId = inContextId;
        self.dbFileName = dbName;
    }
    return self;
}


-(BOOL) createTable {
    BOOL isSuccess = YES;
    
    NSString* query = @"CREATE TABLE IF NOT EXISTS ";
    query =  [query stringByAppendingString : [self getTableName]];
    query = [query stringByAppendingString : @"(itemRefId INTEGER PRIMARY KEY AUTOINCREMENT, "];
     query = [query stringByAppendingString : @"user TEXT, "];
     query = [query stringByAppendingString : @"module TEXT, "];
    query =  [query stringByAppendingString : @"maxDocNo TEXT, "];
    query =  [query stringByAppendingString : @"trackerNo TEXT, "];
    query =  [query stringByAppendingString : @"submitDate TEXT, "];
    query =  [query stringByAppendingString : @"status TEXT, "];
    query =  [query stringByAppendingString : @"formType TEXT, "];
    query =  [query stringByAppendingString : @"submittedResponse TEXT, "];
     query = [query stringByAppendingString : @"formId TEXT, "];
    query =  [query stringByAppendingString : @"dotFormPost TEXT); "];
    
    char *errMsg;
    const char *sql_stmt = [query UTF8String];
   
    if (sqlite3_exec([self sqlConnection], sql_stmt, NULL, NULL, &errMsg)
        != SQLITE_OK)
    {
        isSuccess = NO;
        NSLog(@"Failed to create table");
    }
    [self close];
    return isSuccess;
}


- (NSString*) getTableName {
	NSString* tableName = @"RECENT_REQUEST_";
   tableName = [tableName stringByAppendingString: contextId];
	return tableName;
}



-(int) insertDoc : (RecentRequestItem*) recentRequest {
    int insertId = -1;
  //  QSqlQuery sqlQuery(SQLConnection());
    
    NSString* query = @"INSERT INTO ";
   query =  [query stringByAppendingString : [self getTableName]];
   query = [query stringByAppendingString : @"(user, module, maxDocNo, trackerNo, submitDate, status, formType, submittedResponse, formId, dotFormPost) "];
   query = [query stringByAppendingString : @"VALUES(:user, :module, :maxDocNo, :trackerNo, :submitDate, :status, :formType, :submittedResponse, :formId, :dotFormPost);"];
    
    sqlite3_stmt *statement = nil;
    if (sqlite3_prepare_v2([self sqlConnection], [query UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, ":user"), [recentRequest.user UTF8String], recentRequest.user.length, nil);
        sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, ":module"), [recentRequest.module UTF8String], recentRequest.module.length, nil);
        sqlite3_bind_int(statement, sqlite3_bind_parameter_index(statement, ":maxDocNo"), recentRequest.maxDocNo);
        sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, ":trackerNo"), [recentRequest.trackerNo UTF8String], recentRequest.trackerNo.length, nil);
        sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, ":submitDate"), [recentRequest.submitDate UTF8String], recentRequest.submitDate.length, nil);
        sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, ":status"), [recentRequest.status UTF8String], recentRequest.status.length, nil);
        sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, ":formType"), [recentRequest.formType UTF8String], recentRequest.formType.length, nil);
        sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, ":submittedResponse"), [recentRequest.submittedResponse UTF8String], recentRequest.submittedResponse.length, nil);
        sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, ":formId"), [recentRequest.formId UTF8String], recentRequest.formId.length, nil);
        sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, ":dotFormPost"), [recentRequest.dotFormPost UTF8String], recentRequest.dotFormPost.length, nil);
        
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            insertId = (int)sqlite3_last_insert_rowid([self sqlConnection]);
        }
        sqlite3_finalize(statement);
        [self close];
    }
    return insertId;
}


-(BOOL) deleteDoc : (int) docId {    
    NSString* query = @"DELETE FROM ";
    [query stringByAppendingString : [self getTableName]];
    [query stringByAppendingString : @" WHERE itemRefId = :refid;"];
    
    sqlite3_stmt *statement = nil;
    if (sqlite3_prepare_v2([self sqlConnection], [query UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        sqlite3_bind_int(statement, sqlite3_bind_parameter_index(statement, ":refid"), docId);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_finalize(statement);
            [self close];
            return true;
        }
    }
    return false;
}

-(BOOL) updateDoc : (RecentRequestItem*) recentRequest {
    
    NSString* query = @"UPDATE ";
  query =  [query stringByAppendingString : [self getTableName]];
    
   query = [query stringByAppendingString : @" SET "];
  query =  [query stringByAppendingString : @" user = :user, "];
   query = [query stringByAppendingString : @" module = :module, "];
  query =  [query stringByAppendingString : @" maxDocNo = :maxDocNo, "];
   query = [query stringByAppendingString : @" trackerNo = :trackerNo, "];
   query = [query stringByAppendingString : @" submitDate = :submitDate, "];
   query = [query stringByAppendingString : @" status = :status, "];
   query = [query stringByAppendingString : @" formType = :formType, "];
  query =  [query stringByAppendingString : @" submittedResponse = :submittedResponse, "];
  query =  [query stringByAppendingString : @" formId = :formId, "];
  query =  [query stringByAppendingString : @" dotFormPost = :dotFormPost "];
  query =  [query stringByAppendingString : @" where itemRefId = :refid;"];
    
    
    sqlite3_stmt *statement = nil;
    if (sqlite3_prepare_v2([self sqlConnection], [query UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, ":user"), [recentRequest.user UTF8String], recentRequest.user.length, nil);
        sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, ":module"), [recentRequest.module UTF8String], recentRequest.module.length, nil);
        sqlite3_bind_int(statement, sqlite3_bind_parameter_index(statement, ":maxDocNo"), recentRequest.maxDocNo);
        sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, ":trackerNo"), [recentRequest.trackerNo UTF8String], recentRequest.trackerNo.length, nil);
        sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, ":submitDate"), [recentRequest.submitDate UTF8String], recentRequest.submitDate.length, nil);
        sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, ":status"), [recentRequest.status UTF8String], recentRequest.status.length, nil);
        sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, ":formType"), [recentRequest.formType UTF8String], recentRequest.formType.length, nil);
        sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, ":submittedResponse"), [recentRequest.submittedResponse UTF8String], recentRequest.submittedResponse.length, nil);
        sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, ":formId"), [recentRequest.formId UTF8String], recentRequest.formId.length, nil);
        sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, ":dotFormPost"), [recentRequest.dotFormPost UTF8String], recentRequest.dotFormPost.length, nil);

        sqlite3_bind_int(statement, sqlite3_bind_parameter_index(statement, ":refid"), recentRequest.itemRefId);
        
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_finalize(statement);
            [self close];
            return true;
        }
    }
    return false;
}

-(NSMutableArray*)  getRecentDocuments {
    NSMutableArray* list = [[NSMutableArray alloc] init];
    NSString* query = @"SELECT itemRefId, user, module, maxDocNo, trackerNo, submitDate, status, formType, submittedResponse, formId, dotFormPost from ";
        query = [query stringByAppendingString : [self getTableName]];
        query = [query stringByAppendingString : @";"];
    
    
    sqlite3_stmt *statement = nil;
    if (sqlite3_prepare_v2([self sqlConnection], [query UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        while(sqlite3_step(statement) == SQLITE_DONE) {
            [list addObject: [self retrieveItem : statement]];
        }
        sqlite3_finalize(statement);
        [self close];
    }
    return list;
}

-(RecentRequestItem*) getDocument : (int) docId {
    RecentRequestItem* recentItem = nil;

    NSString* query = @"SELECT itemRefId, user, module, maxDocNo, trackerNo, submitDate, status, formType, submittedResponse, formId, dotFormPost from ";
    [query stringByAppendingString : [self getTableName]];
    [query stringByAppendingString : @" where itemRefId = :refid;"];
    
    sqlite3_stmt *statement = nil;
    if (sqlite3_prepare_v2([self sqlConnection], [query UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        sqlite3_bind_int(statement, sqlite3_bind_parameter_index(statement, ":refid"), docId);
        
        if(sqlite3_step(statement) == SQLITE_DONE) {
            recentItem = [self retrieveItem : statement];
        }
        sqlite3_finalize(statement);
        [self close];
        return recentItem;
    }
    return nil;
}


- (RecentRequestItem*) retrieveItem : (sqlite3_stmt *) statement {
    RecentRequestItem* recentItem = [[RecentRequestItem alloc] init];
    
    recentItem.itemRefId = sqlite3_column_int(statement, 0);
    recentItem.user = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
    recentItem.module  = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
    recentItem.maxDocNo = sqlite3_column_int(statement, 3);
    recentItem.trackerNo  = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 4)];
    recentItem.submitDate  = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 5)];
    recentItem.status  = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 6)];
    recentItem.formType  = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 7)];
    recentItem.submittedResponse  = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 8)];
    recentItem.formId  = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 9)];
    recentItem.dotFormPost  = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 10)];
    
    return recentItem;
}


+ (void) createInstance : (NSString*) contextId :  (BOOL) isDefault {
    RecentRequestStorage* newInstance = nil;
	@try {
		// newInstance->fileStore = new QFile(RecentRequestStorage::BASE_FOLDER + contextId + ".sqlite.db");
		NSString* dbName = @"recentrequest.sqlite.db";
        newInstance = [[RecentRequestStorage alloc] initWithContext:contextId :dbName];
		[newInstance createTable];
    }
	@catch (NSException *exception)  {
        NSLog(@"RecentRequestStorage.createInstance = %@", [exception reason]);
    }
    
	if(INSTANCE_MAP == nil) {
		INSTANCE_MAP = [[NSMutableDictionary alloc] init];
	}

	[INSTANCE_MAP  setObject:newInstance  forKey: contextId ];
    
	if(isDefault) {
		DEFAULT_INSTANCE = newInstance;
	}
}


-(NSMutableArray*) getRecentDocuments : (NSString*) user : (NSString*) module {
    
     NSMutableArray* list = [[NSMutableArray alloc]init];
   
      //  QSqlQuery sqlQuery(SQLConnection());
    
    NSString* query = @"SELECT itemRefId, user, module, maxDocNo, trackerNo, submitDate, status, formType, submittedResponse, formId, dotFormPost from ";
    query = [query stringByAppendingString:[self getTableName]];
    query = [query stringByAppendingString:@" where user = ? and module = ?"];
    
    sqlite3_stmt *statement = nil;
    
    
    if (sqlite3_prepare_v2([self sqlConnection], [query UTF8String], -1, &statement, nil) != SQLITE_OK) {
        NSLog(@"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg([self sqlConnection]));
    } else {
        
        if (sqlite3_bind_text(statement, 1, [user UTF8String], -1, NULL) != SQLITE_OK) {
            NSLog(@"Error: failed to bind statement with message '%s'.", sqlite3_errmsg([self sqlConnection]));
        }
        
        if (sqlite3_bind_text(statement, 2, [module UTF8String], -1, NULL) != SQLITE_OK) {
            NSLog(@"Error: failed to bind statement with message '%s'.", sqlite3_errmsg([self sqlConnection]));
        }
        
        while (sqlite3_step(statement) == SQLITE_ROW) {
            [list addObject:[self retrieveItem:statement]];
        }
    }
    return list;

}

-(NSMutableDictionary*) getRecentDocumentsAsMap : (NSString*) user : (NSString*) module {
    
  
    NSMutableDictionary* map = [[NSMutableDictionary alloc]init];
    
    //QSqlQuery sqlQuery(SQLConnection());
    NSString* query = @"SELECT itemRefId, user, module, maxDocNo, trackerNo, submitDate, status, formType, submittedResponse, formId, dotFormPost from ";
   
    query = [query stringByAppendingString:[self getTableName]];
   
    query = [query stringByAppendingString:@" where user = :user and module = :module;"];
     sqlite3_stmt *statement = nil;
    
       
    if (sqlite3_prepare_v2([self sqlConnection], [query UTF8String], -1, &statement, nil) != SQLITE_OK) {
        NSLog(@"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg([self sqlConnection]));
    } else {
        
        if (sqlite3_bind_text(statement, 1, [user UTF8String], -1, NULL) != SQLITE_OK) {
            NSLog(@"Error: failed to bind statement with message '%s'.", sqlite3_errmsg([self sqlConnection]));
        }
        
        if (sqlite3_bind_text(statement, 2, [module UTF8String], -1, NULL) != SQLITE_OK) {
            NSLog(@"Error: failed to bind statement with message '%s'.", sqlite3_errmsg([self sqlConnection]));
        }
        
        while (sqlite3_step(statement) == SQLITE_ROW) {
            NSMutableDictionary* objectAsMap = [[NSMutableDictionary alloc]init];
                                  
            [objectAsMap setObject:[[NSNumber alloc]initWithInt:sqlite3_column_int(statement, 0)] forKey:@"itemRefId"];
        	
            [objectAsMap setObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)] forKey:@"user"];
        	
            [objectAsMap setObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)] forKey:@"module"];
        	[objectAsMap setObject:[[NSNumber alloc]initWithInt : sqlite3_column_int(statement, 3)] forKey:XmwcsConst_RECENT_REQ_MAX_DOC_ID];
            [objectAsMap setObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 4)] forKey:XmwcsConst_RECENT_REQ_TRACER_NO];
        	[objectAsMap setObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 5)] forKey:XmwcsConst_RECENT_REQ_DOC_SUBMIT_DATE];
        	[objectAsMap setObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 6)] forKey:XmwcsConst_RECENT_REQ_STATUS];
            [objectAsMap setObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 7)] forKey:XmwcsConst_RECENT_REQ_DOC_SUBMIT_MESSAGE];
            [objectAsMap setObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 8)] forKey:@"formType"];
            [objectAsMap setObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 9)] forKey:XmwcsConst_RECENT_REQ_FORM_ID];
        	[objectAsMap setObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 10)] forKey:@"dotFormPost"];
        	[objectAsMap setObject:@"Todo" forKey:XmwcsConst_RECENT_REQ_DOC_NAME];
            [map setObject:objectAsMap forKey:[[NSNumber alloc]initWithInt : sqlite3_column_int(statement, 3)]];         	
        }
    }
    return map;

    
}


-(NSMutableDictionary*) getMaxDocIdDocumentAsMap : (NSString*)  user : (NSString*)  module : (int) maxDocId {
    
    NSMutableDictionary* map = [[NSMutableDictionary alloc]init];
   // QSqlQuery sqlQuery(SQLConnection());
    NSString* query = @"SELECT itemRefId, user, module, maxDocNo, trackerNo, submitDate, status, formType, submittedResponse, formId, dotFormPost from ";
    query = [query stringByAppendingString:[self getTableName]];
    query = [query stringByAppendingString:@" where user = :user and module = :module and maxDocNo = :maxDocNo;"];
    
    sqlite3_stmt *statement = nil;
    
    
    if (sqlite3_prepare_v2([self sqlConnection], [query UTF8String], -1, &statement, nil) != SQLITE_OK) {
        NSLog(@"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg([self sqlConnection]));
    } else {
        
        if (sqlite3_bind_text(statement, 1, [user UTF8String], -1, NULL) != SQLITE_OK) {
            NSLog(@"Error: failed to bind statement with message '%s'.", sqlite3_errmsg([self sqlConnection]));
        }
        
        if (sqlite3_bind_text(statement, 2, [module UTF8String], -1, NULL) != SQLITE_OK) {
            NSLog(@"Error: failed to bind statement with message '%s'.", sqlite3_errmsg([self sqlConnection]));
        }
        
        if(sqlite3_bind_int(statement, sqlite3_bind_parameter_index(statement, ":maxDocNo"), maxDocId)!= SQLITE_OK){
            NSLog(@"Error: failed to bind statement with message '%s'.", sqlite3_errmsg([self sqlConnection]));
          
        }
        while (sqlite3_step(statement) == SQLITE_ROW) {
            [map setObject:[[NSNumber alloc]initWithInt : sqlite3_column_int(statement, 0)] forKey:@"itemRefId"];
           [map setObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)] forKey:@"user"];
           [map setObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)] forKey:@"module"];
            [map setObject:[[NSNumber alloc]initWithInt : sqlite3_column_int(statement, 3)] forKey:XmwcsConst_RECENT_REQ_MAX_DOC_ID];
        [map setObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 4)] forKey:XmwcsConst_RECENT_REQ_TRACER_NO];
        [map setObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 5)] forKey:XmwcsConst_RECENT_REQ_DOC_SUBMIT_DATE];
        [map setObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 6)] forKey:XmwcsConst_RECENT_REQ_STATUS];
        [map setObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 7)] forKey:XmwcsConst_RECENT_REQ_DOC_SUBMIT_MESSAGE];
        [map setObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 8)] forKey:@"formType"];
        [map setObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 9)] forKey:XmwcsConst_RECENT_REQ_FORM_ID];
        [map setObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 10)] forKey:@"dotFormPost"];
        [map setObject:@"Todo" forKey:XmwcsConst_RECENT_REQ_DOC_NAME];
        break;
        }
    }
    return map;
           
   }


-(void) deleteData : (NSString*) user : (NSString*) module : (int) maxDocNo {
    
   // QSqlQuery sqlQuery(SQLConnection());
    
	
    NSString* query = @"DELETE FROM";
    query = [query stringByAppendingString:[self getTableName]];
	query = [query stringByAppendingString:@" WHERE user = :user and module = :module and maxDocNo = :maxDocNo;"];
	
    sqlite3_stmt *statement = nil;
    
    
    if (sqlite3_prepare_v2([self sqlConnection], [query UTF8String], -1, &statement, nil) != SQLITE_OK) {
        NSLog(@"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg([self sqlConnection]));
    } else {
        
        if (sqlite3_bind_text(statement, 1, [user UTF8String], -1, NULL) != SQLITE_OK) {
            NSLog(@"Error: failed to bind statement with message '%s'.", sqlite3_errmsg([self sqlConnection]));
        }
        
        if (sqlite3_bind_text(statement, 2, [module UTF8String], -1, NULL) != SQLITE_OK) {
            NSLog(@"Error: failed to bind statement with message '%s'.", sqlite3_errmsg([self sqlConnection]));
        }
        if (sqlite3_bind_int(statement, 3, maxDocNo) != SQLITE_OK){
         NSLog(@"Error: failed to bind statement with message '%s'.", sqlite3_errmsg([self sqlConnection]));
        }
    }

        
    
}

+ (BOOL) isInitialized : (NSString*) contextId {
    if(INSTANCE_MAP!=nil) {
        if ([INSTANCE_MAP objectForKey:contextId] != nil) {
            return true;
        }
    }
    return false;
}


// for default instance;
+ (RecentRequestStorage*) getInstance {    
    return DEFAULT_INSTANCE;
}


+ (RecentRequestStorage*) getInstance : (NSString*) contextId {
    if(INSTANCE_MAP != nil) {
        return [INSTANCE_MAP objectForKey:contextId];
	}
    return nil;
}

@end
