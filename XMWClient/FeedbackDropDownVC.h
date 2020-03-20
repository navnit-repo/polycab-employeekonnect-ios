//
//  FeedbackDropDownVC.h
//  XMWClient
//
//  Created by dotvikios on 05/10/18.
//  Copyright © 2018 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DoneDelegate;

@interface FeedbackDropDownVC : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *aerialBunchedView;
@property (weak, nonatomic) IBOutlet UIButton *aerialBunchedButton;
@property (weak, nonatomic) IBOutlet UIImageView *controlCablesView;
@property (weak, nonatomic) IBOutlet UIButton *controlCablesButton;
@property (weak, nonatomic) IBOutlet UIImageView *flexibleCablesView;
@property (weak, nonatomic) IBOutlet UIButton *flexibleCablesButton;
@property (weak, nonatomic) IBOutlet UIImageView *fireSurvivalCablesView;
@property (weak, nonatomic) IBOutlet UIButton *fireSurvivalCablesButton;
@property (weak, nonatomic) IBOutlet UIImageView *flexibleWiresView;
@property (weak, nonatomic) IBOutlet UIButton *flexibleWiresButton;
@property (weak, nonatomic) IBOutlet UIImageView *hTCablesView;
@property (weak, nonatomic) IBOutlet UIButton *hTCablesButton;
@property (weak, nonatomic) IBOutlet UIImageView *buildingWiresView;
@property (weak, nonatomic) IBOutlet UIButton *buildingWiresButton;
@property (weak, nonatomic) IBOutlet UIImageView *instrumentationCablesView;
@property (weak, nonatomic) IBOutlet UIButton *instrumentationCablesButton;
@property (weak, nonatomic) IBOutlet UIImageView *fRLSWiresView;
@property (weak, nonatomic) IBOutlet UIButton *fRLSWiresButton;
@property (weak, nonatomic) IBOutlet UIImageView *lANCablesView;
@property (weak, nonatomic) IBOutlet UIButton *lANCablesButton;
@property (weak, nonatomic) IBOutlet UIImageView *powerCablesView;
@property (weak, nonatomic) IBOutlet UIButton *powerCablesButton;
@property (weak, nonatomic) IBOutlet UIImageView *submersibleCablesView;
@property (weak, nonatomic) IBOutlet UIButton *submersibleCablesButton;

@property (weak,nonatomic) id<DoneDelegate>delegate;


@property (weak, nonatomic) IBOutlet UILabel *constantView1;
@property (weak, nonatomic) IBOutlet UIImageView *constantView2;
@property (weak, nonatomic) IBOutlet UIButton *constantView3;
@property (weak, nonatomic) IBOutlet UILabel *constantView4;
@property (weak, nonatomic) IBOutlet UIImageView *constantView5;
@property (weak, nonatomic) IBOutlet UIButton *constantView6;
@property (weak, nonatomic) IBOutlet UILabel *constantView7;
@property (weak, nonatomic) IBOutlet UIImageView *constantView8;
@property (weak, nonatomic) IBOutlet UIButton *constantView9;
@property (weak, nonatomic) IBOutlet UILabel *constantView10;
@property (weak, nonatomic) IBOutlet UIImageView *constantView11;
@property (weak, nonatomic) IBOutlet UIButton *constantView12;
@property (weak, nonatomic) IBOutlet UILabel *constantView13;
@property (weak, nonatomic) IBOutlet UIImageView *constantView14;
@property (weak, nonatomic) IBOutlet UIButton *constantView15;
@property (weak, nonatomic) IBOutlet UILabel *constantView16;
@property (weak, nonatomic) IBOutlet UIImageView *constantView17;
@property (weak, nonatomic) IBOutlet UIButton *constantView18;
@property (weak, nonatomic) IBOutlet UILabel *constantView19;
@property (weak, nonatomic) IBOutlet UIImageView *constantView20;
@property (weak, nonatomic) IBOutlet UIButton *constantView21;
@property (weak, nonatomic) IBOutlet UILabel *constantView22;
@property (weak, nonatomic) IBOutlet UIImageView *constantView23;
@property (weak, nonatomic) IBOutlet UIButton *constantView24;
@property (weak, nonatomic) IBOutlet UILabel *constantView25;
@property (weak, nonatomic) IBOutlet UIImageView *constantView26;
@property (weak, nonatomic) IBOutlet UIButton *constantView27;
@property (weak, nonatomic) IBOutlet UILabel *constantView28;
@property (weak, nonatomic) IBOutlet UIImageView *constantView29;
@property (weak, nonatomic) IBOutlet UIButton *constantView30;
@property (weak, nonatomic) IBOutlet UILabel *constantView31;
@property (weak, nonatomic) IBOutlet UIImageView *constantView32;
@property (weak, nonatomic) IBOutlet UIButton *constantView33;
@property (weak, nonatomic) IBOutlet UILabel *constantView34;
@property (weak, nonatomic) IBOutlet UIImageView *constantView35;
@property (weak, nonatomic) IBOutlet UIButton *constantView36;






@end
@protocol DoneDelegate<NSObject>
-(void)doneButton:(FeedbackDropDownVC *) array:(NSMutableArray *)selectedWireList;
@end
