//
//  BaseDAO.h
//  QCMSProject
//
//  Created by Pradeep Singh on 7/6/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface BaseDAO : NSObject
{
    NSString *databasePath;
    sqlite3 *database;
    
}

@property NSString* databasePath;

-(id) initWithDBName : (NSString*) dbName;
-(BOOL)createDB;
-(sqlite3 *) sqlConnection;
-(void) close;

@end
