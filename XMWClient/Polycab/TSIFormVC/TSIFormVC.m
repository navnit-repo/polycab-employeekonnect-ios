//
//  TSIFormVC.m
//  XMWClient
//
//  Created by Pradeep Singh on 18/05/20.
//  Copyright © 2020 dotvik. All rights reserved.
//

#import "TSIFormVC.h"
#import "DVAppDelegate.h"
#import "ClientVariable.h"
#import "DataManager.h"

@interface TSIFormVC ()

@end

@implementation TSIFormVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Do any additional setup after loading the view.
    
    registryID = [[NSUserDefaults standardUserDefaults] valueForKey:@"selectedRegisterIDCode"];
    
    
    [self initializeFilters];
}



- (void)done:(SelectedListVC *)selectedListVC context:(NSString *)context code:(NSString *)code display:(NSString *)display
{
    
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
    
    if ([dropDownField.elementId isEqualToString:@"CUSTOMER_NUMBER"]) {
           [self verticalSelectionHandler:dropDownField code:code display:display];
    }
    
    if ([dropDownField.elementId isEqualToString:@"CUSTOMER_ACCOUNT"]) {
           [self verticalSelectionHandler:dropDownField code:code display:display];
    }
    
#if 0
    if ([dropDownField.elementId isEqualToString:@"REGISTRY_ID"]) {
        regIDCheck = YES;
        NSArray *myArray = [display componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"-"]];
         [[NSUserDefaults standardUserDefaults ] setObject:display forKey:@"selectedRegisterID"];
         [[NSUserDefaults standardUserDefaults ] setObject:code forKey:@"selectedRegisterIDCode"];
         [[NSUserDefaults standardUserDefaults ] setObject:[myArray objectAtIndex:1] forKey:@"selectedRegisterIDCustomerName"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        //////////////
       
         // Pradeep: 2020-06-26 we should not be changing this, username is logged in user, code is registry id
        // [ClientVariable getInstance].CLIENT_USER_LOGIN.userName = code; // set userName accoring to userID
      
        //////////////
        
        //blank field code
        MXTextField *BUSINESS_VERTICAL = (MXTextField *) [self getDataFromId:@"BUSINESS_VERTICAL"];
        BUSINESS_VERTICAL.text = @"";
        
        

        NSMutableArray  *dropDownData = [[NSMutableArray alloc]init];
        NSMutableArray *keys =[[NSMutableArray alloc]init];
        NSMutableArray *values= [[NSMutableArray alloc]init];
        [dropDownData addObject:keys];
        [dropDownData addObject:values];
        
        
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
        
        // customer_number and business_vertical for TSI means same as
        // it is just another name
        
        //// for employee dependent drop down add code
        customerAccountButton = (MXButton*)[self getDataFromId:@"CUSTOMER_NUMBER_button"];
        if(customerAccountButton==nil) {
            customerAccountButton = (MXButton*)[self getDataFromId:@"CUSTOMER_ACCOUNT_button"];
        }
        
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
        
    }

#endif
    
}


-(void) initializeFilters
{
    NSMutableArray  *dropDownData = [[NSMutableArray alloc]init];
    NSMutableArray *keys =[[NSMutableArray alloc]init];
    NSMutableArray *values= [[NSMutableArray alloc]init];
    
    // [keys addObject:@"Select Registry ID"];
    // [values addObject:@"Select Registry ID"];
    
    NSMutableArray< NSMutableArray< NSString* >* >* registryIds = [DataManager getInstance].unfiltered_customers;
    
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
        

        //// for employee dependent drop down add code
        MXButton *customerAccountButton = (MXButton*)[self getDataFromId:@"BUSINESS_VERTICAL_button"];
        if(customerAccountButton==nil) {
            customerAccountButton = (MXButton*)[self getDataFromId:@"CUSTOMER_NUMBER_button"];
        }
        
        if(customerAccountButton==nil) {
            customerAccountButton = (MXButton*)[self getDataFromId:@"CUSTOMER_ACCOUNT_button"];
        }
        
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
            
            // we need to use unfiltered accounts other then create order
            [getDataArray addObjectsFromArray:[[DataManager getInstance].unfiltered_accounts objectForKey:selectKey]];
            
            
            NSLog(@"%@",getDataArray);
            
            for (int i=0; i<getDataArray.count; i++) {
                [key addObject: [[getDataArray objectAtIndex:i] objectAtIndex:0]];
                [value addObject: [[getDataArray objectAtIndex:i] objectAtIndex:1]];
            }
            
            
            [customerAccountButtonDropDownArray addObject:key];
            [customerAccountButtonDropDownArray addObject:value];
            
            if (getDataArray.count !=0) {
                NSString *search = [customerAccountButton.elementId stringByReplacingOccurrencesOfString:@"_button" withString:@""];
                MXTextField *customerAccountdropDownField = (MXTextField *) [self getDataFromId:search];
                
                if(customerAccountdropDownField!=nil) {
                    customerAccountdropDownField.text = @"";
                    customerAccountButton.attachedData = customerAccountButtonDropDownArray;
                }
            }
        }
        NSLog(@"accessoryView details %@",   [customerAccountButton description]);
        /////  for employee add new code 73 to 101
    }
}



-(void) verticalSelectionHandler:(MXTextField*) dropDownField code:(NSString *)code display:(NSString *)display
{
    
    if ([dropDownField.elementId isEqualToString:@"BUSINESS_VERTICAL"]) {
           
        
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
