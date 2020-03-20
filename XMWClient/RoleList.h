//
//  RoleList.h
//  XMWClient
//
//  Created by dotvikios on 24/07/18.
//  Copyright © 2018 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface RoleList : UIView
+(RoleList*) createInstance:(CGFloat)yOrigin;
-(void)configure:(NSDictionary *)dict;
@property (weak, nonatomic) IBOutlet UIView *constantView1;
@property (weak, nonatomic) IBOutlet UIButton *constantView2;
@property (weak, nonatomic) IBOutlet UIImageView *constantView3;

@property (weak, nonatomic) IBOutlet UILabel *constantView4;




@property (weak, nonatomic) IBOutlet UIButton *checkBoxButton;
@property (weak, nonatomic) IBOutlet UILabel *rolelistLable;
@property (weak, nonatomic) IBOutlet UIImageView *checkBoxImageView;
@end
