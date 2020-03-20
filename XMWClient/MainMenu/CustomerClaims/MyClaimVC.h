//
//  MyClaimVC.h
//  XMWClient
//
//  Created by dotvikios on 05/07/18.
//  Copyright © 2018 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FormVC.h"
#import "DVPeriodCalendar.h"
#import "MyClaimResponse.h"

@interface MyClaimVC : FormVC <UITextFieldDelegate,UIAlertViewDelegate,DVPeriodCalendarDelegate, MyClaimResponseDelegate>


@property (strong, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UILabel *fromDate;
@property (weak, nonatomic) IBOutlet UILabel *toDate;
@property (weak,nonatomic) IBOutlet UIView *topView;


@end
