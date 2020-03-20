//
//  DVDateStruct.m
//  ExPMCalender
//
//  Created by Pradeep Singh on 4/3/14.
//  Copyright (c) 2014 Dotvik Solutions. All rights reserved.
//

#import "DVDateStruct.h"
#import "DVCalendarConstants.h"

@implementation DVDateStruct

@synthesize day;
@synthesize month;
@synthesize year;



+(DVDateStruct*) fromNSDate:(NSDate*) date
{
    
   // NSCalendar *gregorian = [[NSCalendar alloc]
     //                        initWithCalendarIdentifier:NSGregorianCalendar];
    //NSDateComponents *weekdayComponents =[gregorian components:NSWeekdayCalendarUnit fromDate:date];
    
    
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *weekdayComponents =[gregorian components:(NSDayCalendarUnit | NSWeekdayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:date];
    
    DVDateStruct* tDate = [[DVDateStruct alloc] init:weekdayComponents.day :weekdayComponents.month-1 : weekdayComponents.year ];
    
    return tDate;
}


-(id) init
{
    self = [super init];
    if(self!=nil) {
        self.day = 1;
        self.month = 0;
        self.year = 2014;
        
    }
    return self;
}


-(id) init :(int) inDay :(int) inMonth :(int) inYear
{
    self = [super init];
    if(self!=nil) {
        self.day = inDay;
        self.month = inMonth;
        self.year = inYear;
    }
    return self;
}

-(void) checkValidity {
    if (month > 11) {
        month = 11;
    }
    if (month < 0) {
        month = 0;
    }
    int dt = [self getNoDays: month :year];
    if (day > dt)
        day = dt;
    if (day < 1)
        day = 1;
}

-(int) getNoDays :(int) inMonth :(int) inYear
{
	NSNumber* limit = [[DVCalendarConstants daysInMonth] objectAtIndex:inMonth];
    if ((inMonth == 1) && (inYear % 4 == 0)) {
		return  29;
    } else {
        return limit.intValue;
    }
}

-(NSDate*) convertToNSDate
{
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents* dateComponents = [[NSDateComponents alloc] init];
    dateComponents.day = self.day;
    dateComponents.month = self.month + 1;
    dateComponents.year = self.year;
    
    return [gregorian dateFromComponents:dateComponents];
}

@end
