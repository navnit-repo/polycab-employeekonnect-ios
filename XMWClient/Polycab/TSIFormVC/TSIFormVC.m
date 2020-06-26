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

@interface TSIFormVC ()

@end

@implementation TSIFormVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Do any additional setup after loading the view.
    
    registryID = [[NSUserDefaults standardUserDefaults] valueForKey:@"selectedRegisterIDCode"];
}



- (void)done:(SelectedListVC *)selectedListVC context:(NSString *)context code:(NSString *)code display:(NSString *)display
{
    
    NSString *search= [self.mxButton.elementId stringByReplacingOccurrencesOfString:@"_button" withString:@""];
    MXTextField *dropDownField = (MXTextField *) [self getDataFromId:search];
    dropDownField.keyvalue = code;
    dropDownField.text = display;
    
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
