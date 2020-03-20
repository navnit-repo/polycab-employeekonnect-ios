//
//  TimePickerViewController.m
//  QCMSProject
//
//  Created by Ashish Tiwari on 15/10/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//

#import "TimePickerViewController.h"


@interface TimePickerViewController ()

@end

@implementation TimePickerViewController
@synthesize datePicker;
@synthesize parentController;

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
    [self drawNavigationButtonItem];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) drawNavigationButtonItem
{
    self.title              = @"Time";
    
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStyleBordered
                           
                                   
                                   
                                                                  target:self
                                                                  action:@selector(doneHandler:)];
   // [self.navigationItem setLeftBarButtonItem:doneButton];
    [self.navigationItem setRightBarButtonItem:doneButton];
    
}

- (void) doneHandler : (id) sender
{
   NSDate *date =  self.datePicker.date;

    
    [parentController dismissTimePicker : date];
    
    
    [ [self navigationController]  popViewControllerAnimated:YES];
    
}

@end
