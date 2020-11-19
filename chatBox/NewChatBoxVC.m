//
//  NewChatBoxVC.m
//  XMWClient
//
//  Created by dotvikios on 07/05/19.
//  Copyright © 2019 dotvik. All rights reserved.
//

#import "NewChatBoxVC.h"
#import "NetworkHelper.h"
#import "LoadingView.h"
#import "XmwcsConstant.h"
#import "DVAppDelegate.h"
#import "AppConstants.h"
#import "LayoutClass.h"
#import "ClientVariable.h"
#import "ChatThreadCell.h"
#import "ChatThreadList_Object.h"
#import "LogInVC.h"
@interface NewChatBoxVC ()

@end

@implementation NewChatBoxVC
{
    NetworkHelper *networkHelper;
    LoadingView *loadingView;
    NSMutableArray *dataArray;
    NSMutableDictionary *expendStatus;
}
@synthesize chatTableView;
- (void)viewDidLoad {
    [super viewDidLoad];
    if (isiPhoneXSMAX) {
        self.view.frame = CGRectMake(0, 64, 414, 832);
    }
    else if(isiPhoneXR) {
        self.view.frame = CGRectMake(0, 64, 414, 832);
    }
    
    else if(isiPhoneXS) {
        self.view.frame = CGRectMake(0, 64, 375, 748);
    }
    else if(isiPhone10) {
        self.view.frame = CGRectMake(0, 64, 375, 748);
    }
    
    else if(isiPhone6Plus) {
        self.view.frame = CGRectMake(0, 64, 414, 672);
    }
    else if(isiPhone6) {
        self.view.frame = CGRectMake(0, 64, 375, 600);
    } else if(isiPhone5) {
        self.view.frame = CGRectMake(0, 64, 320, 504);
    } else {
        // 0, 64, 320, 416
        self.view.frame = CGRectMake(0, 64, 320, 416);
    }
    dataArray = [[NSMutableArray alloc]init];
    expendStatus = [[NSMutableDictionary alloc]init];
    [self drawHeaderItem];
    [self initializeView];
    [self netWorkCall];
}
-(void) drawHeaderItem
{
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage
                                                                          imageNamed:@"back-button"]  style:UIBarButtonItemStylePlain target:self
                                                                  action:@selector(backHandler:)];
    
    
    
    backButton.tintColor = [UIColor whiteColor];
    
    
    
    UIBarButtonItem *addButon = [[UIBarButtonItem alloc]initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self action:@selector(addButtonHandler:)];
    addButon.tintColor = [UIColor whiteColor];
    
    
    UIImageView *polycabLogo = [[UIImageView alloc] initWithImage:[UIImage  imageNamed:@"polycab_logo"]];
    self.navigationItem.titleView.contentMode = UIViewContentModeCenter;
    self.navigationItem.titleView = polycabLogo;
    
    [self.navigationItem setLeftBarButtonItem:backButton];
    [self.navigationItem setRightBarButtonItem:addButon];
    
}
- (void) backHandler : (id) sender
{
    [ [self navigationController]  popViewControllerAnimated:YES];
    
}
- (void) addButtonHandler : (id) sender
{
//    ChatBoxUserListVC *userListVC = [[ChatBoxUserListVC alloc]init];
//    [[self navigationController] pushViewController:userListVC animated:YES];
    
}
-(void)initializeView
{
    [LayoutClass setLayoutForIPhone6:self.lineView1];
    [LayoutClass setLayoutForIPhone6:self.lineView2];
    [LayoutClass labelLayout:self.nameLbl forFontWeight:UIFontWeightBold];
    [LayoutClass setLayoutForIPhone6:self.chatTableView];
    

    chatTableView.bounces = NO;
    
    //    [self setHeaderDetailsData];
}
-(void)netWorkCall
{
    loadingView = [LoadingView loadingViewInView:self.view];
    ClientVariable* clientVariables = [ClientVariable getInstance : [DVAppDelegate currentModuleContext] ];
    NSString * version = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
    NSMutableDictionary *chatThreadRequestData = [[NSMutableDictionary alloc]init];
    
    [chatThreadRequestData setValue:@"1" forKey:@"requestId"];
    [chatThreadRequestData setValue:clientVariables.CLIENT_LOGIN_RESPONSE.authToken forKey:@"authToken"];
    [chatThreadRequestData setValue:[chatPersonUserID stringByAppendingString:@"@employee"] forKey:@"username"];
    
    
    NSMutableDictionary *reqstData = [[NSMutableDictionary alloc]init];
    
    NSString* username = [[NSUserDefaults standardUserDefaults] objectForKey:@"USERNAME"];
    
    [reqstData setValue:[chatPersonUserID stringByAppendingString:@"@employee"] forKey:@"userId"];
    [reqstData setValue:[[clientVariables.CLIENT_USER_LOGIN deviceInfoMap] valueForKey:@"IMEI"] forKey:@"deviceId"];
    [reqstData setValue:XmwcsConst_DEVICE_TYPE_IPHONE forKey:@"osType"];
    [reqstData setValue:version forKey:@"appVersion"];
    [reqstData setValue:@"1" forKey:@"apiVersion"];
    [chatThreadRequestData setObject:reqstData forKey:@"requestData"];
    
    networkHelper = [[NetworkHelper alloc]init];
    NSString * url=[XmwcsConst_CHAT_URL stringByAppendingString:@"PushMessage/api/chatThreadsGroupByUser"];
    networkHelper.serviceURLString = url;
//    networkHelper.serviceURLString = @"http://polycab.dotvik.com:8080/PushMessage/api/chatThreadsGroupByUser";
    [networkHelper genericJSONPayloadRequestWith:chatThreadRequestData :self :@"chatThreadRequestData"];
}
- (void) httpResponseObjectHandler : (NSString*) callName : (id) respondedObject : (id) requestedObject
{
    [loadingView removeView];
    if ([callName isEqualToString:@"chatThreadRequestData"]) {
        
        if ([[respondedObject objectForKey:@"status"] boolValue] == YES) {
            dataArray = [[NSMutableArray alloc]init];
            [dataArray addObjectsFromArray:[[respondedObject objectForKey:@"responseData"]  objectForKey:@"groupByUser"]];
            [chatTableView reloadData];
        }
    }
    
}
- (void) httpFailureHandler : (NSString*) callName : (NSString*) message {
    [loadingView removeView];
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
    [myAlertView show];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{  NSString *str = [NSString stringWithFormat:@"cell_%ld",indexPath.row];
//    ChatThreadList_Object *objectCheckDict = (ChatThreadList_Object*)[dataArray objectAtIndex:indexPath.row];
    if ([[dataArray objectAtIndex:indexPath.row] isKindOfClass:[NSDictionary class]]  ) {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:str];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:str];
        cell.textLabel.text = [[dataArray objectAtIndex:indexPath.row] valueForKey:@"userId"];
//        [expendStatus setObject:@"YES" forKey:str];
        return cell;
    }
    else if([[dataArray objectAtIndex:indexPath.row] isKindOfClass:[ChatThreadList_Object class]] )
    {
        ChatThreadCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        //    if (cell==nil) {
        [tableView registerNib:[UINib nibWithNibName:@"ChatThreadCell" bundle:nil] forCellReuseIdentifier:str];
        cell  = [tableView dequeueReusableCellWithIdentifier:str];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        ChatThreadList_Object *obj = (ChatThreadList_Object *)[dataArray objectAtIndex:indexPath.row];
        cell.subjectLbl.text = obj.subject;
        cell.chatPersonLbl.text = obj.displayName;
        double timeStamp = [obj.lastMessageOn doubleValue];

        NSTimeInterval timeInterval=timeStamp/1000;
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
        NSDateFormatter *dateformatter=[[NSDateFormatter alloc]init];
        [dateformatter setDateFormat:@"dd LLL,yy HH:mm"];
        NSString *dateString=[dateformatter stringFromDate:date];
        cell.timeStampLbl.text =dateString;
        cell.tag = obj.chatThreadId;

        if ([obj.status isEqualToString:@"Accept"] || [obj.status isEqualToString:@"Close"]) {
            //            cell.subjectLbl.textColor    =[UIColor colorWithRed:211.0f/255 green:211.0f/255 blue:211.0f/255 alpha:1.0];
            //            cell.chatPersonLbl.textColor =[UIColor colorWithRed:211.0f/255 green:211.0f/255 blue:211.0f/255 alpha:1.0];
            //            cell.timeStampLbl.textColor  =[UIColor colorWithRed:211.0f/255 green:211.0f/255 blue:211.0f/255 alpha:1.0];
            [cell.acceptImageView setImage:[UIImage imageNamed:@"Tick_Mark"]];
        }
        NSString *newPushCheck = [[NSUserDefaults standardUserDefaults] valueForKey:[NSString stringWithFormat:@"NEW_PUSH_%d",obj.chatThreadId]];
        if ([newPushCheck isEqualToString:@"YES"]) {

        }
        else
        {
            cell.pushView.backgroundColor = [UIColor clearColor];
        }
        return cell;
    }

    return nil;
    
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{   NSString *status = [expendStatus valueForKey:[NSString stringWithFormat:@"cell_%ld",indexPath.row]];
    
    
     if ([status isEqualToString:@"YES"]) {
          [expendStatus setObject:@"NO" forKey:[NSString stringWithFormat:@"cell_%ld",indexPath.row]];
        NSUInteger count=indexPath.row+1;
        NSMutableArray *arCells=[NSMutableArray array];
         NSMutableArray *clildData =[[dataArray objectAtIndex:indexPath.row] valueForKey:@"threads"];
         for (int i=0; i<[clildData count]; i++) {
              ChatThreadList_Object* dInner = [[ChatThreadList_Object alloc] init];
             dInner.chatThreadId =[[[clildData objectAtIndex:i] valueForKey:@"id"] integerValue] ;
             dInner.from =   [ NSString stringWithFormat:@"%@", [[clildData objectAtIndex:i] valueForKey:@"fromUserId"]];
             dInner.to =  [ NSString stringWithFormat:@"%@",[[clildData objectAtIndex:i] valueForKey:@"toUserId"]];
             dInner.subject =[ NSString stringWithFormat:@"%@",[[clildData objectAtIndex:i] valueForKey:@"subject"]];
             dInner.lastMessageOn =[ NSString stringWithFormat:@"%@",[[clildData objectAtIndex:i] valueForKey:@"lastMessageOn"]];
             dInner.status =[ NSString stringWithFormat:@"%@",[[clildData objectAtIndex:i] valueForKey:@"status"]];
             dInner.displayName = @"abc";
              [arCells addObject:[NSIndexPath indexPathForRow:count inSection:0]];
              [dataArray insertObject:dInner atIndex:count++];
         }
        [tableView insertRowsAtIndexPaths:arCells withRowAnimation:UITableViewRowAnimationLeft];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    else
    {
         [expendStatus setObject:@"YES" forKey:[NSString stringWithFormat:@"cell_%ld",indexPath.row]];
        NSMutableArray *array = [[NSMutableArray alloc]init];
        for (int i=0; i<dataArray.count; i++) {
             if([[dataArray objectAtIndex:i] isKindOfClass:[ChatThreadList_Object class]] )
             {
                 [array addObject:[dataArray objectAtIndex:i]];
             }
        }
      
       [self miniMizeThisRows:array];
    }
  
}

-(void)miniMizeThisRows:(NSArray*)ar{

//    for (int i=0; i<[ar count]; i++) {
//        if ([[dataArray objectAtIndex:i] isKindOfClass:[ChatThreadList_Object class]]) {
//            NSUInteger indexToRemove= [dataArray indexOfObject:[dataArray objectAtIndex:i]];
//            [dataArray replaceObjectAtIndex:indexToRemove withObject:@""];
//            [chatTableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:indexToRemove inSection:0] animated:UITableViewRowAnimationRight];
//
//            [chatTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:
//                                                   [NSIndexPath indexPathForRow:indexToRemove inSection:0]
//                                                   ]
//                                 withRowAnimation:UITableViewRowAnimationRight];
//        }
//
//    }
    
    for(ChatThreadList_Object *dInner in ar ) {
        NSUInteger indexToRemove=[dataArray indexOfObject:dInner];
//        NSArray *arInner=dInner.childCategories;
//        if(arInner && [arInner count]>0){
//            [self miniMizeThisRows:arInner];
//        }
        
        if([dataArray indexOfObject:dInner]!=NSNotFound) {
            [dataArray removeObject:dInner];
            [chatTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:
                                          [NSIndexPath indexPathForRow:indexToRemove inSection:0]
                                          ]
                        withRowAnimation:UITableViewRowAnimationRight];
        }
    }
    
}
@end
