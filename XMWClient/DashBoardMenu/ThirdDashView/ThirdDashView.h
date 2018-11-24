//
//  ThirdDashView.h
//  QCMSProject
//
//  Created by Ashish Tiwari on 14/01/15.
//  Copyright (c) 2015 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HttpEventListener.h"

@interface ThirdDashView : UIView<HttpEventListener>

+(ThirdDashView*) createInstance;
-(void) updateData;
@property (weak, nonatomic) IBOutlet UILabel *notificationLbl;
-(void)fetchPendingNotifications : (NSNotification*) notification;

+(void) removeObsr;

@end
