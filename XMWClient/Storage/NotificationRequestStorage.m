//
//  RGUserRequestStorage.m
//  RateGain
//
//  Created by RateGain on 3/27/14.
//  Copyright (c) 2014 RateGain. All rights reserved.
//

#import "NotificationRequestStorage.h"

static NSMutableDictionary* INSTANCE_MAP = 0;
static NotificationRequestStorage* DEFAULT_INSTANCE = 0;
static NSString* BASE_FOLDER = nil;

@implementation NotificationRequestStorage

@synthesize dbFileName;
@synthesize contextId;
@synthesize notificationList;

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
    query = [query stringByAppendingString : @"(KEY_ID INTEGER PRIMARY KEY AUTOINCREMENT, "];
    query = [query stringByAppendingString : @"KEY_READ TEXT, "];
    query = [query stringByAppendingString : @"KEY_DELETE TEXT, "];
    query =  [query stringByAppendingString : @"KEY_NOTIFY_CONTENT_TYPE TEXT, "];
    query =  [query stringByAppendingString : @"KEY_NOTIFY_CONTENT_TITLE TEXT, "];
    query =  [query stringByAppendingString : @"KEY_NOTIFY_COTENT_MSG TEXT, "];
    query =  [query stringByAppendingString : @"KEY_NOTIFY_CONTENT_URL TEXT, "];
    query =  [query stringByAppendingString : @"KEY_NOTIFY_CONTENT_DATA TEXT, "];
    query =  [query stringByAppendingString : @"KEY_NOTIFY_CALLBACK_DATA TEXT, "];
    query =  [query stringByAppendingString : @"KEY_NOTIFY_FIELD1 TEXT, "];
    query = [query stringByAppendingString : @"KEY_NOTIFY_FIELD2 TEXT, "];
    query =  [query stringByAppendingString : @"KEY_RESPOND_TO_BACK TEXT, "];
    query =  [query stringByAppendingString : @"KEY_REQUIRE_LOGIN TEXT, "];
    query =  [query stringByAppendingString : @"KEY_NOTIFY_CREATE_DATE TEXT, "];
    query =  [query stringByAppendingString : @"KEY_NOTIFY_LOGID TEXT, "];
    query =  [query stringByAppendingString : @"KEY_CALLNAME TEXT, "];
    
    query =  [query stringByAppendingString : @"REC_TS DATETIME DEFAULT CURRENT_TIMESTAMP); "];     // adding Timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
    
    char *errMsg;
    const char *sql_stmt = [query UTF8String];
    
    if (sqlite3_exec([self sqlConnection], sql_stmt, NULL, NULL, &errMsg)
        != SQLITE_OK)
    {
        isSuccess = NO;
        //NSLog(@"Failed to create table");
    }
    [self close];
    return isSuccess;
}


- (NSString*) getTableName {
	NSString* tableName = @"NOTIFICATION";
    tableName = [tableName stringByAppendingString: contextId];
	return tableName;
}



