//
//  CreateOrderStatusVC.h
//  XMWClient
//
//  Created by dotvikios on 25/01/19.
//  Copyright © 2019 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface CreateOrderStatusVC : UIViewController
{
    id jsonResponse;
    NSString *businessVerticalName;
}
@property (weak, nonatomic) IBOutlet UILabel *headerNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *trackerIdLbl;
@property (weak, nonatomic) IBOutlet UILabel *trackerIdValueLbl;
@property (weak, nonatomic) IBOutlet UILabel *orderNumLbl;
@property (weak, nonatomic) IBOutlet UILabel *orderNumValueLbl;
@property (weak, nonatomic) IBOutlet UILabel *customerPoLbl;
@property (weak, nonatomic) IBOutlet UILabel *customerPoValueLbl;
@property (weak, nonatomic) IBOutlet UILabel *poDateLbl;
@property (weak, nonatomic) IBOutlet UILabel *poDateValueLbl;
@property (weak, nonatomic) IBOutlet UILabel *orderStatusLbl;
@property (weak, nonatomic) IBOutlet UILabel *orderStatusValueLbl;
@property (weak, nonatomic) IBOutlet UILabel *statusMsgLbl;
@property (weak, nonatomic) IBOutlet UILabel *statusMsgValueLbl;
@property (weak, nonatomic) IBOutlet UILabel *billToLbl;
@property (weak, nonatomic) IBOutlet UILabel *billToValueLbl;
@property (weak, nonatomic) IBOutlet UILabel *shipToLbl;
@property (weak, nonatomic) IBOutlet UILabel *shipToValueLbl;
@property (weak, nonatomic) IBOutlet UILabel *lineAmountLbl;
@property (weak, nonatomic) IBOutlet UILabel *lineAmountValueLbl;
@property (weak, nonatomic) IBOutlet UILabel *lineTaxAmountLbl;
@property (weak, nonatomic) IBOutlet UILabel *lineTaxAmountValueLbl;
@property (weak, nonatomic) IBOutlet UILabel *totalLineAmountLbl;
@property (weak, nonatomic) IBOutlet UILabel *totalLineAmountValueLbl;

@property (weak, nonatomic) IBOutlet UILabel *totalLbl;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UIView *totalView;
@property NSString *businessVerticalName;
@property id jsonResponse;

@end


