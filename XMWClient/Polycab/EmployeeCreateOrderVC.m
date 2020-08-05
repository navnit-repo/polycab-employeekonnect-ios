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
#import "ClientVariable.h"
#import "DataManager.h"

@interface EmployeeCreateOrderVC ()

@end

@implementation EmployeeCreateOrderVC
{
    NSString* codeLOB;
    NetworkHelper *networkHelper;
    LoadingView *loadingView;
    NSString *registryID;
    
    MXTextField *registryIdField;
    MXTextField *customerAccountField;
    
    NSMutableArray *roleList; // json array of objects.
    NSMutableArray* roles;  // role name list
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    registryID = [[NSUserDefaults standardUserDefaults]valueForKey:@"selectedRegisterIDCode"];
    // Do any additional setup after loading the view from its nib.
    
    
    registryIdField = (MXTextField *) [self getDataFromId:@"REGISTRY_ID"];
    customerAccountField = (MXTextField *) [self getDataFromId:@"BUSINESS_VERTICAL"];
    
    MXButton* regIdField_button = (MXButton*)[self getDataFromId:@"REGISTRY_ID_button"];
    
    // SHIP_TO_button.attachedData = dropDownData;
           
    MXButton* verticalField_button = (MXButton*)[self getDataFromId:@"BUSINESS_VERTICAL_button"];
    // BILL_TO_button.attachedData = dropDownData;
    
    
    ClientVariable* clientVariables = [ClientVariable getInstance : [DVAppDelegate currentModuleContext] ];
    roleList = [[NSMutableArray alloc]init];
    
    [roleList addObjectsFromArray:[clientVariables.CLIENT_LOGIN_RESPONSE.clientMasterDetail.masterDataRefresh valueForKey:@"LEVEL_WISE_ROLES"]];
    
    
    roles = [[NSMutableArray alloc] init];
    

    for (int i=0; i<roleList.count; i++) {
        NSString* roleName = [[roleList objectAtIndex:i] valueForKey:@"rolename"];
        [roles addObject:roleName];
    }
    
     // Pradeep: 2020-07-02 non tsi cusotmer api also return booking accounts for TSI as well
    // so no need to use explicit default employee role.

    /*
    if (![roles containsObject:@"EMPLOYEE_USER"]) {
        // non tsi employee state head etc.
        
        if([DataManager getInstance].non_tsi_customers == nil) {
            [self getNonTSI_Accounts];
        } else {
            [self initializeFiltersWithNonTSIData];
        }
    }
     */
    
    if([DataManager getInstance].non_tsi_customers == nil) {
        [self getNonTSI_Accounts];
    } else {
        [self initializeFiltersWithNonTSIData];
    }

    
}

- (void)done:(SelectedListVC *)selectedListVC context:(NSString *)context code:(NSString *)code display:(NSString *)display{
    
    NSString *search= [self.mxButton.elementId stringByReplacingOccurrencesOfString:@"_button" withString:@""];
    MXTextField *dropDownField = (MXTextField *) [self getDataFromId:search];
    dropDownField.keyvalue = code;
    dropDownField.text = display;
    
    if ([dropDownField.elementId isEqualToString:@"REGISTRY_ID"]) {
        
        [self registryIdSelectionHandler:dropDownField code:code display:display];
    }

    if ([dropDownField.elementId isEqualToString:@"BUSINESS_VERTICAL"]) {
        [self verticalSelectionHandler:dropDownField code:code display:display];
    }
 
}


