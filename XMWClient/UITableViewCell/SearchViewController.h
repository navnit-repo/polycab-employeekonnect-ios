//
//  SearchViewController.h
//  QCMSProject
//
//  Created by Ashish Tiwari on 04/09/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DotReportDraw.h"
#import "SearchResponse.h"
#import "FormVC.h"
#import "DVCheckbox.h"

@class FormVC;


@protocol SearchViewMultiSelectDelegate <NSObject>
-(void) multipleItemsSelected:(NSArray*) headerData   :(NSArray*) selectedRows;
-(void) selectionCancelled;
@end


@interface SearchViewController : UIViewController<UITableViewDelegate,UITableViewDataSource, DVCheckboxDelegate,UISearchBarDelegate>
{
    
    UITableView *searchList;
    int screenId;
    SearchResponse *searchResponse;
    NSMutableArray *searchData;
    NSString *elementId;
    NSMutableArray *selectedRowElement;
    FormVC *parentController;
    NSString* masterValueMapping;
    NSString* headerTitle;
    
    BOOL multiSelect;
    id<SearchViewMultiSelectDelegate> multiSelectDelegate;
    NSString *primaryCat;
    NSString *subCat;
    NSMutableDictionary* selectedRows;
    float cellHeight;
    
}
@property NSMutableDictionary* selectedRows;
@property NSString *primaryCat;
@property NSString *subCat;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property float cellHeight;

@property  FormVC *parentController;
@property NSMutableArray *selectedRowElement;
@property NSString *elementId;
@property UITableView *searchList;
@property NSMutableArray *searchData;
@property NSString* masterValueMapping;

@property SearchResponse *searchResponse;
@property int screenId;
@property NSString* headerTitle;
@property BOOL multiSelect;
@property id<SearchViewMultiSelectDelegate> multiSelectDelegate;

-(void)showSearchData;
-(void)drawSearchTable :(NSMutableArray *)data;


@end
