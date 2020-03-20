//
//  DotHorizontalBarCell.h
//  QCMSProject
//
//  Created by Pradeep Singh on 1/16/15.
//  Copyright (c) 2015 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DotHBar.h"

@class DotHBarChart;


@interface DotHorizontalBarCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIView* barView;
@property (weak, nonatomic) IBOutlet UIView* leftAxisPartView;
@property BOOL needLeftAxis;

-(void) configuredForNoLeftAxis:(BOOL) needLeftAxis;

-(DotHBar*) addSubBar:(DotHBarChart*) barChart forIndex:(NSInteger) index;
-(DotHBar*) addSubBar:(DotHBarChart *)barChart forValue:(double) value maxValue:(double) value;
-(NSArray*) subBars;
-(DotHBar*) subBarAtIndex:(NSInteger) index;
-(void) updateSubBar:(DotHBarChart *)barChart forValue:(double) value maxValue:(double) maxValue subBarIndex:(NSInteger) index;


@end
