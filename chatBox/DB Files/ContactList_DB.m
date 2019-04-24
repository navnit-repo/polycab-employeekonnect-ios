//
//  ContactList_DB.m
//  XMWClient
//
//  Created by dotvikios on 15/04/19.
//  Copyright © 2019 dotvik. All rights reserved.
//

#import "ContactList_DB.h"

static NSMutableDictionary* INSTANCE_MAP = 0;
static ContactList_DB* DEFAULT_INSTANCE = 0;

@implementation ContactList_DB

@synthesize dbFileName;
@synthesize contextId;
@synthesize contactList;

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
    query = [query stringByAppendingString : @"emailId TEXT, "];
    query = [query stringByAppendingString : @"name TEXT, "];
    query = [query stringByAppendingString : @"userId TEXT, "];
    query = [query stringByAppendingString : @"isHidden INTEGER, "];
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
    NSString* tableName = @"CONTACT";
    tableName = [tableName stringByAppendingString: contextId];
    return tableName;
}

+ (void) createInstance : (NSString*) contextId :  (BOOL) isDefault {
    ContactList_DB* newInstance = nil;
    @try {
        // newInstance->fileStore = new QFile(RecentRequestStorage::BASE_FOLDER + contextId + ".sqlite.db");
        NSString* dbName = @"ContactList_DB.sqlite.db";
        newInstance = [[ContactList_DB alloc] initWithContext:contextId :dbName];
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


- (int)insertDoc:(ContactList_Object *)contactListObject
{
    int insertId = -1;
    //  QSqlQuery sqlQuery(SQLConnection());
    
    NSString* query = @"INSERT INTO ";
    query =  [query stringByAppendingString : [self getTableName]];
    query = [query stringByAppendingString : @"(emailId, name, userId, isHidden) "];
    query = [query stringByAppendingString : @"VALUES(:emailId, :name, :userId, :isHidden);"];
    
    sqlite3_stmt *statement = nil;
    if (sqlite3_prepare_v2([self sqlConnection], [query UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, ":emailId"), [contactListObject.emailId UTF8String], contactListObject.emailId.length, nil);
        sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, ":name"), [contactListObject.name UTF8String], contactListObject.name.length, nil);
        //sqlite3_bind_int(statement, sqlite3_bind_parameter_index(statement, ":maxDocNo"), recentRequest.maxDocNo);
        sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, ":userId"), [contactListObject.userId UTF8String], contactListObject.userId.length, nil);
        
//        sqlite3_bind_int(statement, sqlite3_bind_parameter_index(statement, ":chatThreadId"), chatThreadList_Object.chatThreadId);
        
        sqlite3_bind_int(statement, sqlite3_bind_parameter_index(statement,":isHidden"), contactListObject.isHidden);
        
//        sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, ":isHidden"), [contactListObject.isHidden UTF8String], contactListObject.isHidden.length, nil);
//
        
        
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

-(NSMutableArray*)  getRecentDocumentsData : (NSString *)delete_stringFlag
{
    NSMutableArray* list = [[NSMutableArray alloc] init];
    NSString* query = @"SELECT emailId, name, userId from ";
    query = [query stringByAppendingString : [self getTableName]];
    NSString *whereClause= @" Where isHidden = 0;";
    query = [query stringByAppendingString:whereClause];
    NSLog(@"%@",query);
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
    }
    return list;
}

- (ContactList_Object*) retrieveItem : (sqlite3_stmt *) statement {
    ContactList_Object* contactList_Object = [[ContactList_Object alloc] init];
    
//    contactList_Object.KEY_ID = sqlite3_column_int(statement, 0);
    contactList_Object.emailId = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
    contactList_Object.name  = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
    contactList_Object.userId  = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
   
    
    return contactList_Object;
}
- (NSMutableArray *)getContactDisplayName:(NSString *)delete_stringFlag :(NSString*) userID
{
    NSMutableArray* list = [[NSMutableArray alloc] init];
    NSString* query = @"SELECT emailId, name from ";
    query = [query stringByAppendingString : [self getTableName]];
    NSString *whereClause= @" Where userId ='";
    whereClause = [[whereClause stringByAppendingString:userID]stringByAppendingString:@"';"];
    query = [query stringByAppendingString:whereClause];
    NSLog(@"%@",query);
    // query = [query stringByAppendingString : @" ;"];
    
    //query =[query stringByAppendingString : @" where KEY_DELETE = :id1 order by datetime(REC_TS) DESC;"];//code comment by me(tushar)
    
    
    sqlite3_stmt *statement = nil;
    if (sqlite3_prepare_v2([self sqlConnection], [query UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, ":id1"), [delete_stringFlag UTF8String], delete_stringFlag.length, nil);
        while(sqlite3_step(statement) == SQLITE_ROW) {
            [list addObject: [self retrieveContactName : statement]];
        }
        sqlite3_finalize(statement);
        [self close];
    }
    else{
        NSLog(@"Error: Property Message '%s'.", sqlite3_errmsg([self sqlConnection]));
    }
    return list;
}
- (ContactList_Object*) retrieveContactName : (sqlite3_stmt *) statement {
    ContactList_Object* contactList_Object = [[ContactList_Object alloc] init];
    
    //    contactList_Object.KEY_ID = sqlite3_column_int(statement, 0);
    contactList_Object.emailId = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
    contactList_Object.userName  = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
  
    
    
    return contactList_Object;
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
+ (ContactList_DB*) getInstance {
    return DEFAULT_INSTANCE;
}


+ (ContactList_DB*) getInstance : (NSString*) contextId {
    if(INSTANCE_MAP != nil) {
        return [INSTANCE_MAP objectForKey:contextId];
    }
    return nil;
}


@end
