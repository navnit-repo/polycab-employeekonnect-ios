//
//  HamBurgerMenuView.h
//  QCMSProject
//
//  Created by Pradeep Singh on 10/5/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol HamBurgerMenuHandler <NSObject>
-(void) menuClicked : (int) idx;
@end


@interface HamBurgerMenuView : UIView
{
    id<HamBurgerMenuHandler> burgerMenuHandler;
}

- (id)initWithFrame:(CGRect)frame withMenu:(NSArray*) menus handler:(id<HamBurgerMenuHandler>) menuHandler;

@end


