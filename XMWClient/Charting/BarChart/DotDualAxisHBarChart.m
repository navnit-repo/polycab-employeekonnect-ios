//
//  DotDualAxisHBarChart.m
//  QCMSProject
//
//  Created by Pradeep Singh on 2/3/15.
//  Copyright (c) 2015 dotvik. All rights reserved.
//

#import "DotDualAxisHBarChart.h"
#import "DotHAxis.h"
#import "DualAxisHorizontalBarCell.h"

#define kInnerBarViewTag 5769
#define kInnerAxisViewTag 5770
#define kHLeftAxisTag 4770
#define kHRightAxisTag 4870

@implementation DotDualAxisHBarChart

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


+(DotDualAxisHBarChart*) createInstance
{
    DotDualAxisHBarChart *view = (DotDualAxisHBarChart *)[[[NSBundle mainBundle] loadNibNamed:@"DotDualAxisHBarChart" owner:self options:nil] objectAtIndex:0];
    view.barChartsTableView.delegate = view;
    view.barChartsTableView.dataSource = view;
    view.barChartsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [view.barChartsTableView registerNib:[UINib nibWithNibName:@"DualAxisHorizontalBarCell" bundle:nil]  forCellReuseIdentifier:@"DualAxisHorizontalBarCell" ];
    
    return view;
}



-(void) updateLayout
{
    
    CGRect hAxisFrame = self.horizontalAxisView.frame;
    self.horizontalAxisView.frame = CGRectMake(hAxisFrame.origin.x, hAxisFrame.origin.y, self.frame.size.width, hAxisFrame.size.height);
    
    CGRect legendViewFrame = self.legendView.frame;
    self.legendView.frame = CGRectMake(legendViewFrame.origin.x, self.frame.size.height - legendViewFrame.size.height, self.frame.size.width, legendViewFrame.size.height);
    
    CGRect tableFrame = self.barChartsTableView.frame;
    self.barChartsTableView.frame = CGRectMake(tableFrame.origin.x, self.horizontalAxisView.frame.origin.y + self.horizontalAxisView.frame.size.height, self.frame.size.width, self.frame.size.height - self.legendView.frame.size.height - self.horizontalAxisView.frame.size.height);
    
    
}



#pragma mark - table view delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.chartDataSource!=nil && [self.chartDataSource respondsToSelector:@selector(dotHBarChartNumberOfBars:)]) {
        return [self.chartDataSource dotHBarChartNumberOfBars:self];
    } else {
        return 0;
    }
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger widthOfSubBar = 30.0;
    
    if([self.chartDataSource respondsToSelector:@selector(dotHBarChartBarWidth:)]) {
        widthOfSubBar = [self.chartDataSource dotHBarChartBarWidth:self];
    }
    
    return 6 + widthOfSubBar + 6;
}


-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DualAxisHorizontalBarCell *cell = (DualAxisHorizontalBarCell*)[tableView dequeueReusableCellWithIdentifier:@"DualAxisHorizontalBarCell"];
    
    if(cell==nil) {
        // it should not come here
        cell = [[DualAxisHorizontalBarCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"DualAxisHorizontalBarCell"];
        
    }

    if(self.chartDelegate!=nil && [self.chartDelegate respondsToSelector:@selector(dotHBarChart: horizontalBarView:)]) {
        UIView* udfBarView = [cell.contentView viewWithTag:kInnerBarViewTag];
        if(udfBarView==nil) {
            udfBarView = [self.chartDelegate dotHBarChart:cell horizontalBarView:indexPath.row];
            if(udfBarView!=nil) {
                udfBarView.tag = kInnerBarViewTag;
                [cell.contentView addSubview:udfBarView];
            }
        }
    }

    return cell;
    
}


-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
        if(self.chartDelegate!=nil && [self.chartDelegate respondsToSelector:@selector(dotHBarChart: userDefView: configureHorizontalBarView:)])
        {
            UIView* udfBarView = [cell.contentView viewWithTag:kInnerBarViewTag];
            [self.chartDelegate dotHBarChart:cell userDefView:udfBarView configureHorizontalBarView:indexPath.row];
        } else {
            // do something here
            // draw default behaviour
            
        }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.chartDelegate!=nil && [self.chartDelegate respondsToSelector:@selector(dotHBarChart: didSelectRowAtIndexPath:)]) {
        [self.chartDelegate dotHBarChart:self didSelectRowAtIndexPath:indexPath];
        
    }
    
}





-(void) updateLeftHorizontalAxis:(double) minValue :(double) maxValue
{
    DotHAxis* hAxis = (DotHAxis*)[self.horizontalAxisView viewWithTag:kHLeftAxisTag];
    if(hAxis!=nil) {
        [hAxis removeFromSuperview];
    }
    
    hAxis = [[DotHAxis alloc] initWithFrame:CGRectMake(self.horizontalAxisView.frame.origin.x, self.horizontalAxisView.frame.origin.y, self.horizontalAxisView.frame.size.width*3.0f/4.0f, self.horizontalAxisView.frame.size.height)];
    
    hAxis.displayText = @"INR \n(in Lacs)";
    hAxis.maxValue = maxValue;
    hAxis.minValue = minValue;
    hAxis.parts = 4;
    hAxis.isDescending = NO;
    hAxis.clipsToBounds = NO;
    hAxis.backgroundColor = [UIColor clearColor];
    hAxis.tag = kHLeftAxisTag;
    [self.horizontalAxisView addSubview:hAxis];
    
}

-(void) updateRightHorizontalAxis:(double) minValue :(double) maxValue
{
    
    DotHAxis* hAxis = (DotHAxis*)[self.horizontalAxisView viewWithTag:kHRightAxisTag];
    if(hAxis!=nil) {
        [hAxis removeFromSuperview];
    }
    
    hAxis = [[DotHAxis alloc] initWithFrame:CGRectMake(self.horizontalAxisView.frame.origin.x + self.horizontalAxisView.frame.size.width*3.0f/4.0f, self.horizontalAxisView.frame.origin.y, self.horizontalAxisView.frame.size.width/4.0f, self.horizontalAxisView.frame.size.height)];
    
    hAxis.displayText = @"INR \n(in Lacs)";

    hAxis.maxValue = maxValue;
    hAxis.minValue = minValue;
    hAxis.parts = 2;
    hAxis.isDescending = YES;
    hAxis.clipsToBounds = NO;
    hAxis.backgroundColor = [UIColor clearColor];
    hAxis.tag = kHRightAxisTag;
    [self.horizontalAxisView addSubview:hAxis];
    
}

@end
