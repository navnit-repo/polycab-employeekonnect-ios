//
//  XmwNotificationWebViewController.h
//  QCMSProject
//
//  Created by Ashish Tiwari on 24/09/14.
//  Copyright (c) 2014 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XmwNotificationWebViewController : UIViewController
{
    UIWebView *webView;
    UIActivityIndicatorView* loadingIndicator;
    NSString *urlString;
}
@property (nonatomic, retain) IBOutlet UIWebView* webView;
@property UIActivityIndicatorView *loadingIndicator;
@property NSString *urlString;
@end
