//
//  DVDateStruct.h
//  ExPMCalender
//
//  Created by Pradeep Singh on 4/3/14.
//  Copyright (c) 2014 Dotvik Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DVDateStruct : NSObject
{
    int day;
	int month;
	int year;
}

@property int day;
@property int month;
@property int year;

+(DVDateStruct*) fromNSDate:(NSDate*) date;
-(id) init :(int) inDay :(int) inMonth :(int) inYear;
-(NSDate*) convertToNSDate;

@end
