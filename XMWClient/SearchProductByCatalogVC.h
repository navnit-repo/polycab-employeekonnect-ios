//
//  SearchProductByCatalogVC.h
//  XMWClient
//
//  Created by dotvikios on 17/08/18.
//  Copyright © 2018 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductSearchVC.h"
@interface SearchProductByCatalogVC : ProductSearchVC<UITableViewDataSource, UITableViewDelegate,  UITextFieldDelegate>
{
    NSString *itmeName;
    NSString *itemNameString;
}
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property NSString *itmeName;
@property NSString *itemNameString;
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parentForm:(FormVC*) parent formElement:(NSString *) formElementId elementData:(NSString *)masterValueMapping radioGroupData:(NSMutableArray *) keyValueDoubleArray :(NSString*)buttonSender :(NSString*)itemName :(NSString*)bill_To :(NSString *)ship_To;
@end
