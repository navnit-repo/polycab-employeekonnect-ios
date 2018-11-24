//
//  DVMonthYearPicker.m
//  SampleCalendar
//
//  Created by Pradeep Singh on 10/30/13.
//  Copyright (c) 2013 Dotvik Solutions. All rights reserved.
//

#import "DVMonthYearPicker.h"

@implementation DVMonthYearPicker

static NSArray* g_MonthList = nil;

@synthesize monthYearPicker;
@synthesize yearList;
@synthesize lowerYear;
@synthesize upperYear;
@synthesize currentYear;
@synthesize monthYearDelegate;
@synthesize selectedMonthIdx;
@synthesize selectedYearIdx;
@synthesize selectedMonth;
@synthesize selectedYear;

- (id)initWithFrame:(CGRect)frame
{
    if(g_MonthList==nil) {
        g_MonthList = [[NSArray alloc] initWithObjects:@"January", @"February", @"March", @"April", @"May",
                       @"June", @"July", @"August", @"September", @"October", @"November", @"December",  nil];
    }
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    self = [super initWithFrame:CGRectMake(0, screenRect.size.height/2, screenRect.size.width, screenRect.size.height/2)];
    if (self) {
        
        UIToolbar* pickerToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0, 2, screenRect.size.width, 40)];
		pickerToolBar.barStyle = UIBarStyleBlackTranslucent;
		[pickerToolBar sizeToFit];
        
        UIButton* cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 80, 40)];
        [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];

        UIButton* doneButton = [[UIButton alloc] initWithFrame:CGRectMake(screenRect.size.width - 80, 0.0, 80 , 40)];
        [doneButton setTitle:@"Done" forState:UIControlStateNormal];
        [doneButton addTarget:self action:@selector(doneButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [pickerToolBar addSubview:cancelButton];
        [pickerToolBar addSubview:doneButton];
        
        
        monthYearPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, screenRect.size.width, 150)];
        // Initialization code
        monthYearPicker.delegate = self;
        monthYearPicker.dataSource = self;
        monthYearPicker.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:pickerToolBar];
        [self addSubview:monthYearPicker];
        
        NSDate *today = [NSDate date];
        NSCalendar *gregorian = [[NSCalendar alloc]
                                 initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *weekdayComponents =
        [gregorian components:(NSDayCalendarUnit | NSWeekdayCalendarUnit | NSYearCalendarUnit) fromDate:today];
        
        NSLog(@"year %d", weekdayComponents.year);
        self.currentYear = [[NSNumber alloc] initWithInt:weekdayComponents.year ];
        self.lowerYear = [[NSNumber alloc] initWithInt:weekdayComponents.year - 9];
        self.upperYear = [[NSNumber alloc] initWithInt:weekdayComponents.year + 1];
        self.yearList = [[NSMutableArray alloc] init];
        
        for(int i= self.lowerYear.intValue; i<=self.upperYear.intValue; i++) {
            NSString* yearName = [[NSString alloc] initWithFormat:@"%d", i ];
            [self.yearList addObject:yearName];
        }
        
         selectedMonthIdx = [[NSNumber alloc] initWithInt:-1 ];
         selectedYearIdx = [[NSNumber alloc] initWithInt:-1 ];
         selectedMonth = [[NSNumber alloc] initWithInt:-1 ];
         selectedYear = [[NSNumber alloc] initWithInt:-1 ];
        
        
       // NSInteger year = currentDate
                              // ]currentDate
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



// functions form UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if(component == 0) {
        return 12; // number of months
    } else {
        
        // it will depends on the type of the calendar,
        // we have three cases, 1 lower date limited from current date
        // 2. upper date limited from current date
        // 3. limited date from lowe to uppder
        return self.yearList.count;
    }
    
}

// functions for UIPickerViewDelegate Protocol Reference

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 30.0;
}


- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if(component == 0) {
        return [[UIScreen mainScreen] bounds].size.width/2;
    } else {
        return [[UIScreen mainScreen] bounds].size.width/2;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(component == 0) {
        return @"Month";
        
    } else {
        return @"Year";
    }
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return nil;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    
    UILabel* label;
    if(component==0) {
        label = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width/2, 30)];
        label.text = [g_MonthList objectAtIndex:row];
        label.textAlignment = NSTextAlignmentCenter;
    } else {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width/2, 30)];
        label.text = [self.yearList objectAtIndex:row];
        label.textAlignment = NSTextAlignmentCenter;
    }
    
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSLog(@"pickerView didSelectRow in Component %d %d", row, component);
    if(component==0) {
        self.selectedMonthIdx = [[NSNumber alloc] initWithInt:row ] ;
        self.selectedMonth = [[NSNumber alloc] initWithInt: (row +1)  ];
         NSLog(@"pickerView didSelectRow selected month = %@ ", self.selectedMonth);
    } else {
        self.selectedYearIdx = [[NSNumber alloc] initWithInt:row ] ;
        int yearValue = [(NSString*)[self.yearList objectAtIndex:row] intValue];
        self.selectedYear = [[NSNumber alloc] initWithInt:yearValue ] ;
        NSLog(@"pickerView didSelectRow selected year = %@ ", self.selectedYear);
    }
}


-(IBAction)cancelButtonPressed:(id)sender
{
    if(monthYearDelegate!=nil) {
        [monthYearDelegate canceled];
    }
    [self removeFromSuperview];
}

-(IBAction)doneButtonPressed:(id)sender
{
    if(monthYearDelegate!=nil)
    {
        if(self.selectedYear.intValue == -1 && self.selectedMonth.intValue !=-1)
        {
            [monthYearDelegate selectedMonth:self.selectedMonth.intValue year:[[self.yearList objectAtIndex:0] intValue]];
        }
        else if( self.selectedMonth.intValue ==-1 && self.selectedYear.intValue != -1)
        {
            [monthYearDelegate selectedMonth:1 year:self.selectedYear.intValue];
        }
        else if(self.selectedYear.intValue == -1 && self.selectedMonth.intValue ==-1)
        {
            [monthYearDelegate selectedMonth:1 year:[[self.yearList objectAtIndex:0] intValue]];
            
        }
        else
        [monthYearDelegate selectedMonth:self.selectedMonth.intValue year:self.selectedYear.intValue];
    }
    
    [self removeFromSuperview];
}


@end
