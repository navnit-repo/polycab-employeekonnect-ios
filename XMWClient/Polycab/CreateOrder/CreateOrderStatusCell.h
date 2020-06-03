//
//  CreateOrderStatusCell.h
//  XMWClient
//
//  Created by dotvikios on 25/01/19.
//  Copyright © 2019 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CreateOrderStatusCell : UIView
+(CreateOrderStatusCell *) CreateInstance :(BOOL) spaFlag;
-(void)configure:(NSArray *)array :(NSString*)verticalName;
@property (weak, nonatomic) IBOutlet UILabel *orderedItemLbl;
@property (weak, nonatomic) IBOutlet UILabel *orderedItemValueLbl;
@property (weak, nonatomic) IBOutlet UILabel *descLbl;
@property (weak, nonatomic) IBOutlet UILabel *descValueLbl;
@property (weak, nonatomic) IBOutlet UILabel *qntyLbl;
@property (weak, nonatomic) IBOutlet UILabel *qntyValueLbl;
@property (weak, nonatomic) IBOutlet UILabel *statusFlgLbl;
@property (weak, nonatomic) IBOutlet UILabel *statusFlgValueLbl;
@property (weak, nonatomic) IBOutlet UILabel *listPriceLbl;
@property (weak, nonatomic) IBOutlet UILabel *listPriceValueLbl;
@property (weak, nonatomic) IBOutlet UILabel *unitSellPriceLbl;
@property (weak, nonatomic) IBOutlet UILabel *unitSellPriceValueLbl;
@property (weak, nonatomic) IBOutlet UILabel *lineAmntLbl;
@property (weak, nonatomic) IBOutlet UILabel *lineAmntValueLbl;
@property (weak, nonatomic) IBOutlet UILabel *linTaxAmntLbl;
@property (weak, nonatomic) IBOutlet UILabel *linTaxAmntValueLbl;
@property (weak, nonatomic) IBOutlet UILabel *totlLineAmntLbl;
@property (weak, nonatomic) IBOutlet UILabel *totlLineAmntValueLbl;
@property (weak, nonatomic) IBOutlet UILabel *prcntDiscntLbl;
@property (weak, nonatomic) IBOutlet UILabel *prcntDiscntValueLbl;
@property (weak, nonatomic) IBOutlet UILabel *isCodeLbl;
@property (weak, nonatomic) IBOutlet UILabel *isCodeValueLbl;

@property (weak, nonatomic) IBOutlet UILabel *spaPriceTextLbl;
@property (weak, nonatomic) IBOutlet UILabel *spaPriceValueLbl;

@end


