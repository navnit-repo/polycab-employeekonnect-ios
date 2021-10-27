//
//  SpaApprovalLineCell.h
//  QCMSProject
//
//  Created by Nit Navodit on 22/10/21.
//  Copyright © 2021 dotvik. All rights reserved.
//

#ifndef SpaApprovalLineCell_h
#define SpaApprovalLineCell_h


#endif /* SpaApprovalLineCell_h */
#import "MXTextField.h"

@interface SpaApprovalLineCell : UIView

@property (weak, nonatomic) IBOutlet UILabel *descriptionLbl;
@property (weak, nonatomic) IBOutlet UILabel *subcategoryLbl;
@property (weak, nonatomic) IBOutlet UILabel *lpmtrLbl;
@property (weak, nonatomic) IBOutlet UILabel *sizeLbl;
@property (weak, nonatomic) IBOutlet UILabel *coreLbl;
@property (weak, nonatomic) IBOutlet UILabel *unitLbl;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;
@property (weak, nonatomic) IBOutlet UILabel *totalValueLbl;
@property (weak, nonatomic) IBOutlet MXTextField *qtyTextField;
@property (weak, nonatomic) IBOutlet MXTextField *rateTextField;
@property (weak, nonatomic) IBOutlet MXTextField *discountTextField;


@end
