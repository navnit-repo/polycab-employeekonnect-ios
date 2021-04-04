//
//  XMWFaqWebViewController.m
//  QCMSProject
//
//  Created by Ashish Tiwari on 07/10/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//


#import "XMWFaqWebViewController.h"
#import "XmwcsConstant.h"

@interface XMWFaqWebViewController ()

@end

@implementation XMWFaqWebViewController


@synthesize webView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if(isiPhone5) {
        self.view.frame = CGRectMake(0, 64, 320, 504);
    } else {
        // 0, 64, 320, 416
        self.view.frame = CGRectMake(0, 64, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height - 64.0f);
    }
    
    // Do any additional setup after loading the view from its nib.
    [self startWebViewLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//programmer defined method to load the webpage
-(void)startWebViewLoad{
    
    // please check with any url
	NSString *urlAddress = XmwcsConst_MKONNECT_FAQ_URL;
	//Create a URL object.
	NSURL *url = [NSURL URLWithString:urlAddress];
	
	//URL Requst Object
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
	
	//Load the request in the UIWebView.
	[webView loadRequest:requestObj];
	
}

@end
