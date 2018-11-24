//
//  SearchRequestStorage.h
//  QCMSProject
//
//  Created by Ashish Tiwari on 30/09/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//

#import "BaseDAO.h"
#import "SearchRequestItem.h"

@interface SearchRequestStorage : BaseDAO
{
    NSString* dbFileName;
	NSMutableArray* searchItemList;
    
}
@property NSString* dbFileName;
@property NSMutableArray* searchItemList;

-(SearchRequestItem*) retrieveItem :(sqlite3_stmt *) statement;


-(BOOL)createTable;
-(NSString*) getTableName;

-(int) insertDoc : (SearchRequestItem*) searchRequest;
-(BOOL) checkIfAlreadyExist : (SearchRequestItem*) searchRequest;
-(NSMutableArray*)getSearchRecords : (NSString*) module : (NSString*) searchId;
-(NSMutableArray*)lastSearchRecords;


//static method
+(void) createInstance;
+(BOOL) isInitialized;
+(SearchRequestStorage*) getInstance;

@end
