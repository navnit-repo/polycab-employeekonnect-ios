//
//  DotBarChartDataSource.h
//  QCMSProject
//
//  Created by Pradeep Singh on 1/7/15.
//  Copyright (c) 2015 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>


@class DotHBarChart;
@class DotDualAxisHBarChart;
@class DotVBarChart;
@class DotHorizontalBarCell;
@class DotVerticalBarCell;
@class DualAxisHorizontalBarCell;


@protocol DotHBarChartDataSource <NSObject>

-(NSInteger) dotHBarChartNumberOfBars:(DotHBarChart *)barChart;
-(NSInteger) dotHBarChart:(DotHBarChart *)barChart noOfSubBarFor:(NSInteger) index;
-(NSInteger) dotHBarChartSubBarWidth:(DotHBarChart *)barChart;
-(NSNumber*) dotHBarChart:(DotHBarChart *)barChart barValueFor:(NSInteger) index;
-(NSNumber*) dotHBarChart:(DotHBarChart *)barChart maxBarValueFor:(NSInteger) index;
-(NSString*) dotHBarChart:(DotHBarChart *)barChart axisValueFor:(NSInteger) index;
-(NSString*) dotHBarChart:(DotHBarChart *)barChart unitOfMeasureValueFor:(NSInteger)index;

@end

@protocol DotHBarChartDelegate <NSObject>

-(UIView*) dotHBarChart:(DotHorizontalBarCell *)barCell partViewForVerticalAxis:(NSInteger) index;
-(void) dotHBarChart:(DotHorizontalBarCell *)barCell userDefAxisView:(UIView*) udfView configurePartAxisView:(NSInteger) index;

-(UIView*) dotHBarChart:(DotHorizontalBarCell *)barCell horizontalBarView:(NSInteger) index;
-(void) dotHBarChart:(DotHorizontalBarCell *)barCell userDefView:(UIView*) udfView configureHorizontalBarView:(NSInteger) index;
-(void)dotHBarChart:(DotHBarChart *)barChart didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end


@protocol DotDualHAxisDataSource <NSObject>
-(NSInteger) dotHBarChartNumberOfBars:(DotDualAxisHBarChart *)barChart;
-(NSInteger) dotHBarChartBarWidth:(DotDualAxisHBarChart *)barChart;

@end

@protocol DotDualHAxisDelegate <NSObject>
-(UIView*) dotHBarChart:(DualAxisHorizontalBarCell *) cell horizontalBarView:(NSInteger) index;
-(void) dotHBarChart:(DualAxisHorizontalBarCell *)cell userDefView:(UIView*) udfView configureHorizontalBarView:(NSInteger) index;
-(void) dotHBarChart:(DotDualAxisHBarChart *)barChart didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
@end

@protocol DotVBarChartDataSource <NSObject>


-(NSInteger) dotVBarChartNumberOfBars:(DotVBarChart *)barChart;
-(NSNumber*) dotVBarChart:(DotVBarChart *)barChart barValueFor:(NSInteger) index;
-(NSNumber*) dotVBarChart:(DotVBarChart *)barChart maxBarValueFor:(NSInteger)index;
-(NSString*) dotVBarChart:(DotVBarChart *)barChart axisValueFor:(NSInteger) index;
-(NSString*) dotVBarChart:(DotVBarChart *)barChart unitOfMeasureValueFor:(NSInteger)index;


@end

@protocol DotVBarChartDelegate <NSObject>

-(UIView*) dotVBarChart:(DotVerticalBarCell *)barCell partViewForHorizontalAxis:(NSInteger) index;
-(void) dotVBarChart:(DotVerticalBarCell *)barCell configurePartAxisView:(NSInteger) index;

-(UIView*) dotVBarChart:(DotVerticalBarCell *)barCell verticalBarView:(NSInteger) index;
-(void) dotVBarChart:(DotVerticalBarCell *)barCell configureVerticalBarView:(NSInteger) index;


@end
