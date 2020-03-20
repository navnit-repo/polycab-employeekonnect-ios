//
//  FifthDashView.h
//  QCMSProject
//
//  Created by Ashish Tiwari on 14/01/15.
//  Copyright (c) 2015 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HttpEventListener.h"

@interface FifthDashView : UIView<HttpEventListener>

+(FifthDashView*) createInstance;

@property (weak, nonatomic) IBOutlet UIImageView *dashCellImageIcon;
@property (weak, nonatomic) IBOutlet UILabel *dashCellNameLbl;

@end
