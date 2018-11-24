//
//  FormBaseSection.m
//  QCMSProject
//
//  Created by Pradeep Singh on 3/20/17.
//  Copyright © 2017 dotvik. All rights reserved.
//

#import "FormBaseSection.h"
#import "FormVC.h"
#import "ClientVariable.h"
#import "DVAppDelegate.h"


@interface FormBaseSection ()
{
    FormVC* subForm;
    DotForm* dotForm;
    NSMutableDictionary* forwardedDataDisplay;
    NSMutableDictionary* forwardedDataPost;
    DotFormPost* dotFormPost;
    
    
}

@end



@implementation FormBaseSection



-(void)updateData: (DotReport*) inDotReport :(ReportPostResponse*) inReportPostResponse
{
    forwardedDataPost = self.reportVC.forwardedDataPost;
    forwardedDataDisplay = self.reportVC.forwardedDataDisplay;
    
    ClientVariable *clientVariables = [ClientVariable getInstance:[DVAppDelegate currentModuleContext]];
    
    
    DotMenuObject* formMenuObject = [[DotMenuObject alloc] init];
    formMenuObject.FORM_ID = self.dotFormId;
    
    dotForm = (DotForm *) [clientVariables.DOT_FORM_MAP objectForKey: self.dotFormId];
    if (forwardedDataDisplay == nil)
        forwardedDataDisplay   = [[NSMutableDictionary alloc] init];
    
    if (forwardedDataPost == nil)
        forwardedDataPost      = [[NSMutableDictionary alloc] init];
    
    dotFormPost = [[DotFormPost alloc] init];
    
    
    subForm = [[FormVC alloc] initWithData :formMenuObject
                                                          :dotFormPost
                                                          :NO
                                                          :forwardedDataDisplay
                                                          :forwardedDataPost];
    subForm.headerStr			= dotForm.screenHeader;
    subForm.menuViewController = nil;
    
    CGFloat formHeight = [[dotForm.formElements allKeys] count] * 50.0f;
    subForm.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, formHeight);

}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(subForm==nil) {
        return 0;
    } else {
        return 1;
    }
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FormSectionCell"];
    if(subForm!=nil) {
        UIView* view = [cell.contentView viewWithTag:9001];
        if(view==nil) {
            subForm.view.tag = 9001;
            [cell.contentView addSubview:subForm.view];
        }
    }
    
    return cell;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(subForm==nil) {
        return 0;
    } else {
        return subForm.view.frame.size.height;
    }
    
}


-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
}

@end
