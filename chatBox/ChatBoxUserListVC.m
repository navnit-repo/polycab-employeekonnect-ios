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
#import "LayoutClass.h"
#import "DVAppDelegate.h"
@interface ChatBoxUserListVC ()

@end

@implementation ChatBoxUserListVC
{
    NetworkHelper *networkHelper;
    LoadingView *loadingView;
    UITableView *mainTableView;
    UISearchBar *searchBar;
    NSMutableArray *orignalContactListArray;
    NSMutableArray *searchTextArray;
}
@synthesize contactsList;
- (void)viewDidLoad {
    [super viewDidLoad];
     self.navigationController.navigationBar.translucent = NO;
    CGFloat navBarHeight = self.navigationController.navigationBar.frame.size.height;
    NSLog(@"Navigation Bar height : %f",navBarHeight);
    CGFloat statusBarSize = [[UIApplication sharedApplication] statusBarFrame].size.height;
    NSLog(@"statusBarSize Bar height : %f",statusBarSize);
    CGFloat yorigin = navBarHeight +statusBarSize;
    CGFloat totalViewHeight = [[UIApplication sharedApplication].keyWindow bounds].size.height;
    if (isiPhoneXSMAX) {
        self.view.frame = CGRectMake(0, yorigin, 414, totalViewHeight-yorigin);
    }
    else if(isiPhoneXR) {
        self.view.frame = CGRectMake(0, yorigin, 414, totalViewHeight-yorigin);
    }

    else if(isiPhoneXS) {
        self.view.frame = CGRectMake(0, yorigin, 375, totalViewHeight-yorigin);
    }
    else if(isiPhone10) {
        self.view.frame = CGRectMake(0, yorigin, 375, totalViewHeight-yorigin);
    }

    else if(isiPhone6Plus) {
        self.view.frame = CGRectMake(0, yorigin, 414, totalViewHeight-yorigin);
    }
    else if(isiPhone6) {
        self.view.frame = CGRectMake(0, yorigin, 375, totalViewHeight-yorigin);
    } else if(isiPhone5) {
        self.view.frame = CGRectMake(0, yorigin, 320, totalViewHeight-yorigin);
    } else {
        // 0, 64, 320, 416
        self.view.frame = CGRectMake(0, yorigin, 320, totalViewHeight-yorigin);
    }
    
    contactsList = [[NSMutableArray alloc]init];
    orignalContactListArray = [[NSMutableArray alloc]init];
    [self drawHeaderItem];
    [self configureTableView];
    [self fetchUserListFormServerNetworkCall];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    searchBar.text = @"";
    [mainTableView reloadData];
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
    
    searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(20, 8, self.view.frame.size.width-40, 44*deviceHeightRation)];
    searchBar.delegate = self;
    searchBar.barTintColor = [UIColor whiteColor];
    searchBar.layer.borderWidth = 0.5;
    searchBar.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [searchBar setPlaceholder:@"Search"];
    [searchBar setReturnKeyType:UIReturnKeyDone];
    searchBar.enablesReturnKeyAutomatically = NO;
    [self.view addSubview:searchBar];
    
    mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, searchBar.frame.size.height+searchBar.frame.origin.y, self.view.bounds.size.width, self.view.bounds.size.height-(searchBar.frame.size.height+searchBar.frame.origin.y)) style:UITableViewStylePlain];
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
        [orignalContactListArray addObjectsFromArray: contactsList];
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
        NSString * url=[XmwcsConst_CHAT_URL stringByAppendingString:@"PushMessage/api/getContacts"];
         networkHelper.serviceURLString = url;
//        networkHelper.serviceURLString = @"http://polycab.dotvik.com:8080/PushMessage/api/getContacts";
        [networkHelper genericJSONPayloadRequestWith:requstData :self :@"requestUserList"];
    }
    
}

