//
//  SPALinesFormVC.h
//  QCMSProject
//
//  Created by Nit Navodit on 23/10/21.
//  Copyright © 2021 dotvik. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "FormVC.h"


@interface SPALinesFormVC : FormVC <UITableViewDataSource, UITableViewDelegate>
    @property (strong, nonatomic) UITableView *tableView;    
    @property NSString *spa_payment_terms;
    @property NSString *spahrefid;
    @property NSMutableDictionary *spaRequestObject;
    
@end
