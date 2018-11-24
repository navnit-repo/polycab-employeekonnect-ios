//
//  FirstDashMTDView.h
//  QCMSProject
//
//  Created by Ashish Tiwari on 16/01/15.
//  Copyright (c) 2015 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HttpEventListener.h"
#import "ClientVariable.h"
#import "ReportPostResponse.h"

@interface FirstDashMTDView : UIView<HttpEventListener>

+(FirstDashMTDView*) createInstance;


-(void) updateData;
-(void) refreshData;


-(void)setViewContent:(ReportPostResponse *)responseMTDdata;


@property (weak, nonatomic) ReportPostResponse* salesSummaryDataMTD;

@property (weak, nonatomic) IBOutlet UILabel *dataLable;
@property (weak, nonatomic) IBOutlet UILabel *mtdLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomLineView;

@property (weak, nonatomic) IBOutlet UIView *topLineView;
@property (weak, nonatomic) IBOutlet UILabel *lacLabel;
@property (weak, nonatomic) IBOutlet UIButton* pauseFlipButton;

@end
