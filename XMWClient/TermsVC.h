//
//  TermsVC.h
//  XMWClient
//
//  Created by dotvikios on 16/07/18.
//  Copyright © 2018 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TermsVC : UIViewController<UIWebViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSString *regID;
    NSString *password;
}
@property NSString *regID;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UILabel *displayLangName;
@property (weak, nonatomic) IBOutlet UIButton *constant1;
@property (weak, nonatomic) IBOutlet UIImageView *constant2;
@property (weak, nonatomic) IBOutlet UIWebView *constant3;
@property (weak, nonatomic) IBOutlet UIButton *constant4;
@property NSString *password;
@end
