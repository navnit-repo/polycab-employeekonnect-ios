//
//  ChatThreadList_DB.m
//  XMWClient
//
//  Created by dotvikios on 16/04/19.
//  Copyright © 2019 dotvik. All rights reserved.
//

#import "ChatThreadList_DB.h"
static NSMutableDictionary* INSTANCE_MAP = 0;
static ChatThreadList_DB* DEFAULT_INSTANCE = 0;
@implementation ChatThreadList_DB
@synthesize dbFileName;
@synthesize contextId;
@synthesize contactList;

-(id) initWithDBName : (NSString*) dbName {
    self = [super init];
    
    if(self!=nil) {
        
        NSString *appGroupId = @"group.com.polycab.xmw.employee.push.group";
        NSURL *appGroupDirectoryPath = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:appGroupId];
        NSString *appGroupDirectoryPathString = appGroupDirectoryPath.absoluteString;
        
        self.databasePath = [[NSString alloc] initWithString:
                             [appGroupDirectoryPathString stringByAppendingPathComponent: dbName]];
        [self createDB];
        
        return self;
    }
    return nil;
}
- (BOOL)createDB
{
    BOOL isSuccess = YES;
    NSFileManager *filemgr = [NSFileManager defaultManager];
    if ([filemgr fileExistsAtPath: databasePath ] == NO)
    {
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &database) == SQLITE_OK)
        {
            sqlite3_close(database);
            database = nil;
            return  isSuccess;
        }
        else {
            isSuccess = NO;
            NSLog(@"Failed to open/create database");
        }
    }
    return isSuccess;
}
-(id) initWithContext : (NSString*) inContextId : (NSString*) dbName {
    self = [self initWithDBName:dbName];
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
   // query = [query stringByAppendingString : @"(KEY_ID INTEGER PRIMARY KEY AUTOINCREMENT, "];
    query = [query stringByAppendingString : @"(chatThreadId INTEGER PRIMARY KEY, "];
    query = [query stringByAppendingString : @"fromId TEXT, "];
    query = [query stringByAppendingString : @"toId TEXT, "];
    query = [query stringByAppendingString : @"status TEXT, "];
    query = [query stringByAppendingString : @"subject TEXT, "];
    query = [query stringByAppendingString : @"lastMessageOn TEXT, "];
    query = [query stringByAppendingString : @"displayName TEXT, "];
    query = [query stringByAppendingString : @"filterByLatestTime INTEGER, "];
    query = [query stringByAppendingString : @"deleteFlag TEXT, "];
    query =  [query stringByAppendingString : @"REC_TS DATETIME DEFAULT CURRENT_TIMESTAMP); "];
    
    // adding Timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
    
    char *errMsg;
    const char *sql_stmt = [query UTF8String];
    
    if (sqlite3_exec([self sqlConnection], sql_stmt, NULL, NULL, &errMsg)
        != SQLITE_OK)
    {
        isSuccess = NO;
        //NSLog(@"Failed to create table");
    }
    [self close];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSLog(@"path is %@",documentsDirectory);
    return isSuccess;
}
- (NSString*) getTableName {
    NSString* tableName = @"CHATTHREAD";
    tableName = [tableName stringByAppendingString: contextId];
    return tableName;
}
+ (void) createInstance : (NSString*) contextId :  (BOOL) isDefault {
    ChatThreadList_DB* newInstance = nil;
    @try {
        // newInstance->fileStore = new QFile(RecentRequestStorage::BASE_FOLDER + contextId + ".sqlite.db");
        NSString* dbName = @"ChatThreadList_DB.sqlite.db";
        newInstance = [[ChatThreadList_DB alloc] initWithContext:contextId :dbName];
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
- (BOOL)updateDocLastMessageTime:(ChatThreadList_Object *)chatThreadList_Object
{
    NSString* query = @"UPDATE ";
    query =  [query stringByAppendingString : [self getTableName]];
    //update  tableName set status = '212' where chatThreadId = 10;
    //  chatThreadId, fromId, toId, status, subject, lastMessageOn
    query = [[[[query stringByAppendingString : @" SET "] stringByAppendingString:@" lastMessageOn ='"]stringByAppendingString:chatThreadList_Object.lastMessageOn] stringByAppendingString:@"'"];
      query = [[[[query stringByAppendingString:@" ,"] stringByAppendingString:@"filterByLatestTime ="]stringByAppendingString:chatThreadList_Object.lastMessageOn]stringByAppendingString:@""];
    NSString *whereClaue = [[@" where chatThreadId =" stringByAppendingString:[NSString stringWithFormat:@"%d",chatThreadList_Object.chatThreadId]] stringByAppendingString:@";"];
    
    query = [query stringByAppendingString:whereClaue];
    
    
    sqlite3_stmt *statement = nil;
    if (sqlite3_prepare_v2([self sqlConnection], [query UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, ":KEY_READ"), [chatThreadList_Object.status UTF8String], chatThreadList_Object.status.length, nil);
        
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_finalize(statement);
            [self close];
            return true;
        }
        [self close];
    }
    else {
        //NSLog(@"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg([self sqlConnection]));
    }
    
    return false;
}
- (BOOL)updateDeletedTheadFlag:(ChatThreadList_Object *)chatThreadList_Object
{   NSString* query = @"UPDATE ";
    query =  [query stringByAppendingString : [self getTableName]];
    query = [[query stringByAppendingString : @" SET "] stringByAppendingString:@" deleteFlag = '"];
    query = [[query stringByAppendingString:chatThreadList_Object.deletedFlag] stringByAppendingString:@"'"];
    NSString *whereClause = [[@" where chatThreadId =" stringByAppendingString:[NSString stringWithFormat:@"%d",chatThreadList_Object.chatThreadId]] stringByAppendingString:@";"];
     query = [query stringByAppendingString:whereClause];
    sqlite3_stmt *statement = nil;
    if (sqlite3_prepare_v2([self sqlConnection], [query UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, ":KEY_READ"), [chatThreadList_Object.status UTF8String], chatThreadList_Object.status.length, nil);
        
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_finalize(statement);
            [self close];
            return true;
        }
        [self close];
    }
    else {
        //NSLog(@"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg([self sqlConnection]));
    }
    
    return false;
}
-(BOOL) updateDoc : (ChatThreadList_Object*) chatThreadList_Object
{
    NSString* query = @"UPDATE ";
    query =  [query stringByAppendingString : [self getTableName]];
    //update  tableName set status = '212' where chatThreadId = 10;
    //  chatThreadId, fromId, toId, status, subject, lastMessageOn
    query = [[[[query stringByAppendingString : @" SET "] stringByAppendingString:@" status ='"]stringByAppendingString:chatThreadList_Object.status] stringByAppendingString:@"'"];
    
    NSString *whereClaue = [[@" where chatThreadId =" stringByAppendingString:[NSString stringWithFormat:@"%d",chatThreadList_Object.chatThreadId]] stringByAppendingString:@";"];
    
    query = [query stringByAppendingString:whereClaue];
    
    
    sqlite3_stmt *statement = nil;
    if (sqlite3_prepare_v2([self sqlConnection], [query UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, ":KEY_READ"), [chatThreadList_Object.status UTF8String], chatThreadList_Object.status.length, nil);
        
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_finalize(statement);
            [self close];
            return true;
        }
        [self close];
    }
    else {
        //NSLog(@"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg([self sqlConnection]));
    }
    
    return false;
}

