//
//  PODFormUpdateVC.m
//  QCMSProject
//
//  Created by Pradeep Singh on 3/31/17.
//  Copyright © 2017 dotvik. All rights reserved.
//

#import "PODFormUpdateVC.h"
#import "DotFormPostUtil.h"
#import "DVAppDelegate.h"
#import "LoadingView.h"
#import "NetworkHelper.h"
#import "AppConstants.h"

@interface PODFormUpdateVC ()
{
    MXButton* submitButton;
    NetworkHelper* networkHelper;
    LoadingView* loadingView;
}

@end

@implementation PODFormUpdateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    // we need to add custom submit button handler here
    
    DotFormElement* dotFormElement = [self.dotForm.formElements objectForKey:@"SUBMIT"];
    if( [dotFormElement.componentType isEqualToString:XmwcsConst_DE_COMPONENT_BUTTON]) {
        submitButton = [self getDataFromId:dotFormElement.elementId];
        submitButton.enabled = YES;
        
        // remove previous target if already configure
        [submitButton removeTarget:self action:@selector(submitPressed:)  forControlEvents:UIControlEventTouchUpInside];
        
        // add customer submit handler so that we can override the behaviour
        [submitButton addTarget:self action:@selector(submitPressed:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    
    // few more customization
    
    dotFormElement = [self.dotForm.formElements objectForKey:@"REMARK_SUBMIT"];
     if( [dotFormElement.componentType isEqualToString:XmwcsConst_DE_COMPONENT_TEXTAREA]) {
         MXTextField* textField = [self getDataFromId:dotFormElement.elementId];
         if(self.surrogateParent!=nil) {
             textField.delegate = self.surrogateParent;
         }
         
     }
    
    
    // subForm.surrogateParent = self.reportVC;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void) dropDownPickerDoneHandle:(DotFormElement*) ddFormElement
{
    NSLog(@"dropDownPickerHandle: %@", ddFormElement.elementId);
    
    
    MXTextField *dropDownField = (MXTextField *) [self getDataFromId:ddFormElement.elementId];
    NSLog(@"Key value = %@", dropDownField.keyvalue);
    NSLog(@"Display value = %@", dropDownField.text);
    
    MXTextField* remarkTextField = [self getDataFromId:ddFormElement.dependedCompName];
    
    NSLog(@"Remark Value is %@", remarkTextField.text);
    
    UIView* parentView = remarkTextField.superview;
    FormTableViewCell* formViewCell = (FormTableViewCell*)[parentView superview];
    
    
    if([dropDownField.keyvalue isEqualToString:@"Y"]) {
        formViewCell.mandatoryLabel.hidden = YES;
    } else {
        formViewCell.mandatoryLabel.hidden = NO;
    }
    
}


#pragma mark - SubmitClicked

-(IBAction)submitPressed:(id)sender
{
    NSString* validationMessage;
    
    if([self validateForm:&validationMessage]) {
        
        DotFormPostUtil* postUtil = [[DotFormPostUtil alloc] init];
        
        [postUtil getFormComponentData:self.dotForm :self :dotFormPost :@"" :forwardedDataDisplay :forwardedDataPost];
        
        [dotFormPost setAdapterId: dotForm.submitAdapterId];
        [dotFormPost setDocId : dotForm.formId];
        [dotFormPost setDocDesc : dotForm.screenHeader];
        [dotFormPost setAdapterType:dotForm.adapterType];
        [dotFormPost setModuleId: [DVAppDelegate currentModuleContext]];
        
        [postUtil incrementMaxDocId : dotFormPost];
        
        loadingView = [LoadingView loadingViewInView:[UIApplication sharedApplication].keyWindow];
        networkHelper = [[NetworkHelper alloc] init];
        [networkHelper makeXmwNetworkCall:dotFormPost :self : nil :XmwcsConst_CALL_NAME_FOR_SUBMIT];
        
    } else {
        UIAlertController *alertController = [UIAlertController  alertControllerWithTitle:@"Validation Failed"  message:validationMessage  preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}


-(BOOL) validateForm:(NSString**) message
{
    BOOL retVal = YES;
    
    
    MXTextField *dropDownField = (MXTextField *) [self getDataFromId:@"CUSTOMER_SATISFIED"];
    NSLog(@"Key value = %@", dropDownField.keyvalue);
    NSLog(@"Display value = %@", dropDownField.text);
    
    MXTextField* remarkTextField = [self getDataFromId:@"REMARK_SUBMIT"];
    
    NSLog(@"Remark Value is %@", remarkTextField.text);
    
    if([dropDownField.keyvalue isEqualToString:@"N"]) {
        NSString* remark = [remarkTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if([remark length]==0) {
            retVal = NO;
            *message = @"Please enter remark.";
        }
    } else if([dropDownField.keyvalue isEqualToString:@"Y"]) {
        retVal = YES;
    } else {
        retVal = NO;
        *message = @"Please select YES/NO.";
    }
    return retVal;
}


#pragma  mark - HttpEventListener
-(void) httpFailureHandler:(NSString *)callName :(NSString *)message
{
    [loadingView removeView];
    
    
}

-(void) httpResponseObjectHandler:(NSString *)callName :(id)respondedObject :(id)requestedObject
{
    [loadingView removeView];
    
    if([callName isEqualToString:XmwcsConst_CALL_NAME_FOR_SUBMIT]) {
        
        DocPostResponse *docPostResponse = (DocPostResponse *)respondedObject;
        NSString *message = docPostResponse.submittedMessage;
        NSString* status = docPostResponse.submitStatus;
        
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Info!" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
        myAlertView.tag = 2005;
        [myAlertView show];
        
    }
    
}

#pragma mark - UIAlertViewController

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    [self.navigationController popViewControllerAnimated:YES];

}

@end