-(void) registryIdSelectionHandler:(MXTextField*) dropDownField code:(NSString *)code display:(NSString *)display
{

    if ([dropDownField.elementId isEqualToString:@"REGISTRY_ID"]) {
        regIDCheck = YES;
        NSArray *myArray = [display componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"-"]];
         [[NSUserDefaults standardUserDefaults ] setObject:display forKey:@"selectedRegisterID"];
         [[NSUserDefaults standardUserDefaults ] setObject:code forKey:@"selectedRegisterIDCode"];
         [[NSUserDefaults standardUserDefaults ] setObject:[myArray objectAtIndex:1] forKey:@"selectedRegisterIDCustomerName"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        //////////////
       
        
        // Pradeep: 2020-06-26 username is logged in user, code is registry id.
        // [ClientVariable getInstance].CLIENT_USER_LOGIN.userName = code;
      
        
        
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
            
            
            // Pradeep: 2020-07-02 non tsi cusotmer api also return booking accounts for TSI as well
            // so no need to use explicit default employee role.
            /*
             if (![roles containsObject:@"EMPLOYEE_USER"]) {
                 [getDataArray addObjectsFromArray:[[DataManager getInstance].non_tsi_accounts objectForKey:selectKey]];
             } else {
                 [getDataArray addObjectsFromArray:[masterDataForEmployee  valueForKey:selectKey]];
             }
             */
            
            [getDataArray addObjectsFromArray:[[DataManager getInstance].non_tsi_accounts objectForKey:selectKey]];
            
            
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
}



-(void) verticalSelectionHandler:(MXTextField*) dropDownField code:(NSString *)code display:(NSString *)display
{
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

#pragma mark - HttpEventListener
- (void)httpResponseObjectHandler:(NSString *)callName :(id)respondedObject :(id)requestedObject
{
    
    if([callName isEqualToString:XmwcsConst_CALL_NAME_FOR_SEARCH]) {
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
           
           NSMutableArray *key_value_Array = [[NSMutableArray alloc]init];
           for (int i=0; i<keys.count; i++) {
               NSString *key;
               NSString *value;
               key = [keys objectAtIndex:i];
               value = [values objectAtIndex:i];
               if ([key isEqualToString:@""] || [key isKindOfClass:[NSNull class]] || key == nil || key.length <=0) {
                   key = @"";
               }
               if ([value isEqualToString:@""] || [value isKindOfClass:[NSNull class]] || value == nil || value.length <=0) {
                   value = @"";
               }
               
               NSString *finalValue = [[key stringByAppendingString:@"-"]stringByAppendingString:value];
               [key_value_Array addObject:finalValue];
           }
           
           [dropDownData addObject:keys];
           [dropDownData addObject:key_value_Array];
           
           
           
           MXButton *mxbutton = (MXButton*)[self getDataFromId:@"SHIP_TO_button"];
           mxbutton.attachedData = dropDownData;
           
           MXTextField *SHIP_TO = (MXTextField *) [self getDataFromId:@"SHIP_TO"];
           SHIP_TO.text = [key_value_Array objectAtIndex:0];
           SHIP_TO.keyvalue =[[dropDownData objectAtIndex:0]objectAtIndex:0]; ///value check
     
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
           NSMutableArray *key_value_Array = [[NSMutableArray alloc]init];
           for (int i=0; i<keys.count; i++) {
               NSString *key;
               NSString *value;
               key = [keys objectAtIndex:i];
               value = [values objectAtIndex:i];
               if ([key isEqualToString:@""] || [key isKindOfClass:[NSNull class]] || key == nil || key.length <=0) {
                   key = @"";
               }
               if ([value isEqualToString:@""] || [value isKindOfClass:[NSNull class]] || value == nil || value.length <=0) {
                   value = @"";
               }
               
               NSString *finalValue = [[key stringByAppendingString:@"-"]stringByAppendingString:value];
               [key_value_Array addObject:finalValue];
           }
           
           [dropDownData addObject:keys];
           [dropDownData addObject:key_value_Array];
           
           MXButton *mxbutton = (MXButton*)[self getDataFromId:@"BILL_TO_button"];
           mxbutton.attachedData = dropDownData;

           MXTextField *BILL_TO = (MXTextField *) [self getDataFromId:@"BILL_TO"];
           BILL_TO.text = [key_value_Array objectAtIndex:0];
           BILL_TO.keyvalue =[[dropDownData objectAtIndex:0]objectAtIndex:0]; ///value check
           [loadingView removeView];
       }

    } else if([callName isEqualToString:@"role_based_registry_ids_accounts"]){
        [self handleNonTSI_Response:respondedObject];
        [loadingView removeView];        
    }
    
}
- (void)httpFailureHandler:(NSString *)callName :(NSString *)message
{
    [loadingView removeView];
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Polycab Authentication!" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
    [myAlertView show];
}

-(void)getNonTSI_Accounts
{
    ClientVariable* clientVariables = [ClientVariable getInstance : [DVAppDelegate currentModuleContext] ];
    
    NSMutableDictionary * postCall = [[NSMutableDictionary  alloc]init];
    [postCall setObject:@"role_based_registry_ids_accounts" forKey:@"opcode"];
    [postCall setObject:clientVariables.CLIENT_LOGIN_RESPONSE.authToken forKey:@"authToken"];
    
    
    NSMutableDictionary* postData = [[NSMutableDictionary alloc] init];
    // here it is logged in user (not registy id as used in other apis)
    [postData setObject:clientVariables.CLIENT_USER_LOGIN.userName forKey:@"username"];
    [postData setObject:roles forKey:@"roles"];
        
    [postCall setObject: postData forKey:@"userdetails"];
    
   

    loadingView = [LoadingView loadingViewInView:self.view];
    
    NetworkHelper * networkHelper = [[NetworkHelper alloc] init];
    NSString* url = XmwcsConst_OPCODE_URL;
    networkHelper.serviceURLString = url;
    [networkHelper genericJSONPayloadRequestWith:postCall :self :@"role_based_registry_ids_accounts"];

}


-(void) handleNonTSI_Response:(NSDictionary*) response
{
    if([[response allKeys] containsObject:@"customers"]) {
        NSArray* customers = [response objectForKey:@"customers"];
        
        NSMutableArray< NSMutableArray< NSString* >* >* registryIds = [[NSMutableArray alloc] init];
        
        NSMutableDictionary<NSString*, NSMutableArray< NSMutableArray< NSString*>* >* >*  nonTSIAccounts = [[NSMutableDictionary alloc] init];


        for(int i=0; i<[customers count]; i++) {
            NSDictionary* customer = [customers objectAtIndex:i];
            NSString* registryId = [customer  objectForKey:@"registry_id"];

            NSMutableArray<NSString*>* details = [[NSMutableArray alloc] init];
            
            [details addObject:[[customer objectForKey:@"registry_id"] copy]];
            [details addObject:[[customer objectForKey:@"customer_name"] copy]];
            
            // details.add(customer.getString("display_value"));

            // accounts
            [registryIds addObject:details];

            NSString* key = [@"BUSINESS_VERTICAL_" stringByAppendingString:registryId];

            NSArray* customerAccounts = [customer objectForKey:@"accounts"];

            NSMutableArray< NSMutableArray< NSString*>* >* accountsVertical =  [[NSMutableArray alloc] init];

            for(int j=0; j<[customerAccounts count]; j++) {
                NSDictionary* account = [customerAccounts objectAtIndex:j];
                NSString* customerNumber = [account objectForKey:@"customer_number"];
                NSString* buGroup = [account objectForKey:@"bu_group"];
                // account.getString("display_value_account");
                NSMutableArray<NSString*>* numberList = [[NSMutableArray alloc] init];
                [numberList addObject:[customerNumber copy]];
                [numberList addObject:[NSString stringWithFormat:@"%@-%@", customerNumber, buGroup]];
                
                [accountsVertical addObject:numberList];
            }
            [nonTSIAccounts setObject:accountsVertical forKeyedSubscript:key];
        }
        
        [DataManager getInstance].non_tsi_customers = registryIds;
        [DataManager getInstance].non_tsi_accounts = nonTSIAccounts;
        
        [self initializeFiltersWithNonTSIData];
    }
    
    if([[response allKeys] containsObject:@"customers_unfiltered"]) {
           NSArray* customers = [response objectForKey:@"customers_unfiltered"];
           
           NSMutableArray< NSMutableArray< NSString* >* >* unfilteredIds = [[NSMutableArray alloc] init];
           
           NSMutableDictionary<NSString*, NSMutableArray< NSMutableArray< NSString*>* >* >*  unfilteredAccounts = [[NSMutableDictionary alloc] init];


           for(int i=0; i<[customers count]; i++) {
               NSDictionary* customer = [customers objectAtIndex:i];
               NSString* registryId = [customer  objectForKey:@"registry_id"];

               NSMutableArray<NSString*>* details = [[NSMutableArray alloc] init];
               
               [details addObject:[[customer objectForKey:@"registry_id"] copy]];
               [details addObject:[[customer objectForKey:@"customer_name"] copy]];
               
               // details.add(customer.getString("display_value"));

               // accounts
               [unfilteredIds addObject:details];

               NSString* key = [@"BUSINESS_VERTICAL_" stringByAppendingString:registryId];

               NSArray* customerAccounts = [customer objectForKey:@"accounts"];

               NSMutableArray< NSMutableArray< NSString*>* >* accountsVertical =  [[NSMutableArray alloc] init];

               for(int j=0; j<[customerAccounts count]; j++) {
                   NSDictionary* account = [customerAccounts objectAtIndex:j];
                   NSString* customerNumber = [account objectForKey:@"customer_number"];
                   NSString* buGroup = [account objectForKey:@"bu_group"];
                   // account.getString("display_value_account");
                   NSMutableArray<NSString*>* numberList = [[NSMutableArray alloc] init];
                   [numberList addObject:[customerNumber copy]];
                   [numberList addObject:[NSString stringWithFormat:@"%@-%@", customerNumber, buGroup]];
                   
                   [accountsVertical addObject:numberList];
               }
               [unfilteredAccounts setObject:accountsVertical forKeyedSubscript:key];
           }
           
           [DataManager getInstance].unfiltered_customers = unfilteredIds;
           [DataManager getInstance].unfiltered_accounts = unfilteredAccounts;
       }

}

-(void) initializeFiltersWithNonTSIData
{
    NSMutableArray  *dropDownData = [[NSMutableArray alloc]init];
    NSMutableArray *keys =[[NSMutableArray alloc]init];
    NSMutableArray *values= [[NSMutableArray alloc]init];
    
    // [keys addObject:@"Select Registry ID"];
    // [values addObject:@"Select Registry ID"];
    
    NSMutableArray< NSMutableArray< NSString* >* >* registryIds = [DataManager getInstance].non_tsi_customers;
    
    if(registryIds!=nil && [registryIds count]>0) {
        
        for(int i=0; i<[registryIds count]; i++) {
            NSMutableArray< NSString* >* rowData = [registryIds objectAtIndex:i];
            NSString* value = [NSString stringWithFormat:@"%@-%@", [rowData objectAtIndex:0] , [rowData objectAtIndex:1] ];
            [values addObject:value];
            
            NSString* key = [[rowData objectAtIndex:0] copy];
            [keys addObject:key];
        }
        
        MXButton* regIdField_button = (MXButton*)[self getDataFromId:@"REGISTRY_ID_button"];
        
        if(regIdField_button!=nil) {
            [dropDownData addObject:keys];
            [dropDownData addObject:values];
            regIdField_button.attachedData = dropDownData;
        }
        
        // regId.configureAgain(activity, arrayValues, arrayKeys, false);
        
    }

}

@end
