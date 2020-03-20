//
//  SimpleEditForm.h
//  QCMSProject
//
//  Created by Pradeep Singh on 11/2/16.
//  Copyright © 2016 dotvik. All rights reserved.
//

#import "FormVC.h"

@class ReportPostResponse;
@class DotReport;


@interface SimpleEditForm : FormVC

@property (strong, nonatomic) ReportPostResponse *reportFormResponse;
@property (weak, nonatomic) DotReport *dotReport;
@property (strong, nonatomic) DotFormPost* requestFormPost;

@end
