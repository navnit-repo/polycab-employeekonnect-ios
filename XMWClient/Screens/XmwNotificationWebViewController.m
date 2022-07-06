//
//  XmwNotificationWebViewController.m
//  QCMSProject
//
//  Created by Ashish Tiwari on 24/09/14.
//  Copyright (c) 2014 dotvik. All rights reserved.
//

#import "XmwNotificationWebViewController.h"

@interface XmwNotificationWebViewController ()
{
    
}

@end

@implementation XmwNotificationWebViewController
@synthesize webView;
@synthesize loadingIndicator;
@synthesize urlString;

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
    // Do any additional setup after loading the view from its nib.
    //urlString = @"http://timesofindia.indiatimes.com";
    
    NSLog(@"XmwNotificationWebViewController: urlString = %@", urlString);
    
    [self setUrlInWebView : urlString];
}


-(void)setUrlInWebView : (NSString *)Url
{
    int yCoord = (self.view.bounds.size.height - 200) /2;
    int xCoord = (self.view.bounds.size.width - 200) / 2;
    self.loadingIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(xCoord, yCoord, 200,200)];
    [loadingIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [loadingIndicator setHidesWhenStopped:YES];
    [self.webView addSubview:loadingIndicator];
    
    
    self.webView.delegate = self;
    //self.webView.scalesPageToFit = YES;
    NSURL* url = [NSURL URLWithString:Url];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
   
    
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}
/**
 * \brief Updates the forward, back and stop buttons.
 */


// MARK: -
// MARK: UIWebViewDelegate protocol
/**
 * \brief
 *
 * This is called for more than just the toplevel page so is not ideal for
 * updating the loading URL.
 *
 * \param navigationType is one of:
 * <ol>
 * <li>UIWebViewNavigationTypeFormSubmitted,</li>
 * <li>UIWebViewNavigationTypeBackForward,</li>
 * <li>UIWebViewNavigationTypeReload,</li>
 * <li>UIWebViewNavigationTypeFormResubmitted,</li>
 * <li>UIWebViewNavigationTypeOther.</li>
 * </ol>
 */
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [loadingIndicator startAnimating];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [loadingIndicator stopAnimating];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [loadingIndicator stopAnimating];
    //NSLog(@"Error for WEBVIEW: %@", [error description]);
    
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error!" message:[error description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
    //[myAlertView show];
    
}




@end
