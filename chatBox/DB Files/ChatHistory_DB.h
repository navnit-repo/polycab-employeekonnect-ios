//
//  ChatHistory_DB.h
//  XMWClient
//
//  Created by dotvikios on 17/04/19.
//  Copyright © 2019 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseDAO.h"
#import "ChatHistory_Object.h"
NS_ASSUME_NONNULL_BEGIN

@interface ChatHistory_DB : BaseDAO
{
    NSString* dbFileName;
    NSString* contextId;
    NSMutableArray* contactList;
    int chatThreatIdToRetrieveHistory;
}
@property  NSString* dbFileName;
@property  NSString* contextId;
@property  NSMutableArray* contactList;
@property  int chatThreatIdToRetrieveHistory;
-(void)dropTable :(NSString*) context;
-(BOOL) createTable;
+ (void) createInstance : (NSString*) contextId :  (BOOL) isDefault :(int)chatThreadId;

-(int) insertDoc : (ChatHistory_Object*) chatHistory_Object;
+ (BOOL) isInitialized :(NSString*) contextId ;
+ (ChatHistory_DB*) getInstance ;
+ (ChatHistory_DB*) getInstance : (NSString*) contextId ;
-(NSMutableArray*)  getRecentDocumentsData : (NSString *)delete_stringFlag;
- (ChatHistory_Object*) retrieveItem : (sqlite3_stmt *) statement ;
@end

NS_ASSUME_NONNULL_END
