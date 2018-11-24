//
//  DVDayNameCell.h
//  ExPMCalender
//
//  Created by Pradeep Singh on 4/3/14.
//  Copyright (c) 2014 Dotvik Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DVDayNameCell : UIView
{
    UILabel* label;
	NSString* text;
	int dayOfWeek;
	int cellWidth;
	int cellHeight;
}

@property UILabel* label;
@property NSString* text;
@property int dayOfWeek;
@property int cellWidth;
@property int cellHeight;

- (id)initWithFrame:(CGRect)frame :(NSString*) inText :(int) inDayOfWeek;


@end
