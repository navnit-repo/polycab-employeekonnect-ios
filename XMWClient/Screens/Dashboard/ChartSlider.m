//
//  ChartSlider.m
//  QCMSProject
//
//  Created by Pradeep Singh on 1/28/15.
//  Copyright (c) 2015 dotvik. All rights reserved.
//

#import "ChartSlider.h"
#import "SalesComparisonChart.h"

@interface ChartSlider ()
{
    SalesComparisonChart* mtdComparisionChart;
    SalesComparisonChart* ytdCompparisionChart;
}

@end

@implementation ChartSlider

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.delegate = self;
    self.dataSource = self;
    
    NSArray *viewControllers = [NSArray arrayWithObjects:[self viewControllerAtIndex:0], nil];
    [self viewControllerAtIndex:1];
    
    [self setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (UIViewController *)viewControllerAtIndex:(NSUInteger)index {
    
    if(index==0) {
        if(mtdComparisionChart==nil) {
            mtdComparisionChart = [[SalesComparisonChart alloc] init];
            mtdComparisionChart.chartType = MTD_SALES;
        }
        return  mtdComparisionChart;
    } else if(index==1) {
        if(ytdCompparisionChart==nil) {
            ytdCompparisionChart = [[SalesComparisonChart alloc] init];
            ytdCompparisionChart.chartType = YTD_SALES;
        }
        return ytdCompparisionChart;
    } else {
        return nil;
    }
}


#pragma  mark - UIPageViewControllerDelegate




#pragma  mark - UIPageViewControllerDataSource


- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    SalesComparisonChart* salesChartVC = (SalesComparisonChart*)viewController;
    if(salesChartVC.chartType==MTD_SALES) return ytdCompparisionChart;
    if(salesChartVC.chartType==YTD_SALES) return mtdComparisionChart;
    return nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    SalesComparisonChart* salesChartVC = (SalesComparisonChart*)viewController;
    if(salesChartVC.chartType==MTD_SALES) return ytdCompparisionChart;
    if(salesChartVC.chartType==YTD_SALES) return mtdComparisionChart;
    return nil;
    
}


@end
