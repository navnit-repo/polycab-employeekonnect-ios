//
//  CustomerClaimVC.m
//  XMWClient
//
//  Created by dotvikios on 11/06/18.
//  Copyright © 2018 dotvik. All rights reserved.
//

#import "CustomerClaimVC.h"
#import "NetworkHelper.h"
#import "DotFormDraw.h"
#import "DotDropDownPicker.h"
#import "MXBarButton.h"
#import "ClientVariable.h"
#import "DotFormPostUtil.h"
#import "DVAppDelegate.h"
#import "CustomerClaimInvoiceDetailsVC.h"
#import "LoadingView.h"
#import "FormTableViewCell.h"


@interface CustomerClaimVC ()
{
    NetworkHelper* networkHelper;
    NSString * fieldSet;
    DropDownTableViewCell *dropDownCell;
    DotDropDownPicker    * dotDropDownPicker;
    UIView* pickerContainer;
    NSString *selectedCliam;
    NSString *SelectedClaimCode;
    DotFormElement * ddFormElement;
    NSString *CLAIM_TYPE;
    NSString *CLAIM_SUB_TYPE;
    NSString *CLAIM_REASON;
    NSMutableDictionary *requestData;
    
}
@end
@implementation CustomerClaimVC
- (void)viewDidLoad {
    [super viewDidLoad];
    requestData = [[NSMutableDictionary alloc]init];
    // Do any additional setup after loading the view from its nib.
    NSLog(@"Customer Claim VC Call");
    
    
    //remove Invoice & Scheme TextFields and change next button height
    MXTextField* textFieldInvoiceNO = (MXTextField*)[self getDataFromId:@"INVOICE_NO"];
    [textFieldInvoiceNO.superview removeFromSuperview];
    
    MXTextField* textFieldSchemeNO = (MXTextField*)[self getDataFromId:@"SCHEME_NO"];
    [textFieldSchemeNO.superview removeFromSuperview];
    
    UIView* buttonRowView =   [dotFormDraw formRowContainer:scrollFormView :@"NEXT" ];

    buttonRowView.frame = CGRectMake(buttonRowView.frame.origin.x, buttonRowView.frame.origin.y-100, buttonRowView.frame.size.width, buttonRowView.frame.size.height);

  
    
    //Network Call
    NSDictionary *data = [[NSDictionary alloc ]init];
    NSMutableDictionary * dropdowncall = [[NSMutableDictionary  alloc]init];
    [dropdowncall setObject:data forKey:@"data"];
    [dropdowncall setObject:@"claimTypes" forKey:@"opcode"];
    networkHelper = [[NetworkHelper alloc]init];
    NSString * url=@"http://qamkonnect.havells.com:8080/xmwcsdealermkonnect/store";
    networkHelper.serviceURLString = url;
    [networkHelper genericJSONPayloadRequestWith:dropdowncall :self :@"CUSTOMER_CLAIM_TYPE"];
    

    //set SubClaim field Defalut values
    NSMutableArray *subClaim= [[NSMutableArray alloc]init];
        [subClaim addObject:@""];
    NSMutableArray *subClaim1= [[NSMutableArray alloc]init];
        [subClaim1 addObject:@"Select Claim Type"];
    NSMutableArray *subClaimData= [[NSMutableArray alloc]init];
    [subClaimData addObject:subClaim];
    [subClaimData addObject:subClaim1];
        MXTextField* dropdownFieldSubcliam = (MXTextField*)[self getDataFromId:@"CUSTOMER_CLAIM_SUB_TYPE"];
        MXButton* mxbuttonSubclaim = (MXButton*)dropdownFieldSubcliam.rightView;
        mxbuttonSubclaim.attachedData=subClaimData;
   
    
    //set reason field Defalut values
    MXTextField *dropdownFieldReason = (MXTextField*)[self getDataFromId:@"CUSTOMER_CLAIM_REASON"];
    MXButton *mxButtonReason = (MXButton*)dropdownFieldReason.rightView;
    NSMutableArray *reason= [[NSMutableArray alloc]init];
    [reason addObject:@""];
    NSMutableArray *reason1= [[NSMutableArray alloc]init];
    [reason1 addObject:@"Select Claim Sub Type"];
    NSMutableArray *reasonData= [[NSMutableArray alloc]init];
    [reasonData addObject:reason];
    [reasonData addObject:reason1];
    mxButtonReason.attachedData = reasonData;
  
}
-(void) dropDownPickerDoneHandle:(DotFormElement *) ddFormElement
{
    NSString *printSelectedIndex;
    printSelectedIndex= CustomerClaimValue;
    NSLog(@"selected %@",printSelectedIndex);
    NSLog(@"%@",[ddFormElement elementId ]);

if([ddFormElement.elementId isEqualToString :@"CUSTOMER_CLAIM_TYPE"])
{
    //set SubClaim field and Reason Filed Defalut Text
    MXTextField* dropdownFieldSubcliam = (MXTextField*)[self getDataFromId:@"CUSTOMER_CLAIM_SUB_TYPE"];
    dropdownFieldSubcliam.text =@"Select Claim Sub Type";
    MXTextField *dropdownFieldReason = (MXTextField*)[self getDataFromId:@"CUSTOMER_CLAIM_REASON"];
    dropdownFieldReason.text = @"Select Claim Reason";
    
    //fetch select value,key and store it
    //selectedCliam and SelectedClaimCode initialized variable globaly
    selectedCliam = CustomerClaimValue;
    SelectedClaimCode =CustomerClaimKey;
    CLAIM_TYPE =SelectedClaimCode;
    
    //NetWork Call
    NSMutableDictionary * call = [[NSMutableDictionary  alloc]init];
    NSMutableDictionary * data = [[NSMutableDictionary alloc ]init];
    [data setObject:CustomerClaimKey forKey:@"TYPE_CODE"];
    [data setValue:CustomerClaimValue forKey:@"CLAIM_TYPE"];
    [call setObject:data forKey:@"data"];
    [call setObject:@"claimSubTypes" forKey:@"opcode"];
    networkHelper = [[NetworkHelper alloc]init];
    NSString * url=@"http://qamkonnect.havells.com:8080/xmwcsdealermkonnect/store";
    networkHelper.serviceURLString = url;
    [networkHelper genericJSONPayloadRequestWith:call :self :@"CUSTOMER_CLAIM_SUB_TYPE"];
    
    loadingView= [LoadingView loadingViewInView:self.view];
    
    }

    else if([ddFormElement.elementId isEqualToString :@"CUSTOMER_CLAIM_SUB_TYPE"]){
    
        MXTextField* dropdownFieldSubcliam = (MXTextField*)[self getDataFromId:@"CUSTOMER_CLAIM_SUB_TYPE"];
        if ([dropdownFieldSubcliam.text isEqualToString:@"Select Claim Type"]) {
          //do nothing
        }
        else{
            CLAIM_SUB_TYPE =CustomerClaimKey;
            //set Reason Filed Defalut Text
            MXTextField *dropdownFieldReason = (MXTextField*)[self getDataFromId:@"CUSTOMER_CLAIM_REASON"];
            dropdownFieldReason.text = @"Select Claim Reason";
            //NetWork Call
            NSMutableDictionary * call = [[NSMutableDictionary  alloc]init];
            NSMutableDictionary * data = [[NSMutableDictionary alloc ]init];
            [data setObject:SelectedClaimCode forKey:@"TYPE_CODE"];
            [data setObject:selectedCliam forKey:@"CLAIM_TYPE"];
            [data setObject:CustomerClaimKey forKey:@"SUBTYPE_CODE"];
            [data setObject:CustomerClaimValue forKey:@"CLAIM_SUBTYPE"];
            [call setObject:data forKey:@"data"];
            [call setObject:@"claimReasons" forKey:@"opcode"];
            networkHelper = [[NetworkHelper alloc]init];
            NSString * url=@"http://qamkonnect.havells.com:8080/xmwcsdealermkonnect/store";
            networkHelper.serviceURLString = url;
            [networkHelper genericJSONPayloadRequestWith:call :self :@"CUSTOMER_CLAIM_REASON"];
            loadingView= [LoadingView loadingViewInView:self.view];
            
        }
    }
    
    else if([ddFormElement.elementId isEqualToString :@"CUSTOMER_CLAIM_REASON"]){
        
         MXTextField *dropdownFieldReason = (MXTextField*)[self getDataFromId:@"CUSTOMER_CLAIM_REASON"];
        if ([dropdownFieldReason.text isEqualToString:@"Select Claim Type"]) {
            //do nothing
        }
        else{
            CLAIM_REASON= CustomerClaimKey;
        }
    
    }
}

