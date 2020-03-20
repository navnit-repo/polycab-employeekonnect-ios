//
//  MTBScanController.h
//  QCMSProject
//
//  Created by Pradeep Singh on 4/11/17.
//  Copyright © 2017 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BarcodeScanDelegate.h"

@interface MTBScanController : UIViewController


@property (strong, nonatomic) NSString* contextId;
@property (strong, nonatomic) id<BarcodeScanDelegate> scanDelegate;


@property (weak, nonatomic) IBOutlet UIButton* rescanButton;
@property (weak, nonatomic) IBOutlet UIButton* cancelButton;
@property (weak, nonatomic) IBOutlet UIButton* doneButton;


@property (weak, nonatomic) IBOutlet UIView* cameraPreviewView;
@property (weak, nonatomic) IBOutlet UILabel* scannedBarcode;

@end
