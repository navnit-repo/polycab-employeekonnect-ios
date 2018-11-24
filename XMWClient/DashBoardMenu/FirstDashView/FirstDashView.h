//
//  FirstDashView.h
//  QCMSProject
//
//  Created by Ashish Tiwari on 14/01/15.
//  Copyright (c) 2015 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HttpEventListener.h"
#import "ClientVariable.h"


@interface FirstDashView : UIView<HttpEventListener>

+(FirstDashView*) createInstance;
-(void) updateData;
-(void) refreshData;


-(void)setViewContent:(ReportPostResponse *)responseYTDdata;


@property (weak, nonatomic) ReportPostResponse* salesSummaryDataYTD;

@property (weak, nonatomic) IBOutlet UILabel *dataLable;


@property (weak, nonatomic) IBOutlet UILabel *ytdLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomLineView;
@property (weak, nonatomic) IBOutlet UIView *topLineView;
@property (weak, nonatomic) IBOutlet UILabel *lacLabel;
@property (weak, nonatomic) IBOutlet UIButton* pauseFlipButton;

@end
