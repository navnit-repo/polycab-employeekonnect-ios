//
//  DotHorizontalBarCell.m
//  QCMSProject
//
//  Created by Pradeep Singh on 1/16/15.
//  Copyright (c) 2015 dotvik. All rights reserved.
//

#import "DotHorizontalBarCell.h"
#import "DotHBar.h"
#import "DotHBarChart.h"
#import "LayoutClass.h"

#define BAR_TAG_START 2500
#define BAR_LABEL_TAG_START 4500
#define RIGHT_BAR_PADDING 0

@interface DotHorizontalBarCell ()
{
    int rowsCount;
}

@end

@implementation DotHorizontalBarCell

- (void)awakeFromNib {
    // Initialization code
    
    [super awakeFromNib];
    
    rowsCount = 0;
    self.barView.backgroundColor = [UIColor clearColor];
    self.leftAxisPartView.backgroundColor = [UIColor clearColor];
    self.needLeftAxis = YES;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self autolayout];
}


-(void)autolayout
{
    [LayoutClass setLayoutForIPhone6:self.contentView];
    
    [LayoutClass setLayoutForIPhone6:self.barView];
   // [LayoutClass setLayoutForIPhone6:self.line];
    [LayoutClass setLayoutForIPhone6:self.leftAxisPartView];
        
}


-(void) configuredForNoLeftAxis:(BOOL) needLeftAxis
{
    if(self.leftAxisPartView.hidden==NO && needLeftAxis==NO) {
        self.leftAxisPartView.hidden = YES;
        CGRect axisPartFrame = self.leftAxisPartView.frame;
        CGRect barFrame = self.barView.frame;
        self.barView.frame = CGRectMake(barFrame.origin.x - axisPartFrame.size.width , barFrame.origin.y, barFrame.size.width + axisPartFrame.size.width, barFrame.size.height);
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(DotHBar*) addSubBar:(DotHBarChart*) barChart forIndex:(NSInteger) index
{
    NSInteger widthOfSubBar = 30.0;  // this is default
    if([barChart.chartDataSource respondsToSelector:@selector(dotHBarChartSubBarWidth:)]) {
        widthOfSubBar = [barChart.chartDataSource dotHBarChartSubBarWidth:barChart];
    }
    NSInteger yOffset = 6 + rowsCount*widthOfSubBar;
    
    long value = 0;
    long maxValue = self.barView.frame.size.width - RIGHT_BAR_PADDING;
    
    
    if([barChart.chartDataSource respondsToSelector:@selector(dotHBarChart: barValueFor:)]) {
        value = [[barChart.chartDataSource dotHBarChart:barChart barValueFor:index] longValue];
    }
    
    if([barChart.chartDataSource respondsToSelector:@selector(dotHBarChart: maxBarValueFor:)]) {
        maxValue = [[barChart.chartDataSource dotHBarChart:barChart maxBarValueFor:index] longValue];
    }
    
    DotHBar* hBar = [[DotHBar alloc] initWithFrame:CGRectMake(0, yOffset, (self.barView.frame.size.width - RIGHT_BAR_PADDING)*value/maxValue, widthOfSubBar)];
    [self.barView addSubview:hBar];
    hBar.tag = BAR_TAG_START + rowsCount;
    
    rowsCount = rowsCount + 1;
    
    return hBar;
}

-(DotHBar*) addSubBar:(DotHBarChart *)barChart forValue:(double) value maxValue:(double) maxValue
{
    NSInteger widthOfSubBar = 30.0;  // this is default
   
    if([barChart.chartDataSource respondsToSelector:@selector(dotHBarChartSubBarWidth:)]) {
        widthOfSubBar = [barChart.chartDataSource dotHBarChartSubBarWidth:barChart];
    }
    
    NSInteger yOffset = 6 + rowsCount*widthOfSubBar;
    
   //  maxValue -----   (self.barView.frame.size.width - RIGHT_BAR_PADDING)*value/maxValue
    
    
    DotHBar* hBar = [[DotHBar alloc] initWithFrame:CGRectMake(RIGHT_BAR_PADDING, yOffset, (self.barView.frame.size.width - 2*RIGHT_BAR_PADDING)*value/maxValue, widthOfSubBar)];
    [self.barView addSubview:hBar];
    hBar.tag = BAR_TAG_START + rowsCount;
    
    rowsCount = rowsCount + 1;
    return hBar;
}

// NSArray of sub bars
-(NSArray*) subBars
{
    NSMutableArray* subBarArray = [[NSMutableArray alloc] initWithCapacity:rowsCount];
    
    for(int i=0; i<rowsCount; i++) {
        UIView* subBarView = [self.barView viewWithTag:(BAR_TAG_START + rowsCount)];
        [subBarArray addObject:subBarView];
    }
    return subBarArray;
}

-(DotHBar*) subBarAtIndex:(NSInteger) index
{
    return (DotHBar*)[self.barView viewWithTag:(BAR_TAG_START + index)];
}


-(void) updateSubBar:(DotHBarChart *)barChart forValue:(double) value maxValue:(double) maxValue subBarIndex:(NSInteger) index
{
   DotHBar* subBar =  (DotHBar*)[self.barView viewWithTag:(BAR_TAG_START + index)];

    CGFloat barWidth = 0.0;
    
    if(subBar!=nil) {
        if(maxValue>0.0) {
            barWidth = value*(self.barView.frame.size.width - 2*RIGHT_BAR_PADDING)/maxValue;
        }
        subBar.frame = CGRectMake(RIGHT_BAR_PADDING, subBar.frame.origin.y, barWidth , subBar.frame.size.height);
    }
    
    NSString* barLabelText = [NSString stringWithFormat:@"%.02f", value];
    
    CGSize  rectSize = [barLabelText boundingRectWithSize:CGSizeMake(self.barView.frame.size.width, subBar.frame.size.height) options: NSStringDrawingUsesLineFragmentOrigin attributes: @{ NSFontAttributeName: [UIFont systemFontOfSize:11] } context: nil].size;
    
    
    UILabel* barLabel = (UILabel*)[self.barView viewWithTag:(BAR_LABEL_TAG_START + index) ];
    if(barLabel!=nil) {
        [barLabel removeFromSuperview];
    }
    
    if(rectSize.width > barWidth) {
        // it cannot be fit inside the bar
        UILabel* barLabel = [[UILabel alloc] initWithFrame:CGRectMake(barWidth + 2, subBar.frame.origin.y, rectSize.width, rectSize.height)];
         barLabel.text = barLabelText;
        barLabel.textAlignment = NSTextAlignmentLeft;
        barLabel.font = [UIFont systemFontOfSize:11];
        barLabel.tag = BAR_LABEL_TAG_START + index;
        [self.barView addSubview:barLabel];
    } else {
        // it can fit inside the bar
        UILabel* barLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, subBar.frame.origin.y, barWidth, rectSize.height)];
        barLabel.text = barLabelText;
        barLabel.textAlignment = NSTextAlignmentCenter;
        barLabel.tag = BAR_LABEL_TAG_START + index;
        
        barLabel.font = [UIFont systemFontOfSize:11];
        
        [self.barView addSubview:barLabel];
    }

}

@end
