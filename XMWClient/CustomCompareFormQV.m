//
//  CustomCompareFormQV.m
//  QCMSProject
//
//  Created by Pradeep Singh on 9/4/16.
//  Copyright © 2016 dotvik. All rights reserved.
//

#import "FormVC.h"
#import "CustomCompareFormQV.h"
#import "DotFormPostUtil.h"
#import "Styles.h"

#import "CustomCompareFormQV.h"
#import "ReportQuantityValue.h"

@interface CustomCompareFormQV ()
{
    MXButton* submitButton;
    NSDateFormatter* dateFormatter;
}
@end

@implementation CustomCompareFormQV 

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    
    // Do any additional setup after loading the view.
    
   // self.view.backgroundColor = [Styles formBackgroundColor];
   // self.scrollFormView.backgroundColor = [Styles formBackgroundColor];
    
    
    DotFormElement* dotFormElement = [self.dotForm.formElements objectForKey:@"SUBMIT"];
    if( [dotFormElement.componentType isEqualToString:XmwcsConst_DE_COMPONENT_BUTTON]) {
        submitButton = [self getDataFromId:dotFormElement.elementId];
        submitButton.enabled = NO;
        
        // remove previous target if already configure
        [submitButton removeTarget:self action:@selector(submitPressed:)  forControlEvents:UIControlEventTouchUpInside];
        // add customer submit handler so that we can override the behaviour
        [submitButton addTarget:self action:@selector(submitPressed:) forControlEvents:UIControlEventTouchUpInside];
        
    }
     
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
    
    
    ReportQuantityValue* customReport = [[ReportQuantityValue alloc] initWithNibName:@"ReportQuantityValue" bundle:nil];
    
    customReport.dotForm = self.dotForm;
    customReport.firstFormPost = [self defaultColumnFirst:formPost];
    customReport.secondFormPost = [self defaultColumnSecond:formPost];
    customReport.thirdFormPost = [self defaultColumnThird:formPost];
    customReport.forwardedDataDisplay = self.forwardedDataDisplay;
    customReport.forwardedDataPost = self.forwardedDataPost;
    
    [self.navigationController pushViewController:customReport animated:YES];
    
}


-(DotFormPost*) defaultColumnFirst:(DotFormPost*) formPost
{
    DotFormPost* newFormPost = [formPost cloneObject];
    
    // user selected date from previous screen inputs
    NSString* fromStr = [formPost.postData objectForKey:@"FROM_DATE"];
    NSString* toStr = [formPost.postData objectForKey:@"TO_DATE"];
    
    [newFormPost.postData setObject:fromStr forKey:@"FROM_DATE"];
    [newFormPost.postData setObject:toStr forKey:@"TO_DATE"];
    
    [newFormPost.displayData setObject:fromStr forKey:@"FROM_DATE"];
    [newFormPost.displayData setObject:toStr forKey:@"TO_DATE"];
    
    return  newFormPost;
}

-(DotFormPost*) defaultColumnSecond:(DotFormPost*) formPost
{
    DotFormPost* newFormPost = [formPost cloneObject];
    
    // user selected date (minus one month) from previous screen inputs
    
    // user selected date from previous screen inputs
    NSString* fromStr = [formPost.postData objectForKey:@"FROM_DATE"];
    NSString* toStr = [formPost.postData objectForKey:@"TO_DATE"];
    
    NSDate* fromDate = [dateFormatter dateFromString:fromStr];
    NSDate* toDate = [dateFormatter dateFromString:toStr];
    
    
    
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *weekdayComponents =[gregorian components:(NSDayCalendarUnit | NSWeekdayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:fromDate];
    
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setMonth:-1]; // note that I'm setting it to -1
    
    NSDate* lastMonthFromDate = [gregorian dateByAddingComponents:offsetComponents toDate:fromDate options:0];
    
    NSDate* lastMonthToDate = [gregorian dateByAddingComponents:offsetComponents toDate:toDate options:0];
    
    NSString* lastMonthFromStr = [dateFormatter stringFromDate:lastMonthFromDate];
    NSString* lastMonthToStr = [dateFormatter stringFromDate:lastMonthToDate];
    
    [newFormPost.postData setObject:lastMonthFromStr forKey:@"FROM_DATE"];
    [newFormPost.postData setObject:lastMonthToStr forKey:@"TO_DATE"];
    
    [newFormPost.displayData setObject:lastMonthFromStr forKey:@"FROM_DATE"];
    [newFormPost.displayData setObject:lastMonthToStr forKey:@"TO_DATE"];
    
    return newFormPost;
}

-(DotFormPost*) defaultColumnThird:(DotFormPost*) formPost
{
    
     DotFormPost* newFormPost = [formPost cloneObject];
    // user selected date (minus one year) from previous screen inputs
    
    // user selected date from previous screen inputs
    NSString* fromStr = [formPost.postData objectForKey:@"FROM_DATE"];
    NSString* toStr = [formPost.postData objectForKey:@"TO_DATE"];
    
    NSDate* fromDate = [dateFormatter dateFromString:fromStr];
    NSDate* toDate = [dateFormatter dateFromString:toStr];
    
    
    
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *weekdayComponents =[gregorian components:(NSDayCalendarUnit | NSWeekdayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:fromDate];
    
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setYear:-1]; // note that I'm setting it to -1
    
    NSDate* lastYearFromDate = [gregorian dateByAddingComponents:offsetComponents toDate:fromDate options:0];
    
    NSDate* lastYearToDate = [gregorian dateByAddingComponents:offsetComponents toDate:toDate options:0];
    
    NSString* lastYearFromStr = [dateFormatter stringFromDate:lastYearFromDate];
    NSString* lastYearToStr = [dateFormatter stringFromDate:lastYearToDate];
    
    [newFormPost.postData setObject:lastYearFromStr forKey:@"FROM_DATE"];
    [newFormPost.postData setObject:lastYearToStr forKey:@"TO_DATE"];
    
    [newFormPost.displayData setObject:lastYearFromStr forKey:@"FROM_DATE"];
    [newFormPost.displayData setObject:lastYearToStr forKey:@"TO_DATE"];
    
    return newFormPost;
 
}

@end
