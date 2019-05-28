//
//  PushNotificationHandler.m
//  XMWClient
//
//  Created by dotvikios on 29/04/19.
//  Copyright © 2019 dotvik. All rights reserved.
//

#import "PushNotificationHandler.h"
//#import "DVAppDelegate.h"
//#import "SBJsonParser.h"
#import "ChatHistory_Object.h"
#import "ChatHistory_DB.h"
#import "ChatThreadList_Object.h"
#import "ChatThreadList_DB.h"
#import "ContactList_DB.h"
#import "ContactList_Object.h"
#import "KeychainItemWrapper.h"
//#import "ClientVariable.h"
@implementation PushNotificationHandler
+ (void)notificationDict:(NSDictionary *)dict
{
    @synchronized (self) {
        
 
  KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"com.polycab.xmw.employee" accessGroup:nil ];
    NSString *userId = [keychainItem objectForKey:kSecAttrAccount];
    
    
    // polycab notification code
    NSString *jsonStr =[dict objectForKey:@"CONTENT_MSG"];
    
    NSData *webData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *mainDict = [NSJSONSerialization JSONObjectWithData:webData options:0 error:&error];
    NSLog(@"%@",mainDict);
    
    
    if ([[mainDict objectForKey:@"OPERATION"] isEqualToString:@"8"] ) {
        if ([[mainDict objectForKey:@"NOTIFY_CALLNAME"] isEqualToString:@"NEW_MESSAGE"]) {
            
            NSMutableDictionary *responsedict = [[NSMutableDictionary alloc]init];
            [responsedict setDictionary:[mainDict objectForKey:@"NOTIFY_MESSAGE_KEY"]];
            NSString * timeStampValue = [[NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]]stringByAppendingString:@"000"];
           // long int filterTime =[[NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]]stringByAppendingString:@"000"];
            long int filterTime = (long)[[NSDate date] timeIntervalSince1970] + 000;
            
            NSString *messageString = [responsedict valueForKey:@"message"];
            NSData *messageData = [messageString dataUsingEncoding:NSUTF8StringEncoding];
            NSString *base64MessageString = [messageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            NSLog(@"Time Stamp Value == %@", timeStampValue);
            [ChatHistory_DB createInstance : @"ChatHistory_DB_STORAGE" : true :[[responsedict valueForKey:@"chatThread"] integerValue]];
            
            ChatHistory_DB *chatHistory_DBStorage = [ChatHistory_DB getInstance];
            ChatHistory_Object* chatHistory_Object = [[ChatHistory_Object alloc] init];
            chatHistory_Object.chatThreadId =  [[responsedict valueForKey:@"chatThread"] integerValue] ;
            chatHistory_Object.from =   [ NSString stringWithFormat:@"%@", [responsedict valueForKey:@"from"]];
            chatHistory_Object.to =  [ NSString stringWithFormat:@"%@",[responsedict valueForKey:@"to"]];
            chatHistory_Object.message =base64MessageString;
            chatHistory_Object.messageDate =[ NSString stringWithFormat:@"%@",timeStampValue];
            chatHistory_Object.messageType =[ NSString stringWithFormat:@"%@", [responsedict valueForKey:@"messageType"]];
            chatHistory_Object.messageRead =@"NO";
            chatHistory_Object.messageId =  [[responsedict valueForKey:@"messageId"] integerValue] ;
            [chatHistory_DBStorage insertDoc:chatHistory_Object];
            
             [ChatThreadList_DB createInstance : @"ChatThread_DB_STORAGE" : true];
             ChatThreadList_DB *chatThreadListStorage = [ChatThreadList_DB getInstance];
             ChatThreadList_Object* chatThreadList_Object = [[ChatThreadList_Object alloc] init];
             chatThreadList_Object.chatThreadId =  chatHistory_Object.chatThreadId;
             chatThreadList_Object.lastMessageOn = [ NSString stringWithFormat:@"%@",timeStampValue];
//             chatThreadList_Object.filterTimeStamp = filterTime;
            [chatThreadListStorage updateDocLastMessageTime:chatThreadList_Object];
            
     // update delete thread flag
            
  
                ChatThreadList_Object* chatThreadList_Object2 = [[ChatThreadList_Object alloc] init];
                chatThreadList_Object2.chatThreadId = chatHistory_Object.chatThreadId ;
                chatThreadList_Object2.deletedFlag =@"NO";
                [chatThreadListStorage updateDeletedTheadFlag:chatThreadList_Object2];

                int unreadCount = [chatThreadListStorage getCurrentUnreadCount:chatThreadList_Object2];
            
                [chatThreadListStorage updateUnreadThread:chatThreadList_Object2 :unreadCount+1];
            
        }
        
        else if ([[mainDict valueForKey:@"NOTIFY_CALLNAME"] isEqualToString:@"NEW_THREAD"]) {
            [ContactList_DB createInstance : @"ContactList_DB_STORAGE" : true];
            ContactList_DB *contactListStorage = [ContactList_DB getInstance];
            NSMutableDictionary *responsedict = [[NSMutableDictionary alloc]init];
            [responsedict setDictionary:[mainDict objectForKey:@"NOTIFY_MESSAGE_KEY"]];
            
            [ChatThreadList_DB createInstance : @"ChatThread_DB_STORAGE" : true];
            ChatThreadList_DB *chatThreadListStorage = [ChatThreadList_DB getInstance];
            NSArray *array = [[responsedict valueForKey:@"from"] componentsSeparatedByString:@"@"];
            NSString *ownUserId = userId ;
            NSString *parseId= @"";// for get username from contact db
            
            if ([[array objectAtIndex:0] isEqualToString:ownUserId]) {
                parseId = [responsedict valueForKey:@"to"];
            }
            
            else{
                parseId =[responsedict valueForKey:@"from"];;
            }
            
            
            
            NSArray *contactListStorageData = [contactListStorage getContactDisplayName:@"False" :parseId];
            ContactList_Object *obj;
            if (contactListStorageData.count==0) {
                obj = [[ContactList_Object alloc]init];
            }
            else{
                obj = (ContactList_Object*) [contactListStorageData objectAtIndex:0];
            }
            
            
            NSString *subjectString = [responsedict  valueForKey:@"subject"];
            NSData *subjectData = [subjectString dataUsingEncoding:NSUTF8StringEncoding];
            NSString *base64SubjectString = [subjectData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            
            ChatThreadList_Object* chatThreadList_Object = [[ChatThreadList_Object alloc] init];
            chatThreadList_Object.chatThreadId = [[[responsedict valueForKey:@"message"] valueForKey:@"chatThread"] integerValue];
            chatThreadList_Object.from =        [responsedict valueForKey:@"from"];
            chatThreadList_Object.to =          [responsedict valueForKey:@"to"];
            chatThreadList_Object.subject =     base64SubjectString;
            chatThreadList_Object.displayName = obj.userName;
            NSString * timeStampValue = [[NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]]stringByAppendingString:@"000"];
            NSLog(@"Time Stamp Value == %@", timeStampValue);
            
            chatThreadList_Object.lastMessageOn = timeStampValue;
            chatThreadList_Object.status = @"";
            chatThreadList_Object.deletedFlag = @"NO";
            chatThreadList_Object.unreadMessageCount = 1;
            chatThreadList_Object.spaNo = [responsedict valueForKey:@"spaNo"];
            [chatThreadListStorage insertDoc:chatThreadList_Object];
            [chatThreadListStorage updateDocLastMessageTime:chatThreadList_Object];
        }
        
        
        else if ([[mainDict valueForKey:@"NOTIFY_CALLNAME"] isEqualToString:@"CHAT_THREAD_STATUS_UPDATE"]) {
            NSMutableDictionary *responsedict = [[NSMutableDictionary alloc]init];
            [responsedict setDictionary:[mainDict objectForKey:@"NOTIFY_MESSAGE_KEY"]];
            
            [ChatThreadList_DB createInstance : @"ChatThread_DB_STORAGE" : true];
            ChatThreadList_DB *chatThreadListStorage = [ChatThreadList_DB getInstance];
            
            
            ChatThreadList_Object* chatThreadList_Object = [[ChatThreadList_Object alloc] init];
            chatThreadList_Object.chatThreadId =[[responsedict valueForKey:@"chatThreadId"] integerValue] ;
            chatThreadList_Object.status =[responsedict valueForKey:@"status"];
            [chatThreadListStorage updateDoc:chatThreadList_Object];
    
            
        }
        
    }
    }
}

@end
