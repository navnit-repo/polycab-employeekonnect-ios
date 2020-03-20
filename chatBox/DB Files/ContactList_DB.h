//
//  ContactList_DB.h
//  XMWClient
//
//  Created by dotvikios on 15/04/19.
//  Copyright © 2019 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseDAO.h"
#import "ContactList_Object.h"
NS_ASSUME_NONNULL_BEGIN

@interface ContactList_DB : BaseDAO
{
    NSString* dbFileName;
    NSString* contextId;
    NSMutableArray* contactList;
}
@property  NSString* dbFileName;
@property  NSString* contextId;
@property  NSMutableArray* contactList;
-(id) initWithDBName : (NSString*) dbName;
-(BOOL)createDB;
-(NSMutableArray*)  getContactDisplayName : (NSString *)delete_stringFlag :(NSString *)userID;
-(void)dropTable :(NSString*) context;
-(BOOL) createTable;
+ (void) createInstance : (NSString*) contextId :  (BOOL) isDefault;

-(int) insertDoc : (ContactList_Object*) contactListObject;
+ (BOOL) isInitialized :(NSString*) contextId ;
+ (ContactList_DB*) getInstance ;
+ (ContactList_DB*) getInstance : (NSString*) contextId ;
-(NSMutableArray*)  getRecentDocumentsData : (NSString *)delete_stringFlag;
- (ContactList_Object*) retrieveItem : (sqlite3_stmt *) statement ;
@end

NS_ASSUME_NONNULL_END
