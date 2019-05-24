//
//  ChatHistory_DB.m
//  XMWClient
//
//  Created by dotvikios on 17/04/19.
//  Copyright © 2019 dotvik. All rights reserved.
//

#import "ChatHistory_DB.h"
#import "KeychainItemWrapper.h"
static NSMutableDictionary* INSTANCE_MAP = 0;
static ChatHistory_DB* DEFAULT_INSTANCE = 0;
@implementation ChatHistory_DB
@synthesize dbFileName;
@synthesize contextId;
@synthesize contactList;
@synthesize chatThreatIdToRetrieveHistory;

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
-(id) initWithContext : (NSString*) inContextId : (NSString*) dbName :(int)threadID {
    self = [self initWithDBName:dbName];
    if(self !=nil) {
        self.contextId = inContextId;
        self.dbFileName = dbName;
        self.chatThreatIdToRetrieveHistory =threadID;
    }
    return self;
}
-(BOOL) createTable {
    BOOL isSuccess = YES;
    
    NSString* query = @"CREATE TABLE IF NOT EXISTS ";
    query =  [query stringByAppendingString : [self getTableName]];
   // query = [query stringByAppendingString : @"(KEY_ID INTEGER PRIMARY KEY AUTOINCREMENT, "];
    query = [query stringByAppendingString : @"(chatThreadId INTEGER , "];
    query = [query stringByAppendingString : @"fromId TEXT, "];
    query = [query stringByAppendingString : @"toId TEXT, "];
    query = [query stringByAppendingString : @"message TEXT, "];
    query = [query stringByAppendingString : @"messageDate TEXT, "];
    query = [query stringByAppendingString : @"messageType TEXT, "];
    query = [query stringByAppendingString : @"messageId INTEGER PRIMARY KEY, "];
    query = [query stringByAppendingString : @"messageRead TEXT, "];
    
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
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSLog(@"path is %@",documentsDirectory);
    return isSuccess;
}
- (NSString*) getTableName {
    NSString* tableName = @"CHATHISTORY";
    tableName = [tableName stringByAppendingString: contextId];
    return tableName;
}
+ (void)createInstance:(NSString *)contextId :(BOOL)isDefault :(int)chatThreadId
{
    ChatHistory_DB* newInstance = nil;
    @try {
        // newInstance->fileStore = new QFile(RecentRequestStorage::BASE_FOLDER + contextId + ".sqlite.db");
        NSString* dbName = @"ChatHistory_DB.sqlite.db";
        newInstance = [[ChatHistory_DB alloc] initWithContext:contextId :dbName :chatThreadId];
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


- (int)insertDoc:(ChatHistory_Object *)chatHistory_Object
{
    int insertId = -1;
    //  QSqlQuery sqlQuery(SQLConnection());
    
    NSString* query = @"INSERT INTO ";
    query =  [query stringByAppendingString : [self getTableName]];
    query = [query stringByAppendingString : @"(chatThreadId, fromId, toId, message, messageDate, messageType, messageId, messageRead) "];
    query = [query stringByAppendingString : @"VALUES(:chatThreadId, :fromId, :toId, :message, :messageDate, :messageType , :messageId, :messageRead);"];
    
    sqlite3_stmt *statement = nil;
    if (sqlite3_prepare_v2([self sqlConnection], [query UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        
//         sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, ":chatThreadId"), [chatHistory_Object.from UTF8String], chatHistory_Object.from.length, nil);
        sqlite3_bind_int(statement, sqlite3_bind_parameter_index(statement, ":chatThreadId"), chatHistory_Object.chatThreadId);
        
        //        sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, ":chatThreadId"), [chatThreadList_Object.chatThreadId UTF8String], chatThreadList_Object.chatThreadId.length, nil);
        sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, ":fromId"), [chatHistory_Object.from UTF8String], chatHistory_Object.from.length, nil);
        //sqlite3_bind_int(statement, sqlite3_bind_parameter_index(statement, ":maxDocNo"), recentRequest.maxDocNo);
        sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, ":toId"), [chatHistory_Object.to UTF8String], chatHistory_Object.to.length, nil);
        
        sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, ":message"), [chatHistory_Object.message UTF8String], chatHistory_Object.message.length, nil);
        sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, ":messageDate"), [chatHistory_Object.messageDate UTF8String], chatHistory_Object.messageDate.length, nil);
        sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, ":messageType"), [chatHistory_Object.messageType UTF8String], chatHistory_Object.messageType.length, nil);
        
         sqlite3_bind_int(statement, sqlite3_bind_parameter_index(statement, ":messageId"), chatHistory_Object.messageId);
        
        sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, ":messageRead"), [chatHistory_Object.messageRead UTF8String], chatHistory_Object.messageRead.length, nil);
        
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
- (NSMutableArray *)getRecentUnreadMessage:(NSString *)delete_stringFlag
{
    NSMutableArray* list = [[NSMutableArray alloc] init];
    NSString* query = @"SELECT Distinct chatThreadId, messageId, messageRead from ";
    
    /* old query (if in feture needs show ticks then use old query and implement logic in chatroomvc class)
    NSString *whereClause = [[@" where chatThreadId="stringByAppendingString:[NSString stringWithFormat:@"%d",chatThreatIdToRetrieveHistory]]stringByAppendingString:@" and messageRead='NO'"];
    */
    
    //updated query
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"com.polycab.xmw.employee" accessGroup:nil ];
    NSString *userId = [[keychainItem objectForKey:kSecAttrAccount]stringByAppendingString:@"@employee"];
    
    NSString *whereClause = [[[[[@" where chatThreadId="stringByAppendingString:[NSString stringWithFormat:@"%d",chatThreatIdToRetrieveHistory]]stringByAppendingString:@" and messageRead='NO'"]stringByAppendingString:@" and toId = '"]stringByAppendingString:userId]stringByAppendingString:@"'"];
    
    query = [[[query stringByAppendingString : [self getTableName]]stringByAppendingString:whereClause]stringByAppendingString:@";"];
    NSLog(@"%@",query);
 
    
    sqlite3_stmt *statement = nil;
    if (sqlite3_prepare_v2([self sqlConnection], [query UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, ":id1"), [delete_stringFlag UTF8String], delete_stringFlag.length, nil);
        while(sqlite3_step(statement) == SQLITE_ROW) {
            [list addObject: [self retrieveItemUnreadMessage : statement]];
        }
        sqlite3_finalize(statement);
        [self close];
    }
    else{
        NSLog(@"Error: Property Message '%s'.", sqlite3_errmsg([self sqlConnection]));
        [self close];
    }
    return list;
}
- (ChatHistory_Object*) retrieveItemUnreadMessage : (sqlite3_stmt *) statement {
    ChatHistory_Object*  chatHistory_Object = [[ChatHistory_Object alloc] init];
//    chatThreadId, messageId, messageRead
    
    chatHistory_Object.chatThreadId  = sqlite3_column_int(statement, 0);
    chatHistory_Object.messageId  = sqlite3_column_int(statement, 1);
    chatHistory_Object.messageRead =[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
    return chatHistory_Object;
}
-(NSMutableArray*)  getRecentDocumentsData : (NSString *)delete_stringFlag
{
    NSMutableArray* list = [[NSMutableArray alloc] init];
    NSString* query = @"SELECT Distinct chatThreadId,  fromId, toId, message, messageDate, messageType , messageId, messageRead from ";
//    NSString *whereClause =[[[ @" where chatThreadId =" stringByAppendingString:@"'"]stringByAppendingString:[NSString stringWithFormat@"%@",chatThreatIdToRetrieveHistory]]stringByAppendingString:@"'"];
    NSString *whereClause = [@" where chatThreadId="stringByAppendingString:[NSString stringWithFormat:@"%d",chatThreatIdToRetrieveHistory]];
    query = [[[query stringByAppendingString : [self getTableName]]stringByAppendingString:whereClause]stringByAppendingString:@";"];
    NSLog(@"%@",query);
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
        NSLog(@"Error: Property Message '%s'.", sqlite3_errmsg([self sqlConnection]));
        [self close];
    }
    return list;
}

