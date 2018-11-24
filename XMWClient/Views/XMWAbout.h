//
//  XMWAbout.h
//  QCMSProject
//
//  Created by Pradeep Singh on 10/6/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol XMWAboutCloseDelegate <NSObject>
-(void) aboutClosed;
@end

@interface XMWAbout : UIView
{
    id<XMWAboutCloseDelegate> closeDelegate;
}

@property id<XMWAboutCloseDelegate> closeDelegate;


+ (id)loadingViewInView:(UIView *)aSuperview handler:(id<XMWAboutCloseDelegate>) handler;

- (void)removeView;

@end
