//
//  GrowthIndicatorFormVC.m
//  XMWClient
//
//  Created by Pradeep Singh on 21/09/18.
//  Copyright © 2018 dotvik. All rights reserved.
//

#import "GrowthIndicatorFormVC.h"
#import "DotFormPost.h"
#import "DotFormPostUtil.h"
#import "Styles.h"
#import "GrowthIndicatorReportVC.h"


@interface GrowthIndicatorFormVC ()
{
    MXButton* submitButton;
    NSDateFormatter* dateFormatter;
}
@end

@implementation GrowthIndicatorFormVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];

    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


-(IBAction)submitPressed:(id)sender
{
    
    DotFormPostUtil *dotFormPostUtil = [[DotFormPostUtil alloc]init];
    MXButton* button = (MXButton*) sender;
    NSString* attachedData = (NSString*)button.attachedData;
    
    DotFormElement *dotFormElement = [self.dotForm.formElements objectForKey:button.elementId];
    
    
    DotFormPost* formPost = [dotFormPostUtil submitSimpleForm:self.dotForm :self : self.dotFormPost :self.forwardedDataDisplay :self.forwardedDataPost :YES :NO :dotFormElement];
    
    NSLog(@"formPost = %@", [formPost.postData description]);
    
    // [self saveBookmarkForm:self :formPost];
    
    GrowthIndicatorReportVC* customReport = [[GrowthIndicatorReportVC alloc] initWithNibName:@"GrowthIndicatorReportVC" bundle:nil];
    
    customReport.dotForm = self.dotForm;
    customReport.firstFormPost = [self defaultColumnFirst:formPost];
    customReport.secondFormPost = [self defaultColumnSecond:formPost];
    customReport.thirdFormPost = [self defaultColumnThird:formPost];
    customReport.forwardedDataDisplay = self.forwardedDataDisplay;
    customReport.forwardedDataPost = self.forwardedDataPost;
    
    [self.navigationController pushViewController:customReport animated:YES];
    
}

@end
