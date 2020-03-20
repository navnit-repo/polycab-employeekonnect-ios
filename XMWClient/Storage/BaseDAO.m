//
//  BaseDAO.m
//  QCMSProject
//
//  Created by Pradeep Singh on 7/6/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//

#import "BaseDAO.h"


@implementation BaseDAO
@synthesize databasePath;

-(id) initWithDBName : (NSString*) dbName {
    self = [super init];
    
    if(self!=nil) {
        NSString *docsDir;
        NSArray *dirPaths;
        // Get the documents directory
        dirPaths = NSSearchPathForDirectoriesInDomains
        (NSDocumentDirectory, NSUserDomainMask, YES);
        docsDir = dirPaths[0];
        self.databasePath = [[NSString alloc] initWithString:
                        [docsDir stringByAppendingPathComponent: dbName]];
        [self createDB];
        
        return self;
    }
    return nil;
}



-(BOOL)createDB {
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

-(sqlite3 *) sqlConnection {
    const char *dbpath = [databasePath UTF8String];
    
    if(database==nil) {
        if (sqlite3_open(dbpath, &database) == SQLITE_OK)
        {
            return  database;
        }
    }
    return database;
}

-(void) close {
    if(database!=nil) {
        sqlite3_close(database);
        database = nil;
    }
}


@end
