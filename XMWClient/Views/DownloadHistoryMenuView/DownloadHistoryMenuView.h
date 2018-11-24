//
//  SharedMenuOptionView.h
//
//  Created by Ashish Tiwari
//  Copyright (c) 2013 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReportVC.h"


@protocol DownloadHistoryMenuHandler <NSObject>
-(void) downloadHistoryClicked : (int) idx;
@end


@interface DownloadHistoryMenuView : UIView<UITableViewDelegate,UITableViewDataSource>
{
    id<DownloadHistoryMenuHandler> downloadHistoryMenuHandler;
    
    
    UIProgressView *firstProgress;
    UILabel *percentageLabel;
    CGFloat _percentage;
    
    ReportVC *reportVc;
}

@property UITableView* downloadTable;
@property NSMutableArray* downloadHistoryList;

- (id)initWithFrame:(CGRect)frame withMenu:(NSArray*) menus handler:(id<DownloadHistoryMenuHandler>) historyMenuHandler;


@property UIProgressView *firstProgress;
@property UILabel *percentageLabel;
@property CGFloat _percentage;
@property ReportVC *reportVc;


@end


