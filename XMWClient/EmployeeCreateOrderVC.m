//
//  EmployeeCreateOrderVC.m
//  XMWClient
//
//  Created by dotvikios on 03/12/18.
//  Copyright © 2018 dotvik. All rights reserved.
//

#import "EmployeeCreateOrderVC.h"
#import "LogInVC.h"
#import "NetworkHelper.h"
#import "HttpEventListener.h"
#import "XmwcsConstant.h"
#import "LoadingView.h"
#import "DotFormPost.h"
#import "SearchResponse.h"
#import "DVAppDelegate.h"

@interface EmployeeCreateOrderVC ()

@end

@implementation EmployeeCreateOrderVC
{
    NSString* codeLOB;
    NetworkHelper *networkHelper;
    LoadingView *loadingView;
    NSString *registryID;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    registryID = [[NSUserDefaults standardUserDefaults]valueForKey:@"selectedRegisterIDCode"];
    // Do any additional setup after loading the view from its nib.
}

- (void)done:(SelectedListVC *)selectedListVC context:(NSString *)context code:(NSString *)code display:(NSString *)display{
    
    NSString *search= [self.mxButton.elementId stringByReplacingOccurrencesOfString:@"_button" withString:@""];
    MXTextField *dropDownField = (MXTextField *) [self getDataFromId:search];
    dropDownField.keyvalue = code;
    dropDownField.text = display;
    
    if ([dropDownField.elementId isEqualToString:@"REGISTRY_ID"]) {
        regIDCheck = YES;
        
         [[NSUserDefaults standardUserDefaults ] setObject:display forKey:@"selectedRegisterID"];
         [[NSUserDefaults standardUserDefaults ] setObject:code forKey:@"selectedRegisterIDCode"];
        //blank field code
        MXTextField *BUSINESS_VERTICAL = (MXTextField *) [self getDataFromId:@"BUSINESS_VERTICAL"];
        BUSINESS_VERTICAL.text = @"";
        MXTextField *SHIP_TO = (MXTextField *) [self getDataFromId:@"SHIP_TO"];
        SHIP_TO.text = @"";
        MXTextField *BILL_TO = (MXTextField *) [self getDataFromId:@"BILL_TO"];
        BILL_TO.text = @"";
        
        
        NSMutableArray  *dropDownData = [[NSMutableArray alloc]init];
        NSMutableArray *keys =[[NSMutableArray alloc]init];
        NSMutableArray *values= [[NSMutableArray alloc]init];
        [dropDownData addObject:keys];
        [dropDownData addObject:values];
        
        MXButton *SHIP_TO_button = (MXButton*)[self getDataFromId:@"SHIP_TO_button"];
        SHIP_TO_button.attachedData = dropDownData;
        
        MXButton *BILL_TO_button = (MXButton*)[self getDataFromId:@"BILL_TO_button"];
        BILL_TO_button.attachedData = dropDownData;

        
        

        //// for employee dependent drop down add code
        MXButton *customerAccountButton = (MXButton*)[self getDataFromId:@"BUSINESS_VERTICAL_button"];
        if (customerAccountButton !=nil) {
            registryID = code;
            NSMutableArray *key = [[NSMutableArray alloc]init];
            NSMutableArray *value = [[NSMutableArray alloc]init];
            NSMutableArray *customerAccountButtonDropDownArray = [[NSMutableArray alloc]init];
            
            NSString *selectKey = [@"BUSINESS_VERTICAL_" stringByAppendingString:code];
            NSMutableArray *getDataArray = [[NSMutableArray alloc]init];
            [getDataArray addObjectsFromArray:[masterDataForEmployee  valueForKey:selectKey]];
            NSLog(@"%@",getDataArray);
            
            for (int i=0; i<getDataArray.count; i++) {
                [key addObject: [[getDataArray objectAtIndex:i] objectAtIndex:0]];
                [value addObject: [[getDataArray objectAtIndex:i] objectAtIndex:1]];
            }
            
            
            [customerAccountButtonDropDownArray addObject:key];
            [customerAccountButtonDropDownArray addObject:value];
            
            if (getDataArray.count !=0) {
                MXTextField *customerAccountdropDownField = (MXTextField *) [self getDataFromId:@"BUSINESS_VERTICAL"];
                customerAccountdropDownField.text = @"";
                customerAccountButton.attachedData = customerAccountButtonDropDownArray;
            }
        }
        NSLog(@"accessoryView details %@",   [customerAccountButton description]);
        /////  for employee add new code 73 to 101
    }

    if ([dropDownField.elementId isEqualToString:@"BUSINESS_VERTICAL"]) {
        
        
        //blank field
        MXTextField *SHIP_TO = (MXTextField *) [self getDataFromId:@"SHIP_TO"];
        SHIP_TO.text = @"";
        MXTextField *BILL_TO = (MXTextField *) [self getDataFromId:@"BILL_TO"];
        BILL_TO.text = @"";
        
        
        NSString *selectDropDownValue;
        selectDropDownValue= dropDownField.text;
        NSLog(@"Selected Value- %@",selectDropDownValue);
        NSLog(@"Element ID- %@",[dropDownField elementId ]);
        
        // Example 8004-Conduits
        NSString *value = selectDropDownValue;
        NSRange pos = [value rangeOfString:@"-"];
        codeLOB = [value substringToIndex:pos.location];
        NSLog(@"Code: %@",codeLOB);
        
        // bill to & ship to netwrok call
        [self networkCall:registryID :codeLOB];
    }
 
}
-(void)networkCall :(NSString*)registryID :(NSString*)customerAccount {
    loadingView = [LoadingView loadingViewInView:self.view];
//    dotFormPost.setAdapterType("JDBC");
//    dotFormPost.setAdapterId("SHIP_TO");
//    dotFormPost.setModuleId("xmwpolycab");
//    dotFormPost.setDocId("SHIP_TO");
//    dotFormPost.setDocDesc("SHIP TO data");
//    dotFormPost.setReportCacheRefresh("true");
//    postData.put("SEARCH_TEXT", "");
//    postData.put("SEARCH_BY", "SBC");
//    postData.put("REGISTRY_ID", userRefId);
//    postData.put("CUSTOMER_NUMBER", accountNumber);
    
 DotFormPost *dotFormPostShipTO = [[DotFormPost alloc]init];
    [dotFormPostShipTO setAdapterType:@"JDBC"];
    [dotFormPostShipTO setAdapterId:@"SHIP_TO"];
    [dotFormPostShipTO setModuleId:@"xmwpolycab"];
    [dotFormPostShipTO setDocId:@"SHIP_TO"];
    [dotFormPostShipTO setDocDesc:@"SHIP TO data"];
    [dotFormPostShipTO setReportCacheRefresh:@"true"];
    [dotFormPostShipTO.postData setObject:@"" forKey:@"SEARCH_TEXT"];
    [dotFormPostShipTO.postData setObject:@"SBC" forKey:@"SEARCH_BY"];
    [dotFormPostShipTO.postData setObject:registryID forKey:@"REGISTRY_ID"];
    [dotFormPostShipTO.postData setObject:customerAccount forKey:@"CUSTOMER_NUMBER"];
    
    
    
    networkHelper = [[NetworkHelper alloc] init];
    [networkHelper makeXmwNetworkCall:dotFormPostShipTO :self : nil :  XmwcsConst_CALL_NAME_FOR_SEARCH];
    
    
    DotFormPost *dotFormPostBillTO = [[DotFormPost alloc]init];
    [dotFormPostBillTO setAdapterType:@"JDBC"];
    [dotFormPostBillTO setAdapterId:@"BILL_TO"];
    [dotFormPostBillTO setModuleId:@"xmwpolycab"];
    [dotFormPostBillTO setDocId:@"BILL_TO"];
    [dotFormPostBillTO setDocDesc:@"Bill TO data"];
    [dotFormPostBillTO setReportCacheRefresh:@"true"];
    
    [dotFormPostBillTO.postData setObject:@"" forKey:@"SEARCH_TEXT"];
    [dotFormPostBillTO.postData setObject:@"SBC" forKey:@"SEARCH_BY"];
    [dotFormPostBillTO.postData setObject:registryID forKey:@"REGISTRY_ID"];
    [dotFormPostBillTO.postData setObject:customerAccount forKey:@"CUSTOMER_NUMBER"];
    networkHelper = [[NetworkHelper alloc] init];
    [networkHelper makeXmwNetworkCall:dotFormPostBillTO :self : nil :  XmwcsConst_CALL_NAME_FOR_SEARCH];
    
    
}

