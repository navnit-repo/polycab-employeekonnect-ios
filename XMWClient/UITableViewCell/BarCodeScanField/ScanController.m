//
//  ScanController.m
//  QCMSProject
//
//  Created by Pradeep Singh on 4/10/17.
//  Copyright © 2017 dotvik. All rights reserved.
//

#import "ScanController.h"

#import <AVFoundation/AVFoundation.h>



@interface ScanController () <AVCaptureMetadataOutputObjectsDelegate>
{
    AVCaptureSession *captureSession;
    AVCaptureVideoPreviewLayer *captureLayer;

}


@end

@implementation ScanController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    [self setupScanningSession];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // Start the camera capture session as soon as the view appears completely.
    [captureSession startRunning];
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
    [captureSession startRunning];
}

- (IBAction)copyButtonPressed:(id)sender {
    // Copy the barcode text to the clipboard.
    [UIPasteboard generalPasteboard].string = self.scannedBarcode.text;
}

- (IBAction)doneButtonPressed:(id)sender {
    [captureSession stopRunning];
    
    
    [self dismissViewControllerAnimated:YES completion:^() {
        if(self.scanDelegate!=nil && [self.scanDelegate respondsToSelector:@selector(barcodeResult: forContext:)]) {
            [self.scanDelegate barcodeResult:self.scannedBarcode.text forContext:self.contextId];
        }
    }];
}

- (IBAction)cancelButtonPressed:(id)sender {
    [captureSession stopRunning];
    [self dismissViewControllerAnimated:YES completion:^() {
        if(self.scanDelegate!=nil && [self.scanDelegate respondsToSelector:@selector(barcodeCancelledForContext:)]) {
            [self.scanDelegate barcodeCancelledForContext:self.contextId];
        }
    }];
}


// iOS implementation for scanning

- (void)setupScanningSession {
    // Initalising hte Capture session before doing any video capture/scanning.
    captureSession = [[AVCaptureSession alloc] init];
    
    NSError *error;
    // Set camera capture device to default and the media type to video.
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    // Set video capture input: If there a problem initialising the camera, it will give am error.
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    
    if (!input) {
        NSLog(@"Error Getting Camera Input");
        return;
    }
    // Adding input souce for capture session. i.e., Camera
    [captureSession addInput:input];
    
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    // Set output to capture session. Initalising an output object we will use later.
    [captureSession addOutput:captureMetadataOutput];
    
    // Create a new queue and set delegate for metadata objects scanned.
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("scanQueue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    // Delegate should implement captureOutput:didOutputMetadataObjects:fromConnection: to get callbacks on detected metadata.
    [captureMetadataOutput setMetadataObjectTypes:[captureMetadataOutput availableMetadataObjectTypes]];
    
    // Layer that will display what the camera is capturing.
    captureLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:captureSession];
    [captureLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [captureLayer setFrame:self.cameraPreviewView.layer.bounds];
    // Adding the camera AVCaptureVideoPreviewLayer to our view's layer.
    [self.cameraPreviewView.layer addSublayer:captureLayer];
}


#pragma mark - AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    // Do your action on barcode capture here:
    NSString *capturedBarcode = nil;
    
    // Specify the barcodes you want to read here:
    NSArray *supportedBarcodeTypes = @[AVMetadataObjectTypeUPCECode,
                                       AVMetadataObjectTypeCode39Code,
                                       AVMetadataObjectTypeCode39Mod43Code,
                                       AVMetadataObjectTypeEAN13Code,
                                       AVMetadataObjectTypeEAN8Code,
                                       AVMetadataObjectTypeCode93Code,
                                       AVMetadataObjectTypeCode128Code,
                                       AVMetadataObjectTypePDF417Code,
                                       AVMetadataObjectTypeAztecCode];
    
    // In all scanned values..
    for (AVMetadataObject *barcodeMetadata in metadataObjects) {
        // ..check if it is a suported barcode
        for (NSString *supportedBarcode in supportedBarcodeTypes) {
            
            if ([supportedBarcode isEqualToString:barcodeMetadata.type]) {
                // This is a supported barcode
                // Note barcodeMetadata is of type AVMetadataObject
                // AND barcodeObject is of type AVMetadataMachineReadableCodeObject
                AVMetadataMachineReadableCodeObject *barcodeObject = (AVMetadataMachineReadableCodeObject *)[captureLayer transformedMetadataObjectForMetadataObject:barcodeMetadata];
                capturedBarcode = [barcodeObject stringValue];
                // Got the barcode. Set the text in the UI and break out of the loop.
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [captureSession stopRunning];
                    
                    // We need to set the content here
                    self.scannedBarcode.text = capturedBarcode;
                    
                    [self dismissViewControllerAnimated:YES completion:^(){
                        if(self.scanDelegate!=nil && [self.scanDelegate respondsToSelector:@selector(barcodeResult: forContext:)]) {
                            [self.scanDelegate barcodeResult:capturedBarcode forContext:self.contextId];
                        }
                    }];
                });
                return;
            }
        }
    }
}


@end
