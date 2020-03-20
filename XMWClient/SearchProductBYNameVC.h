//
//  SearchProductBYNameVC.h
//  XMWClient
//
//  Created by dotvikios on 17/08/18.
//  Copyright © 2018 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductSearchVC.h"
#import "MXTextField.h"
#import "MXButton.h"

@interface SearchProductBYNameVC : ProductSearchVC<UITableViewDataSource, UITableViewDelegate,  UITextFieldDelegate>
{
    MXTextField *coreTextField;
    MXTextField *colorTextField;
    MXTextField *squareTextField;
    MXTextField *uomDescriptionTextField;
    
    MXButton *coreButton;
    MXButton *colorButton;
    MXButton *squareButton;
    MXButton *uomDescriptionButton;
    MXButton *mxButton;
    NSString *itemNameString;
}
@property NSString *itemNameString;
@property MXTextField *coreTextField;
@property MXTextField *colorTextField;
@property MXTextField *squareTextField;
@property MXTextField *uomDescriptionTextField;

@property MXButton *coreButton;
@property MXButton *colorButton;
@property MXButton *squareButton;
@property MXButton *uomDescriptionButton;

@property  MXButton *mxButton;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parentForm:(FormVC*) parent formElement:(NSString *) formElementId elementData:(NSString *)masterValueMapping radioGroupData:(NSMutableArray *) keyValueDoubleArray :(NSString*)buttonSender :(NSString*)itemName :(NSString*)bill_To :(NSString*)ship_To;
@end
