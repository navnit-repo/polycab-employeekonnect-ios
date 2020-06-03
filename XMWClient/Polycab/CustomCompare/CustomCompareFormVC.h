//
//  CustomCompareFormVC.h
//  QCMSProject
//
//  Created by Pradeep Singh on 9/4/16.
//  Copyright © 2016 dotvik. All rights reserved.
//

#import "FormVC.h"

@interface CustomCompareFormVC : FormVC
-(DotFormPost*) defaultColumnFirst:(DotFormPost*) formPost;
-(DotFormPost*) defaultColumnSecond:(DotFormPost*) formPost;
-(DotFormPost*) defaultColumnThird:(DotFormPost*) formPost;
@end
