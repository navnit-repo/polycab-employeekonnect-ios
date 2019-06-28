//
//  RMAVC.m
//  XMWClient
//
//  Created by dotvikios on 24/09/18.
//  Copyright © 2018 dotvik. All rights reserved.
//

#import "RMAVC.h"

@interface RMAVC ()

@end

@implementation RMAVC

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"RMAVC call");
    [self customizeView];
    // Do any additional setup after loading the view from its nib.
}

-(void)customizeView{
    MXTextField* textField = (MXTextField*)[self getDataFromId:@"Distributor_Name"];
    textField.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"CUSTOMER_NAME"];
    textField.userInteractionEnabled = NO;
    MXButton* dateField = (MXButton*)[self getDataFromId:@"TO_DATE_Button"];
    dateField.userInteractionEnabled = NO;

}

@end
