//
//  DVMonthYearPicker.h
//  SampleCalendar
//
//  Created by Pradeep Singh on 10/30/13.
//  Copyright (c) 2013 Dotvik Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DVMonthYearDelegate <NSObject>
-(void) canceled;
-(void) selectedMonth:(int) monVal year:(int) yearVal;
@end

@interface DVMonthYearPicker : UIView <UIPickerViewDelegate, UIPickerViewDataSource>
{
    UIPickerView* monthYearPicker;
    NSMutableArray* yearList;
    NSNumber* lowerYear;
    NSNumber* upperYear;
    NSNumber* currentYear;
    // keeping month list as global
    id<DVMonthYearDelegate> monthYearDelegate;
    
    NSNumber* selectedMonthIdx;
    NSNumber* selectedYearIdx;
    NSNumber* selectedMonth;
    NSNumber* selectedYear;
}

@property UIPickerView* monthYearPicker;
@property NSMutableArray* yearList;
@property NSNumber* lowerYear;
@property NSNumber* upperYear;
@property NSNumber* currentYear;
@property id<DVMonthYearDelegate> monthYearDelegate;

@property NSNumber* selectedMonthIdx;
@property NSNumber* selectedYearIdx;
@property NSNumber* selectedMonth;
@property NSNumber* selectedYear;

@end
