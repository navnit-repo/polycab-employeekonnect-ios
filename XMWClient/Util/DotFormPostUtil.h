//
//  DotFormPostUtil.h
//  QCMSProject
//
//  Created by Ashish Tiwari on 01/07/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DotFormElement.h"
#import "DotForm.h"
#import "DotFormPost.h"
#import "FormVC.h"




@interface DotFormPostUtil : NSObject
{
    

   
    
}

-(BOOL) mandatoryCheckOfDotFormElement : (DotFormElement *) dotFormElement : (FormVC *) baseForm;

-(void) mandatoryCheckForCheckBoxGroup : (NSString *) name : (FormVC *) baseForm;
-(BOOL) checkForPasswordConfirm : (DotForm *) formDef : (FormVC *) baseForm;
-(BOOL) mandatoryCheck : (DotForm *) formDef : (FormVC *) baseForm;
-(DotFormPost *) submitSimpleForm : (DotForm *) formDef : (FormVC *)baseForm : (DotFormPost *)formPost : (NSMutableDictionary *)forwardedDataDisplay : (NSMutableDictionary *)forwardedDataPost : (BOOL) getEnteredData: (BOOL)isSubmitOnServer : (DotFormElement *) dotFormElement;


-(void) getFormComponentData : (DotForm *) formDef : (FormVC *) baseForm : (DotFormPost*) formPost : (NSString *)appendStr : (NSMutableDictionary *)forwardedDataDisplay : (NSMutableDictionary *) forwardedDataPost;


-(NSMutableArray * ) getDotFormElementData : (DotFormElement *) dotFormElement : (FormVC *) baseForm;
-(void) docFormSubmit : (DotFormPost *) formPost;


-(DotFormPost *) checkTypeOfFormAndSubmit : (DotForm *) formDef : (FormVC *) baseForm : (DotFormPost *) formPost :(NSMutableDictionary *) forwardedDataDisplay :(NSMutableDictionary *) forwardedDataPost :(bool) isSubmitOnServer : (DotFormElement *) dotFormElement;

-(void) storeRecentRequest : (DotForm*) dotForm :  (DotFormPost*) dotFormPost : (DocPostResponse*) postResponse : (BOOL) removeOld;

-(BOOL) checkForLeaveReqDates : (FormVC*) baseForm;

-(void) incrementMaxDocId : (DotFormPost *) formPost;

@end
