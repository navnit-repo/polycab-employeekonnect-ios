//
//  CustomCompareReportVC.h
//  QCMSProject
//
//  Created by Pradeep Singh on 9/4/16.
//  Copyright © 2016 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DotForm.h"
#import "DotFormPost.h"
#import "DotFormElement.h"


@interface CustomCompareReportVC : UIViewController

@property (weak, nonatomic) DotForm* dotForm;

@property (strong, nonatomic) DotFormPost* firstFormPost;
@property (strong, nonatomic) DotFormPost* secondFormPost;
@property (strong, nonatomic) DotFormPost* thirdFormPost;

@property (nonatomic, retain) NSMutableDictionary* forwardedDataDisplay;
@property (nonatomic, retain) NSMutableDictionary* forwardedDataPost;


@property (weak, nonatomic) IBOutlet UITableView* mainTable;


@end