-(int) insertDoc : (NotificationRequestItem*) notificationRequest {
    int insertId = -1;
    //  QSqlQuery sqlQuery(SQLConnection());
    
    NSString* query = @"INSERT INTO ";
    query =  [query stringByAppendingString : [self getTableName]];
    query = [query stringByAppendingString : @"(KEY_READ, KEY_DELETE, KEY_NOTIFY_CONTENT_TYPE, KEY_NOTIFY_CONTENT_TITLE, KEY_NOTIFY_COTENT_MSG, KEY_NOTIFY_CONTENT_URL, KEY_NOTIFY_CONTENT_DATA, KEY_NOTIFY_CALLBACK_DATA, KEY_NOTIFY_FIELD1, KEY_NOTIFY_FIELD2, KEY_RESPOND_TO_BACK, KEY_REQUIRE_LOGIN, KEY_NOTIFY_CREATE_DATE, KEY_NOTIFY_LOGID, KEY_CALLNAME) "];
    query = [query stringByAppendingString : @"VALUES(:KEY_READ, :KEY_DELETE, :KEY_NOTIFY_CONTENT_TYPE, :KEY_NOTIFY_CONTENT_TITLE, :KEY_NOTIFY_COTENT_MSG, :KEY_NOTIFY_CONTENT_URL, :KEY_NOTIFY_CONTENT_DATA, :KEY_NOTIFY_CALLBACK_DATA, :KEY_NOTIFY_FIELD1, :KEY_NOTIFY_FIELD2, :KEY_RESPOND_TO_BACK, :KEY_REQUIRE_LOGIN, :KEY_NOTIFY_CREATE_DATE, :KEY_NOTIFY_LOGID, :KEY_CALLNAME);"];
    
    sqlite3_stmt *statement = nil;
    if (sqlite3_prepare_v2([self sqlConnection], [query UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, ":KEY_READ"), [notificationRequest.KEY_READ UTF8String], notificationRequest.KEY_READ.length, nil);
        sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, ":KEY_DELETE"), [notificationRequest.KEY_DELETE UTF8String], notificationRequest.KEY_DELETE.length, nil);
        //sqlite3_bind_int(statement, sqlite3_bind_parameter_index(statement, ":maxDocNo"), recentRequest.maxDocNo);
        sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, ":KEY_NOTIFY_CONTENT_TYPE"), [notificationRequest.KEY_NOTIFY_CONTENT_TYPE UTF8String], notificationRequest.KEY_NOTIFY_CONTENT_TYPE.length, nil);
        sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, ":KEY_NOTIFY_CONTENT_TITLE"), [notificationRequest.KEY_NOTIFY_CONTENT_TITLE UTF8String], notificationRequest.KEY_NOTIFY_CONTENT_TITLE.length, nil);
        sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, ":KEY_NOTIFY_COTENT_MSG"), [notificationRequest.KEY_NOTIFY_COTENT_MSG UTF8String], notificationRequest.KEY_NOTIFY_COTENT_MSG.length, nil);
        sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, ":KEY_NOTIFY_CONTENT_URL"), [notificationRequest.KEY_NOTIFY_CONTENT_URL UTF8String], notificationRequest.KEY_NOTIFY_CONTENT_URL.length, nil);
        sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, ":KEY_NOTIFY_CONTENT_DATA"), [notificationRequest.KEY_NOTIFY_CONTENT_DATA UTF8String], notificationRequest.KEY_NOTIFY_CONTENT_DATA.length, nil);
        sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, ":KEY_NOTIFY_CALLBACK_DATA"), [notificationRequest.KEY_NOTIFY_CALLBACK_DATA UTF8String], notificationRequest.KEY_NOTIFY_CALLBACK_DATA.length, nil);
        sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, ":KEY_NOTIFY_FIELD1"), [notificationRequest.KEY_NOTIFY_FIELD1 UTF8String], notificationRequest.KEY_NOTIFY_FIELD1.length, nil);
        sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, ":KEY_NOTIFY_FIELD2"), [notificationRequest.KEY_NOTIFY_FIELD2 UTF8String], notificationRequest.KEY_NOTIFY_FIELD2.length, nil);
        sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, ":KEY_RESPOND_TO_BACK"), [notificationRequest.KEY_RESPOND_TO_BACK UTF8String], notificationRequest.KEY_RESPOND_TO_BACK.length, nil);
        sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, ":KEY_REQUIRE_LOGIN"), [notificationRequest.KEY_REQUIRE_LOGIN UTF8String], notificationRequest.KEY_REQUIRE_LOGIN.length, nil);
        sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, ":KEY_NOTIFY_CREATE_DATE"), [notificationRequest.KEY_NOTIFY_CREATE_DATE UTF8String], notificationRequest.KEY_NOTIFY_CREATE_DATE.length, nil);
        sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, ":KEY_NOTIFY_LOGID"), [notificationRequest.KEY_NOTIFY_LOGID UTF8String], notificationRequest.KEY_NOTIFY_LOGID.length, nil);
        sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, ":KEY_CALLNAME"), [notificationRequest.KEY_CALLNAME UTF8String], notificationRequest.KEY_CALLNAME.length, nil);
        
        
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            insertId = (int)sqlite3_last_insert_rowid([self sqlConnection]);
        }
        sqlite3_finalize(statement);
        [self close];
    }
    else
    {
        NSLog(@"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg([self sqlConnection]));
    }
    return insertId;
}