- (ChatHistory_Object*) retrieveItem : (sqlite3_stmt *) statement {
    ChatHistory_Object*  chatHistory_Object = [[ChatHistory_Object alloc] init];
    
    //chatThreadList_Object.KEY_ID = sqlite3_column_int(statement, 0);
    
    //chatThreadList_Object.chatThreadId = sqlite3_column_int(statement, 0);
    
    chatHistory_Object.chatThreadId  = sqlite3_column_int(statement, 0);
    chatHistory_Object.from  = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
    
    chatHistory_Object.to  = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
    
    chatHistory_Object.message  = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 3)];
    
    chatHistory_Object.messageDate  = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 4)];
    
    chatHistory_Object.messageType  = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 5)];
    
    chatHistory_Object.messageId  = sqlite3_column_int(statement, 6);
    chatHistory_Object.messageRead =[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 7)];
    return chatHistory_Object;
}
- (BOOL)updateUnreadMessageStatus:(ChatHistory_Object *)chatHistory_Object
{
    NSString* query = @"UPDATE ";
    query =  [query stringByAppendingString : [self getTableName]];
    query = [[query stringByAppendingString : @" SET "] stringByAppendingString:@" messageRead = 'YES'"];
    NSString *whereClause = [[[[@"where messageId="stringByAppendingString:[NSString stringWithFormat:@"%d",chatHistory_Object.messageId]]stringByAppendingString:@" and chatThreadId="]stringByAppendingString:[NSString stringWithFormat:@"%d",chatThreatIdToRetrieveHistory]]stringByAppendingString:@";"];
   
    query = [query stringByAppendingString:whereClause];
    NSLog(@"Unread message update query;-\n%@",query);
    sqlite3_stmt *statement = nil;
    if (sqlite3_prepare_v2([self sqlConnection], [query UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        
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

- (void)dropRows:(NSString *)context
{
    contextId = context;
    NSString* query = @"DELETE from ";
    query = [query stringByAppendingString : [self getTableName]];
    NSString *whereClause;
    whereClause = [NSString stringWithFormat:@" where chatThreadId = %d ;",chatThreatIdToRetrieveHistory];
    query = [query stringByAppendingString:whereClause];
    NSLog(@"%@",query);
    
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
+ (ChatHistory_DB*) getInstance {
    return DEFAULT_INSTANCE;
}


+ (ChatHistory_DB*) getInstance : (NSString*) contextId {
    if(INSTANCE_MAP != nil) {
        return [INSTANCE_MAP objectForKey:contextId];
    }
    return nil;
}


@end
