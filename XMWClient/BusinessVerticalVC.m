//
//  BusinessVerticalVC.m
//  XMWClient
//
//  Created by dotvikios on 19/09/18.
//  Copyright © 2018 dotvik. All rights reserved.
//

#import "BusinessVerticalVC.h"
#import "DotFormPostUtil.h"
#import "BusinessVerticalReportVC.h"
@interface BusinessVerticalVC ()

@end

@implementation BusinessVerticalVC


- (void)viewDidLoad {
    [super viewDidLoad];
    [self customizeView];
    // Do any additional setup after loading the view from its nib.
}

-(void)customizeView{
    
    [[self.view viewWithTag:1002] removeFromSuperview]; //remove from date
    [[self.view viewWithTag:1003] removeFromSuperview]; //remove to date
    [self.view viewWithTag:1004].frame = CGRectMake([self.view viewWithTag:1004].frame.origin.x, [self.view viewWithTag:1004].frame.origin.y-140, [self.view viewWithTag:1004].frame.size.width, [self.view viewWithTag:1004].frame.size.height); //change button y position
    
}
-(IBAction)submitPressed:(id)sender
{
    
    DotFormPostUtil *dotFormPostUtil = [[DotFormPostUtil alloc]init];
    MXButton* button = (MXButton*) sender;
    NSString* attachedData = (NSString*)button.attachedData;
    
    DotFormElement *dotFormElement = [self.dotForm.formElements objectForKey:button.elementId];
    
    
    DotFormPost* formPost = [dotFormPostUtil submitSimpleForm:self.dotForm :self : self.dotFormPost :self.forwardedDataDisplay :self.forwardedDataPost :YES :NO :dotFormElement];
    
    NSLog(@"formPost = %@", [formPost.postData description]);
    
    BusinessVerticalReportVC* customReport = [[BusinessVerticalReportVC alloc] initWithNibName:@"ReportQuantityValue" bundle:nil];
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
    
    
    
    NSLocale* currentDate = [NSLocale currentLocale];
    [[NSDate date] descriptionWithLocale:currentDate];
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    // or @"yyyy-MM-dd hh:mm:ss a" if you prefer the time with AM/PM
    NSLog(@"%@",[dateFormatter stringFromDate:[NSDate date]]);
    
    NSString *fromDate =[dateFormatter stringFromDate:[NSDate date]];
    NSString *toDate = [dateFormatter stringFromDate:[NSDate date]];
    NSLog(@"From Date : %@",fromDate);
    NSLog(@"To date : %@",toDate);
    
    
    // user selected date from previous screen inputs
    
    [newFormPost.postData setObject:fromDate forKey:@"FROM_DATE"];
    [newFormPost.postData setObject:toDate forKey:@"TO_DATE"];
    
    [newFormPost.displayData setObject:fromDate forKey:@"FROM_DATE"];
    [newFormPost.displayData setObject:toDate forKey:@"TO_DATE"];
    
    return  newFormPost;
}


