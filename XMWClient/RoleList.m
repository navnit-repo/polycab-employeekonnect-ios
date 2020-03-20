//
//  RoleList.m
//  XMWClient
//
//  Created by dotvikios on 24/07/18.
//  Copyright © 2018 dotvik. All rights reserved.
//

#import "RoleList.h"
#import "LayoutClass.h"

@implementation RoleList
{
    BOOL click;
}
@synthesize checkBoxButton;
@synthesize rolelistLable;
@synthesize checkBoxImageView;

+(RoleList*) createInstance:(CGFloat)yOrigin

{
    RoleList *view = (RoleList *)[[[NSBundle mainBundle] loadNibNamed:@"RoleList" owner:self options:nil] objectAtIndex:0];
    
    CGRect frame = view.frame;
    frame.origin.y = yOrigin;
    view.frame = frame;
    return view;
}
-(void)autoLayout{
    [LayoutClass setLayoutForIPhone6:self.constantView1];
    [LayoutClass setLayoutForIPhone6:self.constantView2];
    [LayoutClass setLayoutForIPhone6:self.constantView3];
    
    [LayoutClass labelLayout:self.constantView4 forFontWeight:UIFontWeightRegular];
}
- (void)configure:(NSDictionary *)dict{
    [self autoLayout];
    NSLog(@"%@",dict);
    click = true;
    self.checkBoxImageView.image = [UIImage imageNamed:@"checkbox.png"];
    [checkBoxButton setTitle:[NSString stringWithFormat:@"%@",[dict valueForKey:@"roleId"]] forState:UIControlStateNormal];
    checkBoxButton.titleLabel.textColor = [UIColor clearColor];
     self.rolelistLable.text = [dict valueForKey:@"roleName"];
}


- (IBAction)checkBoxClickedButton:(id)sender {
    UIButton* button = (UIButton*)sender;
    NSString* title =  [NSString stringWithFormat:@"%@",button.titleLabel.text];
    NSLog(@"Selected Role RefID-%@",title);
    if (click) {
         self.checkBoxImageView.image = [UIImage imageNamed:@"checkedbox.png"];
        checkBoxButton.tag = 1;
        click = false;
    }
   else if (click == false) {
        self.checkBoxImageView.image = [UIImage imageNamed:@"checkbox.png"];
       checkBoxButton.tag = 0;
        click = true;
    }
}

@end
