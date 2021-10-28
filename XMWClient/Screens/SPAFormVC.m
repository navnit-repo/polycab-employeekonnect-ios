//
//  SPAFormVC.m
//  XMWClient
//
//  Created by Nit Navodit on 19/10/21.
//  Copyright © 2021 dotvik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPAFormVC.h"
#import "NetworkHelper.h"
#import "LoadingView.h"
#import "XmwcsConstant.h"
#import "HttpEventListener.h"
#import "DVAppDelegate.h"
#import "ClientVariable.h"
#import "SPALinesFormVC.h"
#import "Styles.h"

@interface SPAFormVC ()
    @property NSString *SPAHREFID;
@property NSMutableDictionary *spaRequestObject;
@end
@implementation SPAFormVC

-(void) viewDidLoad{
    [super viewDidLoad];
    [[self view] setBackgroundColor:[UIColor whiteColor]];
    self.SPAHREFID = [self.addedRowData objectAtIndex:0];
    NSMutableDictionary *sendDict = [[NSMutableDictionary alloc]init];
    [sendDict setObject:self.SPAHREFID forKey:@"SPAHREFID"];
    
    ClientVariable* clientVariables = [ClientVariable getInstance : [DVAppDelegate currentModuleContext] ];
    [sendDict setObject:clientVariables.CLIENT_LOGIN_RESPONSE.authToken forKey:@"authToken"];
    [sendDict setValue:@"SPA_REQUEST_DETAIL" forKey:@"opcode"];
    
    // Pradeep, 2020-06-26 We need to disable back button
    // so that user cannot go back
    
    networkHelper = [[NetworkHelper alloc]init];
    
    NSString *url = XmwcsConst_OPCODE_URL;
    networkHelper.serviceURLString = url;
    [networkHelper genericJSONPayloadRequestWith:sendDict :self :@"SPA_REQUEST_DETAIL"];
}