-(DotFormPost*) defaultColumnSecond:(DotFormPost*) formPost
{
    DotFormPost* newFormPost = [formPost cloneObject];
    
    //    // user selected date (minus one month) from previous screen inputs
    
    NSLocale* currentDate = [NSLocale currentLocale];
    [[NSDate date] descriptionWithLocale:currentDate];
    
    NSDateFormatter *dateFormatterFormDate=[[NSDateFormatter alloc] init];
    [dateFormatterFormDate setDateFormat:@"01/MM/yyyy"];
    // or @"yyyy-MM-dd hh:mm:ss a" if you prefer the time with AM/PM
    NSLog(@"%@",[dateFormatterFormDate stringFromDate:[NSDate date]]);
    
    
    NSDateFormatter *dateFormatterToDate=[[NSDateFormatter alloc] init];
    [dateFormatterToDate setDateFormat:@"dd/MM/yyyy"];
    // or @"yyyy-MM-dd hh:mm:ss a" if you prefer the time with AM/PM
    NSLog(@"%@",[dateFormatterToDate stringFromDate:[NSDate date]]);
    
    
    NSString *fromDate =[dateFormatterFormDate stringFromDate:[NSDate date]];
    NSString *toDate = [dateFormatterToDate stringFromDate:[NSDate date]];
    NSLog(@"From Date : %@",fromDate);
    NSLog(@"To date : %@",toDate);
    
    
    [newFormPost.postData setObject:fromDate forKey:@"FROM_DATE"];
    [newFormPost.postData setObject:toDate forKey:@"TO_DATE"];
    
    [newFormPost.displayData setObject:fromDate forKey:@"FROM_DATE"];
    [newFormPost.displayData setObject:toDate forKey:@"TO_DATE"];
    
    return newFormPost;
}
-(DotFormPost*) defaultColumnThird:(DotFormPost*) formPost
{
    
    DotFormPost* newFormPost = [formPost cloneObject];
    
    NSString *fromDate;
    NSLocale* currentDate = [NSLocale currentLocale];
    [[NSDate date] descriptionWithLocale:currentDate];
    
    NSDateFormatter *dateFormatterToDate=[[NSDateFormatter alloc] init];
    [dateFormatterToDate setDateFormat:@"dd/MM/yyyy"];
    // or @"yyyy-MM-dd hh:mm:ss a" if you prefer the time with AM/PM
    NSLog(@"%@",[dateFormatterToDate stringFromDate:[NSDate date]]);
    NSString *toDate = [dateFormatterToDate stringFromDate:[NSDate date]];
    
    // for month condition check
    NSDateFormatter *checkMonth = [[NSDateFormatter alloc] init];
    [checkMonth setDateFormat:@"01/04/yyyy"];
    NSLog(@"%@",[checkMonth stringFromDate:[NSDate date]]);
    NSString *date1=[checkMonth stringFromDate:[NSDate date]]; //01-04-current year
    NSString *date2=[dateFormatterToDate stringFromDate:[NSDate date]]; //current to date
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"dd/MM/yyyy"];
    NSDate *dtOne=[format dateFromString:date1];
    NSDate *dtTwo=[format dateFromString:date2];
    NSComparisonResult result;
    result = [dtOne compare:dtTwo];
    
    if (result == NSOrderedAscending) {
        NSDateFormatter *dateFormatterFormDate=[[NSDateFormatter alloc] init];
        [dateFormatterFormDate setDateFormat:@"01/04/yyyy"];
        // or @"yyyy-MM-dd hh:mm:ss a" if you prefer the time with AM/PM
        NSLog(@"%@",[dateFormatterFormDate stringFromDate:[NSDate date]]);
        fromDate =[dateFormatterFormDate stringFromDate:[NSDate date]];
        
    }
    else{
        NSDate *date = [NSDate date];
        NSDateComponents *setPreviousYear = [[NSDateComponents alloc] init];
        [setPreviousYear setYear:-1];
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDate *newDate = [calendar dateByAddingComponents:setPreviousYear toDate:date options:0];
        NSLog(@"newDate -> %@",newDate);
        
        NSDateFormatter *dateFormatterFormDate=[[NSDateFormatter alloc] init];
        [dateFormatterFormDate setDateFormat:@"dd/MM/yyyy"];
        NSLog(@"%@",[dateFormatterFormDate stringFromDate:newDate]);
        fromDate =[dateFormatterFormDate stringFromDate:newDate];
    }
    
    NSLog(@"From Date : %@",fromDate);
    NSLog(@"To date : %@",toDate);
    
    
    
    
    [newFormPost.postData setObject:fromDate forKey:@"FROM_DATE"];
    [newFormPost.postData setObject:toDate forKey:@"TO_DATE"];
    
    [newFormPost.displayData setObject:fromDate forKey:@"FROM_DATE"];
    [newFormPost.displayData setObject:toDate forKey:@"TO_DATE"];
    
    return newFormPost;
    
    
    
}
@end
