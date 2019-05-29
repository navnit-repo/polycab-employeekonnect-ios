//
//  ReadUnreadService.m
//  XMWClient
//
//  Created by dotvikios on 24/05/19.
//  Copyright © 2019 dotvik. All rights reserved.
//

#import "ReadUnreadService.h"
#import "NetworkHelper.h"
#import "ChatHistory_Object.h"
#import "ChatHistory_DB.h"
#import "ChatThreadList_Object.h"
#import "ChatThreadList_DB.h"
#import "ChatBoxVC.h"
#import "SWRevealViewController.h"
#import "XmwcsConstant.h"
@implementation ReadUnreadService
{
    NetworkHelper *networkHelper;
}
- (id)initWithPostData:(NSMutableDictionary *)request withContext:(NSString *)context
{
    self = [super init];
    
    if(self!=nil) {
        self.requestDict = request;
        self.callName = context;
        networkHelper = [[NetworkHelper alloc] init];
        [self networkCall];
    }
    return self;
}
-(void)networkCall
{
    NSString *url = [XmwcsConst_CHAT_URL stringByAppendingString:@"PushMessage/api/messagesRead"];
    networkHelper.serviceURLString =  url;
//    networkHelper.serviceURLString =  @"http://polycab.dotvik.com:8080/PushMessage/api/messagesRead";
    [networkHelper genericJSONPayloadRequestWith:self.requestDict :self :self.callName];
}
- (void) httpResponseObjectHandler : (NSString*) callName : (id) respondedObject : (id) requestedObject
{

    if ([callName isEqualToString:self.callName]) {
        
        if ([[respondedObject objectForKey:@"status"] boolValue] == YES) {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
            [dict setDictionary:[respondedObject objectForKey:@"responseData"]];
            NSMutableArray *updated = [dict valueForKey:@"updated"];
            NSMutableArray *failedToUpdate = [dict valueForKey:@"failedToUpdate"];
            for ( int i=0; i<updated.count; i++) {
                [ChatHistory_DB createInstance : @"ChatHistory_DB_STORAGE" : true :[[dict valueForKey:@"chatThreadId"] integerValue]];
                ChatHistory_DB *chatHistory_DBStorage = [ChatHistory_DB getInstance];
                
                ChatHistory_Object* chatHistory_Object = [[ChatHistory_Object alloc] init];
                chatHistory_Object.chatThreadId = [[dict valueForKey:@"chatThreadId"] integerValue] ;
                chatHistory_Object.messageId    =  [[updated objectAtIndex:i] integerValue];
                [chatHistory_DBStorage updateUnreadMessageStatus:chatHistory_Object];
            }
            if (failedToUpdate.count>0) {
                //                [self unreadMessageNetworkCall];
            }
            else
            {
                
                [ChatThreadList_DB createInstance : @"ChatThread_DB_STORAGE" : true];
                ChatThreadList_DB *chatThreadListStorage = [ChatThreadList_DB getInstance];
                ChatThreadList_Object* chatThreadList_Object = [[ChatThreadList_Object alloc] init];
                chatThreadList_Object.chatThreadId =[[dict valueForKey:@"chatThreadId"] integerValue] ;
                [chatThreadListStorage updateUnreadThread:chatThreadList_Object :0];
                //                [chatThreadListStorage updateUnreadThread:chatThreadList_Object];
                
                UIViewController *root;
                root = [[[[UIApplication sharedApplication]windows]objectAtIndex:0]rootViewController];
                SWRevealViewController *reveal = (SWRevealViewController*)root;
                UINavigationController *check =(UINavigationController*)reveal.frontViewController;
                NSArray* viewsList = check.viewControllers;
                if (viewsList.count==3) {
                    UIViewController *checkView = (UIViewController *) [viewsList objectAtIndex:viewsList.count - 2];
                    NSMutableArray *chatThreadListStorageData = [chatThreadListStorage getRecentDocumentsData : @"False"];
                    if ([checkView isKindOfClass:[ChatBoxVC class]]) {
                        ChatBoxVC *vc =  (ChatBoxVC*) checkView;
                        vc.chatThreadDict = chatThreadListStorageData;
                    }
                }
                
                
                
            }
        }
    }
}
- (void) httpFailureHandler : (NSString*) callName : (NSString*) message {
    
    
}
@end
