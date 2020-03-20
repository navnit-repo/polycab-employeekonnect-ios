//
//  RMACardCell.h
//  XMWClient
//
//  Created by dotvikios on 24/09/18.
//  Copyright © 2018 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXButton.h"
#import "SelectedListVC.h"
#import "MXTextField.h"
@protocol RMACardButtonDelegate;

@interface RMACardCell : UIView<UITextFieldDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *constantView1;
@property (weak, nonatomic) IBOutlet UIImageView *constantView2;
@property (weak, nonatomic) IBOutlet UILabel *constantView3;
@property (weak, nonatomic) IBOutlet UITextField *constantView4;
@property (weak, nonatomic) IBOutlet UILabel *constantView5;
@property (weak, nonatomic) IBOutlet UITextField *constantView6;
@property (weak, nonatomic) IBOutlet UILabel *constantView7;
@property (weak, nonatomic) IBOutlet UITextField *constantView8;
@property (weak, nonatomic) IBOutlet UILabel *constantView9;
@property (weak, nonatomic) IBOutlet UITextField *constantView10;
@property (weak, nonatomic) IBOutlet UILabel *constantView11;
@property (weak, nonatomic) IBOutlet MXTextField *costantView12;
@property (weak, nonatomic) IBOutlet MXButton *costantView13;



@property (weak, nonatomic) IBOutlet UITextField *productCategoryTextField;
@property (weak, nonatomic) IBOutlet UITextField *skuCodeTextField;

@property (weak, nonatomic) IBOutlet UITextField *quantityTextField;
@property (weak, nonatomic) IBOutlet UITextField *polycabInvoiceTextField;
@property (weak, nonatomic) IBOutlet MXTextField *reasonForReturnTextField;

@property (weak, nonatomic) IBOutlet UIButton *crossButton;
@property (weak, nonatomic) IBOutlet MXButton *mxButton;

@property (weak,nonatomic) id<RMACardButtonDelegate>delegate;

+(RMACardCell*)createInstance;
-(void)configCell:(NSDictionary*)data :(NSString*)invoiceNO :(int)tags;
-(void)configCellBlankCard:(int)tag;
@end

@protocol RMACardButtonDelegate<NSObject>
-(void)crossButtonHandler:(RMACardCell *)buttonTag :(long int )tag;
-(void)cellTag:(RMACardCell*)viewTag :(long int)tag;
@end
