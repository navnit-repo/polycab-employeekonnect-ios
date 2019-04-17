//
//  ChatBoxUserListVC.m
//  XMWClient
//
//  Created by dotvikios on 08/04/19.
//  Copyright © 2019 dotvik. All rights reserved.
//

#import "ChatBoxUserListVC.h"
#import "NetworkHelper.h"
#import "LoadingView.h"
#import "XmwcsConstant.h"
#import "LayoutClass.h"
#import "DVAppDelegate.h"
#import "AppConstants.h"
#import "ClientVariable.h"
#import "MessageSubjectVC.h"
#import "ContactList_DB.h"
#import "ContactList_Object.h"
@interface ChatBoxUserListVC ()

@end

@implementation ChatBoxUserListVC
{
    NetworkHelper *networkHelper;
    LoadingView *loadingView;
    UITableView *mainTableView;
}
@synthesize contactsList;
- (void)viewDidLoad {
    [super viewDidLoad];
    contactsList = [[NSMutableArray alloc]init];
    [self drawHeaderItem];
    [self configureTableView];
    [self fetchUserListFormServerNetworkCall];
    
}

-(void) drawHeaderItem
{
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage
                                                                          imageNamed:@"back-button"]  style:UIBarButtonItemStylePlain target:self
                                                                  action:@selector(backHandler:)];
    
    
    
    backButton.tintColor = [UIColor whiteColor];
    
    
    
   
    UIImageView *polycabLogo = [[UIImageView alloc] initWithImage:[UIImage  imageNamed:@"polycab_logo"]];
    self.navigationItem.titleView.contentMode = UIViewContentModeCenter;
    self.navigationItem.titleView = polycabLogo;
    [self.navigationItem setLeftBarButtonItem:backButton];
  
    
}
- (void) backHandler : (id) sender
{
    [ [self navigationController]  popViewControllerAnimated:YES];
    
}
-(void)configureTableView
{
    mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    mainTableView.bounces = NO;
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    [self.view addSubview:mainTableView];
}
-(void)fetchUserListFormServerNetworkCall
{
    [ContactList_DB createInstance : @"ContactList_DB_STORAGE" : true];
    ContactList_DB *contactListStorage = [ContactList_DB getInstance];
    NSMutableArray *contactListStorageData = [contactListStorage getRecentDocumentsData : @"False"];
    contactsList = [[NSMutableArray alloc]init];
    [contactsList addObjectsFromArray:contactListStorageData];
    if (contactsList.count!=0) {
        // show loacl save data
    }
    else
    {
        loadingView = [LoadingView loadingViewInView:self.view];
        ClientVariable* clientVariables = [ClientVariable getInstance : [DVAppDelegate currentModuleContext] ];
        NSString * version = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
        NSMutableDictionary *requstData = [[NSMutableDictionary alloc]init];
        
        [requstData setValue:@"45" forKey:@"requestId"];
        NSMutableDictionary *data = [[NSMutableDictionary alloc]init];
        [data setValue:[[clientVariables.CLIENT_USER_LOGIN userName] stringByAppendingString:@"@employee"] forKey:@"userId"];
        [data setValue:@"1" forKey:@"apiVersion"];
        [data setValue:[[clientVariables.CLIENT_USER_LOGIN deviceInfoMap] valueForKey:@"IMEI"]  forKey:@"deviceId"];
        [data setValue:XmwcsConst_DEVICE_TYPE_IPHONE forKey:@"osType"];
        [data setValue:version forKey:@"appVersion"];
        
        [requstData setObject:data forKey:@"requestData"];
        networkHelper = [[NetworkHelper alloc]init];
        NSString * url=XmwcsConst_OPCODE_URL;
        networkHelper.serviceURLString = @"http://polycab.dotvik.com:8080/PushMessage/api/getContacts";
        [networkHelper genericJSONPayloadRequestWith:requstData :self :@"requestUserList"];
    }
    
}

- (void) httpResponseObjectHandler : (NSString*) callName : (id) respondedObject : (id) requestedObject
{
    [loadingView removeView];
    if ([callName isEqualToString:@"requestUserList"]) {
        if ([[respondedObject objectForKey:@"status"] boolValue] == YES) {
            [contactsList addObjectsFromArray:[[respondedObject valueForKey:@"responseData"] valueForKey:@"contacts"]];
        
            [ContactList_DB createInstance : @"ContactList_DB_STORAGE" : true];
            ContactList_DB *contactListStorage = [ContactList_DB getInstance];
            [contactListStorage dropTable:@"ContactList_DB_STORAGE"];
            
            for(int i =0; i<[contactsList count];i++)
            {
                ContactList_Object* contactList_Object = [[ContactList_Object alloc] init];
                contactList_Object.emailId = [[contactsList objectAtIndex:i] valueForKey:@"emailId"];
                contactList_Object.name =    [[contactsList objectAtIndex:i] valueForKey:@"name"];
                contactList_Object.userId =  [[contactsList objectAtIndex:i] valueForKey:@"userId"];
                [contactListStorage insertDoc:contactList_Object];
            }
            NSMutableArray *contactListStorageData = [contactListStorage getRecentDocumentsData : @"False"];
            contactsList = [[NSMutableArray alloc]init];
            [contactsList addObjectsFromArray:contactListStorageData];
            [mainTableView reloadData];
            
        }
        else
        {
            UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"" message:[[respondedObject valueForKey:@"responseData"] valueForKey:@"displayMessage"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
            [myAlertView show];
        }
       
    }
}
- (void) httpFailureHandler : (NSString*) callName : (NSString*) message {
    [loadingView removeView];
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
    [myAlertView show];
    
}
#pragma - mark Tableview methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return contactsList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifire= [NSString stringWithFormat:@"cell_%ld",(long)indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifire];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifire];
        
       //  UIView *cellView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
         UILabel *name= [[UILabel alloc]initWithFrame:CGRectMake(20, 0, self.view.frame.size.width, 20)];
         [name setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14.0f]];
         [name setTextColor:[UIColor blackColor]];
         name.text =[[contactsList objectAtIndex:indexPath.row] valueForKey:@"name"];
        
         UILabel *email= [[UILabel alloc]initWithFrame:CGRectMake(20, 22, self.view.frame.size.width, 20)];
        [email setFont:[UIFont fontWithName:@"Helvetica-light" size:12.0f]];
        [email setTextColor:[UIColor lightGrayColor]];
        email.text =[[contactsList objectAtIndex:indexPath.row] valueForKey:@"emailId"];
        
        [cell.contentView addSubview:name];
        [cell.contentView addSubview:email];
    }
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"UserID unique : %@",[[contactsList objectAtIndex:indexPath.row] valueForKey:@"userId"]);
    MessageSubjectVC *vc = [[MessageSubjectVC alloc]init];
   vc.userIDUnique = [[contactsList objectAtIndex:indexPath.row] valueForKey:@"userId"];
    [self.navigationController pushViewController:vc animated:YES];
}
@end