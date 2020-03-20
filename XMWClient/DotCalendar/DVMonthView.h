//
//  DVMonthView.h
//  ExPMCalender
//
//  Created by Pradeep Singh on 4/3/14.
//  Copyright (c) 2014 Dotvik Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DVDateStruct.h"
#import "DVDateCell.h"
#import "DVMonthYearPicker.h"

@protocol DVMonthViewDelegate <NSObject>
-(void) dateSelected:(DVDateStruct*) dateStruct;
@end

@interface DVMonthView : UIView <DVMonthYearDelegate, DVDateCellDelegate>
{
    BOOL istouch;
	NSDate* calc;
	NSDate* calcDate;
    
	DVDateStruct* lowerDate;
	DVDateStruct* upperDate;
	DVDateStruct* userDate;
	int greyFlag; // what are possible values here? Only 0, 1, 2, 3
	int selectedYear;
	int selectedMonth;
    
	int MAKE_LABEL_FOCUS;
	int MAKE_LABEL_NONFOCUS;
    
	DVDateCell*  initialFocusableCell;

	DVDateCell* m_selectedCell;
	NSString* m_context;
    
    id<DVMonthViewDelegate> monthViewDelegate;
    id<DVDateCellCustomRenderer> cellRenderer;
}

@property id<DVMonthViewDelegate> monthViewDelegate;
@property id<DVDateCellCustomRenderer> cellRenderer;

- (id)initWithFrame:(CGRect)frame Renderer:(id<DVDateCellCustomRenderer>) myCellRenderer;

- (id)initWithFrame:(CGRect)frame lowerLimit:(NSDate*) lDate upperLimit:(NSDate*) uDate displayDate:(NSDate*) dDate Renderer:(id<DVDateCellCustomRenderer>) myCellRenderer;




@end
