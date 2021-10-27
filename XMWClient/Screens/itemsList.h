//
//  itemsList.h
//  polycab
//
//  Created by Shivangi on 26/10/21.
//

#import <UIKit/UIKit.h>
 
@interface itemsList : UITableViewCell
 

// identifier = itemsListId
@property (weak, nonatomic) IBOutlet UILabel *descriptionLbl;
@property (weak, nonatomic) IBOutlet UILabel *subcategoryLbl;
@property (weak, nonatomic) IBOutlet UILabel *MtrLbl;
@property (weak, nonatomic) IBOutlet UILabel *sizeLbl;
@property (weak, nonatomic) IBOutlet UILabel *unitLbl;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;
@property (weak, nonatomic) IBOutlet UILabel *totalValueLbl;
@property (weak, nonatomic) IBOutlet UILabel *coreLbl;
@property (weak, nonatomic) IBOutlet UITextField *rateTxt;
@property (weak, nonatomic) IBOutlet UITextField *discountTxt;
@property (weak, nonatomic) IBOutlet UITextField *quantityTxt;
 
@end
