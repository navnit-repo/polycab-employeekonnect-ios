//
//  SimpleEditForm.m
//  QCMSProject
//
//  Created by Pradeep Singh on 11/2/16.
//  Copyright © 2016 dotvik. All rights reserved.
//

#import "SimpleEditForm.h"
#import "Styles.h"
#import "ReportPostResponse.h"
#import "ClientVariable.h"
#import "DotFormPostUtil.h"
#import "DVAppDelegate.h"

@interface SimpleEditForm ()

@end

@implementation SimpleEditForm

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self populateForm];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)populateForm
{
    // for here is already drawn, not we neet to set the data
    
    NSDictionary* preFillData = self.reportFormResponse.headerData;
    
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

-(IBAction)updateButtonPressed:(id)sender
{
    DotFormPost* dotFormPost = [[DotFormPost alloc] init];
    
    ClientVariable* clientVariables = [ClientVariable getInstance : [DVAppDelegate currentModuleContext]];
    MXButton* button = (MXButton*) sender;
    NSString* attachedData = (NSString*)button.attachedData;
        
    DotFormElement *dotFormElement = [self.dotForm.formElements objectForKey:button.elementId];
        
    DotFormPostUtil *dotFormPostUtil = [[DotFormPostUtil alloc]init];
    if([attachedData isEqualToString:XmwcsConst_DE_BUTTON_DATA_TYPE_FORM_SUBMIT] || [attachedData isEqualToString:XmwcsConst_DE_BUTTON_DATA_TYPE_VIEW_REPORT]) {
            // [dotFormPostUtil mandatoryCheck : dotForm : self];
        [dotFormPostUtil checkTypeOfFormAndSubmit:self.dotForm :self :dotFormPost :self.forwardedDataDisplay :self.forwardedDataPost :true :dotFormElement];
    }
    
    
}


@end
