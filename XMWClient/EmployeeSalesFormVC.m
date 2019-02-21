//
//  EmployeeSalesFormVC.m
//  XMWClient
//
//  Created by dotvikios on 21/02/19.
//  Copyright © 2019 dotvik. All rights reserved.
//

#import "EmployeeSalesFormVC.h"
#import "DotFormPostUtil.h"
#import "EmpolyeeSalesReportVC.h"
#import "DotFormPost.h"
@implementation EmployeeSalesFormVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(IBAction)submitPressed:(id)sender
{
    
    DotFormPostUtil *dotFormPostUtil = [[DotFormPostUtil alloc]init];
    MXButton* button = (MXButton*) sender;
    NSString* attachedData = (NSString*)button.attachedData;
    
    DotFormElement *dotFormElement = [self.dotForm.formElements objectForKey:button.elementId];
    
    
    DotFormPost* formPost = [dotFormPostUtil submitSimpleForm:self.dotForm :self : self.dotFormPost :self.forwardedDataDisplay :self.forwardedDataPost :YES :NO :dotFormElement];
    
    NSLog(@"formPost = %@", [formPost.postData description]);
    
    
    EmpolyeeSalesReportVC* customReport = [[EmpolyeeSalesReportVC alloc] initWithNibName:@"CustomCompareReportVC" bundle:nil];
    
    customReport.dotForm = self.dotForm;
    customReport.firstFormPost = [self defaultColumnFirst:formPost];
    customReport.secondFormPost = [self defaultColumnSecond:formPost];
    customReport.thirdFormPost = [self defaultColumnThird:formPost];
    customReport.forwardedDataDisplay = self.forwardedDataDisplay;
    customReport.forwardedDataPost = self.forwardedDataPost;
    
    
    [self.navigationController pushViewController:customReport animated:YES];
    
}



@end
