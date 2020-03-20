//
//  WebViewController.m
//  QCMSProject
//
//  Created by dotvikios on 06/09/17.
//  Copyright © 2017 dotvik. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withWebURL:(NSString*) url
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self!=nil)  {
        self.webUrl = url;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if(![self.webUrl isEqualToString:@""]) {
        [self startWebViewLoad];
    }

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
//programmer defined method to load the webpage
-(void)startWebViewLoad{
    
    // please check with any url
    NSString *urlAddress = self.webUrl;
    //Create a URL object.
    NSURL *url = [NSURL URLWithString:urlAddress];
    
    //URL Requst Object
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    self.webView.delegate = self;
    
    //Load the request in the UIWebView.
    [self.webView loadRequest:requestObj];
    
}


#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    /*
     int yCoord = (self.view.bounds.size.height - 200) /2;
     int xCoord = (self.view.bounds.size.width - 200) / 2;
     UIActivityIndicatorView* activityIndicator  = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(xCoord, yCoord, 200, 200)];
     activityIndicator.tag = 1001;
     activityIndicator.backgroundColor = [UIColor clearColor];
     [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
     [self.view addSubview:activityIndicator];
     [activityIndicator startAnimating];
     */
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    /*
     UIActivityIndicatorView* activityIndicator = (UIActivityIndicatorView*)[self.view viewWithTag:1001];
     if(activityIndicator!=nil) {
     [activityIndicator stopAnimating];
     [activityIndicator removeFromSuperview];
     }
     */
}


-(IBAction)backButtonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
/*http://perrymitchell.net/article/communication-between-javascript-ios-using-uiwebview-base64/*/

/*
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([request.URL.scheme isEqualToString:@"inapp"]) {
        if ([request.URL.host isEqualToString:@"capture"]) {
            // do capture action
        }
        return NO;
    }
    
    return YES;
}
 */
@end
