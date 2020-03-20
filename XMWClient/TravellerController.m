//
//  TravellerController.m
//  QCMSProject
//
//  Created by Ashish Tiwari on 01/10/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//

#import "TravellerController.h"
#import "ClientUserLogin.h"
#import "XmwcsConstant.h"
#import "ObjectStorage.h"

@interface TravellerController ()

@end

@implementation TravellerController
@synthesize userName;
@synthesize password;

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
    
    
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIColor whiteColor],NSForegroundColorAttributeName,
                                    [UIColor whiteColor],NSBackgroundColorAttributeName,nil];
    
    self.navigationController.navigationBar.titleTextAttributes = textAttributes;
    // self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    
    UILabel*  titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 220, 40)];
    titleLabel.text = @"Traveller Authentication";
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    [self.navigationItem setTitleView: titleLabel];
    
    // Do any additional setup after loading the view from its nib.
    UIImage *blueImage          = [UIImage imageNamed:@"blueButton.png"];
	UIImage *blueButtonImage    = [blueImage stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	UIButton *travelerAuthenticationLoginButton       = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[travelerAuthenticationLoginButton setFrame:CGRectMake( 72.0f, 250.0f, 180.0f, 36.0f)];
	[travelerAuthenticationLoginButton setBackgroundImage:blueButtonImage forState:UIControlStateNormal];
	[travelerAuthenticationLoginButton setTitleColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0] forState: UIControlStateNormal];
	[travelerAuthenticationLoginButton setTitle:@"Login" forState:UIControlStateNormal];
    [travelerAuthenticationLoginButton addTarget:self action:@selector(travelerAuthenticationLoginButton:) forControlEvents:UIControlEventTouchUpInside];
	
	
    [self.view addSubview:travelerAuthenticationLoginButton];
    
   	[userName setPlaceholder:@"Username@havells.com"];
    [password setPlaceholder:@"Password"];
    userName.delegate    = self;
    password.delegate    = self;
    password.secureTextEntry = YES;
    
     self.title = @"Traveler Authentication";
    
    
    NSMutableDictionary* travellerDetails = [[ObjectStorage getInstance]readJsonObject:@"TRAVELLER"];
	if(travellerDetails) {
		
        userName.text = [travellerDetails objectForKey:@"USERNAME"];
		
        password.text = [travellerDetails objectForKey:@"PASSWORD"];
		
		[self makeAuthCall];
	}
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)travelerAuthenticationLoginButton:(id)sender
{
    
    
    [self makeAuthCall];
    
    
}
-(void)makeAuthCall
{
    loadingView = [LoadingView loadingViewInView:self.view];
    NSURL *url                      = [NSURL URLWithString: XmwcsConst_HAVELLS_TRAVELLER_URL];
    NSMutableURLRequest *request    = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
        
    NSURLConnection* urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [urlConnection start];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
        
    [textField resignFirstResponder];
    
    return TRUE;
}


// Connection Authentication

- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    NSLog(@"Implementing for Traveler auth : (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge");
    
     if ([challenge previousFailureCount] == 0) {
         NSURLCredential* urlCredentials = [NSURLCredential credentialWithUser:userName.text password:password.text persistence:NSURLCredentialPersistenceNone];
    
         [[challenge sender] useCredential:urlCredentials forAuthenticationChallenge:challenge];
     } else {
         [[challenge sender] cancelAuthenticationChallenge:challenge];
     }
    
}

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    
    NSLog(@"Not implemented : connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace ");
    
    
    return false;
}


- (void)connection:(NSURLConnection *)connection didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    
    NSLog(@"Not implemented : - (void)connection:(NSURLConnection *)connection didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge ");
    
    
    
}


- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    
    NSLog(@"Not implemented : - (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge");
    
    
    
}


- (BOOL)connectionShouldUseCredentialStorage:(NSURLConnection *)connection {
    
    NSLog(@"Not implemented : - (BOOL)connectionShouldUseCredentialStorage:(NSURLConnection *)connection");
    
    return false;
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
     [loadingView removeFromSuperview];
    NSLog (@"Not implemented : - (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error");
    NSString *message = @"Please Provide Correct Credential?";
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Traveler Auth Failure!" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
    [myAlertView show];

    
}


- (NSInputStream *)connection:(NSURLConnection *)connection needNewBodyStream:(NSURLRequest *)request {
    NSLog(@"Not implemented : - (NSInputStream *)connection:(NSURLConnection *)connection needNewBodyStream:(NSURLRequest *)request");
    
    return nil;
}


- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite {
    
    NSLog(@"Not implemented : - (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite");
    
    
}


// there will be repeat calls and data needs to be appended
// Sent as a connection loads data incrementally.
// The newly available data. The delegate should concatenate the contents of each data object
// delivered to build up the complete data for a URL load.
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSLog(@"To be implemented : - (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data");
    NSLog(@"Data Received = %d", data.length);
    
   
}


// Sent when the connection has received sufficient data to construct the URL response for its request.
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    NSLog(@"To be implemented : - (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response");
    
    // – expectedContentLength
    // – suggestedFilename
    // – MIMEType
    // – textEncodingName
    //  – URL
    
    NSLog(@"expectedContentLength = %lld", response.expectedContentLength);
    NSLog(@"MIMEType = %@", response.MIMEType);
    NSLog(@"textEncodingName = %@", response.textEncodingName);
    
    
}


// Sent before the connection stores a cached response in the cache, to give the delegate an opportunity to alter it.
- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse {
    
    NSLog(@"May not implemented : - (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse");
    
    
    
    return nil;
}



// Sent when the connection determines that it must change URLs in order to continue loading a request.
- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponse {
    
    NSLog(@"May not implement: - (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponse ");
    
    return request;
}


//Sent when a connection has finished loading successfully. (required)

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    [loadingView removeFromSuperview];
    
    NSLog(@"(void)connectionDidFinishLoading:(NSURLConnection *)connection");
    
    
    NSMutableDictionary* credMap = [[NSMutableDictionary alloc]init];
    [credMap setObject:userName.text forKey:@"USERNAME"];
    [credMap setObject:password.text forKey:@"PASSWORD"];
    
    [[ObjectStorage getInstance] writeJsonObject:@"TRAVELLER" :credMap];    
    [[ObjectStorage getInstance] flushStorage];
       
    
     PageViewController *pageViewController    = [[PageViewController alloc] initWithNibName:@"PageViewController" bundle:nil];
     [[self navigationController] pushViewController:pageViewController animated:YES];

    
}


@end
