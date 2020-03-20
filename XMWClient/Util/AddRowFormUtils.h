//
//  AddRowFormUtils.h
//  QCMSProject
//
//  Created by Ashish Tiwari on 01/07/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DotForm.h"
#import "DotFormPost.h"
#import "FormVC.h"

@interface AddRowFormUtils : NSObject
{
    int yOffset;
}



-(UIView *) drawRowForTable : (DotForm *) formDef : (NSInteger) rowNoOfTable : (DotFormPost *) formPost;
-(int) addDocDetailAsRow : (NSString *) formId : (NSInteger) rowNoOfTable :  (DotFormPost *) formPost : (FormVC *)baseForm : (UIView *) addItemContainer : (BOOL) submitButtonFlag;

-(UIView *) makeItemHeaderTable : (DotForm *) formDef;

-(int) deleteRow : (FormVC *) baseForm : (DotFormPost *) formPost : (UIView *) addItemContainer : (NSInteger) rowNoOfTable :(UIView*)toBeRemovedViewed : (int) rowNoDelete;

@end
