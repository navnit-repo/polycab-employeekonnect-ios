//
//  CreateOrderDashView.m
//  XMWClient
//
//  Created by dotvikios on 20/12/17.
//  Copyright © 2017 dotvik. All rights reserved.
//

#import "CreateOrderDashView.h"

@implementation CreateOrderDashView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+(CreateOrderDashView*) createInstance
{
    
    CreateOrderDashView *view = (CreateOrderDashView *)[[[NSBundle mainBundle] loadNibNamed:@"CreateOrderDashView" owner:self options:nil] objectAtIndex:0];
    
    
    return view;
}
@end