- (int)insertDoc:(ChatThreadList_Object *)chatThreadList_Object
{
    int insertId = -1;
    //  QSqlQuery sqlQuery(SQLConnection());
    
    NSString* query = @"INSERT INTO ";
    query =  [query stringByAppendingString : [self getTableName]];
    query = [query stringByAppendingString : @"(chatThreadId, fromId, toId, status, subject, lastMessageOn, displayName, filterByLatestTime, deleteFlag) "];
    query = [query stringByAppendingString : @"VALUES(:chatThreadId, :fromId, :toId, :status, :subject, :lastMessageOn, :displayName, :filterByLatestTime, :deleteFlag);"];
    
    sqlite3_stmt *statement = nil;
    if (sqlite3_prepare_v2([self sqlConnection], [query UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        sqlite3_bind_int(statement, sqlite3_bind_parameter_index(statement, ":chatThreadId"), chatThreadList_Object.chatThreadId);
      
//        sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, ":chatThreadId"), [chatThreadList_Object.chatThreadId UTF8String], chatThreadList_Object.chatThreadId.length, nil);
        sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, ":fromId"), [chatThreadList_Object.from UTF8String], chatThreadList_Object.from.length, nil);
        //sqlite3_bind_int(statement, sqlite3_bind_parameter_index(statement, ":maxDocNo"), recentRequest.maxDocNo);
        sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, ":toId"), [chatThreadList_Object.to UTF8String], chatThreadList_Object.to.length, nil);
        
         sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, ":status"), [chatThreadList_Object.status UTF8String], chatThreadList_Object.status.length, nil);
         sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, ":subject"), [chatThreadList_Object.subject UTF8String], chatThreadList_Object.subject.length, nil);
         sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, ":lastMessageOn"), [chatThreadList_Object.lastMessageOn UTF8String], chatThreadList_Object.lastMessageOn.length, nil);
        
         sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, ":displayName"), [chatThreadList_Object.displayName UTF8String], chatThreadList_Object.displayName.length, nil);
        
       double filterTime = [chatThreadList_Object.lastMessageOn doubleValue];
        
        sqlite3_bind_int64(statement, sqlite3_bind_parameter_index(statement, ":filterByLatestTime"), filterTime);
        sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, ":deleteFlag"), [chatThreadList_Object.deletedFlag UTF8String], chatThreadList_Object.deletedFlag.length, nil);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            insertId = (int)sqlite3_last_insert_rowid([self sqlConnection]);
            [self close];
        }
        sqlite3_finalize(statement);
        [self close];
    }
    else
    {
        NSLog(@"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg([self sqlConnection]));
        [self close];
    }
    return insertId;
}
-(NSMutableArray*)  getRecentDocumentsData : (NSString *)delete_stringFlag
{
    [NSThread sleepForTimeInterval:0.25];
    NSMutableArray* list = [[NSMutableArray alloc] init];
    NSString* query = @"SELECT chatThreadId,  fromId, toId, status, subject, lastMessageOn, displayName, deleteFlag from ";
    query = [[query stringByAppendingString : [self getTableName]]stringByAppendingString:@" where deleteFlag ='NO' ORDER BY filterByLatestTime DESC;"];
   // NSString* query = [@"SELECT * from " stringByAppendingString:[self getTableName]];
    
    // query = [query stringByAppendingString : @" ;"];
    
    //query =[query stringByAppendingString : @" where KEY_DELETE = :id1 order by datetime(REC_TS) DESC;"];//code comment by me(tushar)
    
    
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
        NSLog(@"getRecentDocumentsData Error: Property Message '%s'.", sqlite3_errmsg([self sqlConnection]));
        [self close];
    }
    return list;
}

