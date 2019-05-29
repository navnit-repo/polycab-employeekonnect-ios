//
//  ChatThreadCell.m
//  XMWClient
//
//  Created by dotvikios on 12/04/19.
//  Copyright © 2019 dotvik. All rights reserved.
//

#import "ChatThreadCell.h"
#import "LayoutClass.h"
#import "DVAppDelegate.h"
#import "ClientVariable.h"
#import "NetworkHelper.h"
#import "LoadingView.h"
#import "ChatThreadList_Object.h"
#import "ChatThreadList_DB.h"
#import "ChatBoxVC.h"
#import "ExpendObjectClass.h"
@implementation ChatThreadCell
{
    NetworkHelper *networkHelper;
    LoadingView *loadingView;
    NSString *chatThreadId;
}
@synthesize pushView;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
     [LayoutClass labelLayout:self.chatIdLbl forFontWeight:UIFontWeightRegular];
    [LayoutClass labelLayout:self.subjectLbl forFontWeight:UIFontWeightRegular];
    [LayoutClass labelLayout:self.timeStampLbl forFontWeight:UIFontWeightRegular];
    [LayoutClass labelLayout:self.chatPersonLbl forFontWeight:UIFontWeightRegular];
    [LayoutClass setLayoutForIPhone6:self.pushView];
    [LayoutClass setLayoutForIPhone6:self.acceptImageView];
    [LayoutClass buttonLayout:self.closeButtonOutlate forFontWeight:UIFontWeightBold];
    pushView.layer.cornerRadius = 5;  // half the width/height

}
- (IBAction)deleteButton:(id)sender {
    MXButton *button = (MXButton*) sender;
    chatThreadId =button.elementId;
    NSLog(@"delete thread : %@",chatThreadId);
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:@"Do you want to delete the chat?" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:@"cancel", nil];
    [alertView show];
   
}
-(void)networkCall
{
    UIViewController *root;
    root = [[[[UIApplication sharedApplication]windows]objectAtIndex:0]rootViewController];
    SWRevealViewController *reveal = (SWRevealViewController*)root;
    UINavigationController *check =(UINavigationController*)reveal.frontViewController;
    NSArray* viewsList = check.viewControllers;
    UIViewController *checkView = (UIViewController *) [viewsList objectAtIndex:viewsList.count - 1];
    
    loadingView = [LoadingView loadingViewInView:checkView.view];
    ClientVariable* clientVariables = [ClientVariable getInstance : [DVAppDelegate currentModuleContext] ];
    NSString * version = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
    NSMutableDictionary *chatThreadRequestData = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *reqstData = [[NSMutableDictionary alloc]init];
    NSMutableArray *threadsArray = [[NSMutableArray alloc]init];
    [threadsArray addObject:chatThreadId];
    [chatThreadRequestData setValue:@"1" forKey:@"requestId"];
    [reqstData setValue:[[clientVariables.CLIENT_USER_LOGIN userName] stringByAppendingString:@"@employee"] forKey:@"userId"];
    [reqstData setValue:[[clientVariables.CLIENT_USER_LOGIN deviceInfoMap] valueForKey:@"IMEI"] forKey:@"deviceId"];
    [reqstData setValue:XmwcsConst_DEVICE_TYPE_IPHONE forKey:@"osType"];
    [reqstData setValue:version forKey:@"appVersion"];
    [reqstData setValue:@"1" forKey:@"apiVersion"];
    [reqstData setValue:threadsArray forKey:@"chatThreads"];
    [chatThreadRequestData setObject:reqstData forKey:@"requestData"];
    
    networkHelper = [[NetworkHelper alloc]init];
    NSString * url=[XmwcsConst_CHAT_URL stringByAppendingString:@"PushMessage/api/deleteChatThreads"];
    networkHelper.serviceURLString = url;
//    networkHelper.serviceURLString = @"http://polycab.dotvik.com:8080/PushMessage/api/deleteChatThreads";
    [networkHelper genericJSONPayloadRequestWith:chatThreadRequestData :self :@"deleteThread"];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        //Code for OK button
        [self networkCall];
    }
    if (buttonIndex == 1)
    {
        //Code for other button
    }
}