-(void)populateForm
{
    // for here is already drawn, not we neet to set the data
    
    NSDictionary* preFillData = self.spaRequestObject;
    
    NSDictionary* formElements = self.dotForm.formElements;
    NSArray* formIds = formElements.allKeys;
    
    for(int i=0; i<[formIds count];i++) {
        DotFormElement* formElement = [formElements objectForKey:[formIds objectAtIndex:i]];
        id formComponent = [self getDataFromId:formElement.elementId];
        
        if([formElement.componentType isEqualToString:XmwcsConst_DE_COMPONENT_TEXTFIELD]) {
            if([formComponent isKindOfClass:[MXTextField class]]) {
                MXTextField* textField = (MXTextField*)formComponent;
                textField.text = [preFillData objectForKey:formElement.elementId];
                if(formElement.isReadonly) {
                    textField.enabled = NO;
                    textField.backgroundColor = [Styles disableTextFieldColor];
                }
            }
        } else if([formElement.componentType isEqualToString:XmwcsConst_DE_COMPONENT_TEXTAREA]) {
            if([formComponent isKindOfClass:[MXTextField class]]) {
                MXTextField* textField = (MXTextField*)formComponent;
              
                
                textField.text = [preFillData objectForKey:formElement.elementId];
                if(formElement.isReadonly) {
                    textField.enabled = NO;
                    textField.backgroundColor = [Styles disableTextFieldColor];
                }
            }
        } else if([formElement.componentType isEqualToString:XmwcsConst_DE_COMPONENT_LABEL]) {
            if([formComponent isKindOfClass:[MXLabel class]]) {
                MXLabel* labelField = (MXLabel*)formComponent;
                
                NSString *value =[preFillData objectForKey:formElement.elementId];
                if (value==nil || [value isKindOfClass:[NSNull class]]) {
                    value = @"";
                }
                
                NSMutableParagraphStyle *style =  [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
                style.alignment = NSTextAlignmentJustified;
                style.firstLineHeadIndent = 8.0f;
                style.headIndent = 10.0f;
                style.tailIndent = -10.0f;
                
                NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:value attributes:@{ NSParagraphStyleAttributeName : style}];
                labelField.attributedText = attrText;
                
               // labelField.text = [preFillData objectForKey:formElement.elementId];
                if(formElement.isReadonly) {
                    labelField.enabled = NO;
                    labelField.backgroundColor = [Styles disableTextFieldColor];
                }
            }
        } else if([formElement.componentType isEqualToString:XmwcsConst_DE_COMPONENT_DATE_FIELD]) {
            if([formComponent isKindOfClass:[MXTextField class]]) {
                MXTextField* textField = (MXTextField*)formComponent;
                
                NSString* serverDate = [preFillData objectForKey:formElement.elementId];
                if(![serverDate isEqualToString:@"00/00/0000"] && ![serverDate isEqualToString:@""]) {
                    textField.text = [preFillData objectForKey:formElement.elementId];
                }
                if(formElement.isReadonly) {
                    textField.enabled = NO;
                    textField.backgroundColor = [Styles disableTextFieldColor];
                }
            }
        } else if([formElement.componentType isEqualToString:XmwcsConst_DE_COMPONENT_BUTTON]) {
            MXButton* button = (MXButton*) formComponent;
            // [button removeTarget:self action:@selector(submitPressed:)  forControlEvents:UIControlEventTouchUpInside];
            /// [button addTarget:self action:@selector(updateButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
}
-(void) prefillFormData{
    NSMutableDictionary *dotFormElements = (NSMutableDictionary *)[dotForm formElements];
    
    NSMutableArray *sortedElements =[DotFormDraw sortFormComponents : dotFormElements];

    for(int cntElement = 0; cntElement < [sortedElements count] ; cntElement++)
    {
        DotFormElement* dotFormElement = (DotFormElement *)[dotFormElements objectForKey:[sortedElements objectAtIndex:cntElement]];
        id formComponent = [self getDataFromId:dotFormElement.elementId];
        if ([dotFormElement.elementId isEqualToString : @"REQUEST_ID" ] ) {
            MXTextField* textField = (MXTextField*)formComponent;
            textField.text = [NSString stringWithFormat:@"%@", self.spaRequestObject[@"SPAHREFID"]];
            textField.enabled = NO;
            textField.backgroundColor = [Styles disableTextFieldColor];
        } else if ([dotFormElement.elementId isEqualToString : @"CUSTOMER_NAME" ] ) {
            MXTextField* textField = (MXTextField*)formComponent;
            textField.text = [NSString stringWithFormat:@"%@", self.spaRequestObject[@"data"][@"customer_name"]];
            textField.enabled = NO;
            textField.backgroundColor = [Styles disableTextFieldColor];
        }else if ([dotFormElement.elementId isEqualToString : @"ORDER_TYPE" ] ) {
            MXTextField *dropDownField = (MXTextField*)formComponent;
            dropDownField.keyvalue = self.spaRequestObject[@"data"][@"requirementType"];
            dropDownField.text = self.spaRequestObject[@"data"][@"requirementType"];
            dropDownField.enabled = NO;
            dropDownField.backgroundColor = [Styles disableTextFieldColor];
        }else if ([dotFormElement.elementId isEqualToString : @"OPPORTUNITY_NAME" ] ) {
            MXTextField* textField = (MXTextField*)formComponent;
            textField.text = [NSString stringWithFormat:@"%@", self.spaRequestObject[@"data"][@"opportunity"]];
            textField.enabled = NO;
            textField.backgroundColor = [Styles disableTextFieldColor];
        }else if ([dotFormElement.elementId isEqualToString : @"BRANCH_OFFICE" ] ) {
            MXTextField* textField = (MXTextField*)formComponent;
            textField.text = [NSString stringWithFormat:@"%@", self.spaRequestObject[@"data"][@"office"]];
            textField.enabled = NO;
            textField.backgroundColor = [Styles disableTextFieldColor];
        }else if ([dotFormElement.elementId isEqualToString : @"DELIVERY_PERIOD" ] ) {
            
        }else if ([dotFormElement.elementId isEqualToString : @"REFERENCE_NO" ] ) {
            MXTextField* textField = (MXTextField*)formComponent;
            textField.text = [NSString stringWithFormat:@"%@", self.spaRequestObject[@"data"][@"reference_no"]];
            textField.enabled = NO;
            textField.backgroundColor = [Styles disableTextFieldColor];
        }else if ([dotFormElement.elementId isEqualToString : @"BUSINESS_VERTICAL" ] ) {
            MXTextField* textField = (MXTextField*)formComponent;
            textField.text = [NSString stringWithFormat:@"%@", self.spaRequestObject[@"data"][@"vertical"]];
            textField.enabled = NO;
            textField.backgroundColor = [Styles disableTextFieldColor];
        }else if ([dotFormElement.elementId isEqualToString : @"SHIP_TO" ] ) {
            MXTextField* textField = (MXTextField*)formComponent;
            textField.text = [NSString stringWithFormat:@"%@", self.spaRequestObject[@"data"][@"shipto"]];
            textField.enabled = NO;
            textField.backgroundColor = [Styles disableTextFieldColor];
        }else if ([dotFormElement.elementId isEqualToString : @"PAYMENT_TERMS" ] ) {
            MXTextField *dropDownField = (MXTextField*)formComponent;
            dropDownField.keyvalue = self.spaRequestObject[@"data"][@"payment_terms"];
            dropDownField.text = self.spaRequestObject[@"data"][@"paymentTermCode"];
            dropDownField.enabled = NO;
            dropDownField.backgroundColor = [Styles disableTextFieldColor];
        }else if ([dotFormElement.elementId isEqualToString : @"FREIGHT_TERMS" ] ) {
            MXTextField *dropDownField = (MXTextField*)formComponent;
            dropDownField.keyvalue = self.spaRequestObject[@"data"][@"freight_terms"];
            dropDownField.text = self.spaRequestObject[@"data"][@"freight_terms"];
            dropDownField.enabled = NO;
            dropDownField.backgroundColor = [Styles disableTextFieldColor];
        }else if ([dotFormElement.elementId isEqualToString : @"DISCOUNT_TYPE" ] ) {
            
        }else if ([dotFormElement.elementId isEqualToString : @"NO_OF_SHIPMENT" ] ) {
            MXTextField* textField = (MXTextField*)formComponent;
            textField.text = [NSString stringWithFormat:@"%@", self.spaRequestObject[@"data"][@"no_of_shipment_lots"]];
            textField.enabled = NO;
            textField.backgroundColor = [Styles disableTextFieldColor];
        }else if ([dotFormElement.elementId isEqualToString : @"SPA_APPROVE_PAYMENT_TERM" ] ) {
            
        }
//        if ([dotFormElement.componentType isEqualToString : XmwcsConst_DE_COMPONENT_DROPDOWN ] ) {
////            MXTextField *dropDownCell = [self getDataFromId:dotFormElement.elementId];
//            printf(@"dropDownCell");
//            [self networkCallConfigureDropDown:dotFormElement.elementId forElement:dotFormElement];
//        }
    
    }
    
}
- (void) httpResponseObjectHandler:(NSString*) callName :(id) respondedObject :(id) requestedObject
{
    [loadingView removeView];
    
    [super httpResponseObjectHandler:callName :respondedObject :requestedObject];
    
    if ([callName isEqualToString:@"SPA_REQUEST_DETAIL"]) {
        
        
        if ([respondedObject valueForKey:@"SPAHREFID"]!=nil) {
             NSLog(@"Post Data = %@",respondedObject);
            self.spaRequestObject = respondedObject;
            [self prefillFormData];
            int status_flag = [[respondedObject valueForKey:@"SPAHREFID"] intValue];
//            if ([status_flag isEqualToString:@"S"]) {
//                [self configureSummaryVC:respondedObject];
//            }
//            else
//            {
//                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Polycab" message: [[respondedObject valueForKey:@"so_header"]valueForKey:@"ERROR_MESSAGE"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//                [alert show];
//            }
        }
    }

}

- (void) httpFailureHandler : (NSString*) callName : (NSString*) message {
    [loadingView removeView];
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Polycab" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
    [myAlertView show];
    
}

-(IBAction) submitPressed:(id) sender
{
    ClientVariable* clientVariables = [ClientVariable getInstance : [DVAppDelegate currentModuleContext]];
    MXButton* button = (MXButton*) sender;
    NSString* attachedData = (NSString*)button.attachedData;
        
    if ([attachedData isEqualToString:XmwcsConst_DE_BUTTON_DATA_TYPE_NEXT]) {
        
        NSMutableDictionary *dotFormElements = (NSMutableDictionary *)[dotForm formElements];
        DotFormElement* dotFormElement = (DotFormElement *)[dotFormElements objectForKey:@"SPA_APPROVE_PAYMENT_TERM"];
        id formComponent = [self getDataFromId:dotFormElement.elementId];
        MXTextField *dropDownField = (MXTextField*)formComponent;
        NSString *spaPaymentTermCode = dropDownField.text;
        NSString *spaPaymentTermValue = dropDownField.keyvalue;
        
        if([spaPaymentTermCode isEqualToString:@""]){
                            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"InCompletle Form" message: @"Invalid SPA Payment Term!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                            [alert show];
            return;
        }
        SPALinesFormVC *formVC = [[NSClassFromString(@"SPALinesFormVC") alloc] init];
        formVC.spahrefid = self.SPAHREFID;
        formVC.spa_payment_terms = spaPaymentTermValue;
        formVC.spaRequestObject = self.spaRequestObject;
        [[self navigationController] pushViewController:formVC  animated:YES];
//
//          [dotFormPostUtil checkTypeOfFormAndSubmit:dotForm :self : dotFormPost :forwardedDataDisplay :forwardedDataPost :false :dotFormElement];

    }
    
    
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
}
@end

