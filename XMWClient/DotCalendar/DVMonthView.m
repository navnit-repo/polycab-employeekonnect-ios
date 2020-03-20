//
//  DVMonthView.m
//  ExPMCalender
//
//  This calendar was originally written as MitrCalendar using MobiSoc 's MITR SDK for Java and Blackberry platform
//  by Saurabh Kumar and PK.
//  Mitr Calendar was used in all mobile apps which were developed using MITR SDK
//
//  Using the same concept, we have created Calendar for iOS, BB10 and Blackberry Java platform.
//
//  In this special version, i have added custom cell renderer as well.
//  Purpose of custom cell renderer is to provide application to define it's own cell rendering on
//  on the basis of its own display content.
//  Some event based application want to show event information in the cell.
//
//
//  Created by Pradeep Singh on 4/3/14.
//  Copyright (c) 2014 Dotvik Solutions. All rights reserved.
//

#import "DVMonthView.h"
#import "DVDateStruct.h"
#import "DVCalendarConstants.h"
#import "DVDateCell.h"
#import "DVDayNameCell.h"

@interface DVMonthView()
{
    int CONTAINER_WIDTH;
    int DAY_ROW_HEIGHT;
    int TOOLBAR_HEIGHT;
    int CELL_HEIGHT;
    int CELL_WIDTH;
    int yOffset;
    BOOL monthViewPickerON;
    UIView* mainContainer;
    
    DVDateStruct* m_selectedDate;
    
}

@end


@implementation DVMonthView

@synthesize monthViewDelegate;
@synthesize cellRenderer;