-(BOOL) deleteDoc : (int) docId {
    NSString* query = @"DELETE FROM ";
    [query stringByAppendingString : [self getTableName]];
    [query stringByAppendingString : @" WHERE KEY_ID = :keyid;"];
    
    sqlite3_stmt *statement = nil;
    if (sqlite3_prepare_v2([self sqlConnection], [query UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        sqlite3_bind_int(statement, sqlite3_bind_parameter_index(statement, ":keyid"), docId);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_finalize(statement);
            [self close];
            return true;
        }
    }
    return false;
}


-(BOOL) updateDoc : (NotificationRequestItem*) notificationRequest;
{
    
    NSString* query = @"UPDATE ";
    query =  [query stringByAppendingString : [self getTableName]];
    
    query = [query stringByAppendingString : @" SET "];
    query =  [query stringByAppendingString : @" KEY_READ = :KEY_READ, "];
    query = [query stringByAppendingString : @" KEY_DELETE = :KEY_DELETE, "];
    query =  [query stringByAppendingString : @" KEY_NOTIFY_CONTENT_TYPE = :KEY_NOTIFY_CONTENT_TYPE, "];
    query = [query stringByAppendingString : @" KEY_NOTIFY_CONTENT_TITLE = :KEY_NOTIFY_CONTENT_TITLE, "];
    query = [query stringByAppendingString : @" KEY_NOTIFY_COTENT_MSG = :KEY_NOTIFY_COTENT_MSG, "];
    query = [query stringByAppendingString : @" KEY_NOTIFY_CONTENT_URL = :KEY_NOTIFY_CONTENT_URL, "];
    query = [query stringByAppendingString : @" KEY_NOTIFY_CONTENT_DATA = :KEY_NOTIFY_CONTENT_DATA, "];
    query =  [query stringByAppendingString : @" KEY_NOTIFY_CALLBACK_DATA = :KEY_NOTIFY_CALLBACK_DATA, "];
    query =  [query stringByAppendingString : @" KEY_NOTIFY_FIELD1 = :KEY_NOTIFY_FIELD1, "];
    query =  [query stringByAppendingString : @" KEY_NOTIFY_FIELD2 = :KEY_NOTIFY_FIELD2, "];
    query =  [query stringByAppendingString : @" KEY_RESPOND_TO_BACK = :KEY_RESPOND_TO_BACK, "];
    query =  [query stringByAppendingString : @" KEY_REQUIRE_LOGIN = :KEY_REQUIRE_LOGIN, "];
    query =  [query stringByAppendingString : @" KEY_NOTIFY_CREATE_DATE = :KEY_NOTIFY_CREATE_DATE, "];
    query =  [query stringByAppendingString : @" KEY_NOTIFY_LOGID = :KEY_NOTIFY_LOGID, "];
    query =  [query stringByAppendingString : @" KEY_CALLNAME = :KEY_CALLNAME "];
    query =  [query stringByAppendingString : @" where KEY_ID = :keyid;"];
    
    
    sqlite3_stmt *statement = nil;
    if (sqlite3_prepare_v2([self sqlConnection], [query UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, ":KEY_READ"), [notificationRequest.KEY_READ UTF8String], notificationRequest.KEY_READ.length, nil);
        sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, ":KEY_DELETE"), [notificationRequest.KEY_DELETE UTF8String], notificationRequest.KEY_DELETE.length, nil);
        //sqlite3_bind_int(statement, sqlite3_bind_parameter_index(statement, ":maxDocNo"), recentRequest.maxDocNo);
        sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, ":KEY_NOTIFY_CONTENT_TYPE"), [notificationRequest.KEY_NOTIFY_CONTENT_TYPE UTF8String], notificationRequest.KEY_NOTIFY_CONTENT_TYPE.length, nil);
        sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, ":KEY_NOTIFY_CONTENT_TITLE"), [notificationRequest.KEY_NOTIFY_CONTENT_TITLE UTF8String], notificationRequest.KEY_NOTIFY_CONTENT_TITLE.length, nil);
        sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, ":KEY_NOTIFY_COTENT_MSG"), [notificationRequest.KEY_NOTIFY_COTENT_MSG UTF8String], notificationRequest.KEY_NOTIFY_COTENT_MSG.length, nil);
        sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, ":KEY_NOTIFY_CONTENT_URL"), [notificationRequest.KEY_NOTIFY_CONTENT_URL UTF8String], notificationRequest.KEY_NOTIFY_CONTENT_URL.length, nil);
        sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, ":KEY_NOTIFY_CONTENT_DATA"), [notificationRequest.KEY_NOTIFY_CONTENT_DATA UTF8String], notificationRequest.KEY_NOTIFY_CONTENT_DATA.length, nil);
        sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, ":KEY_NOTIFY_CALLBACK_DATA"), [notificationRequest.KEY_NOTIFY_CALLBACK_DATA UTF8String], notificationRequest.KEY_NOTIFY_CALLBACK_DATA.length, nil);
        sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, ":KEY_NOTIFY_FIELD1"), [notificationRequest.KEY_NOTIFY_FIELD1 UTF8String], notificationRequest.KEY_NOTIFY_FIELD1.length, nil);
        sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, ":KEY_NOTIFY_FIELD2"), [notificationRequest.KEY_NOTIFY_FIELD2 UTF8String], notificationRequest.KEY_NOTIFY_FIELD2.length, nil);
        sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, ":KEY_RESPOND_TO_BACK"), [notificationRequest.KEY_RESPOND_TO_BACK UTF8String], notificationRequest.KEY_RESPOND_TO_BACK.length, nil);
        sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, ":KEY_REQUIRE_LOGIN"), [notificationRequest.KEY_REQUIRE_LOGIN UTF8String], notificationRequest.KEY_REQUIRE_LOGIN.length, nil);
        sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, ":KEY_NOTIFY_CREATE_DATE"), [notificationRequest.KEY_NOTIFY_CREATE_DATE UTF8String], notificationRequest.KEY_NOTIFY_CREATE_DATE.length, nil);
        sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, ":KEY_NOTIFY_LOGID"), [notificationRequest.KEY_NOTIFY_LOGID UTF8String], notificationRequest.KEY_NOTIFY_LOGID.length, nil);
        sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, ":KEY_CALLNAME"), [notificationRequest.KEY_CALLNAME UTF8String], notificationRequest.KEY_CALLNAME.length, nil);
        
        sqlite3_bind_int(statement, sqlite3_bind_parameter_index(statement, ":keyid"), notificationRequest.KEY_ID);
        
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_finalize(statement);
            [self close];
            return true;
        }
    }
    else {
        //NSLog(@"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg([self sqlConnection]));
    }

    return false;
}


