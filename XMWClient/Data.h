//
//  Data.h
//  XMWClient
//
//  Created by dotvikios on 23/07/18.
//  Copyright © 2018 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DataDelegate <NSObject>
-(void) userID_RegID:(NSString*) userID : (NSString*)regcode refID : (NSString *)userRefID;
@end
@interface Data : UIView
+(Data*) createInstance:(CGFloat)yOrigin;
-(void)configure:(NSDictionary *)dict;

@property (weak, nonatomic) IBOutlet UIView *constantView1;
@property (weak, nonatomic) IBOutlet UILabel *constantView2;
@property (weak, nonatomic) IBOutlet UILabel *constantView3;
@property (weak, nonatomic) IBOutlet UIButton *constantView4;




@property (weak, nonatomic) IBOutlet UILabel *userId;
@property (weak, nonatomic) IBOutlet UILabel *regId;
@property (weak,nonatomic) id<DataDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIButton *editTouchButton;

@end