- (void) httpResponseObjectHandler : (NSString*) callName : (id) respondedObject : (id) requestedObject
{
    [loadingView removeView];
    if ([callName isEqualToString:@"requestUserList"]) {
        if ([[respondedObject objectForKey:@"status"] boolValue] == YES) {
            
            if ([[[respondedObject valueForKey:@"responseData"] valueForKey:@"contacts"] isKindOfClass:[NSNull class]]) {
                // do nothing
            }
            else
            {
                [contactsList addObjectsFromArray:[[respondedObject valueForKey:@"responseData"] valueForKey:@"contacts"]];
            }
        
            [ContactList_DB createInstance : @"ContactList_DB_STORAGE" : true];
            ContactList_DB *contactListStorage = [ContactList_DB getInstance];
            [contactListStorage dropTable:@"ContactList_DB_STORAGE"];
            
            for(int i =0; i<[contactsList count];i++) //for unhidden contact  insert into db
            {
                ContactList_Object* contactList_Object = [[ContactList_Object alloc] init];
                contactList_Object.emailId = [[contactsList objectAtIndex:i] valueForKey:@"emailId"];
                contactList_Object.name =    [[contactsList objectAtIndex:i] valueForKey:@"name"];
                contactList_Object.userId =  [[contactsList objectAtIndex:i] valueForKey:@"userId"];
                contactList_Object.isHidden = 0;
                [contactListStorage insertDoc:contactList_Object];
            }
            
            contactsList = [[NSMutableArray alloc]init];
            if ([[[respondedObject valueForKey:@"responseData"] valueForKey:@"hiddenContacts"] isKindOfClass:[NSNull class]]) {
                // do nothing
            }
            else{
                [contactsList addObjectsFromArray:[[respondedObject valueForKey:@"responseData"] valueForKey:@"hiddenContacts"]];
            }
            
            for(int i =0; i<[contactsList count];i++) //for hidden contact  insert into db
            {
                ContactList_Object* contactList_Object = [[ContactList_Object alloc] init];
                contactList_Object.emailId = [[contactsList objectAtIndex:i] valueForKey:@"emailId"];
                contactList_Object.name =    [[contactsList objectAtIndex:i] valueForKey:@"name"];
                contactList_Object.userId =  [[contactsList objectAtIndex:i] valueForKey:@"userId"];
                contactList_Object.isHidden = 1;
                [contactListStorage insertDoc:contactList_Object];
            }
            
            NSMutableArray *contactListStorageData = [contactListStorage getRecentDocumentsData : @"False"];
            contactsList = [[NSMutableArray alloc]init];
            orignalContactListArray =  [[NSMutableArray alloc]init];
            [contactsList addObjectsFromArray:contactListStorageData];
            [orignalContactListArray addObjectsFromArray: contactsList];
            [mainTableView reloadData];
            
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
//    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifire];
        
       //  UIView *cellView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
         UILabel *name= [[UILabel alloc]initWithFrame:CGRectMake(20, 10, self.view.frame.size.width, 20)];
         [name setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14.0f]];
         [name setTextColor:[UIColor blackColor]];
         name.text =[[contactsList objectAtIndex:indexPath.row] valueForKey:@"name"];
        
         UILabel *email= [[UILabel alloc]initWithFrame:CGRectMake(20, 32, self.view.frame.size.width, 20)];
        [email setFont:[UIFont fontWithName:@"Helvetica-light" size:12.0f]];
        [email setTextColor:[UIColor lightGrayColor]];
        email.text =[[contactsList objectAtIndex:indexPath.row] valueForKey:@"emailId"];
        
        [LayoutClass labelLayout:name forFontWeight:UIFontWeightBold];
        [LayoutClass labelLayout:email forFontWeight:UIFontWeightRegular];
        
        [cell.contentView addSubview:name];
        [cell.contentView addSubview:email];
//    }
    
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
    vc.nameLblText = [[contactsList objectAtIndex:indexPath.row] valueForKey:@"name"];
    
    [self.navigationController pushViewController:vc animated:YES];
    
    //// this code for back handling(to assign original contact list )
    [searchBar resignFirstResponder];
    contactsList = [[NSMutableArray alloc]init];
    [contactsList addObjectsFromArray:orignalContactListArray];
    ////
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10; // you can have your own choice, of course
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
    
}


#pragma mark - searchBar handler
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSLog(@"%@",searchText);
    searchTextArray = [[NSMutableArray alloc]init];
    if (searchText.length>0) {
        
        for (int i=0; i<orignalContactListArray.count; i++) {
            ContactList_Object *obj = (ContactList_Object*) [orignalContactListArray objectAtIndex:i];
            NSString *name  = obj.name;
            
            NSRange nameRange = [name rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if (nameRange.location != NSNotFound) {
                [searchTextArray addObject: obj];
            }
            
        }
        contactsList =[[NSMutableArray alloc]init];
        [contactsList addObjectsFromArray:searchTextArray];
        [mainTableView reloadData];
    }
    else
    {   contactsList  = [[NSMutableArray alloc]init];
        [contactsList addObjectsFromArray:orignalContactListArray];
        [mainTableView reloadData];
    }
    
}
@end
