//
//  PolycabFooter.m
//  XMWClient
//
//  Created by dotvikios on 06/09/18.
//  Copyright © 2018 dotvik. All rights reserved.
//

#import "PolycabFooter.h"
#import "DotMenuObject.h"

@implementation PolycabFooter
@synthesize tabBar;
+(PolycabFooter*) createInstance

{
    
    PolycabFooter *view = (PolycabFooter *)[[[NSBundle mainBundle] loadNibNamed:@"PolycabFooter" owner:self options:nil] objectAtIndex:0];
    return view;
}
- (void)config{
    tabBar.delegate = self;
}
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if (item.tag == 0) {
        NSLog(@"Click on Home");
        //        DotMenuObject * obj = [[DotMenuObject alloc]init];
        //        obj.FORM_ID = @"";
        
    }
    if (item.tag == 1) {
        NSLog(@"Click on Create Order");
        DotMenuObject * obj = [[DotMenuObject alloc]init];
        obj.FORM_ID = @"DOT_FORM_3";
        obj.FORM_TYPE = @"VIEW";
       // [self clickedDashBoardDelegate:1 :obj :@"tab bar clicked"];
    }
    if (item.tag == 2) {
        NSLog(@"Click on My Details");
        DotMenuObject * obj = [[DotMenuObject alloc]init];
        obj.FORM_ID = @"DOT_REPORT_MYDETAIL$CLASSLOADER";
        obj.FORM_TYPE = @"VIEW_DIRECT";
     //   [self clickedDashBoardDelegate:2 :obj :@"tab bar clicked"];
    }
    if (item.tag == 3) {
        NSLog(@"Click on Feedback");
        DotMenuObject * obj = [[DotMenuObject alloc]init];
        obj.FORM_ID = @"DOT_FORM_FEEDBACK";
        obj.FORM_TYPE = @"SUBMIT";
     //   [self clickedDashBoardDelegate:3 :obj :@"tab bar clicked"];
    }
}
@end