-(NSMutableArray*)  getRecentDocumentsData : (NSString *)delete_stringFlag
{
    NSMutableArray* list = [[NSMutableArray alloc] init];
    NSString* query = @"SELECT KEY_ID, KEY_READ, KEY_DELETE, KEY_NOTIFY_CONTENT_TYPE, KEY_NOTIFY_CONTENT_TITLE, KEY_NOTIFY_COTENT_MSG, KEY_NOTIFY_CONTENT_URL, KEY_NOTIFY_CONTENT_DATA, KEY_NOTIFY_CALLBACK_DATA, KEY_NOTIFY_FIELD1, KEY_NOTIFY_FIELD2, KEY_RESPOND_TO_BACK, KEY_REQUIRE_LOGIN, KEY_NOTIFY_CREATE_DATE, KEY_NOTIFY_LOGID, KEY_CALLNAME from ";
    query = [query stringByAppendingString : [self getTableName]];
    
   // query = [query stringByAppendingString : @" ;"];
     query =[query stringByAppendingString : @" where KEY_DELETE = :id1 order by datetime(REC_TS) DESC;"];
    
    
    sqlite3_stmt *statement = nil;
    if (sqlite3_prepare_v2([self sqlConnection], [query UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, ":id1"), [delete_stringFlag UTF8String], delete_stringFlag.length, nil);
        while(sqlite3_step(statement) == SQLITE_ROW) {
            [list addObject: [self retrieveItem : statement]];
        }
        sqlite3_finalize(statement);
        [self close];
    }
    else{
        NSLog(@"Error: Property Message '%s'.", sqlite3_errmsg([self sqlConnection]));
    }
    return list;
}


