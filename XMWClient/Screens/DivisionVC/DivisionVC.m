//
//  DivisionVC.m
//  QCMSProject
//
//  Created by dotvikios on 19/09/17.
//  Copyright © 2017 dotvik. All rights reserved.
//

#import "DivisionVC.h"

#import "WebViewController.h"
#import "Styles.h"

#import "MXTextField.h"
#import "DVAppDelegate.h"
#import "ClientVariable.h"


@interface DivisionVC ()

@end

@implementation DivisionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [Styles formBackgroundColor];
    
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


// override this method in your class for any specific custom handling
-(void) dropDownPickerDoneHandle:(DotFormElement*) ddFormElement
{
    NSLog(@"DivisionVC:dropDownPickerDoneHandle()");
    
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Havells mKonnect" message:@"Do you want to check special price store?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Yes"
                                                       style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                           
                                                           [self alertViewYesBtnHandler:ddFormElement];
                                                           
                                                       }];
    [alertController addAction:okAction];
    
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"No"
                                                           style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                               
                                                               // do nothing
                                                           }];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}


-(void)alertViewYesBtnHandler:(DotFormElement*) ddFormElement
{
    MXTextField *dropDownField = (MXTextField *) [self getDataFromId:ddFormElement.elementId];
    NSString* valueToSubmit =  dropDownField.keyvalue;
    NSString* valueToDisplay = dropDownField.text;
    
    NSLog(@"valueToSubmit = %@", valueToSubmit);
    NSLog(@"valueToDisplay = %@", valueToDisplay);
    
    ClientVariable *clientVariables = [ClientVariable getInstance:[DVAppDelegate currentModuleContext]];
    
    NSString* storeUri = [NSString stringWithFormat:@"division=%@&username=%@&distributionChannel=NA&Source=mobile", valueToSubmit ,clientVariables.CLIENT_USER_LOGIN.userName ];
    
    NSString *urlAddress = [NSString stringWithFormat:@"%@?%@", XmwcsConst_SERVICE_URL_DEAL_STORE, storeUri];
    
    WebViewController* webViewController = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil withWebURL:urlAddress];
   // webViewController.eventId=valueToSubmit;
    [self.navigationController pushViewController:webViewController animated:YES];
    
}



@end
