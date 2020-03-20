//
//  DVPeriodCalendar.h
//  QCMSProject
//
//  Created by Pradeep Singh on 9/5/16.
//  Copyright © 2016 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DVDateStruct.h"
#import "DVMonthView.h"

@protocol DVPeriodCalendarDelegate <NSObject>

-(void) fromDate:(DVDateStruct*) fromDateStruct toDate:(DVDateStruct*) toDateStruct  context:(NSString*) contextId;
-(void) userCancelled:(NSString*) contextId;

@end

@interface DVPeriodCalendar : UIViewController <DVMonthViewDelegate, DVDateCellCustomRenderer>

@property (weak, nonatomic) IBOutlet UIView* topBarContainer;

@property (weak, nonatomic) IBOutlet UIView* fromContainer;
@property (weak, nonatomic) IBOutlet UIView* fromBottomBar;
@property (weak, nonatomic) IBOutlet UILabel* fromLabel;
@property (weak, nonatomic) IBOutlet UITextField* fromField;


@property (weak, nonatomic) IBOutlet UIView* toContainer;
@property (weak, nonatomic) IBOutlet UIView* toBottomBar;
@property (weak, nonatomic) IBOutlet UILabel* toLabel;
@property (weak, nonatomic) IBOutlet UITextField* toField;


@property (weak, nonatomic) IBOutlet UIView* monthViewContainer;


@property id<DVPeriodCalendarDelegate> calendarDelegate;

@property NSString* calendarTitle;


@property NSString* contextId;

@property NSDate* fromLowerDate;
@property NSDate* fromUpperDate;
@property NSDate* fromDisplayDate;


@property NSDate* toLowerDate;
@property NSDate* toUpperDate;
@property NSDate* toDisplayDate;


@end