#pragma -mark Network Call Response methods
- (void) httpResponseObjectHandler : (NSString*) callName : (id) respondedObject : (id) requestedObject
{
    [loadingView removeView];
    if ([callName isEqualToString:@"deleteThread"]) {
        if ([[respondedObject objectForKey:@"status"] boolValue] == YES) {
            NSMutableDictionary  *dict = [[NSMutableDictionary alloc]init];
            [dict setDictionary:[respondedObject objectForKey:@"responseData"]];
            
            [ChatThreadList_DB createInstance : @"ChatThread_DB_STORAGE" : true];
            ChatThreadList_DB *chatThreadListStorage = [ChatThreadList_DB getInstance];
            
            NSMutableArray *deleteThreadsArray = [[NSMutableArray alloc]init];
            [deleteThreadsArray addObjectsFromArray:[dict valueForKey:@"deleted"]];
            for (int i=0; i<deleteThreadsArray.count; i++) {
                ChatThreadList_Object* chatThreadList_Object = [[ChatThreadList_Object alloc] init];
                chatThreadList_Object.chatThreadId = [[deleteThreadsArray objectAtIndex:i] intValue] ;
                chatThreadList_Object.deletedFlag =@"YES";
                [chatThreadListStorage updateDeletedTheadFlag:chatThreadList_Object];
            }
          
            
            NSMutableArray *chatThreadListStorageData = [chatThreadListStorage getRecentDocumentsData : @"False"];
            UIViewController *root;
            root = [[[[UIApplication sharedApplication]windows]objectAtIndex:0]rootViewController];
            SWRevealViewController *reveal = (SWRevealViewController*)root;
            UINavigationController *check =(UINavigationController*)reveal.frontViewController;
            NSArray* viewsList = check.viewControllers;
            UIViewController *checkView = (UIViewController *) [viewsList objectAtIndex:viewsList.count - 1];
            if ([checkView isKindOfClass:[ChatBoxVC class]]) {
                ChatBoxVC *vc  = (ChatBoxVC *) checkView;
                vc.chatThreadDict = [[NSMutableArray alloc]init];
                [vc.chatThreadDict addObjectsFromArray:[self groupData:chatThreadListStorageData]];
                [vc.threadListTableView reloadData];
            }
        }
    else
    {
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"" message:[[respondedObject valueForKey:@"errorData"] valueForKey:@"displayMessage"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
        [myAlertView show];
    }
}
}
- (void) httpFailureHandler : (NSString*) callName : (NSString*) message {
    [loadingView removeView];
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
    [myAlertView show];
    
}
-(NSMutableArray*)groupData :(NSArray*)dataArray
{
    NSMutableArray*distinctName = [[NSMutableArray alloc]init];
    for (int i=0; i<dataArray.count; i++) {
        ChatThreadList_Object *obj = (ChatThreadList_Object*) [dataArray objectAtIndex:i];
        
        if (![distinctName  containsObject:obj.displayName]) {
            [distinctName addObject:obj.displayName];
        }
    }
    
    NSMutableArray *groupObject = [[NSMutableArray alloc]init];
    for (int i=0; i<distinctName.count; i++) {
        NSMutableArray *array = [[NSMutableArray alloc]init];
        ExpendObjectClass * expendObj = [[ExpendObjectClass alloc]init];
        for (int j=0; j<dataArray.count; j++) {
            ChatThreadList_Object *obj = (ChatThreadList_Object*) [dataArray objectAtIndex:j];
            if ([obj.displayName isEqualToString:[distinctName objectAtIndex:i]] ) {
                [array addObject:obj];
            }
            
        }
        expendObj.MENU_NAME =[distinctName objectAtIndex:i];
        expendObj.childCategories = array;
        [groupObject addObject:expendObj];
    }
    return groupObject;
}
@end
