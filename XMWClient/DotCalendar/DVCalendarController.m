//
//  DVCalendarController.m
//  QCMSProject
//
//  Created by Pradeep Singh on 4/29/14.
//  Copyright (c) 2014 dotvik. All rights reserved.
//

#import "DVCalendarController.h"
#import "Styles.h"
#import "DVAppDelegate.h"

@interface DVCalendarController ()
{
    
    DVDateStruct* selectedDate;
}

@end



@implementation DVCalendarController

@synthesize contextId;
@synthesize lowerDate;
@synthesize upperDate;
@synthesize displayDate;
@synthesize calendarDelegate;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    [self drawHeaderItem];
    
    DVMonthView* monthView = [[DVMonthView alloc] initWithFrame:CGRectMake(6, 0, 320*deviceWidthRation, 360) lowerLimit:lowerDate upperLimit:upperDate displayDate:displayDate Renderer:self];
    
    //DVMonthView* monthViewCal = [[DVMonthView alloc] initWithFrame:CGRectMake(6, 50, 308, 360) Renderer:self];
    monthView.monthViewDelegate = self;
    // 255 235 235
    monthView.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1.0];
    
    [self.view addSubview:monthView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) drawHeaderItem
{
    
    // Cancel button, similar as Back
    UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(backHandler:)];
    cancelButton.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:cancelButton];
    
    
    
    // Done button
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                     style:UIBarButtonItemStyleBordered
                                                                    target:self
                                                                    action:@selector(doneHandler:)];
    doneButton.tintColor = [UIColor whiteColor];
    [self.navigationItem setRightBarButtonItem:doneButton];

    
    
    [self drawTitle: @"Select Date"];
    
}


-(void) drawTitle:(NSString *)headerStr
{
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIColor whiteColor],NSForegroundColorAttributeName,
                                    [UIColor whiteColor],NSBackgroundColorAttributeName,nil];
    
    self.navigationController.navigationBar.titleTextAttributes = textAttributes;
    // self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    
    UILabel*  titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 40)];
    titleLabel.text = headerStr;
//    titleLabel.textColor = [Styles headerTextColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    [self.navigationItem setTitleView: titleLabel];
    
}



- (void) backHandler : (id) sender {
    
    if((calendarDelegate!=nil) && [calendarDelegate respondsToSelector:@selector(userCancelled:)]) {
        [calendarDelegate userCancelled: contextId ];
    }
    
    [ [self navigationController]  popViewControllerAnimated:YES];
}



- (void) doneHandler : (id) sender {
    
    if((calendarDelegate!=nil) && [calendarDelegate respondsToSelector:@selector(dateSelected::)]) {
        [calendarDelegate dateSelected:selectedDate : contextId ];
    }
    [ [self navigationController]  popViewControllerAnimated:YES];
}



#pragma mark - DVMonthViewDelegate
-(void) dateSelected:(DVDateStruct*) dateStruct
{
    NSLog(@"I got date selected day=%d,  month=%d, year=%d", dateStruct.day, dateStruct.month, dateStruct.year);
    
    selectedDate = dateStruct;
    
    if((calendarDelegate!=nil) && [calendarDelegate respondsToSelector:@selector(dateSelected::)]) {
        [calendarDelegate dateSelected:selectedDate : contextId ];
    }
    [ [self navigationController]  popViewControllerAnimated:YES];
    

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


@end