- (ChatThreadList_Object*) retrieveItem : (sqlite3_stmt *) statement {
    ChatThreadList_Object*  chatThreadList_Object = [[ChatThreadList_Object alloc] init];
    
    //chatThreadList_Object.KEY_ID = sqlite3_column_int(statement, 0);
    
    chatThreadList_Object.chatThreadId = sqlite3_column_int(statement, 0);
    
    chatThreadList_Object.from  = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];

    chatThreadList_Object.to  = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];

    chatThreadList_Object.status  = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 3)];

    chatThreadList_Object.subject  = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 4)];

    chatThreadList_Object.lastMessageOn  = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 5)];
//    NSString *name = [NSString stringWithFormat:@"%s",(const char*)sqlite3_column_text(statement, 6)];
//    
//    if (name == NULL || name == nil || [name isKindOfClass:[NSNull class]]) {
//        name =@"";
//    }
    chatThreadList_Object.displayName  = [NSString stringWithFormat:@"%s",(const char*)sqlite3_column_text(statement, 6)];
    chatThreadList_Object.deletedFlag  = [NSString stringWithFormat:@"%s",(const char*)sqlite3_column_text(statement, 7)];
    return chatThreadList_Object;
}
- (void)dropTable:(NSString *)context
{
    contextId = context;
    NSString* query = @"DELETE from ";
    query = [[query stringByAppendingString : [self getTableName]] stringByAppendingString:@";"];
    
    char *errMsg;
    const char *sql_stmt = [query UTF8String];
    
    if (sqlite3_exec([self sqlConnection], sql_stmt, NULL, NULL, &errMsg)
        != SQLITE_OK)
    {
        NSLog(@"Failed to drop table");
    }
    [self close];
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
+ (ChatThreadList_DB*) getInstance {
    return DEFAULT_INSTANCE;
}


+ (ChatThreadList_DB*) getInstance : (NSString*) contextId {
    if(INSTANCE_MAP != nil) {
        return [INSTANCE_MAP objectForKey:contextId];
    }
    return nil;
}

@end
