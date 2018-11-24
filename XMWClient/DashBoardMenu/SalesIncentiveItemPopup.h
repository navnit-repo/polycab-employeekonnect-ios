//
//  SalesIncentiveItemPopup.h
//  QCMSProject
//
//  Created by Pradeep Singh on 2/11/15.
//  Copyright (c) 2015 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SalesIncentiveItemPopup : UIView <UITableViewDataSource, UITableViewDelegate>


@property(strong, nonatomic) NSArray* lineItemData;
@property(strong, nonatomic) IBOutlet UIView* popupHolderView;
@property(weak, nonatomic) IBOutlet UITableView* tableView;
@property(weak, nonatomic) IBOutlet UIButton* cancelButton;


+(SalesIncentiveItemPopup*) createInstance;

+(SalesIncentiveItemPopup*) createInstanceWithData:(NSArray*) lineData;


@end
