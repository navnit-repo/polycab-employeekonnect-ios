//
//  BarcodeScanVC.h
//  QCMSProject
//
//  Created by Pradeep Singh on 2/26/17.
//  Copyright © 2017 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BarcodeScanDelegate.h"


@interface BarcodeScanVC : UIViewController

@property (strong, nonatomic) NSString* contextId;
@property (strong, nonatomic) id<BarcodeScanDelegate> scanDelegate;

@end
