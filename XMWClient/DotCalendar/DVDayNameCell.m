//
//  DVDayNameCell.m
//  ExPMCalender
//
//  Created by Pradeep Singh on 4/3/14.
//  Copyright (c) 2014 Dotvik Solutions. All rights reserved.
//

#import "DVDayNameCell.h"

@implementation DVDayNameCell

@synthesize label;
@synthesize  text;
@synthesize  dayOfWeek;
@synthesize  cellWidth;
@synthesize  cellHeight;


- (id)initWithFrame:(CGRect)frame :(NSString*) inText :(int) inDayOfWeek
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.text = inText;
        self.dayOfWeek = inDayOfWeek;
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        label.text = inText;
        label.font = [UIFont systemFontOfSize:10.0];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [super drawRect:rect];
    
    // CGRect rectangle = CGRectMake(0, 100, 320, 100);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(context, 1.0, 0.0, 0.0, 1.0);
    CGContextSetRGBStrokeColor(context, 1.0, 0.0, 0.0, 1.0);
    CGContextFillRect(context, rect);
}
 */


@end
