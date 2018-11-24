//
//  DVTwoWeekView.m
//  ExPMCalender
//
//  Created by Pradeep Singh on 4/14/14.
//  Copyright (c) 2014 Dotvik Solutions. All rights reserved.
//

#import <objc/runtime.h>
#import "DVTwoWeekView.h"
#import "DVDateCell.h"
#import "DVDateStruct.h"
#import "DVDayNameCell.h"
#import "DVCalendarConstants.h"


@implementation DVDateCell (DVTWV)

- (DVDateStruct*)dateStruct;
{
    return objc_getAssociatedObject(self, "dateStruct");
}

- (void)setDateStruct:(DVDateStruct*)property;
{
    objc_setAssociatedObject(self, "dateStruct", property, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end


@interface DVTwoWeekView ()
{
    int CONTAINER_WIDTH;
    int DAY_ROW_HEIGHT;
    int CELL_HEIGHT;
    int CELL_WIDTH;
    int yOffset;
    UIView* mainContainer;
    DVDateStruct* currentDate;
    NSDate* nsDateCurrentDate;
}

@end







@implementation DVTwoWeekView


@synthesize  twoWeekViewDelegate;
@synthesize cellRenderer;

- (id)initWithFrame:(CGRect)frame date:(DVDateStruct*) inDate Renderer:(id<DVDateCellCustomRenderer>) myCellRenderer
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        cellRenderer = myCellRenderer;
        CONTAINER_WIDTH = self.bounds.size.width;
        DAY_ROW_HEIGHT = 20;
        CELL_HEIGHT = (self.bounds.size.height- DAY_ROW_HEIGHT)/2;
        CELL_WIDTH = self.bounds.size.width/7;
        yOffset = 0;
        currentDate = inDate;
        
        mainContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        
        [self addSubview:mainContainer];
        [self drawTwoWeeks];
        
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


-(void) drawTwoWeeks
{
    
    [self setDayName];
    
    [self setCurrentWeek];
}


- (int) getDayIndex :(int) selectedDay :(int) selectedMonth : (int) selectedYear
{
	//calc = new MitrCalendar();
	//calc.setDateTime(time);
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:selectedDay];
    [comps setMonth:(selectedMonth + 1)];
    [comps setYear:selectedYear];
    
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate* calcDate = [gregorian dateFromComponents:comps];
    nsDateCurrentDate = [calcDate copy];
    


    
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


- (void) setDayName
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

-(void) setCurrentWeek
{
    
    
    // current week
    int dayIndex = [self getDayIndex: currentDate.day : currentDate.month :currentDate.year];
    NSLog(@"Day Index = %d", dayIndex);
   
    UIView* rowFieldManager = [[UIView alloc] initWithFrame:CGRectMake(0, yOffset, CONTAINER_WIDTH, CELL_HEIGHT)];
    yOffset =  yOffset + CELL_HEIGHT;
    
    NSTimeInterval timeInterval = 0;
    for(int i=dayIndex; i>=0; i--) {
        // setting previous days
        NSDate* tDate = [nsDateCurrentDate dateByAddingTimeInterval:timeInterval];
        DVDateStruct* tDateStruct = [DVDateStruct fromNSDate:tDate];
        NSLog(@"Prev: tDateStruct day = %d, month = %d", tDateStruct.day, tDateStruct.month);
        [rowFieldManager addSubview:[self createDateLabel :tDateStruct :i  :0]];
        timeInterval = timeInterval - 24*3600;
    }
    
    timeInterval = 0;
    for(int i=dayIndex+1; i<7; i++) {
        // setting next days from current day of this week.
        timeInterval = timeInterval + 24*3600;
        NSDate* tDate = [nsDateCurrentDate dateByAddingTimeInterval:timeInterval];
        DVDateStruct* tDateStruct = [DVDateStruct fromNSDate:tDate];
        NSLog(@"Forward: tDateStruct day = %d, month = %d", tDateStruct.day, tDateStruct.month);
        [rowFieldManager addSubview:[self createDateLabel :tDateStruct :i  :0]];
        
    }
    
    [mainContainer addSubview:rowFieldManager];
    [mainContainer addSubview:[self addHorizontalLine: yOffset]];
    
    
    
    
    
    // next week here
    rowFieldManager = [[UIView alloc] initWithFrame:CGRectMake(0, yOffset, CONTAINER_WIDTH, CELL_HEIGHT)];
    yOffset =  yOffset + CELL_HEIGHT;
    
    
    // we must use timeInterval increment from previous week
    for(int i=0; i<7; i++) {
        timeInterval = timeInterval + 24*3600;
        NSDate* tDate = [nsDateCurrentDate dateByAddingTimeInterval:timeInterval];
        DVDateStruct* tDateStruct = [DVDateStruct fromNSDate:tDate];
        NSLog(@"Forward: tDateStruct day = %d, month = %d", tDateStruct.day, tDateStruct.month);
        [rowFieldManager addSubview:[self createDateLabel :tDateStruct :i  :1]];
    }

    [mainContainer addSubview:rowFieldManager];
    [mainContainer addSubview:[self addHorizontalLine: yOffset]];
    
}


- (DVDateCell*) createDateLabel :(DVDateStruct*) dateStruct :(int) cellIdx  :(int) rowIdx
{
	DVDateCell* cell = nil;
	NSString* value = [NSString stringWithFormat:@"%d", dateStruct.day];
    
    cell = [[DVDateCell alloc] initWithFrame:CGRectMake(cellIdx*CELL_WIDTH, 0, CELL_WIDTH, CELL_HEIGHT) Text:value Day:dateStruct.day Month:dateStruct.month Year:dateStruct.year CellIndex:(rowIdx*7 + cellIdx)   Focus:YES Renderer:cellRenderer];
        
		
    cell.focusEventRegister = [DVDateCell  REGISTER_FIRE] + [DVDateCell  REGISTER_GOT_FOCUS];
    cell.dateCellDelegate = self;
		
	cell.cellName = [NSString stringWithFormat:@"%d", (rowIdx*7 + cellIdx)];
    cell.dateStruct = dateStruct;
    
	return cell;
}


#pragma - mark DVDateCellDelegate

-(void) cellTapped:(DVDateCell*) cell
{
    NSLog(@"DVTwoWeekView:cellTapped dateAtCell = %d", cell.dateAtCell);
    
    if(twoWeekViewDelegate!=nil && [twoWeekViewDelegate respondsToSelector:@selector(dateSelected:)]) {
        [twoWeekViewDelegate dateSelected:cell];
    }
}


@end