-(NSMutableArray*)  getRecentDocuments  :(NSString *)notify_logId
{
    NSMutableArray* list = [[NSMutableArray alloc] init];
    NSString* query =  @"SELECT KEY_ID, KEY_READ, KEY_DELETE, KEY_NOTIFY_CONTENT_TYPE, KEY_NOTIFY_CONTENT_TITLE, KEY_NOTIFY_COTENT_MSG, KEY_NOTIFY_CONTENT_URL, KEY_NOTIFY_CONTENT_DATA, KEY_NOTIFY_CALLBACK_DATA, KEY_NOTIFY_FIELD1, KEY_NOTIFY_FIELD2, KEY_RESPOND_TO_BACK, KEY_REQUIRE_LOGIN, KEY_NOTIFY_CREATE_DATE, KEY_NOTIFY_LOGID, KEY_CALLNAME from ";
    query = [query stringByAppendingString : [self getTableName]];
    
    query =[query stringByAppendingString : @" where KEY_NOTIFY_LOGID = :id1 order by datetime(REC_TS) DESC;"];
   
    
    
    
    sqlite3_stmt *statement = nil;
    if (sqlite3_prepare_v2([self sqlConnection], [query UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, ":id1"), [notify_logId UTF8String], notify_logId.length, nil);
        while(sqlite3_step(statement) == SQLITE_ROW) {
            [list addObject: [self retrieveItem : statement]];
        }
        sqlite3_finalize(statement);
        [self close];
        
    }
    else {
        //NSLog(@"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg([self sqlConnection]));
    }
    return list;
}
-(NSMutableArray*)  getRecentDocuments  : (BOOL) archived :(NSString *)propertyId_1 :(NSString*) propertyId_2 :(NSString*)lockTile
{
    NSMutableArray* list = [[NSMutableArray alloc] init];
    NSString* query = @"SELECT KEY_ID, KEY_TITLE, KEY_URL, KEY_TIME, KEY_TYPE, KEY_STATUS_ARCHIVE, KEY_DATE, KEY_READ, KEY_ICON, KEY_PROPERTY_ID, KEY_DESC, KEY_LOCK, KEY_RECEIVED_DATE, KEY_NOTIFY_CREATE_DATE, KEY_NOTIFY_LOGID, KEY_ALERT_REQUEST_TYPE from ";
    query = [query stringByAppendingString : [self getTableName]];
    if(archived ==true )
    {
        query =[query stringByAppendingString : @" where KEY_STATUS_ARCHIVE = 'Archived' and (KEY_PROPERTY_ID = :id1 or  KEY_PROPERTY_ID = :id2) and KEY_LOCK = :lockTile order by datetime(REC_TS) DESC;"];    //
    }
    if(archived ==false)
    {
        query =[query stringByAppendingString : @" where KEY_STATUS_ARCHIVE = 'NonArchive' and (KEY_PROPERTY_ID = :id1 or  KEY_PROPERTY_ID = :id2) and KEY_LOCK = :lockTile order by datetime(REC_TS) DESC;"];
    }
    //query = [query stringByAppendingString : @";"];
    
    
    sqlite3_stmt *statement = nil;
    if (sqlite3_prepare_v2([self sqlConnection], [query UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, ":id1"), [propertyId_1 UTF8String], propertyId_1.length, nil);
        sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, ":id2"), [propertyId_2 UTF8String], propertyId_2.length, nil);
        sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, ":lockTile"), [lockTile UTF8String], lockTile.length, nil);
        while(sqlite3_step(statement) == SQLITE_ROW) {
            [list addObject: [self retrieveItem : statement]];
        }
        sqlite3_finalize(statement);
        [self close];
    }
    else {
        //NSLog(@"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg([self sqlConnection]));
    }
    return list;
}
-(NSMutableArray*)  getTotalUnreadCountOfCMSAlertRecentDocuments  : (BOOL) archived :(NSString *)propertyId_1 :(NSString*) propertyId_2 :(NSString*)lockTile : (NSString *)unRead
{
    NSMutableArray* list = [[NSMutableArray alloc] init];
    NSString* query = @"SELECT KEY_ID, KEY_TITLE, KEY_URL, KEY_TIME, KEY_TYPE, KEY_STATUS_ARCHIVE, KEY_DATE, KEY_READ, KEY_ICON, KEY_PROPERTY_ID, KEY_DESC, KEY_LOCK, KEY_RECEIVED_DATE, KEY_NOTIFY_CREATE_DATE, KEY_NOTIFY_LOGID, KEY_ALERT_REQUEST_TYPE from ";
    query = [query stringByAppendingString : [self getTableName]];
    if(archived ==true )
    {
        query =[query stringByAppendingString : @" where KEY_STATUS_ARCHIVE = 'Archived' and (KEY_PROPERTY_ID = :id1 or  KEY_PROPERTY_ID = :id2) and KEY_LOCK = :lockTile and KEY_READ = :unRead order by datetime(REC_TS) DESC;"];    //
    }
    if(archived ==false)
    {
        query =[query stringByAppendingString : @" where KEY_STATUS_ARCHIVE = 'NonArchive' and (KEY_PROPERTY_ID = :id1 or  KEY_PROPERTY_ID = :id2) and KEY_LOCK = :lockTile and KEY_READ = :unRead order by datetime(REC_TS) DESC;"];
    }
    //query = [query stringByAppendingString : @";"];
    
    
    sqlite3_stmt *statement = nil;
    if (sqlite3_prepare_v2([self sqlConnection], [query UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, ":id1"), [propertyId_1 UTF8String], propertyId_1.length, nil);
        sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, ":id2"), [propertyId_2 UTF8String], propertyId_2.length, nil);
        sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, ":lockTile"), [lockTile UTF8String], lockTile.length, nil);
        sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, ":unRead"), [unRead UTF8String], unRead.length, nil);
        while(sqlite3_step(statement) == SQLITE_ROW) {
            [list addObject: [self retrieveItem : statement]];
        }
        sqlite3_finalize(statement);
        [self close];
    }
    else {
        //NSLog(@"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg([self sqlConnection]));
    }
    return list;
}

