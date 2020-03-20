//
//  WebViewController.h
//  QCMSProject
//
//  Created by dotvikios on 06/09/17.
//  Copyright © 2017 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController<UIWebViewDelegate>

@property NSString* webUrl;
//@property (nonatomic,retain) NSString* eventId;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withWebURL:(NSString*) url;

@end
