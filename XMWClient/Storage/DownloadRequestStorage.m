//
//  DownloadRequestStorage.m
//  QCMSProject
//
//  Created by Pradeep Singh on 7/26/14.
//  Copyright (c) 2014 dotvik. All rights reserved.
//

#import "DownloadRequestStorage.h"


static DownloadRequestStorage* DEFAULT_INSTANCE = 0;
static NSString* BASE_FOLDER = nil;

@implementation DownloadRequestStorage

@synthesize dbFileName;
@synthesize recentList;



-(BOOL) createTable {
    BOOL isSuccess = YES;
    
    NSString* query = @"CREATE TABLE IF NOT EXISTS ";
    query =  [query stringByAppendingString : [self getTableName]];
    query = [query stringByAppendingString : @"(itemRefId INTEGER PRIMARY KEY AUTOINCREMENT, "];
    query = [query stringByAppendingString : @"username TEXT, "];
    query = [query stringByAppendingString : @"password TEXT, "];
    query =  [query stringByAppendingString : @"downloadURL TEXT, "];
    query =  [query stringByAppendingString : @"localFilePath TEXT, "];
    query =  [query stringByAppendingString : @"createDate TEXT, "];
    query =  [query stringByAppendingString : @"status TEXT, "];
    query =  [query stringByAppendingString : @"length TEXT, "];
    query =  [query stringByAppendingString : @"partial TEXT); "];
    
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
	NSString* tableName = @"DOWNLOAD_REQUEST";
	return tableName;
}



-(int) insertDoc : (DownloadItem*) item {
    int insertId = -1;
    //  QSqlQuery sqlQuery(SQLConnection());
    
    NSString* query = @"INSERT INTO ";
    query =  [query stringByAppendingString : [self getTableName]];
    query = [query stringByAppendingString : @"(username, password, downloadURL, localFilePath, createDate, status, length, partial) "];
    query = [query stringByAppendingString : @"VALUES(:username, :password, :downloadURL, :localFilePath, :createDate, :status, :length, :partial);"];
    
    sqlite3_stmt *statement = nil;
    if (sqlite3_prepare_v2([self sqlConnection], [query UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, ":username"), [item.username UTF8String], strlen([item.username UTF8String]), nil);
        
        sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, ":password"), [item.password UTF8String], strlen([item.password UTF8String]), nil);

        sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, ":downloadURL"), [item.downloadURL UTF8String], strlen([item.downloadURL UTF8String]), nil);

        sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, ":localFilePath"), [item.localFilePath UTF8String], strlen([item.localFilePath UTF8String]), nil);
        
        sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, ":createDate"), [item.createDate UTF8String], strlen([item.createDate UTF8String]), nil);
        
        sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, ":status"), [item.status UTF8String], strlen([item.status UTF8String]), nil);
        
        sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, ":length"), [item.length UTF8String], strlen([item.length UTF8String]), nil);
        
        sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, ":partial"), [item.partial UTF8String], strlen([item.partial UTF8String]), nil);
        
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

-(BOOL) updateDoc : (DownloadItem*) item {
    
    NSString* query = @"UPDATE ";
    query =  [query stringByAppendingString : [self getTableName]];

    query = [query stringByAppendingString : @" SET "];
    query =  [query stringByAppendingString : @" username = :username, "];
    query = [query stringByAppendingString : @" password = :password, "];
    query =  [query stringByAppendingString : @" downloadURL = :downloadURL, "];
    query = [query stringByAppendingString : @" localFilePath = :localFilePath, "];
    query = [query stringByAppendingString : @" createDate = :createDate, "];
    query = [query stringByAppendingString : @" status = :status, "];
    query = [query stringByAppendingString : @" length = :length, "];
    query =  [query stringByAppendingString : @" partial = :partial "];
    query =  [query stringByAppendingString : @" where itemRefId = :refid;"];
    
    
    sqlite3_stmt *statement = nil;
    if (sqlite3_prepare_v2([self sqlConnection], [query UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        
        sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, ":username"), [item.username UTF8String], strlen([item.username UTF8String]), nil);
         sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, ":password"), [item.password UTF8String], strlen([item.password UTF8String]), nil);
         sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, ":downloadURL"), [item.downloadURL UTF8String], strlen([item.downloadURL UTF8String]), nil);
         sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, ":localFilePath"), [item.localFilePath UTF8String], strlen([item.localFilePath UTF8String]), nil);
         sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, ":createDate"), [item.createDate UTF8String], strlen([item.createDate UTF8String]), nil);
         sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, ":status"), [item.status UTF8String], strlen([item.status UTF8String]), nil);
         sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, ":length"), [item.length UTF8String], strlen([item.length UTF8String]), nil);
        
         sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, ":partial"), [item.partial UTF8String], strlen([item.partial UTF8String]), nil);
        
        sqlite3_bind_int(statement, sqlite3_bind_parameter_index(statement, ":refid"), item.itemRefId);
        
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_finalize(statement);
            [self close];
            return true;
        }
    }
    return false;
}

-(NSMutableArray*)  getDownloadItems {
    NSMutableArray* list = [[NSMutableArray alloc] init];
    // username, password, downloadURL, localFilePath, createDate, status, length, partial
    NSString* query = @"SELECT itemRefId, username, password, downloadURL, localFilePath, createDate, createDate, status, length, partial from ";
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

-(DownloadItem*) getDocument : (int) docId {
    DownloadItem* item = nil;
    
    NSString* query = @"SELECT itemRefId, username, password, downloadURL, localFilePath, createDate, status, length, partial from ";
    [query stringByAppendingString : [self getTableName]];
    [query stringByAppendingString : @" where itemRefId = :refid;"];
    
    sqlite3_stmt *statement = nil;
    if (sqlite3_prepare_v2([self sqlConnection], [query UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        sqlite3_bind_int(statement, sqlite3_bind_parameter_index(statement, ":refid"), docId);
        
        if(sqlite3_step(statement) == SQLITE_DONE) {
            item = [self retrieveItem : statement];
        }
        sqlite3_finalize(statement);
        [self close];
        return item;
    }
    return nil;
}


- (DownloadItem*) retrieveItem : (sqlite3_stmt *) statement {
    DownloadItem* item = [[DownloadItem alloc] init];
    
    item.itemRefId = sqlite3_column_int(statement, 0);

    item.username = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
    item.password  = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
    item.downloadURL = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 3)];
    item.localFilePath  = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 4)];
    item.createDate  = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 5)];
    item.status  = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 6)];
    item.length  = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 7)];
    item.partial  = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 8)];

    return item;
}



+ (void) createInstance
{
    DownloadRequestStorage* newInstance = nil;
	@try {
		// newInstance->fileStore = new QFile(RecentRequestStorage::BASE_FOLDER + contextId + ".sqlite.db");
		NSString* dbName = @"downloadrequest.sqlite.db";
        newInstance = [[DownloadRequestStorage alloc] initWithDBName:dbName];
		[newInstance createTable];
    }
	@catch (NSException *exception)  {
        NSLog(@"DownloadRequestStorage.createInstance = %@", [exception reason]);
    }
    
    DEFAULT_INSTANCE = newInstance;
}


+ (BOOL) isInitialized {
    if(DEFAULT_INSTANCE!=nil) {
        return true;
    } else {
        return false;
    }
}


// for default instance;
+ (DownloadRequestStorage*) getInstance {
    return DEFAULT_INSTANCE;
}

@end
