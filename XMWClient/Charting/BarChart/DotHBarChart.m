//
//  DotHBarChart.m
//  QCMSProject
//
//  Created by Pradeep Singh on 1/7/15.
//  Copyright (c) 2015 dotvik. All rights reserved.
//

#import "DotHBarChart.h"
#import "DotHorizontalBarCell.h"
#import "DotHAxis.h"


#define kInnerBarViewTag 5769
#define kInnerAxisViewTag 5770
#define kHAxisTag 4770

@implementation DotHBarChart

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


+(DotHBarChart*) createInstance
{
    DotHBarChart *view = (DotHBarChart *)[[[NSBundle mainBundle] loadNibNamed:@"DotHBarChart" owner:self options:nil] objectAtIndex:0];
    view.barChartsTableView.delegate = view;
    view.barChartsTableView.dataSource = view;
    
    // [view.barChartsTableView registerClass:[DotHorizontalBarCell class] forCellReuseIdentifier:@"DotHorizontalBarCell"];
    
    
    [view.barChartsTableView registerNib:[UINib nibWithNibName:@"DotHorizontalBarCell" bundle:nil]  forCellReuseIdentifier:@"DotHorizontalBarCell" ];
    
    view.needLeftAxis = YES;
    
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

    
    
    DotHAxis* hAxis = [[DotHAxis alloc] initWithFrame:CGRectMake(self.horizontalAxisView.frame.origin.x, self.horizontalAxisView.frame.origin.y, self.horizontalAxisView.frame.size.width, self.horizontalAxisView.frame.size.height)];
    
    hAxis.displayText = @"All data in INR";
    hAxis.maxValue = 100;
    hAxis.minValue = 0;
    hAxis.parts = 4;
    hAxis.clipsToBounds = NO;
    hAxis.backgroundColor = [UIColor clearColor];
    hAxis.tag = kHAxisTag;
    [self.horizontalAxisView addSubview:hAxis];
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
    NSInteger noOfSubBars = 1;
    NSInteger widthOfSubBar = 30.0;
    if(self.chartDataSource != nil && [self.chartDataSource respondsToSelector:@selector(dotHBarChart:noOfSubBarFor:)]) {
        noOfSubBars = [self.chartDataSource dotHBarChart:self noOfSubBarFor:indexPath.row];
        
        if([self.chartDataSource respondsToSelector:@selector(dotHBarChartSubBarWidth:)]) {
            widthOfSubBar = [self.chartDataSource dotHBarChartSubBarWidth:self];
        }
        
    }
    return 6 + noOfSubBars*widthOfSubBar + 6;
}


-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DotHorizontalBarCell"];
    
    if(cell==nil) {
        cell = [[DotHorizontalBarCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"DotHorizontalBarCell"];
    }
    
    if([cell isKindOfClass:[DotHorizontalBarCell class]]) {
        DotHorizontalBarCell* barCell = (DotHorizontalBarCell*) cell;
        
        if(self.needLeftAxis==NO) {
            [barCell configuredForNoLeftAxis:NO];
            CGRect barFrame = barCell.barView.frame;
            CGFloat height = [self tableView:tableView heightForRowAtIndexPath:indexPath];
            barCell.barView.frame = CGRectMake(barFrame.origin.x , barFrame.origin.y, barFrame.size.width, height);
        }
        
        if(self.chartDelegate!=nil && [self.chartDelegate respondsToSelector:@selector(dotHBarChart: horizontalBarView:)]) {
            UIView* udfBarView = [barCell.barView viewWithTag:kInnerBarViewTag];
            if(udfBarView==nil) {
                udfBarView = [self.chartDelegate dotHBarChart:barCell horizontalBarView:indexPath.row];
                if(udfBarView!=nil) {
                    udfBarView.tag = kInnerBarViewTag;
                    [barCell.barView addSubview:udfBarView];
                }
            }
        } else {
            // do something here
            // draw default behaviour
        }
        
        
        if(self.chartDelegate!=nil && [self.chartDelegate respondsToSelector:@selector(dotHBarChart: partViewForVerticalAxis:)]) {
            UIView* udfAxisView = [barCell.leftAxisPartView viewWithTag:kInnerAxisViewTag];
            if(udfAxisView==nil) {
                udfAxisView = [self.chartDelegate dotHBarChart:barCell partViewForVerticalAxis:indexPath.row];
                if(udfAxisView!=nil) {
                    udfAxisView.tag = kInnerAxisViewTag;
                    [barCell.leftAxisPartView addSubview:udfAxisView];
                }
            }
        } else {
            // do something here
            // draw default behaviour
            
        }
        
        
    }
    return cell;
    
}


-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([cell isKindOfClass:[DotHorizontalBarCell class]]) {
         DotHorizontalBarCell* barCell = (DotHorizontalBarCell*) cell;
        
        if(self.chartDelegate!=nil && [self.chartDelegate respondsToSelector:@selector(dotHBarChart: userDefView: configureHorizontalBarView:)]) {
             UIView* udfBarView = [barCell.barView viewWithTag:kInnerBarViewTag];
            [self.chartDelegate dotHBarChart:barCell userDefView:udfBarView configureHorizontalBarView:indexPath.row];
        } else {
            // do something here
            // draw default behaviour
            
        }
        
        
        if(self.chartDelegate!=nil && [self.chartDelegate respondsToSelector:@selector(dotHBarChart: userDefAxisView: configurePartAxisView:)]) {
            UIView* udfAxisView = [barCell.leftAxisPartView viewWithTag:kInnerAxisViewTag];
            [self.chartDelegate dotHBarChart:barCell userDefAxisView:udfAxisView configurePartAxisView:indexPath.row];
        } else {
            // do something here
            // draw default behaviour
            
        }
        
    }
}



-(void) updateHorizontalAxis:(double) minValue :(double) maxValue
{
    DotHAxis* hAxis = (DotHAxis*)[self.horizontalAxisView viewWithTag:kHAxisTag];
    if(hAxis!=nil) {
        [hAxis removeFromSuperview];
    }
    
    
    hAxis = [[DotHAxis alloc] initWithFrame:CGRectMake(self.horizontalAxisView.frame.origin.x, self.horizontalAxisView.frame.origin.y, self.horizontalAxisView.frame.size.width, self.horizontalAxisView.frame.size.height)];
    
    hAxis.displayText = @"All data in INR";
    hAxis.maxValue = maxValue;
    hAxis.minValue = minValue;
    hAxis.parts = 4;
    hAxis.clipsToBounds = NO;
    hAxis.backgroundColor = [UIColor clearColor];
    hAxis.tag = kHAxisTag;
    [self.horizontalAxisView addSubview:hAxis];
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.chartDelegate!=nil && [self.chartDelegate respondsToSelector:@selector(dotHBarChart: didSelectRowAtIndexPath:)]) {
        [self.chartDelegate dotHBarChart:self didSelectRowAtIndexPath:indexPath];
        
    }
    
}


@end
