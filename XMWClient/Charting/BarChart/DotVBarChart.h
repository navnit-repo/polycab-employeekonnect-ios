//
//  DotVBarChart.h
//  QCMSProject
//
//  Created by Pradeep Singh on 1/7/15.
//  Copyright (c) 2015 dotvik. All rights reserved.
//


/*
 * In Vertical chart representation, we will have horizontal axis as a part of the UICollectionView
 * row cell view.
 *
 */

#import <UIKit/UIKit.h>
#import "DotBarChartDataSource.h"

@interface DotVBarChart : UIView <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>


@property (weak, nonatomic) IBOutlet UIView* legendView;
@property (weak, nonatomic) IBOutlet UIView* verticalAxisView;
@property (weak, nonatomic) IBOutlet UICollectionView* barChartsTableView;


@property (weak, nonatomic) id<DotVBarChartDataSource> chartDataSource;
@property (weak, nonatomic) id<DotVBarChartDelegate> chartDelegate;

+(DotVBarChart*) createInstance;

-(void) updateLayout;

@end
