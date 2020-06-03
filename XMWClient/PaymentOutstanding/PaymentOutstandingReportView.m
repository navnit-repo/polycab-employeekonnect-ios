//
//  PaymentOutstandingReportView.m
//  XMWClient
//
//  Created by dotvikios on 20/11/18.
//  Copyright © 2018 dotvik. All rights reserved.
//

#import "PaymentOutstandingReportView.h"
#import "PaymentOutstandingTabbularSection.h"
@interface PaymentOutstandingReportView ()

@end

@implementation PaymentOutstandingReportView

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"My custome View Call");
 
}

-(PaymentOutstandingTabbularSection*) addTabularDataSection
{
    PaymentOutstandingTabbularSection* dataSection = [[PaymentOutstandingTabbularSection alloc] init];
    dataSection.forwardedDataDisplay = forwardedDataDisplay;
    dataSection.forwardedDataPost = forwardedDataPost;
    dataSection.reportVC = self;
    
    return  dataSection;
}



@end
