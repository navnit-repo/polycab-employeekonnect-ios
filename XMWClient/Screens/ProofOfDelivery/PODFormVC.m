//
//  PODFormVC.m
//  QCMSProject
//
//  Created by Pradeep Singh on 3/31/17.
//  Copyright © 2017 dotvik. All rights reserved.
//

#import "PODFormVC.h"
#import "DotFormPostUtil.h"
#import "DVAppDelegate.h"
#import "LoadingView.h"
#import "NetworkHelper.h"
#import "AppConstants.h"
#import "Styles.h"
#import "BarCodeScanField.h"
#import "BarcodeScanVC.h"
#import "ScanController.h"
#import "MTBScanController.h"
#import <AVFoundation/AVFoundation.h>
#import "MTBScanController.h"

@interface PODFormVC () <BarcodeScanDelegate>
{
    MXButton* submitButton;
    NetworkHelper* networkHelper;
    LoadingView* loadingView;
    
    AVCaptureSession *captureSession;
    AVCaptureVideoPreviewLayer *captureLayer;
    
}

@end

@implementation PODFormVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [Styles formBackgroundColor];
    // Do any additional setup after loading the view.
    
    
    // we need to add custom submit button handler here
    
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



#pragma mark - SubmitClicked

-(IBAction)submitPressed:(id)sender
{
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
        [networkHelper makeXmwNetworkCall:dotFormPost :self : nil :XmwcsConst_CALL_NAME_FOR_REPORT];
        

}

#pragma mark - HttpEventListener

-(void) httpFailureHandler:(NSString *)callName :(NSString *)message
{
    [loadingView removeView];
    
    [super httpFailureHandler:callName :message];
    
}

-(void) httpResponseObjectHandler:(NSString *)callName :(id)respondedObject :(id)requestedObject
{
     [loadingView removeView];
    
    
    [super httpResponseObjectHandler:callName :respondedObject :requestedObject];
}



-(void)barCodeScanButtonAction:(id) sender
{
    NSLog(@"Bar Code Scanner");
    
    MXButton* mxButton = (MXButton*) sender;
    
    NSString* formElementId = mxButton.elementId;
    
    /*
    BarcodeScanVC* scanVC = [[BarcodeScanVC alloc] initWithNibName:@"BarcodeScanVC" bundle:nil];
    scanVC.scanDelegate = self;
    scanVC.contextId = formElementId;
    
    [self.navigationController pushViewController:scanVC animated:YES];
     */
    
    /*
    ScanController* scanVC = [[ScanController alloc] initWithNibName:@"ScanController" bundle:nil];
    scanVC.scanDelegate = self;
    scanVC.contextId = formElementId;
     
     */
    
    MTBScanController* scanVC = [[MTBScanController alloc] initWithNibName:@"MTBScanController" bundle:nil];
    scanVC.scanDelegate = self;
    scanVC.contextId = formElementId;

    [self presentViewController:scanVC animated:YES completion:nil];
    
}



#pragma mark - BarcodeScanDelegate

-(void) barcodeResult:(NSString*) scanCode forContext:(NSString*) contextId
{
    NSLog(@"barcodeResult is %@", scanCode);
    NSString* formElementId =  contextId;
    
    if(scanCode!=nil && [scanCode isKindOfClass:[NSString class]] && [scanCode length]>0) {
        BarCodeScanField* barcodeScanField = (BarCodeScanField*)[self getDataFromId:formElementId];
        barcodeScanField.editText.text = scanCode;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self submitPressed:nil];
        });
    }
}

-(void) barcodeCancelledForContext:(NSString*) contextId
{
    NSLog(@"barcodeCancelledForContext");
    
}

@end
