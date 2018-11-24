//
//  OrderPendencyCell.h
//  XMWClient
//
//  Created by dotvikios on 04/09/18.
//  Copyright © 2018 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderPendencyCell : UIView
+(OrderPendencyCell*) createInstance;
@property (weak, nonatomic) IBOutlet UIView *totalView;
@property (weak, nonatomic) IBOutlet UIView *activeView;
@property (weak, nonatomic) IBOutlet UIView *blockedView;
@property (weak, nonatomic) IBOutlet UILabel *displayName;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLbl;
@property (weak, nonatomic) IBOutlet UILabel *activePriceLbl;
@property (weak, nonatomic) IBOutlet UILabel *blockedPriceLbl;
@property (weak, nonatomic) IBOutlet UILabel *totalLblHide;
@property (weak, nonatomic) IBOutlet UILabel *activeLblHide;
@property (weak, nonatomic) IBOutlet UILabel *blockedLblHide;
@property (weak, nonatomic) IBOutlet UIView *chartView;
@property (weak, nonatomic) IBOutlet UILabel *totalLblDisplayTop;
@property (weak, nonatomic) IBOutlet UILabel *activeLblDisplayTop;
@property (weak, nonatomic) IBOutlet UILabel *blockedLblDisplayTop;
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UILabel *constantLbl1;
@property (weak, nonatomic) IBOutlet UILabel *constantLbl2;
@property (weak, nonatomic) IBOutlet UILabel *constantLbl3;
@property (weak, nonatomic) IBOutlet UILabel *constantLbl4;

-(void)config:(NSArray*)array;
@end
