//
//  DVCalendarController.h
//  QCMSProject
//
//  Created by Pradeep Singh on 4/29/14.
//  Copyright (c) 2014 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DVDateStruct.h"
#import "DVMonthView.h"

@protocol DVCalendarControllerDelegate <NSObject>

-(void) dateSelected:(DVDateStruct*) dateStruct :(NSString*) contextId;
-(void) userCancelled:(NSString*) contextId;

@end


@interface DVCalendarController : UIViewController <DVMonthViewDelegate, DVDateCellCustomRenderer>
{
    NSString* contextId;
    NSDate* lowerDate;
    NSDate* upperDate;
    NSDate* displayDate;
    id<DVCalendarControllerDelegate> calendarDelegate;
    
}

@property NSString* contextId;
@property NSDate* lowerDate;
@property NSDate* upperDate;
@property NSDate* displayDate;
@property id<DVCalendarControllerDelegate> calendarDelegate;


@end
