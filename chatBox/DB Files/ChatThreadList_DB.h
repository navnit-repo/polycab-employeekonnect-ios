//
//  ChatThreadList_DB.h
//  XMWClient
//
//  Created by dotvikios on 16/04/19.
//  Copyright © 2019 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseDAO.h"
#import "ChatThreadList_Object.h"
NS_ASSUME_NONNULL_BEGIN

@interface ChatThreadList_DB : BaseDAO
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
-(BOOL) updateDocLastMessageTime : (ChatThreadList_Object*) chatThreadList_Object;
-(BOOL) updateDoc : (ChatThreadList_Object*) chatThreadList_Object;
-(void)dropTable :(NSString*) context;
-(BOOL) createTable;
+ (void) createInstance : (NSString*) contextId :  (BOOL) isDefault;

-(int) insertDoc : (ChatThreadList_Object*) chatThreadList_Object;
+ (BOOL) isInitialized :(NSString*) contextId ;
+ (ChatThreadList_DB*) getInstance ;
+ (ChatThreadList_DB*) getInstance : (NSString*) contextId ;
-(NSMutableArray*)  getRecentDocumentsData : (NSString *)delete_stringFlag;
- (ChatThreadList_Object*) retrieveItem : (sqlite3_stmt *) statement ;
@end

NS_ASSUME_NONNULL_END