-(NotificationRequestItem*) getDocument : (int) docId {
    NotificationRequestItem* notificationItem = nil;
    
    NSString* query = @"SELECT KEY_ID, KEY_TITLE, KEY_URL, KEY_TIME, KEY_TYPE, KEY_STATUS_ARCHIVE, KEY_DATE, KEY_READ, KEY_ICON, KEY_PROPERTY_ID, KEY_DESC, KEY_LOCK, KEY_RECEIVED_DATE, KEY_NOTIFY_CREATE_DATE, KEY_NOTIFY_LOGID, KEY_ALERT_REQUEST_TYPE from ";
    [query stringByAppendingString : [self getTableName]];
    [query stringByAppendingString : @" where KEY_ID = :keyid;"];
    
    sqlite3_stmt *statement = nil;
    if (sqlite3_prepare_v2([self sqlConnection], [query UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        sqlite3_bind_int(statement, sqlite3_bind_parameter_index(statement, ":keyid"), docId);
        
        if(sqlite3_step(statement) == SQLITE_DONE) {
            notificationItem = [self retrieveItem : statement];
        }
        sqlite3_finalize(statement);
        [self close];
        return notificationItem;
    }
    return nil;
}



- (NotificationRequestItem*) retrieveItem : (sqlite3_stmt *) statement {
    NotificationRequestItem* notificationItem = [[NotificationRequestItem alloc] init];
    
    notificationItem.KEY_ID = sqlite3_column_int(statement, 0);
    notificationItem.KEY_READ = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
    notificationItem.KEY_DELETE  = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
    notificationItem.KEY_NOTIFY_CONTENT_TYPE  = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 3)];
    notificationItem.KEY_NOTIFY_CONTENT_TITLE  = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 4)];
    notificationItem.KEY_NOTIFY_COTENT_MSG  = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 5)];
    notificationItem.KEY_NOTIFY_CONTENT_URL  = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 6)];
    notificationItem.KEY_NOTIFY_CONTENT_DATA  = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 7)];
    notificationItem.KEY_NOTIFY_CALLBACK_DATA  = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 8)];
    notificationItem.KEY_NOTIFY_FIELD1  = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 9)];
    notificationItem.KEY_NOTIFY_FIELD2  = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 10)];
    notificationItem.KEY_RESPOND_TO_BACK  = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 11)];
    notificationItem.KEY_REQUIRE_LOGIN  = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 12)];
    notificationItem.KEY_NOTIFY_CREATE_DATE  = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 13)];
    notificationItem.KEY_NOTIFY_LOGID  = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 14)];
    notificationItem.KEY_CALLNAME  = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 15)];
    
    return notificationItem;
}


+ (void) createInstance : (NSString*) contextId :  (BOOL) isDefault {
    NotificationRequestStorage* newInstance = nil;
	@try {
		// newInstance->fileStore = new QFile(RecentRequestStorage::BASE_FOLDER + contextId + ".sqlite.db");
		NSString* dbName = @"NotificationStorage.sqlite.db";
        newInstance = [[NotificationRequestStorage alloc] initWithContext:contextId :dbName];
		[newInstance createTable];
    }
	@catch (NSException *exception)  {
        //NSLog(@"RequestStorage.createInstance = %@", [exception reason]);
    }
    
	if(INSTANCE_MAP == nil) {
		INSTANCE_MAP = [[NSMutableDictionary alloc] init];
	}
    
	[INSTANCE_MAP  setObject:newInstance  forKey: contextId ];
    
	if(isDefault) {
		DEFAULT_INSTANCE = newInstance;
	}
}


