//
//  MTBScanController.m
//  QCMSProject
//
//  Created by Pradeep Singh on 4/11/17.
//  Copyright © 2017 dotvik. All rights reserved.
//

#import "MTBScanController.h"
#import "MTBBarcodeScanner.h"

@interface MTBScanController ()
{
    MTBBarcodeScanner* scanner;
}

@end

@implementation MTBScanController

-(void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSArray *supportedBarcodeTypes = @[AVMetadataObjectTypeUPCECode,
                                       AVMetadataObjectTypeCode39Code,
                                       AVMetadataObjectTypeCode39Mod43Code,
                                       AVMetadataObjectTypeEAN13Code,
                                       AVMetadataObjectTypeEAN8Code,
                                       AVMetadataObjectTypeCode93Code,
                                       AVMetadataObjectTypeCode128Code,
                                       AVMetadataObjectTypePDF417Code,
                                       AVMetadataObjectTypeAztecCode];
    
    
    scanner = [[MTBBarcodeScanner alloc] initWithMetadataObjectTypes:supportedBarcodeTypes previewView:self.cameraPreviewView];
    
    
}


-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [MTBBarcodeScanner requestCameraPermissionWithSuccess:^(BOOL success) {
        if (success) {
            
            NSError *error = nil;
            [scanner startScanningWithResultBlock:^(NSArray *codes) {
                AVMetadataMachineReadableCodeObject *code = [codes firstObject];
                NSLog(@"Found code: %@", code.stringValue);
                self.scannedBarcode.text = code.stringValue;
                [scanner stopScanning];
                
                
                [self dismissViewControllerAnimated:YES completion:^() {
                    if(self.scanDelegate!=nil && [self.scanDelegate respondsToSelector:@selector(barcodeResult: forContext:)]) {
                        [self.scanDelegate barcodeResult:self.scannedBarcode.text forContext:self.contextId];
                    }
                }];
            } error:&error];
        } else {
            // The user denied access to the camera
             NSLog(@"The user denied access to the camera");
        }
    }];
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


- (IBAction)rescanButtonPressed:(id)sender {
    // Start scanning again.
    // [captureSession startRunning];
    
    [scanner stopScanning];
    
    NSError *error = nil;
    [scanner startScanningWithResultBlock:^(NSArray *codes) {
        AVMetadataMachineReadableCodeObject *code = [codes firstObject];
        NSLog(@"Found code: %@", code.stringValue);
        self.scannedBarcode.text = code.stringValue;
        [scanner stopScanning];
        
        [self dismissViewControllerAnimated:YES completion:^() {
            if(self.scanDelegate!=nil && [self.scanDelegate respondsToSelector:@selector(barcodeResult: forContext:)]) {
                [self.scanDelegate barcodeResult:self.scannedBarcode.text forContext:self.contextId];
            }
        }];
        
    } error:&error];
    
}

- (IBAction)doneButtonPressed:(id)sender {
    // [captureSession stopRunning];
    [self dismissViewControllerAnimated:YES completion:^() {
        if(self.scanDelegate!=nil && [self.scanDelegate respondsToSelector:@selector(barcodeResult: forContext:)]) {
            [self.scanDelegate barcodeResult:self.scannedBarcode.text forContext:self.contextId];
        }
    }];
}

- (IBAction)cancelButtonPressed:(id)sender {
    // [captureSession stopRunning];
    [scanner stopScanning];
    
    [self dismissViewControllerAnimated:YES completion:^() {
        if(self.scanDelegate!=nil && [self.scanDelegate respondsToSelector:@selector(barcodeCancelledForContext:)]) {
            [self.scanDelegate barcodeCancelledForContext:self.contextId];
        }
    }];
}


/*
An alternative way to setup MTBBarcodeScanner is to configure the blocks directly, like so:

self.scanner.didStartScanningBlock = ^{
    NSLog(@"The scanner started scanning! We can now hide any activity spinners.");
};

self.scanner.resultBlock = ^(NSArray *codes){
    NSLog(@"Found these codes: %@", codes);
};

self.scanner.didTapToFocusBlock = ^(CGPoint point){
    NSLog(@"The user tapped the screen to focus. \
          Here we could present a view at %@", NSStringFromCGPoint(point));
};

[self.scanner startScanning];
 
 */

@end
