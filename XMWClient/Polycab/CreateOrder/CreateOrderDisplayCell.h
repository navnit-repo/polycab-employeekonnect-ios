//
//  CreateOrderDisplayCell.h
//  XMWClient
//
//  Created by dotvikios on 21/08/18.
//  Copyright © 2018 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXTextField.h"
@protocol DisplayCellButtonDelegate;
@interface CreateOrderDisplayCell : UIView<UITextFieldDelegate>
+(CreateOrderDisplayCell *) CreateInstance;
-(void)configure:(NSArray *)array :(long int)buttonTag :(NSString*)verticalName;
-(void)configure:(NSArray *)array :(long int)buttonTag :(NSString*)verticalName :(NSString *)quntyValue;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLbl;

@property (strong, nonatomic) IBOutlet MXTextField *valueTxtFld;


@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *measurementLbl;
@property (weak, nonatomic) IBOutlet UILabel *mainDescLbl;

@property (weak, nonatomic) IBOutlet UIView *dividerLine;
@property (weak, nonatomic) IBOutlet UILabel *packSizeLabel;

@property(weak,nonatomic) id<DisplayCellButtonDelegate>delegate;

-(BOOL) isPackingSizeRoundingEnabled:(NSString*) businessVertical;

@end

@protocol DisplayCellButtonDelegate <NSObject>
-(void)buttonDelegate:(long int)tag;
-(void)textFieldDelegate:(UITextField *)textfield;
-(void)textFieldValue:(UITextField *)textfield :(long int)cellIndex;
-(void)returnPackSizeFlag :(BOOL) flag;
@end
