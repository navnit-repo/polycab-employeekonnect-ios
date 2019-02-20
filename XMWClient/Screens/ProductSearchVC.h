//
//  ProductSearchVC.h
//  QCMSProject
//
// This class is special customization for Product search for havells create order product search,
// which supports search and catalog browsing.
// Suppose to be used in place of SearchFormControl.
//
//  Created by Pradeep Singh on 3/23/15.
//  Copyright (c) 2015 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DotFormPost.h"
#import "HttpEventListener.h"
#import "RadioGroup.h"
#import "SearchViewController.h"
#import "FormVC.h"
#import "LoadingView.h"
#import "NetworkHelper.h"
#import "PolycabProductCatObject.h"

@protocol SearchViewMultiSelectDelegate;


@interface ProductSearchVC : UIViewController <UITableViewDataSource, UITableViewDelegate, HttpEventListener, UITextFieldDelegate>
{
    
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


@property (weak, nonatomic) NSString* productDivision;

@property (weak, nonatomic)  IBOutlet UITableView* mainTableView;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parentForm:(FormVC*) parent formElement:(NSString *) formElementId elementData:(NSString *)masterValueMapping radioGroupData:(NSMutableArray *) keyValueDoubleArray;


//for global Declare
-(UITextField*) addSearchTextField;
-(RadioGroup*) addRadioGroup;
-(UIButton*) addSearchButton;
- (UITableViewCell *)catTreeTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
-(void) handleCatalogResults:(id) xmwResponse;
-(void) handleCategoryProducts:(id) xmwResponse;
-(void) handleSearchResult:(id) xmwResponse;
-(void) fetchProductsForCatalog:(PolycabProductCatObject *)category;
@property (nonatomic, strong) NSMutableArray *myCatTableDataArray;

@end
