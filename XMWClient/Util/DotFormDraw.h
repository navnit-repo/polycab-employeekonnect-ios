//
//  DotFormDraw.h
//  QCMSProject
//
//  Created by Ashish Tiwari on 29/05/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FormVC.h"
#import "CheckBoxGroup.h"
#import "CheckBoxButton.h"
#import "RadioTableViewCell.h"
#import "FormTableViewCell.h"
#import "DropDownTableViewCell.h"
#import "ButtonTableViewCell.h"
#import "SearchViewController.h"
#import "TimeTableViewCell.h"

#import "XMWTableFormDelegate.h"


@interface DotFormDraw : NSObject
{
@private
    FormVC* formViewController;
    SearchViewController *searchViewController;
    NSMutableDictionary* tag_elementId_map;
    
    int yArguForDrawComp;
 
    
}
@property int yArguForDrawComp;
@property SearchViewController *searchViewController;
@property FormVC* formViewController;
@property NSMutableDictionary* tag_elementId_map;
@property (strong, nonatomic) XMWTableFormDelegate* tableFormDelegate;


-(NSMutableDictionary *) getDropDownList:(DotFormElement *)component;
-(NSMutableDictionary *) methodCall : (NSString *) structFieldName : (NSString *)selectedValue : (NSString *)dependedFieldName : (NSString *)refreshDropDown : (NSString *)dropDownMasterValueMapping;
+(id) getMasterValueForComponent : (NSString *) elementId :  (NSString *) masterValueMapping;

+(NSMutableDictionary*) makeMenuForButtonScreen : (NSString*) formId;


-(void) drawForm:(DotForm*) dotForm :(UIView *) formContainer  :(FormVC*) inFormVC;
+(NSMutableArray *) sortFormComponents :(NSMutableDictionary *)dotFormElements;
+(void) sortListOnPosition : (NSMutableArray *) in_ComponentIdVec: (NSMutableArray *)in_ComponentPositionVec;
-(UIView *) drawDotFormElement : (DotFormElement *) formElement : (FormVC *) formController;

-(UIView*) drawMandatoryLbl : (FormVC *) formController :(DotFormElement*) dotFormElement ;
-(UIView*) drawTextField : (FormVC *) formController :(DotFormElement*) dotFormElement  : (BOOL)isPasswordField;
-(UIView*) drawTextArea : (FormVC *) formController :(DotFormElement*) dotFormElement ;
-(UIView*) drawButton : (FormVC *) formController :(DotFormElement*) dotFormElement ;
-(UIView*) drawDateField : (FormVC *) formController :(DotFormElement*) dotFormElement;
-(UIView*) drawDropDown : (FormVC *) formController :(DotFormElement*) dotFormElement ;
-(UIView*) drawCheckBoxGroup : (FormVC *) formController :(DotFormElement*) dotFormElement ;
-(UIView*) drawCheckBox :(FormVC *) formController :(DotFormElement*) dotFormElement ;
-(UIView*) drawLabel :(FormVC *) formController :(DotFormElement*) dotFormElement ;
-(UIView*) drawTimeField : (FormVC *) formController :(DotFormElement*) dotFormElement ;
-(UIView*) drawRadioGroup : (FormVC *) formController :(DotFormElement*) dotFormElement ;
-(UIView*) drawSearchField : (FormVC *) formController :(DotFormElement*) dotFormElement ;
-(UIView*) drawSubHeader : (FormVC *) formController :(DotFormElement*) dotFormElement ;

- (void) hideFormRowContainer :(UIView*) parentCont : (NSString*) nameId : (BOOL) hideState;
- (int) removeFormRowContainer : (UIView*) parentCont : (NSString*) nameId;
- (UIView*) formRowContainer:(UIView*) parentCont :(NSString*) nameId;
- (void) insertFormRowContainer : (UIView*) parentCont : (UIView*) rowCont : (int) beforeTag;
-(UIView*) drawDropDown : (FormVC *) formController :(DotFormElement*) dotFormElement  customMaster:(id) masterValues;


-(void) setFormEditable:(UIView *) formContainer :(DotForm*) dotForm :(FormVC*) inFormVC;


@end
