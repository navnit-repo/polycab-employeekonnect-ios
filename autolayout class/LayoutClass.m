//
//  LayoutClass.m
//  MillionHere
//
//  Created by dotvikios on 21/02/17.
//  Copyright © 2017 Dotvik. All rights reserved.
//

#import "LayoutClass.h"
#import "DVAppDelegate.h"

@implementation LayoutClass

+(UIView*)setFont:(UIView*)currentView forFontWeight:(UIFontWeight)fontWeight{

    if([currentView isKindOfClass:[UILabel class]])
    {
        UILabel* label=(UILabel*)currentView;
        label.font=[UIFont systemFontOfSize:label.font.pointSize*deviceWidthRation weight:fontWeight];
        
        return label;
    }
    else if([currentView isKindOfClass:[UIButton class]])
    {
        UIButton* button=(UIButton*)currentView;
        CGFloat fontSize=button.titleLabel.font.pointSize;
        [button.titleLabel setFont:[UIFont systemFontOfSize:fontSize*deviceWidthRation weight:fontWeight]];
        
        return button;
    }
    else if([currentView isKindOfClass:[UITextField class]])
    {
        UITextField* textfield=(UITextField*)currentView;
        CGFloat fontSize=textfield.font.pointSize;
        textfield.font=[UIFont systemFontOfSize:fontSize*deviceWidthRation weight:fontWeight];
        
        return textfield;
    }
    else if([currentView isKindOfClass:[UITextView class]])
    {
        UITextView* textview=(UITextView*)currentView;
        CGFloat fontSize=textview.font.pointSize;
        textview.font=[UIFont systemFontOfSize:fontSize*deviceWidthRation weight:fontWeight];
        
        return textview;
    }
    
    return nil;
}

+(UILabel*)labelLayout:(UILabel*)label forFontWeight:(UIFontWeight)fontWeight{

    CGFloat fontSize=label.font.pointSize;
    label.font=[UIFont systemFontOfSize:fontSize*deviceWidthRation weight:fontWeight];
    
    CGRect labelFrame=label.frame;
    labelFrame.origin.x=deviceWidthRation*label.frame.origin.x;
    labelFrame.origin.y=deviceHeightRation*label.frame.origin.y;
    labelFrame.size.width=deviceWidthRation*label.frame.size.width;
    labelFrame.size.height=deviceHeightRation*label.frame.size.height;
    label.frame=labelFrame;
    
    return label;
}

+(UIButton*)buttonLayout:(UIButton*)button forFontWeight:(UIFontWeight)fontWeight{

    CGFloat fontSize=button.titleLabel.font.pointSize;
   
    
    [button.titleLabel setFont:[UIFont systemFontOfSize:fontSize*deviceWidthRation weight:fontWeight]];
    
    CGRect buttonFrame=button.frame;
    buttonFrame.origin.x=deviceWidthRation*button.frame.origin.x;
    buttonFrame.origin.y=deviceHeightRation*button.frame.origin.y;
    buttonFrame.size.width=deviceWidthRation*button.frame.size.width;
    buttonFrame.size.height=deviceHeightRation*button.frame.size.height;
    button.frame=buttonFrame;
    
    return button;
}

+(UITextField*)textfieldLayout:(UITextField*)textfield forFontWeight:(UIFontWeight)fontWeight{

    CGFloat fontSize=textfield.font.pointSize;
    textfield.font=[UIFont systemFontOfSize:fontSize*deviceWidthRation];
    
    CGRect textfieldFrame=textfield.frame;
    textfieldFrame.origin.x=deviceWidthRation*textfield.frame.origin.x;
    textfieldFrame.origin.y=deviceHeightRation*textfield.frame.origin.y;
    textfieldFrame.size.width=deviceWidthRation*textfield.frame.size.width;
    textfieldFrame.size.height=deviceHeightRation*textfield.frame.size.height;
    textfield.frame=textfieldFrame;
    
    return textfield;
}

+(UITextView*)textviewLayout:(UITextView*)textview forFontWeight:(UIFontWeight)fontWeight
{

    CGFloat fontSize=textview.font.pointSize;
    textview.font=[UIFont systemFontOfSize:fontSize*deviceWidthRation];
    
    CGRect textviewFrame=textview.frame;
    textviewFrame.origin.x=deviceWidthRation*textview.frame.origin.x;
    textviewFrame.origin.y=deviceHeightRation*textview.frame.origin.y;
    textviewFrame.size.width=deviceWidthRation*textview.frame.size.width;
    textviewFrame.size.height=deviceHeightRation*textview.frame.size.height;
    textview.frame=textviewFrame;
    
    return textview;
}
+(UIView*)setLayoutForIPhone6:(UIView*)currentView
{

    if([currentView isKindOfClass:[UILabel class]])
    {
        UILabel* label=(UILabel*)currentView;
        label.font=[UIFont systemFontOfSize:label.font.pointSize*deviceWidthRation];
        
        CGRect labelFrame=label.frame;
        labelFrame.origin.x=deviceWidthRation*label.frame.origin.x;
        labelFrame.origin.y=deviceHeightRation*label.frame.origin.y;
        labelFrame.size.width=deviceWidthRation*label.frame.size.width;
        labelFrame.size.height=deviceHeightRation*label.frame.size.height;
        
        if(labelFrame.size.height<1.0)
            labelFrame.size.height=1.0;
        if(labelFrame.size.width<1.0)
            labelFrame.size.width=1.0;
        label.frame=labelFrame;
        
        return label;
    }
    else if([currentView isKindOfClass:[UIButton class]])
    {
        UIButton* button=(UIButton*)currentView;
        
        CGRect buttonFrame=button.frame;
        buttonFrame.origin.x=deviceWidthRation*button.frame.origin.x;
        buttonFrame.origin.y=deviceHeightRation*button.frame.origin.y;
        buttonFrame.size.width=deviceWidthRation*button.frame.size.width;
        buttonFrame.size.height=deviceHeightRation*button.frame.size.height;
        button.frame=buttonFrame;
        
        return button;
    }

    else
    {
        CGRect viewFrame=currentView.frame;
        viewFrame.origin.x=deviceWidthRation*currentView.frame.origin.x;
        viewFrame.origin.y=deviceHeightRation*currentView.frame.origin.y;
        viewFrame.size.width=deviceWidthRation*currentView.frame.size.width;
        viewFrame.size.height=deviceHeightRation*currentView.frame.size.height;
        currentView.frame=viewFrame;
        
        return currentView;
    }
    
    return nil;
}

//+(UIView*)addStatusBarView:(UIView*)parentView forBgColor:(UIColor*) bgColor{
//    
//    UIView* statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, existingDeviceWidth, statusbarHeight)];
//    statusBarView.backgroundColor = bgColor;
//    
//    [parentView addSubview:statusBarView];
//    
//    return statusBarView;
//    
//}

@end