- (void)httpResponseObjectHandler:(NSString *)callName :(id)respondedObject :(id)requestedObject
{
    
    
    DotFormPost* dotformPostReqs = (DotFormPost*)requestedObject;
    
    if ([dotformPostReqs.adapterId isEqualToString:@"SHIP_TO"]) {
        
        
         SearchResponse *searchResponseObj = (SearchResponse*)respondedObject;
        NSMutableArray *searchResponseData = [[NSMutableArray alloc]init];
        [searchResponseData addObjectsFromArray:searchResponseObj.searchRecord];
        
        NSMutableArray  *dropDownData = [[NSMutableArray alloc]init];
        NSMutableArray *keys =[[NSMutableArray alloc]init];
        NSMutableArray *values= [[NSMutableArray alloc]init];
        for (int i=0; i<searchResponseData.count; i++) {
            NSString *key;
            NSString *value;
            if ([[[searchResponseData objectAtIndex:i] objectAtIndex:0] isKindOfClass:[NSNull class]]) {
                key = @"";
            } else {
                key =[[searchResponseData objectAtIndex:i] objectAtIndex:0];
            }
            if ([[[searchResponseData objectAtIndex:i] objectAtIndex:1] isKindOfClass:[NSNull class]]) {
                value = @"";
            } else {
                value =[[searchResponseData objectAtIndex:i] objectAtIndex:1];
            }
            
            [keys addObject: key];
            [values addObject: value];
        }
        [dropDownData addObject:keys];
        [dropDownData addObject:values];
        
        MXButton *mxbutton = (MXButton*)[self getDataFromId:@"SHIP_TO_button"];
        mxbutton.attachedData = dropDownData;
        
        MXTextField *SHIP_TO = (MXTextField *) [self getDataFromId:@"SHIP_TO"];
        SHIP_TO.text = [values objectAtIndex:0];
  
    }
    
    if ([dotformPostReqs.adapterId isEqualToString:@"BILL_TO"]) {
        
        SearchResponse *searchResponseObj = (SearchResponse*)respondedObject;
        NSMutableArray *searchResponseData = [[NSMutableArray alloc]init];
        [searchResponseData addObjectsFromArray:searchResponseObj.searchRecord];
        NSMutableArray  *dropDownData = [[NSMutableArray alloc]init];
        NSMutableArray *keys =[[NSMutableArray alloc]init];
        NSMutableArray *values= [[NSMutableArray alloc]init];
        for (int i=0; i<searchResponseData.count; i++) {//work pending null check error crash
            NSString *key;
            NSString *value;
            if ([[[searchResponseData objectAtIndex:i] objectAtIndex:0] isKindOfClass:[NSNull class]]) {
                key = @"";
            } else {
                key =[[searchResponseData objectAtIndex:i] objectAtIndex:0];
            }
            if ([[[searchResponseData objectAtIndex:i] objectAtIndex:1] isKindOfClass:[NSNull class]]) {
                value = @"";
            } else {
                value =[[searchResponseData objectAtIndex:i] objectAtIndex:1];
            }
            
            [keys addObject: key];
            [values addObject: value];
        }
        [dropDownData addObject:keys];
        [dropDownData addObject:values];
        
        MXButton *mxbutton = (MXButton*)[self getDataFromId:@"BILL_TO_button"];
        mxbutton.attachedData = dropDownData;

        MXTextField *BILL_TO = (MXTextField *) [self getDataFromId:@"BILL_TO"];
        BILL_TO.text = [values objectAtIndex:0];
        
        [loadingView removeView];
    }
    
    
}
- (void)httpFailureHandler:(NSString *)callName :(NSString *)message
{
    [loadingView removeView];
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"mKonnect Authentication!" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
    [myAlertView show];
}
@end
