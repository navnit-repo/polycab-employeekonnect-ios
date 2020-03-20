//
//  Data.m
//  XMWClient
//
//  Created by dotvikios on 23/07/18.
//  Copyright © 2018 dotvik. All rights reserved.
//

#import "Data.h"
#import "LayoutClass.h"
@implementation Data
@synthesize userId;
@synthesize regId;
@synthesize editTouchButton;
+(Data*) createInstance:(CGFloat)yOrigin

{
    
    Data *view = (Data *)[[[NSBundle mainBundle] loadNibNamed:@"Data" owner:self options:nil] objectAtIndex:0];
    
    CGRect frame = view.frame;
    frame.origin.y = yOrigin;
    view.frame = frame;
    return view;
}
-(void)autoLayout{
    [LayoutClass setLayoutForIPhone6:self.constantView1];
    [LayoutClass setLayoutForIPhone6:self.constantView4];
    [LayoutClass labelLayout:self.constantView2 forFontWeight:UIFontWeightRegular];
     [LayoutClass labelLayout:self.constantView3 forFontWeight:UIFontWeightRegular];
}
- (void)configure:(NSDictionary *)dict{
    [self autoLayout];
    
    [editTouchButton setTitle:[NSString stringWithFormat:@"%@",[dict valueForKey:@"userrefid"]] forState:UIControlStateNormal];
    editTouchButton.titleLabel.textColor = [UIColor clearColor];
    self.userId.text = [NSString stringWithFormat:@"%@",[dict valueForKey:@"firstname"]];
    self.regId.text = [NSString stringWithFormat:@"%@",[dict valueForKey:@"userid"]];
}

- (IBAction)EditButton:(id)sender {
    UIButton* button = (UIButton*)sender;
    NSString* title =  [NSString stringWithFormat:@"%@",button.titleLabel.text];
    NSLog(@"Selected User RefID-%@",title);
    NSString *user  = self.userId.text;
    NSString *regid = self.regId.text;
    [ self.delegate userID_RegID:user :regid refID:title];
   
}

@end
