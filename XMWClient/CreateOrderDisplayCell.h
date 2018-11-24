//
//  CreateOrderDisplayCell.h
//  XMWClient
//
//  Created by dotvikios on 21/08/18.
//  Copyright © 2018 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DisplayCellButtonDelegate;
@interface CreateOrderDisplayCell : UIView<UITextFieldDelegate>
+(CreateOrderDisplayCell *) CreateInstance;
-(void)configure:(NSArray *)array :(long int)buttonTag;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLbl;
@property (weak, nonatomic) IBOutlet UITextField *valueTxtFld;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *measurementLbl;


@property(weak,nonatomic) id<DisplayCellButtonDelegate>delegate;
@end

@protocol DisplayCellButtonDelegate <NSObject>
-(void)buttonDelegate:(long int)tag;
@end
