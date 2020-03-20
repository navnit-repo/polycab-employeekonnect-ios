//
//  XMWNotification.h
//  QCMSProject
//
//  Created by Ashish Tiwari on 24/09/14.
//  Copyright (c) 2014 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCSwipeTableViewCell.h"

@interface XmwNotificationViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *notificationTableViewList;
    NSMutableArray *notificationAlertDataFromStorage;
     UIImageView  *imageView;
}

-(void)recievedNotificationPullData : (id)NotificationData;


@property  UIImageView  *imageView;
@end
