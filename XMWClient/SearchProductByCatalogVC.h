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
}
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property NSString *itmeName;
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parentForm:(FormVC*) parent formElement:(NSString *) formElementId elementData:(NSString *)masterValueMapping radioGroupData:(NSMutableArray *) keyValueDoubleArray :(NSString*)buttonSender;
@end
