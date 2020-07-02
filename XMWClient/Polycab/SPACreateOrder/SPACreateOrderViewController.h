//
//  SPACreateOrderViewController.h
//  XMWClient
//
//  Created by Tushar on 20/02/20.
//  Copyright © 2020 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FormVC.h"
#import "SPACreateOrderCell.h"
#import "SearchViewController.h"

@protocol PolyCabCreateOrderMultiSelectDelegate;
@protocol SearchViewMultiSelectDelegate;
NS_ASSUME_NONNULL_BEGIN

@interface SPACreateOrderViewController :FormVC<UITableViewDelegate,UITableViewDataSource,DisplayCellButtonDelegate,UIAlertViewDelegate,UITextFieldDelegate>
{
    id<PolyCabCreateOrderMultiSelectDelegate> PolyCabCreateOrderMultiSelectDelegate;
     float createOrderDynamicCellHeight;
    
    FormVC* parentController;
    NSString *elementId;
    NSString *inMasterValueMapping;
    NSString* searchTitleDisplayText;
    BOOL multiSelect;
    id<SearchViewMultiSelectDelegate> multiSelectDelegate;
    NSMutableDictionary* dependentValueMap;
    NSInteger defaultSelectionRadio;
    NSMutableArray *myCatTableDataArray;
    NSString *primarayCat;
    NSString *subCat;
 
}
@property float createOrderDynamicCellHeight;
@property NSString *primarayCat;
@property NSString *subCat;
@property FormVC* parentController;
@property NSString *elementId;
@property NSString *inMasterValueMapping;
@property NSString* searchTitleDisplayText;
@property BOOL multiSelect;
@property id<SearchViewMultiSelectDelegate> multiSelectDelegate;
@property NSMutableDictionary* dependentValueMap;
@property NSInteger defaultSelectionRadio;







@property (weak, nonatomic) IBOutlet UILabel *constant5;
@property (weak, nonatomic) IBOutlet UIButton *constant4;
@property (weak, nonatomic) IBOutlet UIButton *constant3;
@property (weak, nonatomic) IBOutlet UILabel *constant2;
@property (weak, nonatomic) IBOutlet UILabel *constant1;
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UILabel *itemName;
@property (weak, nonatomic) IBOutlet UILabel *orderRefNo;
@property (weak, nonatomic) IBOutlet UILabel *dateofDelivery;
@property (weak, nonatomic) IBOutlet MXButton *addFavouriteButton;
@property id<PolyCabCreateOrderMultiSelectDelegate> PolyCabCreateOrderMultiSelectDelegate;
@end

NS_ASSUME_NONNULL_END
