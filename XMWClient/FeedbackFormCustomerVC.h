//
//  FeedbackFormCustomerVC.h
//  XMWClient
//
//  Created by dotvikios on 31/07/18.
//  Copyright © 2018 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FormVC.h"
#import "FeedbackDropDownVC.h"
@interface FeedbackFormCustomerVC : FormVC<UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate,DoneDelegate,UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *selEnqFld;
@property (weak, nonatomic) IBOutlet UITextField *selComFld;
@property (weak, nonatomic) IBOutlet UITextField *selTechFld;
@property (weak, nonatomic) IBOutlet UITextField *selCAFld;
@property (weak, nonatomic) IBOutlet UITextField *selAnyOthrFld;
@property (weak, nonatomic) IBOutlet UITextField *selPrdFld;
@property (weak, nonatomic) IBOutlet UITextField *selPackFld;
@property (weak, nonatomic) IBOutlet UITextField *selDelFld;
@property (weak, nonatomic) IBOutlet UIView *pickerViewMain;
//@property (weak, nonatomic) IBOutlet UIPickerView *picker;




@property (weak, nonatomic) IBOutlet UITextField *customeName;
@property (weak, nonatomic) IBOutlet UITextField *locationField;
@property (weak, nonatomic) IBOutlet UITextField *selectWireField;

@property (weak, nonatomic) IBOutlet UIButton *submitButton;


@property (weak, nonatomic) IBOutlet UILabel *constantView1;
@property (weak, nonatomic) IBOutlet UILabel *constantView2;
@property (weak, nonatomic) IBOutlet UILabel *constantView3;
@property (weak, nonatomic) IBOutlet UILabel *constantView4;
@property (weak, nonatomic) IBOutlet UILabel *constantView5;
@property (weak, nonatomic) IBOutlet UILabel *constantView6;


@property (weak, nonatomic) IBOutlet UILabel *constantView7;
@property (weak, nonatomic) IBOutlet UITextField *constantView8;
@property (weak, nonatomic) IBOutlet UILabel *constantView9;
@property (weak, nonatomic) IBOutlet UITextField *constantView10;
@property (weak, nonatomic) IBOutlet UILabel *constantView11;
@property (weak, nonatomic) IBOutlet UITextField *constantView12;
@property (weak, nonatomic) IBOutlet UIButton *constantView13;

@property (weak, nonatomic) IBOutlet UIView *view4;
@property (weak, nonatomic) IBOutlet UIView *view5;
@property (weak, nonatomic) IBOutlet UIView *view6;

@property (weak, nonatomic) IBOutlet UILabel *constantView14;
@property (weak, nonatomic) IBOutlet UITextField *constantView15;
@property (weak, nonatomic) IBOutlet UIButton *constantView16;
@property (weak, nonatomic) IBOutlet UILabel *constantView17;
@property (weak, nonatomic) IBOutlet UITextField *constantView18;
@property (weak, nonatomic) IBOutlet UIButton *constantView19;
@property (weak, nonatomic) IBOutlet UILabel *constantView20;
@property (weak, nonatomic) IBOutlet UITextField *constantView21;
@property (weak, nonatomic) IBOutlet UIButton *constantView22;
@property (weak, nonatomic) IBOutlet UILabel *constantView23;
@property (weak, nonatomic) IBOutlet UITextField *constantView24;
@property (weak, nonatomic) IBOutlet UIButton *constantView25;
@property (weak, nonatomic) IBOutlet UILabel *constantView26;
@property (weak, nonatomic) IBOutlet UITextField *constantView27;
@property (weak, nonatomic) IBOutlet UIButton *constantView28;
@property (weak, nonatomic) IBOutlet UILabel *constantView29;
@property (weak, nonatomic) IBOutlet UITextField *constantView30;
@property (weak, nonatomic) IBOutlet UIButton *constantView31;
@property (weak, nonatomic) IBOutlet UILabel *constantView32;
@property (weak, nonatomic) IBOutlet UITextField *constantView33;
@property (weak, nonatomic) IBOutlet UIButton *constantView34;
@property (weak, nonatomic) IBOutlet UILabel *constantView35;
@property (weak, nonatomic) IBOutlet UITextField *constantView36;
@property (weak, nonatomic) IBOutlet UIButton *constantView37;
@property (weak, nonatomic) IBOutlet UILabel *constantView38;
@property (weak, nonatomic) IBOutlet UIButton *constantView39;

@property (weak, nonatomic) IBOutlet UIScrollView *finalScrollView;






@end
