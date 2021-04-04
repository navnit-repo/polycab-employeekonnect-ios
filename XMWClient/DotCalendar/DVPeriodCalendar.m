//
//  DVPeriodCalendar.m
//  QCMSProject
//
//  Created by Pradeep Singh on 9/5/16.
//  Copyright © 2016 dotvik. All rights reserved.
//

#import "DVPeriodCalendar.h"

#import "MXButton.h"

#import "Styles.h"

@interface DVPeriodCalendar () <UITextFieldDelegate>
{
    DVDateStruct* fromSelectedDate;
    DVDateStruct* toSelectedDate;
    
    int currentTabCtx;
    
    DVMonthView* monthView;
    
    NSDateFormatter* dateFormatter;
}

@end

@implementation DVPeriodCalendar

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (isiPhoneXSMAX) {
        self.view.frame = CGRectMake(0, 64, 414, 832);
    }
    else if(isiPhoneXR) {
        self.view.frame = CGRectMake(0, 64, 414, 832);
    }
    
    else if(isiPhoneXS) {
        self.view.frame = CGRectMake(0, 64, 375, 748);
    }
    else if(isiPhone10) {
        self.view.frame = CGRectMake(0, 64, 375, 748);
    }
    
    else if(isiPhone6Plus) {
        self.view.frame = CGRectMake(0, 64, 414, 672);
    }
    else if(isiPhone6) {
        self.view.frame = CGRectMake(0, 64, 375, 600);
    } else if(isiPhone5) {
        self.view.frame = CGRectMake(0, 64, 320, 504);
    } else {
        // 0, 64, 320, 416
        self.view.frame = CGRectMake(0, 64, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height - 64.0f);
    }
    
    
    // Do any additional setup after loading the view from its nib.
    currentTabCtx = 0;
    
    // assign fromSelected
    fromSelectedDate = [DVDateStruct fromNSDate:self.fromDisplayDate];
    toSelectedDate = [DVDateStruct fromNSDate:self.toDisplayDate];
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    
    [self calInitVariables];
    
    
    UIImage *calendarImage = [UIImage imageNamed:@"Icon-Cal.png"];
    
    MXButton* calendarButton = [MXButton buttonWithType:UIButtonTypeCustom];
    [calendarButton setFrame:CGRectMake( 0.0f, 0.0f, 20, 20)];
    [calendarButton setImage:calendarImage forState:UIControlStateNormal];
    
    [self.fromField setRightView:calendarButton];
    [self.fromField setRightViewMode:UITextFieldViewModeAlways];
    self.fromField.delegate = self;
    
    
    calendarButton = [MXButton buttonWithType:UIButtonTypeCustom];
    [calendarButton setFrame:CGRectMake( 0.0f, 0.0f, 20, 20)];
    [calendarButton setImage:calendarImage forState:UIControlStateNormal];
    
    [self.toField setRightView:calendarButton];
    [self.toField setRightViewMode:UITextFieldViewModeAlways];
    self.toField.delegate = self;
    
    [self drawHeaderItem];
    
    [self selectTab:0];
    
}

-(void) calInitVariables
{
    if(self.fromLowerDate==nil) {
        self.fromLowerDate = [NSDate date];
    }
    
    if(self.fromUpperDate==nil) {
        self.fromUpperDate = [NSDate date];
    }
    
    if(self.fromDisplayDate==nil) {
        self.fromDisplayDate = [NSDate date];
    }
    
    
    if(self.toLowerDate==nil) {
        self.toLowerDate = [NSDate date];
    }
    
    if(self.toUpperDate==nil) {
        self.toUpperDate = [NSDate date];
    }
    
    if(self.toDisplayDate==nil) {
        self.toDisplayDate = [NSDate date];
    }
    
    self.fromField.text = [dateFormatter stringFromDate:self.fromDisplayDate];
    self.toField.text = [dateFormatter stringFromDate:self.toDisplayDate];
    
}

-(void) drawHeaderItem
{
    if(self.calendarTitle==nil) {
       self.calendarTitle = @"Select Period";
    }
    UIButton* cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    cancelButton.frame = CGRectMake(10, 30, 80, 40);
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(backHandler:) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setTitleColor:[Styles barButtonTextColor] forState:UIControlStateNormal];
    
    cancelButton.tintColor = [Styles barButtonTextColor];
    
    [self.topBarContainer addSubview:cancelButton];
    
    
    UIButton* doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    doneButton.frame = CGRectMake(self.view.frame.size.width-90.0f, 30, 80, 40);
    
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(doneHandler:) forControlEvents:UIControlEventTouchUpInside];
    [doneButton setTitleColor:[Styles barButtonTextColor] forState:UIControlStateNormal];
    
    doneButton.tintColor = [Styles barButtonTextColor];
    
    [self.topBarContainer addSubview:doneButton];
    
    
    if(self.calendarTitle!=nil) {
        [self drawTitle:self.calendarTitle];
    }
    
}


