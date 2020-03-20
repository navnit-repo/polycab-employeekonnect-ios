//
//  DVCalendarConstants.m
//  ExPMCalender
//
//  Created by Pradeep Singh on 4/3/14.
//  Copyright (c) 2014 Dotvik Solutions. All rights reserved.
//

#import "DVCalendarConstants.h"


@implementation DVCalendarConstants

static NSArray* g_months = nil;
static NSArray* g_daysInMonth = nil;
static NSArray* g_days = nil;


+(NSArray*) months
{
    if(g_months==nil) {
        g_months = [[NSArray alloc] initWithObjects:@"January", @"February", @"March", @"April", @"May", @"June", @"July", @"August", @"Septemeber", @"October", @"November", @"December", nil];
    }
    return g_months;
}

+(NSArray*) daysInMonth {
    if(g_daysInMonth==nil) {
        NSMutableArray* dayData = [[NSMutableArray alloc] init];
        [dayData addObject:[[NSNumber alloc] initWithInt:31] ];  // jan
        [dayData addObject:[[NSNumber alloc] initWithInt:28] ];  // feb
        [dayData addObject:[[NSNumber alloc] initWithInt:31] ];   // march
        [dayData addObject:[[NSNumber alloc] initWithInt:30] ];   // april
        [dayData addObject:[[NSNumber alloc] initWithInt:31] ];   // may
        [dayData addObject:[[NSNumber alloc] initWithInt:30] ];   // june
        [dayData addObject:[[NSNumber alloc] initWithInt:31] ];   // july
        [dayData addObject:[[NSNumber alloc] initWithInt:31] ];   // aug
        [dayData addObject:[[NSNumber alloc] initWithInt:30] ];   // sep
        [dayData addObject:[[NSNumber alloc] initWithInt:31] ];   // Oct
        [dayData addObject:[[NSNumber alloc] initWithInt:30] ];   // nov
        [dayData addObject:[[NSNumber alloc] initWithInt:31] ];   // dec
        
        g_daysInMonth = [[NSArray alloc] initWithArray:dayData];
    }
    return g_daysInMonth;
    
}

+(NSArray*) days
{
    if(g_days==nil) {
        g_days = [[NSArray alloc] initWithObjects:@"Sun", @"Mon", @"Tue", @"Wed", @"Thu", @"Fri", @"Sat", nil];
    }
    return g_days;
    
}



+(int) SUNDAY
{
    return 1;
}

+(int) MONDAY
{
    return 2;
}

+(int) TUESDAY
{
    return  3;
}

+(int) WEDNESDAY
{
    return  4;
}

+(int) THURSDAY
{
    return 5;
}

+(int) FRIDAY
{
    return 6;
}

+(int) SATURDAY
{
    return 7;
}

@end
