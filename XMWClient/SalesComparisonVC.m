//
//  SalesComparisonVC.m
//  XMWClient
//
//  Created by dotvikios on 19/09/18.
//  Copyright © 2018 dotvik. All rights reserved.
//

#import "SalesComparisonVC.h"
#import "DotFormPostUtil.h"
#import "SalesComparisonReport.h"
#import "DotFormPost.h"

@interface SalesComparisonVC ()

@end

@implementation SalesComparisonVC


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
    
    
    SalesComparisonReport* customReport = [[SalesComparisonReport alloc] initWithNibName:@"CustomCompareReportVC" bundle:nil];
    
    customReport.dotForm = self.dotForm;
    customReport.firstFormPost = [self defaultColumnFirst:formPost];
    customReport.secondFormPost = [self defaultColumnSecond:formPost];
    customReport.thirdFormPost = [self defaultColumnThird:formPost];
    customReport.forwardedDataDisplay = self.forwardedDataDisplay;
    customReport.forwardedDataPost = self.forwardedDataPost;
    
    
    [self.navigationController pushViewController:customReport animated:YES];
    
}


@end
