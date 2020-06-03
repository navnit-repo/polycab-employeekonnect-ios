//
//  CreateOrderVC2.h
//  XMWClient
//
//  Created by dotvikios on 10/08/18.
//  Copyright © 2018 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FormVC.h"
#import "CreateOrderDisplayCell.h"

@protocol PolyCabCreateOrderMultiSelectDelegate;

@interface CreateOrderVC2 : FormVC<UITableViewDelegate,UITableViewDataSource,DisplayCellButtonDelegate,UIAlertViewDelegate,UITextFieldDelegate>
{
    id<PolyCabCreateOrderMultiSelectDelegate> PolyCabCreateOrderMultiSelectDelegate;
    float createOrderDynamicCellHeight;
    
}
@property float createOrderDynamicCellHeight;
@property (weak, nonatomic) IBOutlet UILabel *constant5;
@property (weak, nonatomic) IBOutlet UIButton *constant4;
@property (weak, nonatomic) IBOutlet UIButton *constant3;
@property (weak, nonatomic) IBOutlet UILabel *constant2;
@property (weak, nonatomic) IBOutlet UILabel *constant1;
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UILabel *itemName;
@property (weak, nonatomic) IBOutlet UILabel *orderRefNo;
@property (weak, nonatomic) IBOutlet UILabel *dateofDelivery;
@property id<PolyCabCreateOrderMultiSelectDelegate> PolyCabCreateOrderMultiSelectDelegate;
@end