-(void) drawCalendarView
{
    if(currentTabCtx==0) {
        if(monthView!=nil) {
           [monthView removeFromSuperview];
        }
        
        monthView = [[DVMonthView alloc] initWithFrame:CGRectMake(6, 0, self.view.frame.size.width-12, 360) lowerLimit:self.fromLowerDate upperLimit:self.fromUpperDate displayDate:self.fromDisplayDate Renderer:self];
        
        monthView.monthViewDelegate = self;
        // 255 235 235
        monthView.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1.0];
        
        [self.monthViewContainer addSubview:monthView];
    } else if(currentTabCtx==1) {
        if(monthView!=nil) {
            [monthView removeFromSuperview];
        }
        
        //
        // As per Yogesh, toDisplay date should be of the same month/year of from tab
        //
        if(fromSelectedDate!=nil) {
            self.toDisplayDate = [fromSelectedDate  convertToNSDate];
        }
        
        monthView = [[DVMonthView alloc] initWithFrame:CGRectMake(6, 0, self.view.frame.size.width-12, 360) lowerLimit:self.toLowerDate upperLimit:self.toUpperDate displayDate:self.toDisplayDate Renderer:self];
        
        monthView.monthViewDelegate = self;
        // 255 235 235
        monthView.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1.0];
        
        [self.monthViewContainer addSubview:monthView];
    }
}

-(void) drawTitle:(NSString *)headerStr
{
    UILabel*  titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(90.0f, 30.0f, self.view.frame.size.width - 180.0f, 40)];
    titleLabel.text = headerStr;
    titleLabel.textColor = [Styles headerTextColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    [self.topBarContainer addSubview:titleLabel];
    
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


-(IBAction)backHandler:(id)sender
{
    
    
    if((self.calendarDelegate!=nil) && [self.calendarDelegate respondsToSelector:@selector(userCancelled:)]) {
        [self.calendarDelegate userCancelled: self.contextId ];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)doneHandler:(id)sender
{
    //
    // We need to validate as well, user has to select from and to date, where to date
    // must be greate then from date.
    //
    if((self.calendarDelegate!=nil) && [self.calendarDelegate respondsToSelector:@selector(fromDate: toDate: context:)]) {
        [self.calendarDelegate fromDate:fromSelectedDate toDate:toSelectedDate context:self.contextId];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - DVMonthViewDelegate
-(void) dateSelected:(DVDateStruct*) dateStruct
{
    NSLog(@"I got date selected day=%d,  month=%d, year=%d", dateStruct.day, dateStruct.month, dateStruct.year);
    
    if(currentTabCtx==0) {
        fromSelectedDate = dateStruct;
        NSString *fromDateStr = [dateFormatter stringFromDate:[fromSelectedDate convertToNSDate]];
        self.fromField.text = fromDateStr;
       
        
    } else if (currentTabCtx==1) {
        toSelectedDate = dateStruct;
         NSString *toDateStr = [dateFormatter stringFromDate:[toSelectedDate convertToNSDate]];
        self.toField.text = toDateStr;
    }

}



#pragma mark - DVDateCellCustomRenderer

-(void) setLayoutForCell:(DVDateCell*) cell
{
    cell.backgroundColor = [UIColor clearColor];
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    label.text = cell.text;
    label.textAlignment = NSTextAlignmentCenter;
    [cell addSubview:label];
}

-(void) setLayoutForSelectedCell:(DVDateCell*) cell
{
    cell.backgroundColor = [UIColor redColor];
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    label.text = cell.text;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [cell addSubview:label];
}

-(void) setLayoutForDefaultDateCell:(DVDateCell*) cell
{
    cell.backgroundColor = [UIColor grayColor];
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    label.text = cell.text;
    label.textAlignment = NSTextAlignmentCenter;
    [cell addSubview:label];
}


-(void) selectTab:(NSInteger) tabIndex
{
    
    if(tabIndex==0) {
        self.fromBottomBar.backgroundColor = [UIColor redColor];
        self.toBottomBar.backgroundColor = [UIColor clearColor];
    } else if(tabIndex==1) {
        self.fromBottomBar.backgroundColor = [UIColor clearColor];
        self.toBottomBar.backgroundColor = [UIColor redColor];
    }
    
    currentTabCtx = (int)tabIndex;
    [self drawCalendarView];
    
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(textField.tag==1001) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //code to be executed on the main thread when background task is finished
            [self selectTab:0];
        });
    } else if(textField.tag==1002) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //code to be executed on the main thread when background task is finished
            [self selectTab:1];
        });
    }
    return NO;
}
@end