- (void) httpResponseObjectHandler : (NSString*) callName : (id) respondedObject : (id) requestedObject
{
        [loadingView removeView];
    
    if([callName isEqualToString:@"CUSTOMER_CLAIM_TYPE"]) {
        NSMutableArray  *dropDown = [[NSMutableArray alloc]init];
        NSMutableArray *claim =[[NSMutableArray alloc]init];
        NSMutableArray *claimCode= [[NSMutableArray alloc]init];
        NSArray* responseData = [respondedObject objectForKey:@"responseData"];
        
        
        for ( int i=0 ; i < responseData.count; i++) {
            
            
            [claim addObject:[[responseData objectAtIndex:i] valueForKey:@"CLAIM_TYPE"]];
            [claimCode addObject:[[responseData objectAtIndex:i] valueForKey:@"TYPE_CODE"]];
            
        }
        [dropDown addObject:claimCode];
        [dropDown addObject:claim];
        
        MXTextField* dropdownField = (MXTextField*)[self getDataFromId:@"CUSTOMER_CLAIM_TYPE"];
        MXButton* mxbutton = (MXButton*)dropdownField.rightView;
        mxbutton.attachedData =dropDown;
        NSLog(@"dropdownfield details %@",   [dropdownField description]);
        NSLog(@"accessoryView details %@",   [mxbutton description]);
    }
        if([callName isEqualToString:@"CUSTOMER_CLAIM_SUB_TYPE"]) {
           NSMutableArray  *dropDown = [[NSMutableArray alloc]init];
            NSMutableArray *claim =[[NSMutableArray alloc]init];
            NSMutableArray *claimCode= [[NSMutableArray alloc]init];
            
            NSArray* responseData = [respondedObject objectForKey:@"responseData"];
            
          
            for ( int i=0 ; i < responseData.count; i++) {
                
                
                [claim addObject:[[responseData objectAtIndex:i] valueForKey:@"CLAIM_SUBTYPE"]];
                [claimCode addObject:[[responseData objectAtIndex:i] valueForKey:@"SUBTYPE_CODE"]];
                
            }
            [dropDown addObject:claimCode];
            [dropDown addObject:claim];
            
            MXTextField* dropdownField = (MXTextField*)[self getDataFromId:@"CUSTOMER_CLAIM_SUB_TYPE"];
            MXButton* mxbutton = (MXButton*)dropdownField.rightView;
            mxbutton.attachedData =dropDown;
            NSLog(@"dropdownfield details %@",   [dropdownField description]);
            NSLog(@"accessoryView details %@",   [mxbutton description]);
        }
        if([callName isEqualToString:@"CUSTOMER_CLAIM_REASON"]) {
            NSMutableArray  *dropDown = [[NSMutableArray alloc]init];
            NSMutableArray *claim =[[NSMutableArray alloc]init];
            NSMutableArray *claimCode= [[NSMutableArray alloc]init];
            NSArray* responseData = [respondedObject objectForKey:@"responseData"];
            NSArray* requestData = [requestedObject objectForKey:@"requestData"];
           
            
            for ( int i=0 ; i < responseData.count; i++) {
                
                
                [claim addObject:[[responseData objectAtIndex:i] valueForKey:@"REASON"]];
                [claimCode addObject:[[responseData objectAtIndex:i] valueForKey:@"REASON_CODE"]];
                
            }
            [dropDown addObject:claimCode];
            [dropDown addObject:claim];
            MXTextField* dropdownField = (MXTextField*)[self getDataFromId:@"CUSTOMER_CLAIM_REASON"];
            MXButton* mxbutton = (MXButton*)dropdownField.rightView;
            mxbutton.attachedData =dropDown;
            NSLog(@"dropdownfield details %@",   [dropdownField description]);
            NSLog(@"accessoryView details %@",   [mxbutton description]);
        }
}
- (void) httpFailureHandler : (NSString*) callName : (NSString*) message {
    [loadingView removeView];
    
    
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"mKonnect Authentication!" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
    [myAlertView show];
    
}
-(IBAction) submitPressed:(id) sender{
   
         MXTextField* claimDropdownField = (MXTextField*)[self getDataFromId:@"CUSTOMER_CLAIM_TYPE"];
         MXTextField* claimSubDropdownField = (MXTextField*)[self getDataFromId:@"CUSTOMER_CLAIM_SUB_TYPE"];
         MXTextField* reasondropdownField = (MXTextField*)[self getDataFromId:@"CUSTOMER_CLAIM_REASON"];
        if ([claimDropdownField.text isEqualToString:@""]) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Havells mKonnect"
                                                                    message:@"Incorrect Claim Type"
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                    [alert show];
            
        }
        
 else  if ( [claimSubDropdownField.text isEqualToString:@"Select Claim Sub Type"]){
           
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Havells mKonnect"
                                                            message:@"Incorrect Claim Sub Type"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            
            
        }
  else  if ( [reasondropdownField.text isEqualToString:@"Select Claim Reason"] ){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Havells mKonnect"
                                                            message:@"Incorrect Reason Type"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            
        }
    else {
        CustomerClaimInvoiceDetailsVC *vc = [[CustomerClaimInvoiceDetailsVC alloc]init];
        vc.claimType = claimDropdownField.text;
        vc.claimSubType=claimSubDropdownField.text;
        vc.reason=reasondropdownField.text;
        [requestData setObject:CLAIM_TYPE forKey:@"CLAIM_TYPE"];
        [requestData setObject:CLAIM_SUB_TYPE forKey:@"CLAIM_SUB_TYPE"];
        [requestData setObject:CLAIM_REASON forKey:@"CLAIM_REASON"];
         NSLog(@"%@",requestData);
        vc.requestData = requestData;    
        [ [self navigationController ] pushViewController:vc animated:YES];
        }
}


@end
