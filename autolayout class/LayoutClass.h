//
//  LayoutClass.h
//  MillionHere
//
//  Created by dotvikios on 21/02/17.
//  Copyright © 2017 Dotvik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LayoutClass : NSObject
+(UIPageControl*)pageControlLauout :(UIPageControl*)controller;
+(UIView*)setFont:(UIView*)currentView forFontWeight:(UIFontWeight)fontWeight;
+(UILabel*)labelLayout:(UILabel*)label forFontWeight:(UIFontWeight)fontWeight;
+(UIButton*)buttonLayout:(UIButton*)button forFontWeight:(UIFontWeight)fontWeight;
+(UITextField*)textfieldLayout:(UITextField*)textfield forFontWeight:(UIFontWeight)fontWeight;
+(UITextField*)textviewLayout:(UITextView*)textview forFontWeight:(UIFontWeight)fontWeight;
//+(UIView*)setLayout:(UIView*)currentView;
+(UIView*)setLayoutForIPhone6:(UIView*)currentView;
+(UIView*)addStatusBarView:(UIView*)parentView forBgColor:(UIColor*) bgColor;
+ (CGFloat*)deviceWidthRationSdkWith6s;
@end
