//
//  SearchProductByCatalogNextViewVC.h
//  XMWClient
//
//  Created by dotvikios on 21/01/19.
//  Copyright © 2019 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchProductByCatalogVC.h"
#import "MXButton.h"
#import "MXTextField.h"
#import "ProductSearchVC.h"
@interface SearchProductByCatalogNextViewVC : ProductSearchVC<UITableViewDataSource, UITableViewDelegate,  UITextFieldDelegate>
{
    NSMutableDictionary *catalogReqstData;
    MXButton *mxButton;
    MXTextField *coreTextField;
    MXTextField *colorTextField;
    MXTextField *squareTextField;
    MXTextField *uomDescriptionTextField;
    
    MXButton *coreButton;
    MXButton *colorButton;
    MXButton *squareButton;
    MXButton *uomDescriptionButton;
    NSString *itemNameString;
    NSString *billTo;
    NSString *shipTo;
}
@property NSString *shipTo;
@property NSMutableDictionary *catalogReqstData;
@property MXButton *mxButton;
@property MXTextField *coreTextField;
@property MXTextField *colorTextField;
@property MXTextField *squareTextField;
@property MXTextField *uomDescriptionTextField;
@property NSString *billTo;
@property MXButton *coreButton;
@property MXButton *colorButton;
@property MXButton *squareButton;
@property MXButton *uomDescriptionButton;
@property NSString *itemNameString;

@end


