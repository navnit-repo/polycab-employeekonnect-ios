//
//  GoldCardSubFormVC.h
//  QCMSProject
//
//  Created by Pradeep Singh on 5/12/16.
//  Copyright © 2016 dotvik. All rights reserved.
//

#import "FormVC.h"

@interface GoldCardSubFormVC : FormVC


-(instancetype) initWithData:(DotMenuObject *) _formData : (DotFormPost *) _dotFormPost : (BOOL) _isFormIsSubForm : (NSMutableDictionary*) _forwardedDataDisplay : (NSMutableDictionary*) _forwardedDataPost;


-(void)loadForm;

@end
