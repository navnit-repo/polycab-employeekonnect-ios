//
//  XmwWebViewController.h
//  DotvikAdMofi
//
//  Created by Pradeep Singh on 3/18/14.
//  Copyright (c) 2014 Dotvik Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XmwWebViewController : UIViewController <UIWebViewDelegate>
{
    IBOutlet UIWebView* webView;
    NSString* adUrl;
    UIImageView  *imageView;
}


@property (strong, nonatomic) IBOutlet UIWebView* webView;
@property NSString* adUrl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withAdURL:(NSString*) url;


@property  NSMutableArray* downloadHistoryMenuList;
@property  UIImageView  *imageView;

@end
