//
//  BalanceConfirmationVC.m
//  XMWClient
//
//  Created by dotvikios on 18/09/18.
//  Copyright © 2018 dotvik. All rights reserved.
//

#import "BalanceConfirmationVC.h"

@interface BalanceConfirmationVC ()

@end

@implementation BalanceConfirmationVC



- (void)viewDidLoad {
    DotMenuObject* formMenuObject = [[DotMenuObject alloc] init];
    formMenuObject.FORM_ID = @"DOT_FORM_BALANCE_CONFIRMATION_ACK";
    self.headerStr = @"Balance Confirmation";
    self.formData = formMenuObject;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
