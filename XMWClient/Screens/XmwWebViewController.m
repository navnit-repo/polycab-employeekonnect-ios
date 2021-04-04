//
//  XmwWebViewController.m
//  Dotvik XMW
//
//  Created by Pradeep Singh on 3/18/14.
//  Copyright (c) 2014 Dotvik Solutions. All rights reserved.
//

#import "XmwWebViewController.h"
#import "XmwHttpFileDownloader.h"

#import "Styles.h"
#import "XmwUtils.h"
#import "DownloadHistoryMenuView.h"

@interface XmwWebViewController ()
{
    
}

@end

@implementation XmwWebViewController

@synthesize downloadHistoryMenuList;
@synthesize imageView;

static bool showMenu = true;
static DownloadHistoryMenuView* rightSlideMenu = nil;

@synthesize adUrl;
@synthesize webView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.adUrl = @"";
    }
    return self;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withAdURL:(NSString*) url
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.adUrl = url;
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
    if(![adUrl isEqualToString:@""]) {
        [self startWebViewLoad];
    }
    
    [self drawHeaderItem];
}

-(void) drawHeaderItem
{
    self.title = @"";
    
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(backHandler:)];
    backButton.tintColor = [Styles barButtonTextColor];
    [self.navigationItem setLeftBarButtonItem:backButton];
    
    
    
    
    //animate custom view add
    
    NSArray *images = [NSArray arrayWithObjects:
                       
                       [UIImage imageNamed:@"downloadImage.png"],
                       
                       [UIImage imageNamed:@"downloadImage1.png"],
                       
                       [UIImage imageNamed:@"downloadImage2.png"],
                       
                       [UIImage imageNamed:@"downloadImage3.png"],
                       
                       nil];
    
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage  imageNamed:@"downloadImage.png"]];
    
    self.imageView.animationImages = images;
    
    self.imageView.animationDuration = 0.8;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.bounds = imageView.bounds;
    
    [button addSubview:imageView];
    
    [button addTarget:self action:@selector(downloadButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView: button] ;
    
    
    [self.navigationItem setRightBarButtonItem:rightBarButton];
    
    
}

- (void) backHandler : (id) sender {
    [ [self navigationController]  popViewControllerAnimated:YES];
    
    }


//programmer defined method to load the webpage
-(void)startWebViewLoad{
    
    // please check with any url
	NSString *urlAddress = adUrl;
	//Create a URL object.
	NSURL *url = [NSURL URLWithString:urlAddress];
	
	//URL Requst Object
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    webView.delegate = self;
	
	//Load the request in the UIWebView.
	[webView loadRequest:requestObj];
	
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    int yCoord = (self.view.bounds.size.height - 200) /2;
    int xCoord = (self.view.bounds.size.width - 200) / 2;
    UIActivityIndicatorView* activityIndicator  = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(xCoord, yCoord, 200, 200)];
    activityIndicator.tag = 1001;
    activityIndicator.backgroundColor = [UIColor clearColor];
    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:activityIndicator];
    [activityIndicator startAnimating];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	
	UIActivityIndicatorView* activityIndicator = (UIActivityIndicatorView*)[self.view viewWithTag:1001];
    if(activityIndicator!=nil) {
        [activityIndicator stopAnimating];
        [activityIndicator removeFromSuperview];
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"XmwWebViewController: webView shouldStartLoadWithRequest navigationType");
    
    if(navigationType == UIWebViewNavigationTypeLinkClicked) {
        NSLog(@"UIWebViewNavigationTypeLinkClicked %@", [[request  URL]  absoluteString] );
        
        NSString* userClickedURL = [[request  URL]  absoluteString];
        NSArray *arr = [userClickedURL componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"?=/."]];
        if([arr count] > 1) {
            NSString* fileExt = [arr objectAtIndex:([arr count] -1)];
            NSLog(@"File extension of the URL to download is %@", fileExt);
            
            if( [self isFileDownloadable:fileExt]) {
                
                [XmwUtils toastView:@"Your Downloading Start"];
                
                [self.imageView startAnimating];
                
                XmwHttpFileDownloader* fileDownloader = [[XmwHttpFileDownloader alloc] initWithUrl:userClickedURL];
                // TODO Later: we need to replace these username and password with the user
                [fileDownloader downloadStart:self username:@"czz9999" password:@"crm123"];
                return NO;
            } else {
                return YES;
            }
        }
        
    } else if(navigationType == UIWebViewNavigationTypeFormSubmitted) {
        NSLog(@"UIWebViewNavigationTypeFormSubmitted ");
    } else if(navigationType == UIWebViewNavigationTypeBackForward) {
        NSLog(@"UIWebViewNavigationTypeBackForward ");
    } else if(navigationType == UIWebViewNavigationTypeReload) {
        NSLog(@"UIWebViewNavigationTypeReload ");
    } else if(navigationType == UIWebViewNavigationTypeFormResubmitted) {
        NSLog(@"UIWebViewNavigationTypeFormResubmitted ");
    } else if(navigationType == UIWebViewNavigationTypeOther) {
        NSLog(@"UIWebViewNavigationTypeOther ");
    }
    
    
    return YES;
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"webView didFailLoadWithError %@", error.description);
    
}

