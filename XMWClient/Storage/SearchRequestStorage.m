//
//  SearchRequestStorage.m
//  QCMSProject
//
//  Created by Ashish Tiwari on 30/09/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//

#import "SearchRequestStorage.h"


static NSString* BASE_FOLDER = nil;
static SearchRequestStorage* SR_DEFAULT_INSTANCE = 0;


@implementation SearchRequestStorage

@synthesize dbFileName;
@synthesize searchItemList;

-(BOOL)createTable{

    BOOL isSuccess = NO;
    
    NSString* query = @"CREATE TABLE IF NOT EXISTS ";
    query = [query stringByAppendingString : [self getTableName]];
    query = [query stringByAppendingString : @"(itemRefId INTEGER PRIMARY KEY AUTOINCREMENT, "];
    query = [query stringByAppendingString : @"module TEXT, "];
    query = [query stringByAppendingString : @"search_id TEXT, "];
    query = [query stringByAppendingString : @"name_value TEXT, "];
    query = [query stringByAppendingString : @"key_value TEXT, "];
    query = [query stringByAppendingString : @"submitDate TEXT); "];
    

    char *errMsg;
    const char *sql_stmt = [query UTF8String];

    if (sqlite3_exec([self sqlConnection], sql_stmt, NULL, NULL, &errMsg)== SQLITE_OK)
    {
        isSuccess = YES;
        NSLog(@"Table created");
    } else {
         NSLog(@"Error: failed to sqlite3_exec creating table with message '%s'.", sqlite3_errmsg([self sqlConnection]));
    }
    [self close];
    return isSuccess;

}
-(NSString*) getTableName{
    NSString* tableName = @"SEARCH_REQUEST";
	return tableName;
    
}
-(int) insertDoc : (SearchRequestItem*) searchRequest{
    
    int insertId = -1;
    
    if(![self checkIfAlreadyExist : searchRequest])
    {
	   // QSqlQuery sqlQuery(SQLConnection());
        
	    NSString* query = @"INSERT INTO ";
        query = [query stringByAppendingString:[self getTableName]];
	    query = [query stringByAppendingString:@"(module, search_id, name_value, key_value, submitDate)"];
	    query = [query stringByAppendingString:@"VALUES(:module, :search_id, :name_value, :key_value, :submitDate);"];
	    
        
	    sqlite3_stmt *statement = nil;
        if (sqlite3_prepare_v2([self sqlConnection], [query UTF8String], -1, &statement, nil) == SQLITE_OK)
        {
            sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, ":module"), [searchRequest.module UTF8String], searchRequest.module.length, nil);
            sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, ":search_id"), [searchRequest.searchId UTF8String], searchRequest.searchId.length, nil);
             sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, ":name_value"), [searchRequest.nameValue UTF8String], searchRequest.nameValue.length, nil);
             sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, ":key_value"), [searchRequest.keyValue UTF8String], searchRequest.keyValue.length, nil);
            
            sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, ":submitDate"), [searchRequest.createdDate UTF8String], searchRequest.createdDate.length, nil);
            
	    
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                insertId = (int)sqlite3_last_insert_rowid([self sqlConnection]);
            } else {
                NSLog(@"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg([self sqlConnection]));
            }
            sqlite3_finalize(statement);
            [self close];
        } else {
             NSLog(@"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg([self sqlConnection]));
        }
        
   	           
    }
return insertId;
}

-(BOOL) checkIfAlreadyExist : (SearchRequestItem*) searchRequest {
    BOOL retVal = false;

    NSString* query = @"SELECT itemRefId, module, search_id, name_value, key_value, submitDate from ";
    query = [query stringByAppendingString:[self getTableName]];
    query = [query stringByAppendingString:@" where module = :module and search_id = :search_id and key_value = :key_value"];
    query = [query stringByAppendingString:@";"];
    
    sqlite3_stmt *statement = nil;
    if (sqlite3_prepare_v2([self sqlConnection], [query UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, ":module"), [searchRequest.module UTF8String], searchRequest.module.length, nil);
        sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, ":search_id"), [searchRequest.searchId UTF8String], searchRequest.searchId.length, nil);
        sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, ":key_value"), [searchRequest.keyValue UTF8String], searchRequest.keyValue.length, nil);
    
       
        while(sqlite3_step(statement) == SQLITE_ROW)
        {
            retVal = true;
        }
         
       
    } else {
         NSLog(@"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg([self sqlConnection]));
    }
   
    return retVal;
}
-(NSMutableArray*)getSearchRecords : (NSString*) module : (NSString*) searchId {
   
    
    NSMutableArray* list = [[NSMutableArray alloc]init];
    
    //QSqlQuery sqlQuery(SQLConnection());
    
    NSString* query = @"SELECT itemRefId, module, search_id, name_value, key_value, submitDate from ";
    query = [query stringByAppendingString:[self getTableName]];
    query = [query stringByAppendingString:@" where module = ? and search_id = ?"];
    query = [query stringByAppendingString:@";"];
    
    sqlite3_stmt *statement = nil;
    

    
    if (sqlite3_prepare_v2([self sqlConnection], [query UTF8String], -1, &statement, nil) != SQLITE_OK) {
        NSLog(@"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg([self sqlConnection]));
    } else {
        
        if (sqlite3_bind_text(statement, 1, [module UTF8String], -1, NULL) != SQLITE_OK) {
             NSLog(@"Error: failed to bind statement with message '%s'.", sqlite3_errmsg([self sqlConnection]));
        }
        
        if (sqlite3_bind_text(statement, 2, [searchId UTF8String], -1, NULL) != SQLITE_OK) {
            NSLog(@"Error: failed to bind statement with message '%s'.", sqlite3_errmsg([self sqlConnection]));
        }
    
        while (sqlite3_step(statement) == SQLITE_ROW) {
                [list addObject:[self retrieveItem:statement]];
        }
    }
    
   searchItemList = list;
	return list;
}

-(SearchRequestItem*) retrieveItem :(sqlite3_stmt *) statement
{
    SearchRequestItem* searchItem = [[SearchRequestItem alloc]init];
    searchItem.itemRefId = sqlite3_column_int(statement, 0);
    searchItem.module = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
    searchItem.searchId = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
	searchItem.nameValue = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 3)];
	searchItem.keyValue = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 4)];
	searchItem.createdDate = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 5)];
	
	return searchItem;
}

-(NSMutableArray*)lastSearchRecords{
    return searchItemList;
}

+(void) createInstance{
    SearchRequestStorage* newInstance = 0;
	@try {
            NSString* dbName = @"searchrequest.sqlite.db";
            newInstance = [[SearchRequestStorage alloc]initWithDBName:dbName];
            [newInstance createTable];
		           
        } @catch(NSException* e) {
		
            NSLog(@"exception SearchRequestStaorage: %@",[e reason]);
        }
   	SR_DEFAULT_INSTANCE = newInstance;
}

+(BOOL) isInitialized{
    
    if(SR_DEFAULT_INSTANCE==0)
		return false;
	else
		return true;
    
}
+(SearchRequestStorage*)getInstance{
    if(SR_DEFAULT_INSTANCE==0) {
		[self createInstance];
	}
	return SR_DEFAULT_INSTANCE;
}

@end