-(NSMutableDictionary*) getRecentDocumentsAsMap : (NSString*) KEY_TITLE : (NSString*) KEY_URL {
    
    
    NSMutableDictionary* map = [[NSMutableDictionary alloc]init];
    
    //QSqlQuery sqlQuery(SQLConnection());
    NSString* query = @"SELECT KEY_ID, KEY_TITLE, KEY_URL, KEY_TIME, KEY_TYPE, KEY_STATUS_ARCHIVE, KEY_DATE, KEY_READ, KEY_ICON, KEY_PROPERTY_ID, KEY_DESC, KEY_LOCK, KEY_RECEIVED_DATE, KEY_NOTIFY_CREATE_DATE, KEY_NOTIFY_LOGID, KEY_ALERT_REQUEST_TYPE from ";
    
    
    query = [query stringByAppendingString:[self getTableName]];
    
    query = [query stringByAppendingString:@" where KEY_TITLE = :KEY_TITLE and KEY_URL = :KEY_URL;"];
    sqlite3_stmt *statement = nil;
    
    
    if (sqlite3_prepare_v2([self sqlConnection], [query UTF8String], -1, &statement, nil) != SQLITE_OK) {
        //NSLog(@"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg([self sqlConnection]));
    } else {
        
        if (sqlite3_bind_text(statement, 1, [KEY_TITLE UTF8String], -1, NULL) != SQLITE_OK) {
            //NSLog(@"Error: failed to bind statement with message '%s'.", sqlite3_errmsg([self sqlConnection]));
        }
        
        if (sqlite3_bind_text(statement, 2, [KEY_URL UTF8String], -1, NULL) != SQLITE_OK) {
            //NSLog(@"Error: failed to bind statement with message '%s'.", sqlite3_errmsg([self sqlConnection]));
        }
        
        while (sqlite3_step(statement) == SQLITE_ROW) {
            NSMutableDictionary* objectAsMap = [[NSMutableDictionary alloc]init];
            
            [objectAsMap setObject:[[NSNumber alloc]initWithInt:sqlite3_column_int(statement, 0)] forKey:@"KEY_ID"];
        	
            [objectAsMap setObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)] forKey:@"KEY_TITLE"];
        	
            [objectAsMap setObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)] forKey:@"KEY_URL"];
            [objectAsMap setObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 3)] forKey:@"KEY_TIME"];
            [objectAsMap setObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 4)] forKey:@"KEY_TYPE"];
            [objectAsMap setObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 5)] forKey:@"KEY_STATUS_ARCHIVE"];
            [objectAsMap setObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 6)] forKey:@"KEY_DATE"];
            [objectAsMap setObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 7)] forKey:@"KEY_READ"];
            [objectAsMap setObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 8)] forKey:@"KEY_ICON"];
            [objectAsMap setObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 9)] forKey:@"KEY_PROPERTY_ID"];
            [objectAsMap setObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 10)] forKey:@"KEY_DESC"];
            [objectAsMap setObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 11)] forKey:@"KEY_LOCK"];
            [objectAsMap setObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 12)] forKey:@"KEY_RECEIVED_DATE"];
            [objectAsMap setObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 13)] forKey:@"KEY_NOTIFY_CREATE_DATE"];
            [objectAsMap setObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 14)] forKey:@"KEY_NOTIFY_LOGID"];
            [objectAsMap setObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 15)] forKey:@"KEY_ALERT_REQUEST_TYPE"];
            
            [map setObject:objectAsMap forKey:[[NSNumber alloc]initWithInt : sqlite3_column_int(statement, 3)]];
        }
    }
    return map;
    
    
}


-(NSMutableDictionary*) getMaxDocIdDocumentAsMap : (NSString*)  KEY_TITLE : (NSString*)  KEY_URL : (int) maxDocId {
    
    NSMutableDictionary* map = [[NSMutableDictionary alloc]init];
    // QSqlQuery sqlQuery(SQLConnection());
    NSString* query = @"SELECT KEY_ID, KEY_TITLE, KEY_URL, KEY_TIME, KEY_TYPE, KEY_STATUS_ARCHIVE, KEY_DATE, KEY_READ, KEY_ICON, KEY_PROPERTY_ID, KEY_DESC, KEY_LOCK, KEY_RECEIVED_DATE, KEY_NOTIFY_CREATE_DATE, KEY_NOTIFY_LOGID, KEY_ALERT_REQUEST_TYPE from ";
    query = [query stringByAppendingString:[self getTableName]];
    query = [query stringByAppendingString:@" where KEY_TITLE = :KEY_TITLE and KEY_URL = :KEY_URL and maxDocNo = :maxDocNo;"];
    
    sqlite3_stmt *statement = nil;
    
    
    if (sqlite3_prepare_v2([self sqlConnection], [query UTF8String], -1, &statement, nil) != SQLITE_OK) {
        //NSLog(@"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg([self sqlConnection]));
    } else {
        
        if (sqlite3_bind_text(statement, 1, [KEY_TITLE UTF8String], -1, NULL) != SQLITE_OK) {
            //NSLog(@"Error: failed to bind statement with message '%s'.", sqlite3_errmsg([self sqlConnection]));
        }
        
        if (sqlite3_bind_text(statement, 2, [KEY_URL UTF8String], -1, NULL) != SQLITE_OK) {
            //NSLog(@"Error: failed to bind statement with message '%s'.", sqlite3_errmsg([self sqlConnection]));
        }
        
        if(sqlite3_bind_int(statement, sqlite3_bind_parameter_index(statement, ":maxDocNo"), maxDocId)!= SQLITE_OK){
            //NSLog(@"Error: failed to bind statement with message '%s'.", sqlite3_errmsg([self sqlConnection]));
            
        }
        while (sqlite3_step(statement) == SQLITE_ROW) {
            [map setObject:[[NSNumber alloc]initWithInt : sqlite3_column_int(statement, 0)] forKey:@"KEY_ID"];
            [map setObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)] forKey:@"KEY_TITLE"];
            [map setObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)] forKey:@"KEY_URL"];
            /* [map setObject:[[NSNumber alloc]initWithInt : sqlite3_column_int(statement, 3)] forKey:XmwcsConst_RECENT_REQ_MAX_DOC_ID];
             [map setObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 4)] forKey:XmwcsConst_RECENT_REQ_TRACER_NO];
             [map setObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 5)] forKey:XmwcsConst_RECENT_REQ_DOC_SUBMIT_DATE];
             [map setObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 6)] forKey:XmwcsConst_RECENT_REQ_STATUS];
             [map setObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 7)] forKey:XmwcsConst_RECENT_REQ_DOC_SUBMIT_MESSAGE];
             [map setObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 8)] forKey:@"formType"];
             [map setObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 9)] forKey:XmwcsConst_RECENT_REQ_FORM_ID];
             [map setObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 10)] forKey:@"dotFormPost"];
             [map setObject:@"Todo" forKey:XmwcsConst_RECENT_REQ_DOC_NAME];*/
            break;
        }
    }
    return map;
    
}


