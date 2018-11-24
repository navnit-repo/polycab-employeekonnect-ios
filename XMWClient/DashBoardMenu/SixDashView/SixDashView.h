//
//  SixDashView.h
//  QCMSProject
//
//  Created by Ashish Tiwari on 14/01/15.
//  Copyright (c) 2015 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HttpEventListener.h"

@interface SixDashView : UIView<HttpEventListener>

+(SixDashView*) createInstance;
@property (weak, nonatomic) IBOutlet UILabel *menuLblName;
@property (weak, nonatomic) IBOutlet UIImageView *menuIconImage;

@end
