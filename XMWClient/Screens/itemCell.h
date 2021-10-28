//
//  itemCell.h
//  polycab
//
//  Created by Shivangi on 27/10/21.
//

#import <UIKit/UIKit.h>
 
@interface itemCell : UITableViewCell
 
@property (weak, nonatomic) IBOutlet UILabel *descriptionLbl;
@property (weak, nonatomic) IBOutlet UILabel *subcategoryLbl;
@property (weak, nonatomic) IBOutlet UILabel *sizeLbl;
@property (weak, nonatomic) IBOutlet UILabel *coreLbl;
@property (weak, nonatomic) IBOutlet UILabel *unitLbl;
@property (weak, nonatomic) IBOutlet UILabel *lpLbl;
@property (weak, nonatomic) IBOutlet UILabel *MtrLbl;
@property (weak, nonatomic) IBOutlet UILabel *quantityLbl;
@property (weak, nonatomic) IBOutlet UILabel *rqRateLbl;
@property (weak, nonatomic) IBOutlet UILabel *rqDiscLbl;
@property (weak, nonatomic) IBOutlet UITextField *rateTxt;
@property (weak, nonatomic) IBOutlet UITextField *discountTxt;

 
@end
