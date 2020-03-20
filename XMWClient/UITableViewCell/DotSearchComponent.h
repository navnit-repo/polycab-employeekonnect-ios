//
//  DotSearchComponent.h
//  QCMSProject
//
//  Created by Ashish Tiwari on 21/06/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FormVC.h"


FOUNDATION_EXPORT NSString *const DotSearchConst_POP_SEARCH_BUTTON_ID;
FOUNDATION_EXPORT NSString *const DotSearchConst_SEARCH_TEXT_FIELD_ID;
FOUNDATION_EXPORT NSString *const DotSearchConst_SEARCH_TEXT;
FOUNDATION_EXPORT NSString *const DotSearchConst_SEARCH_BY;
FOUNDATION_EXPORT NSString *const DotSearchConst_SEARCH_MASTER_ID;


@interface DotSearchComponent : UIView
{

    
}


-(void) showSearchScreen : (FormVC *) form : (NSString *) title : (NSString *) searchBy : (NSString *) id : (NSString*) masterValueMapping;

-(NSMutableArray *) getRadioGroupData : (NSString *) groupName;
-(void)addRadioGroup : (NSString *)searchBy :  (NSString *)id;

@end
