//
//  SelectedListVC.h
//  XMWClient
//
//  Created by dotvikios on 27/12/17.
//  Copyright © 2017 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXButton.h"

@class SelectedListVC;


@protocol SelectedPopUpdelegate
-(void) cancel:(SelectedListVC*) selectedListVC context:(NSString*) context;
-(void) done:(SelectedListVC*) selectedListVC context:(NSString*) context code:(NSString*) code display:(NSString*) display;
@end


@interface SelectedListVC : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
{

    id attachedData ;
    NSString* elementId;
    NSMutableArray *dropDownList;
    NSMutableArray *dropDownListKey;
    NSString *selectedPickerValue;
    NSString *selectedPickerKey;
    MXButton* mxButton;
    NSString* dropDownName;
    UISearchBar *searchBar;
    NSMutableArray *orignalDataArray;
    NSMutableArray *orignalDataKeyArray;
    NSMutableArray *searchTextArray;
    NSMutableArray *searchTextKeyArray;
    
}
@property NSMutableArray *searchTextKeyArray;
@property NSMutableArray *orignalDataKeyArray;
@property NSMutableArray *orignalDataArray;
@property NSMutableArray *searchTextArray;
@property UISearchBar *searchBar;
@property NSString* dropDownName;
@property MXButton* mxButton;
@property (strong, nonatomic) IBOutlet UITableView *tableSelected;
@property id attachedData;
@property NSString* elementId;
@property NSMutableArray *dropDownList;
@property NSMutableArray *dropDownListKey;
@property NSString *selectedPickerValue;
@property NSString *selectedPickerKey;
@property (nonatomic, retain) NSIndexPath* checkedIndexPath;
- (IBAction)btnDoneState:(id)sender;
@property id<SelectedPopUpdelegate> delegate;
@end
