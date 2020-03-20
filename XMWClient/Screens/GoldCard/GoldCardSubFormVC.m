//
//  GoldCardSubFormVC.m
//  QCMSProject
//
//  Created by Pradeep Singh on 5/12/16.
//  Copyright © 2016 dotvik. All rights reserved.
//

#import "GoldCardSubFormVC.h"
#import "ClientVariable.h"
#import "DVAppDelegate.h"
#import "GoldCardTableFormDelegate.h"
#import "DVTableFormView.h"

@interface GoldCardSubFormVC ()

@end

@implementation GoldCardSubFormVC


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
    dotFormDraw.tableFormDelegate = [[GoldCardTableFormDelegate alloc] init];
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


-(DVTableFormView*) childTableForm:(CGRect) frame
{
    return [[DVTableFormView alloc] initWithFrameWithNoRightAction:frame];
}



- (void) httpResponseObjectHandler : (NSString*) callName : (id) respondedObject : (id) requestedObject
{
    [super httpResponseObjectHandler:callName :respondedObject :requestedObject];
    
     if([callName isEqualToString:XmwcsConst_CALL_NAME_FOR_VIEW_EDIT]) {
        
        DocPostResponse *docPostResponse = (DocPostResponse *)respondedObject;
        NSString *message = docPostResponse.submittedMessage;
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Info!" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
        [myAlertView show];
        
    }
}


@end
