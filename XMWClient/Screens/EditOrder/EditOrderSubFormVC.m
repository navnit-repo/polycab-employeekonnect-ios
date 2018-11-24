//
//  VehicleReimbursementFormVC.m
//  QCMSProject
//
//  Created by Pradeep Singh on 5/12/16.
//  Copyright © 2016 dotvik. All rights reserved.
//

#import "EditOrderSubFormVC.h"
#import "ClientVariable.h"
#import "DVAppDelegate.h"
#import "EditOrderTableFormDelegate.h"

@interface EditOrderSubFormVC ()

@end

@implementation EditOrderSubFormVC


-(instancetype) initWithData : (NSMutableDictionary *)_formData : (DotFormPost *)_dotFormPost : (BOOL)_isFormIsSubForm : (NSMutableDictionary*) _forwardedDataDisplay : (NSMutableDictionary*) _forwardedDataPost
{
    self = [super initWithData:_formData :_dotFormPost :_isFormIsSubForm :_forwardedDataDisplay :_forwardedDataPost];
    
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)loadForm
{
    ClientVariable* clientVariables = [ClientVariable getInstance : [DVAppDelegate currentModuleContext]];
    dotFormDraw.tableFormDelegate = [[EditOrderTableFormDelegate alloc] init];
    dotFormDraw.tableFormDelegate.formViewController = self;
    
    [super loadForm];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


-(void) setFormEditable
{
    [dotFormDraw setFormEditable:self.view :self.dotForm :self ];
}


@end