-(void) deleteData : (NSString*) KEY_TITLE : (NSString*) KEY_URL //: (int) maxDocNo {
{
    // QSqlQuery sqlQuery(SQLConnection());
    
	
    NSString *query = @"DELETE FROM ";
    query = [query stringByAppendingString:[self getTableName]];
	query = [query stringByAppendingString:@" WHERE KEY_TITLE = :KEY_TITLE and KEY_URL = :KEY_URL;"];// and maxDocNo = :maxDocNo;"];
	
    sqlite3_stmt *statement = nil;
    
    
    if (sqlite3_prepare_v2([self sqlConnection], [query UTF8String], -1, &statement, nil) != SQLITE_OK) {
        
        //NSLog(@"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg([self sqlConnection]));
    } else {
        
        if (sqlite3_bind_text(statement, 1, [KEY_TITLE UTF8String], -1, NULL) == SQLITE_OK) {
            
            // do nothing
        }
        
        //NSLog(@"Error: failed to bind statement with message '%s'.", sqlite3_errmsg([self sqlConnection]));
        
        if (sqlite3_bind_text(statement, 2, [KEY_URL UTF8String], -1, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_finalize(statement);
                [self close];
            }
            else
            {
                //NSLog(@"Error: failed to bind statement with message '%s'.", sqlite3_errmsg([self sqlConnection]));
            }
        }
        // if (sqlite3_bind_int(statement, 3, maxDocNo) != SQLITE_OK){
        //      //NSLog(@"Error: failed to bind statement with message '%s'.", sqlite3_errmsg([self sqlConnection]));
        //   }
    }
    
    
}

////added for RateGain Project
-(void) deleteRowData : (int) keyId {
    NSString* query = @"DELETE FROM ";
    query =[query stringByAppendingString : [self getTableName]];
    query = [query stringByAppendingString : @" WHERE KEY_ID = :keyid;"];
    
    sqlite3_stmt *statement = nil;
    if (sqlite3_prepare_v2([self sqlConnection], [query UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        sqlite3_bind_int(statement, sqlite3_bind_parameter_index(statement, ":keyid"), keyId);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_finalize(statement);
            [self close];
        }
        else
        {
            //NSLog(@"Error: failed to bind statement with message '%s'.", sqlite3_errmsg([self sqlConnection]));
        }
        
    }
    
}
//// close added for RateGain Project
-(void) deleteTable {
    NSString* query = @"DELETE FROM ";
    query =[query stringByAppendingString : [self getTableName]];
    
    sqlite3_stmt *statement = nil;
    if (sqlite3_prepare_v2([self sqlConnection], [query UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_finalize(statement);
            [self close];
        }
        else
        {
            //NSLog(@"Error: failed to bind statement with message '%s'.", sqlite3_errmsg([self sqlConnection]));
        }
        
    }
    
}
//added for rategain User

//

+ (BOOL) isInitialized : (NSString*) contextId {
    if(INSTANCE_MAP!=nil) {
        if ([INSTANCE_MAP objectForKey:contextId] != nil) {
            return true;
        }
    }
    return false;
}


// for default instance;
+ (NotificationRequestStorage*) getInstance {
    return DEFAULT_INSTANCE;
}


+ (NotificationRequestStorage*) getInstance : (NSString*) contextId {
    if(INSTANCE_MAP != nil) {
        return [INSTANCE_MAP objectForKey:contextId];
	}
    return nil;
}


@end
