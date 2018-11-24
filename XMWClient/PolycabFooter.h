//
//  PolycabFooter.h
//  XMWClient
//
//  Created by dotvikios on 06/09/18.
//  Copyright © 2018 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PolycabFooter : UIView<UITabBarDelegate>
+(PolycabFooter*) createInstance;
-(void)config;
@property (weak, nonatomic) IBOutlet UITabBar *tabBar;

@end