// file downloadable when its extension is PDF, PNG, JPG, DOC, DOCX
- (BOOL) isFileDownloadable:(NSString*) fileExt
{
    BOOL retVal = NO;
    NSArray* downloadExtensions = [[NSArray alloc] initWithObjects:@"PDF", @"PNG", @"JPG", @"DOC", @"DOCX", @"XLS", @"XLSX",  nil];
    
    for(int idx=0; idx<[downloadExtensions count]; idx++) {
        
        if([fileExt compare:[downloadExtensions objectAtIndex:idx] options:NSCaseInsensitiveSearch]==NSOrderedSame) {
            retVal = YES;
            break;
        }
    }
    return retVal;
    
}

//code added by ashish tiwari
-(void)setDataInDownloadHistoryMenuViewList
{
    NSMutableArray *directoryStack = [[NSMutableArray alloc] init];
    NSArray *dirPaths;
    NSMutableArray *directoryFiles;
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = dirPaths[0];
    
    [directoryStack addObject:docsDir];
    
    NSLog(@"XmwFileExplorer: Document Directory = %@ ", docsDir);
    if([directoryStack count] >0) {
        NSString* currentDir = [directoryStack objectAtIndex:([directoryStack count] -1)];
        directoryFiles = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:currentDir error:nil];
        NSLog(@"%@", directoryFiles);
    }
    
    
    downloadHistoryMenuList = [[NSMutableArray alloc] init];
    for (int i =0; i<[directoryFiles count]; i++)
    {
        NSString *fileName  =    [directoryFiles objectAtIndex:i];
        NSRange range = [fileName rangeOfString:@".db"];
        NSRange rangeStorage = [fileName rangeOfString:@"MAIN_OBJECT_STORAGE"];
        if(range.length > 0)
        {
            //no need to add file in download history array
        }
        else if(rangeStorage.length>0)
        {
            //again no need to add file in doownload history
        }
        else
        {
            [downloadHistoryMenuList addObject:fileName];
            
        }
    }
    
    
}

- (void) downloadButtonHandler : (id) sender
{
    // [self.imageView stopAnimating];
    [self setDataInDownloadHistoryMenuViewList];
    
    
    if(showMenu)
    {
        rightSlideMenu = [[DownloadHistoryMenuView alloc] initWithFrame:CGRectMake( self.view.bounds.size.width/2, -250, self.view.bounds.size.width/2, [downloadHistoryMenuList count]*40) withMenu:downloadHistoryMenuList handler:self];
        
        [self.view addSubview : rightSlideMenu];
        
        [UIView beginAnimations:@"rightSlideMenu" context:nil];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationDelay:0.1];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        
        rightSlideMenu.frame = CGRectMake( self.view.bounds.size.width/2, 0.0f, self.view.bounds.size.width/2, [downloadHistoryMenuList count]*40);
        
        [UIView commitAnimations];
        
        showMenu = false;
        
    }
    else
    {
        [UIView beginAnimations:@"rightSlideMenu" context:nil];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationDelay:0.1];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(menuRemoved:)];
        rightSlideMenu.frame = CGRectMake( self.view.bounds.size.width/2, -250, self.view.bounds.size.width/2, [downloadHistoryMenuList count]*40);
        [UIView commitAnimations];
        
        showMenu = true;
    }
    
    
}

-(IBAction)menuRemoved:(id)sender
{
    //NSLog(@"menuRemoved");
    [rightSlideMenu removeFromSuperview];
    
}

-(void) downloadHistoryClicked : (int) idx
{
    //NSLog(@"Shared menu clicked with idx %d", idx);
    [rightSlideMenu removeFromSuperview];
    showMenu = true;
    
}

-(void) downloadCompleted :(NSString*) savedFilename
{
    NSLog(@"control comes on download Complete Function");
    
    [self.imageView stopAnimating];
    
    [XmwUtils toastView:@"Download Complete"];
    
    
}
-(void) percentDownloadComplete : (float) percent
{
    NSLog(@"control comes on percent download Complete Function = %f", percent);
    
    
}


@end
