//
//  LeftViewVC.h
//  XMWClient
//
//  Created by dotvikios on 18/07/18.
//  Copyright © 2018 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DotMenuObject.h"

@protocol SlideBarDelegate <NSObject>
-(void)clickedDashBoardDelegate:(int) indx   :(DotMenuObject *) selectedMenuData  :(NSString *)AUTH_TOKEN;
@end

@interface LeftViewVC :UIViewController
{
    NSString *auth_Token;
}
@property NSMutableDictionary *menuDetailsDict;
@property NSString *auth_Token;
@property (weak,nonatomic) id<SlideBarDelegate>delegate;
@end