- (id)initWithFrame:(CGRect)frame Renderer:(id<DVDateCellCustomRenderer>) myCellRenderer
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        cellRenderer = myCellRenderer;
        CONTAINER_WIDTH = self.bounds.size.width;
        TOOLBAR_HEIGHT = 40;
        DAY_ROW_HEIGHT = 20;
        CELL_HEIGHT = (self.bounds.size.height- (TOOLBAR_HEIGHT + DAY_ROW_HEIGHT))/6;
        CELL_WIDTH = self.bounds.size.width/7;
        yOffset = 0;
        monthViewPickerON = NO;
        
        mainContainer = [[UIView alloc] initWithFrame:CGRectMake(0, TOOLBAR_HEIGHT, frame.size.width, frame.size.height-TOOLBAR_HEIGHT)];
        
        lowerDate = [[DVDateStruct alloc] init:1 :0 :1971];
        upperDate = [[DVDateStruct alloc] init:31 :11 :2099];
        
        
        NSCalendar *gregorian = [[NSCalendar alloc]
                                 initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *weekdayComponents =[gregorian components:(NSDayCalendarUnit | NSWeekdayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:[[NSDate alloc] init]];
        
        userDate = [[DVDateStruct alloc] init:[weekdayComponents day] :([weekdayComponents month]-1) :[weekdayComponents year] ];
        
        selectedMonth = [weekdayComponents month]-1;
        selectedYear = [weekdayComponents year] ;
        
        m_selectedCell = nil;
        
        [self addSubview:mainContainer];
        [self drawCalendar];
        
        UISwipeGestureRecognizer* swipeRightGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
        swipeRightGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
        [self addGestureRecognizer:swipeRightGestureRecognizer];
        
        
        UISwipeGestureRecognizer* swipeLeftGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
        swipeLeftGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
        [self addGestureRecognizer:swipeLeftGestureRecognizer];
        
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame lowerLimit:(NSDate*) lDate upperLimit:(NSDate*) uDate displayDate:(NSDate*) dDate Renderer:(id<DVDateCellCustomRenderer>) myCellRenderer
{
    self = [super initWithFrame:frame];
    if (self) {
        cellRenderer = myCellRenderer;
        // Initialization code
        CONTAINER_WIDTH = self.bounds.size.width;
        TOOLBAR_HEIGHT = 40;
        DAY_ROW_HEIGHT = 20;
        CELL_HEIGHT = (self.bounds.size.height- (TOOLBAR_HEIGHT + DAY_ROW_HEIGHT))/6;
        CELL_WIDTH = self.bounds.size.width/7;
        yOffset = 0;
        monthViewPickerON = NO;
        
        mainContainer = [[UIView alloc] initWithFrame:CGRectMake(0, TOOLBAR_HEIGHT, frame.size.width, frame.size.height-TOOLBAR_HEIGHT)];
        
        lowerDate = [ DVDateStruct fromNSDate : lDate ];
        upperDate = [ DVDateStruct fromNSDate : uDate ];
        userDate = [ DVDateStruct fromNSDate : dDate ];
        
        selectedMonth = userDate.month;
        selectedYear = userDate.year;
        
        
        NSCalendar *gregorian = [[NSCalendar alloc]
                                 initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *weekdayComponents =[gregorian components:(NSDayCalendarUnit | NSWeekdayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:[[NSDate alloc] init]];
        
        // userDate = [[DVDateStruct alloc] init:[weekdayComponents day] :([weekdayComponents month]-1) : [weekdayComponents year] ];
        
        m_selectedCell = nil;
        
        [self addSubview:mainContainer];
        [self drawCalendar];
        
        UISwipeGestureRecognizer* swipeRightGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
        swipeRightGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
        [self addGestureRecognizer:swipeRightGestureRecognizer];
        
        
        UISwipeGestureRecognizer* swipeLeftGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
        swipeLeftGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
        [self addGestureRecognizer:swipeLeftGestureRecognizer];
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


- (void) drawCalendar
{
	[self resetMainContainer];
	[self resetCellInfoData];
	[self addDayMonthInTitleBar];
    
	int dayindex = [self getDayIndex :selectedMonth :selectedYear ]; // evaluating day of 1  of month
    int limit = [ self getNoDays :selectedMonth  : selectedYear]; 	// didnt take updated year so i change current
    // year to selected
    // Year
    
	[self setDate :limit :dayindex : userDate.day :selectedMonth :selectedYear];
}


-(void) resetMainContainer
{
    yOffset = 0;
    NSArray *viewsToRemove = [mainContainer subviews];
    for (UIView *v in viewsToRemove) {
        [v removeFromSuperview];
    }
}

-(void) resetCellInfoData
{
    
    
}

-(void) addDayMonthInTitleBar
{
    [self setCalendarNavigationToolbar];
}


// for leap year
- (int) getNoDays :(int) month : (int) year
{
    NSNumber* number = [[DVCalendarConstants daysInMonth] objectAtIndex:month];
	int limit = [number intValue];
	// MitrVector noDaysInMonth = (MitrVector) monthVec.elementAt(0);
	// int limit = MitrInteger.parseInt(((MitrString) noDaysInMonth.elementAt(month)).toString());
	if ((month == 1) && (year % 4 == 0))
		limit = 29;
	return limit;
}

- (int) compareDate : (DVDateStruct*) date1  : (DVDateStruct*) date2
{
	if (date1.year < date2.year) {
		return -1;
	} else if (date1.year > date2.year) {
		return 1;
	} else {
		if (date1.month < date2.month) {
			return -1;
		} else if(date1.month > date2.month) {
			return 1;
		} else {
			if(date1.day < date2.day) {
				return -1;
			} else if(date1.day > date2.day) {
				return 1;
			} else {
				return 0;
			}
		}
	}
}


- (int) getDayIndex : (int) selectedMonth : (int) selectedYear
{
	//calc = new MitrCalendar();
	//calc.setDateTime(time);
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:1];
    [comps setMonth:(selectedMonth + 1)];
    [comps setYear:selectedYear];
    
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    calcDate = [gregorian dateFromComponents:comps];
    
	calc =  [calcDate copy];
    
    
    NSDateComponents *weekdayComponents =[gregorian components:(NSDayCalendarUnit | NSWeekdayCalendarUnit) fromDate:calcDate];
    
    NSInteger weekday = [weekdayComponents weekday];
    // weekday 1 = Sunday for Gregorian calendar

    
	int dayOfWeek =   weekday;          // calcDate dayOfWeek();  // Returns the weekday (1 = Monday to 7 = Sunday) for this date.
	if (dayOfWeek == [DVCalendarConstants SUNDAY] )  // for SUNDAY
		return 0;
	else if (dayOfWeek == [DVCalendarConstants MONDAY])    /// for MONDAY
		return 1;
	else if (dayOfWeek == [DVCalendarConstants TUESDAY] )   // for TUESDAY
		return 2;
	else if (dayOfWeek == [DVCalendarConstants WEDNESDAY])   // for WED
		return 3;
	else if (dayOfWeek == [DVCalendarConstants  THURSDAY])    // for THUR
		return 4;
	else if (dayOfWeek == [DVCalendarConstants  FRIDAY])     // for FRI
		return 5;
	else if (dayOfWeek == [DVCalendarConstants SATURDAY])   // for SAT
		return 6;
	return -1;
}


- (void) setDate:(int) limit  :(int) dayindex :(int) date : (int) month : (int) year
{
	
    
	int vRow = 1;
	int j = 1;
	int borderFlag = 0;
	int bothBorders = 0;
	int typeEnd = 0; // typeEnd 0 not end // 1 lowerMonth // 2 upperMonth
    
	//layoutManager.CELL_HEIGHT = Label.getFontHeight(cal_cellContainerStyle);
    
	if ((greyFlag == 1) || (greyFlag == 3) ) {
		if (year == lowerDate.year && month == lowerDate.month) {
			borderFlag = 1;
			typeEnd = 1;
		}
        if (year == upperDate.year && month == upperDate.month) {
			typeEnd = 2;
		}
	}
	if ((greyFlag == 2) || (greyFlag == 3) ) {
		if (year == upperDate.year && month == upperDate.month) {
			if (borderFlag != 0)
				bothBorders = 1;
			borderFlag = 2;
			typeEnd = 2;
		} else if (year == lowerDate.year && month == lowerDate.month) {
			typeEnd = 1;
		}
	}
    
	if(greyFlag == 0){
		if (year == upperDate.year && month == upperDate.month) {
			typeEnd = 2;
		}else if(year == lowerDate.year && month == lowerDate.month){
			typeEnd = 1;
		}
	}
    
	NSString* minus1 = @"-1";
    NSString* minus2 = @"-2";
    NSString* nullstr = @"";
    DVDateCell* cell;

	[self setDayName :typeEnd];
    
    UIView* rowFieldManager = [[UIView alloc] initWithFrame:CGRectMake(0, yOffset, CONTAINER_WIDTH, CELL_HEIGHT)];
    yOffset =  yOffset + CELL_HEIGHT;
    
	// this loop is only for leaving blank space for empty days before
	// starting of month
	for (int i = 0; i < dayindex; i++) {
		if (typeEnd == 1 || istouch)
			cell = [self createDateLabel :nullstr :minus1 :0 :i :vRow :MAKE_LABEL_NONFOCUS :j];
		else
			cell = [self createDateLabel :nullstr :minus1 :0 :i :vRow :MAKE_LABEL_FOCUS: j];
        
		/*  // Pradeep, TODOLATER
         if(istouch){
         Container invisibleContainer = new Container(0, 0, Component.FOCUSABLE,cal_cellContainerStyle, minus1, minus1);
         invisibleContainer.setRegistry(GraphicConstants.REGISTER_GOT_FOCUS);
         dateContainer.add(invisibleContainer);
         }
         */
		[rowFieldManager addSubview:cell];
		if (j % 7 == 0) {
			[mainContainer addSubview: rowFieldManager];
            [mainContainer addSubview:[self addHorizontalLine: yOffset]];
            vRow++;
			rowFieldManager = [[UIView alloc] initWithFrame:CGRectMake(0, yOffset, CONTAINER_WIDTH, CELL_HEIGHT)];
            yOffset =  yOffset+ CELL_HEIGHT;
		}
		j++;
        // IOS TODO equivalent
		// cellInfo->push_back(cell);
	}
    
	int h = j - 1;
	if (date > limit)
		date = limit;
	
    NSString* dateid;
	for (int i = 1; i <= limit; i++) {
		dateid = [NSString stringWithFormat:@"%d", i ];
		cell = [self createDateLabel :dateid :dateid :1 :h :vRow :MAKE_LABEL_FOCUS :j];
        cell.dateAtCell = i;
        
		h++;
        
		[rowFieldManager addSubview: cell];
		if (j % 7 == 0) {
			[mainContainer addSubview:rowFieldManager];
            [mainContainer addSubview:[self addHorizontalLine: yOffset]];
            vRow++;
            h=0;
			rowFieldManager = [[UIView alloc] initWithFrame:CGRectMake(0, yOffset, CONTAINER_WIDTH, CELL_HEIGHT)];
            yOffset =  yOffset + CELL_HEIGHT;
		}
		// setCellStyle(cell, i, borderFlag, bothBorders, j);
		j++;
        
        
        if ((bothBorders == 1 && i == date) && (date >= lowerDate.day)&& (date <= upperDate.day)) {
            initialFocusableCell = cell;
        } else if ((borderFlag == 1 && i == date) && (date >= lowerDate.day)) {
            initialFocusableCell = cell;
        } else if (i == date && borderFlag == 0) {
            initialFocusableCell = cell;
        } else if ((i == date && borderFlag == 2) && (date <= upperDate.day)) {
            initialFocusableCell = cell;
        }
        
        if(cell.dateAtCell==userDate.day && cell.year==userDate.year && cell.month==userDate.month)
        {
            if(self.cellRenderer!=nil && [self.cellRenderer respondsToSelector:@selector(setLayoutForDefaultDateCell:)]) {
                for (UIView *v in [cell subviews])
                {
                    [v removeFromSuperview];
                }
                [self.cellRenderer setLayoutForDefaultDateCell:cell];
            } else {
                // do nothing, as default drawn
            }
        }
	}
    
	// for displaying empty cell at the end of month
	for (int i = limit + 1; j <= 42; i++) {
		if (typeEnd == 2) {
			cell = [ self createDateLabel :nullstr :minus2 :0 :h :vRow :MAKE_LABEL_NONFOCUS  :j];
		} else {
			cell = [self createDateLabel :nullstr :minus2 :0 :h :vRow :MAKE_LABEL_FOCUS :j];
        }
		
		h++;
		[rowFieldManager addSubview: cell];
		if (j % 7 == 0) {
			vRow++;
			h = 0;
			[mainContainer addSubview:rowFieldManager];
            [mainContainer addSubview:[self addHorizontalLine: yOffset]];

			rowFieldManager = [[UIView alloc] initWithFrame:CGRectMake(0, yOffset, CONTAINER_WIDTH, CELL_HEIGHT)];
            yOffset =  yOffset+ CELL_HEIGHT;
		}
		j++;
        
		// IOS TODO equivalent
		// cellInfo->push_back(cell);
	}
    
}

-(void) setCalendarNavigationToolbar
{
    UIView* barView = [self viewWithTag:1000];
    
    if(barView==nil) {
        UIToolbar* topCalendarBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, TOOLBAR_HEIGHT)];
        topCalendarBar.tag = 1000;
        
        NSMutableArray *items = [[NSMutableArray alloc] init];
        
        UIBarButtonItem *flexibaleSpaceBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        UIButton *leftButton  = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftButton setFrame:CGRectMake( 0.0f, 0.0f, 40.0f, 40.0f)];
        [leftButton setTitle:@"Prev" forState:UIControlStateNormal];
	[leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        // [leftButton setBackgroundImage:[UIImage imageNamed:@"icon_twitter.png"] forState:UIControlStateNormal];
        [leftButton addTarget:self action:@selector(toolItemAction:) forControlEvents:UIControlEventTouchUpInside];
        leftButton.tag = 1001;
        
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
        leftItem.target           = self;
        [items addObject:flexibaleSpaceBarButton];
        [items addObject:leftItem];
        
        
        
        
        UIButton* monthYear = [UIButton buttonWithType:UIButtonTypeCustom];
        [monthYear setFrame:CGRectMake( 0.0f, 0.0f, 160.0f, 40.0f)];
        NSString* displayString = [NSString stringWithFormat:@"%@ %d", [[DVCalendarConstants months]  objectAtIndex:selectedMonth], selectedYear ];
        [monthYear setTitle:displayString forState:UIControlStateNormal];
	[monthYear setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [monthYear addTarget:self action:@selector(toolItemAction:) forControlEvents:UIControlEventTouchUpInside];
        monthYear.tag = 1002;
        
        
        UIBarButtonItem *monthYearItem = [[UIBarButtonItem alloc] initWithCustomView:monthYear];
        monthYearItem.target           = self;
        [items addObject:flexibaleSpaceBarButton];
        [items addObject:monthYearItem];
        
        
        UIButton *rightButton  = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightButton setFrame:CGRectMake( 0.0f, 0.0f, 40.0f, 40.0f)];
        [rightButton setTitle:@"Next" forState:UIControlStateNormal];
	[rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        // [leftButton setBackgroundImage:[UIImage imageNamed:@"icon_twitter.png"] forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(toolItemAction:) forControlEvents:UIControlEventTouchUpInside];
        rightButton.tag = 1003;
        
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
        rightItem.target           = self;
        [items addObject:flexibaleSpaceBarButton];
        [items addObject:rightItem];
        [items addObject:flexibaleSpaceBarButton];
        
        
        
        [topCalendarBar setItems:items animated:NO];
        
        [self addSubview:topCalendarBar];
        
        
    } else {
        UIToolbar* topCalendarBar = (UIToolbar*)barView;
        
        UIButton *monthYear = (UIButton*)[topCalendarBar viewWithTag:1002];
        if(monthYear!=nil) {
            NSString* displayString = [NSString stringWithFormat:@"%@ %d", [[DVCalendarConstants months]  objectAtIndex:selectedMonth], selectedYear ];
            [monthYear setTitle:displayString forState:UIControlStateNormal];
        }
    }
}


\
- (void) toolItemAction : (id) sender
{
    UIBarButtonItem* buttonItem = (UIBarButtonItem*) sender;
    NSLog(@"toolItemAction button clicked = %d", buttonItem.tag);
    
    if(buttonItem.tag ==1001) {
        [self displayPrevious];
    } else if(buttonItem.tag ==1002) {
        if(monthViewPickerON == NO) {
            DVMonthYearPicker* monthViewPicker = [[DVMonthYearPicker alloc] initWithFrame:CGRectMake(0, TOOLBAR_HEIGHT, self.bounds.size.width, 250)];
            monthViewPicker.monthYearDelegate = self;
            [self addSubview:monthViewPicker];
            monthViewPickerON = YES;
        }
    } else if(buttonItem.tag == 1003) {
        [self displayNext];
        
    }
    
}

- (void) setDayName: (int) monthType
{
	UIView* rowFieldManager =  [[UIView alloc] initWithFrame:CGRectMake(0, yOffset, CONTAINER_WIDTH, DAY_ROW_HEIGHT)];
    yOffset = yOffset + DAY_ROW_HEIGHT;
    
    DVDayNameCell* ddName;
	int daysSize = 7;
    
	for (int i = 0; i < daysSize ; i++) {
		ddName = [[DVDayNameCell alloc] initWithFrame:CGRectMake(i*CELL_WIDTH, 0, CELL_WIDTH, DAY_ROW_HEIGHT) : [[DVCalendarConstants days] objectAtIndex:i] :i ];
		[rowFieldManager addSubview:ddName];
	}
	[mainContainer addSubview:rowFieldManager];
    [mainContainer addSubview:[self addHorizontalLine: yOffset]];
}

-(UIView*) addHorizontalLine:(int) posY
{
    UIView* line = [[UIView alloc] initWithFrame:CGRectMake(0, posY, self.bounds.size.width, 2)];
    line.backgroundColor = [UIColor lightGrayColor];
    return line;
}

- (DVDateCell*) createDateLabel :(NSString*) value :(NSString*) name :(int) hasfire   :(int) h :(int) v :(int) makeLabelFocus :(int) labelNumber
{
	DVDateCell* cell = nil;
    int day = 0;
    
    if(![value isEqualToString:@""]) {
        day = [value integerValue];
    }
    
	if (makeLabelFocus == MAKE_LABEL_FOCUS && hasfire == 1) {
		cell = [[DVDateCell alloc] initWithFrame:CGRectMake(h*CELL_WIDTH, 0, CELL_WIDTH, CELL_HEIGHT) Text:value Day:day Month:selectedMonth Year:selectedYear CellIndex:labelNumber   Focus:YES Renderer:cellRenderer];
        
		if (hasfire == 1) {
			cell.focusEventRegister = [DVDateCell  REGISTER_FIRE] + [DVDateCell  REGISTER_LOST_FOCUS];
            cell.dateCellDelegate = self;
		} else {
            cell.focusEventRegister = [DVDateCell  REGISTER_GOT_FOCUS];
		}
	} else {
		cell = [[DVDateCell alloc] initWithFrame:CGRectMake(h*CELL_WIDTH, 0, CELL_WIDTH, CELL_HEIGHT) Text:value  Day:day Month:selectedMonth Year:selectedYear CellIndex:labelNumber Renderer:cellRenderer];
	}
	cell.cellName = name;
	return cell;
}


- (void) displayPrevious
{
	if (selectedMonth > lowerDate.month) {
		selectedMonth--;
		[self redrawCalendar:0];
	} else if (selectedYear > lowerDate.year) {
		if (selectedMonth > 0)
			selectedMonth--;
		else {
			selectedMonth = 11;
			selectedYear--;
		}
		[self redrawCalendar :0];
	} else {
		// int tempIdx = findDateCellIndexFromDate(lowerDate.getDay());
		// ((DateCell) cellInfo.elementAt(tempIdx - 1)).setFocus();
		// cal_pg.modifiedComponent((Label) cellinfo.elementAt(lowerdate - 1));
		//cal_pg.modifiedComponent(null);
	}
}

- (void) displayNext
{
	if (selectedMonth < upperDate.month ) {
		selectedMonth++;
        [self redrawCalendar: 1];
	} else if (selectedYear < upperDate.year) {
		if (selectedMonth == 11) {
			selectedMonth = 0;
			selectedYear++;
		} else {
			selectedMonth++;
		}
		[self redrawCalendar: 1];
	} else {
		//cal_pg.setFocus((Label) cellinfo.elementAt(upperdate - 1));
		//cal_pg.modifiedComponent((Label) cellinfo.elementAt(upperdate - 1));
	}
    
}


-(void) redrawCalendar: (int) previous
{
    [self drawCalendar];
}




-(IBAction) handleSwipe:(UISwipeGestureRecognizer*)recognizer
{
    NSLog(@"DVMonthView : handleSwipe = direction = %d", recognizer.direction );
    
    if(recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        [self displayPrevious];
    } else if(recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        [self displayNext];
    }
}


#pragma - mark DVMonthYearPicker Delegate
-(void) canceled
{
    NSLog(@" Cancelled");
    monthViewPickerON = NO;
    
}

-(void) selectedMonth:(int) monVal year:(int) yearVal
{
    NSLog(@" selected Month and year = %d  , %d", monVal, yearVal );
    monthViewPickerON = NO;
    selectedMonth = monVal - 1;
    selectedYear  = yearVal;
    
    userDate.day = 1 ;
    [self drawCalendar];
    
    
}

#pragma - mark DVDateCellDelegate

-(void) cellTapped:(DVDateCell*) cell
{
    NSLog(@"DVMonthView:cellTapped dateAtCell = %d", cell.dateAtCell);
    
    // we need to unselect previous selected cell
    if(m_selectedCell!=nil) {
        if(self.cellRenderer!=nil && [self.cellRenderer respondsToSelector:@selector(setLayoutForCell:)]) {
            for (UIView *v in [m_selectedCell subviews])
            {
                [v removeFromSuperview];
            }
            [self.cellRenderer setLayoutForCell:m_selectedCell];
        } else {
            // do nothing, as default drawn
        }
    }
    
    m_selectedCell = cell;

    
    if(self.cellRenderer!=nil && [self.cellRenderer respondsToSelector:@selector(setLayoutForSelectedCell:)]) {
        for (UIView *v in [cell subviews])
        {
            [v removeFromSuperview];
        }
        [self.cellRenderer setLayoutForSelectedCell:cell];
    } else {
        // do nothing, as default drawn
    }
    
    
    if(monthViewDelegate!=nil && [monthViewDelegate respondsToSelector:@selector(dateSelected:)]) {
        DVDateStruct* dateStruct = [[DVDateStruct alloc] init:m_selectedCell.dateAtCell :selectedMonth :selectedYear ];
        [monthViewDelegate dateSelected:(DVDateStruct*) dateStruct];
    }
    
}

@end
