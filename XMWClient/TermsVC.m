//
//  TermsVC.m
//  XMWClient
//
//  Created by dotvikios on 16/07/18.
//  Copyright © 2018 dotvik. All rights reserved.
//

#import "TermsVC.h"
#import "NetworkHelper.h"
#import "XmwcsConstant.h"
#import "LoadingView.h"
#import "LogInVC.h"
#import "LayoutClass.h"
@interface TermsVC ()

@end

@implementation TermsVC
{
     NetworkHelper *networkHelper;
    LoadingView *loadingView;
    NSMutableArray *languageArray;
    NSString *defaultLanguageURL;
    BOOL show;
    UITableView *rightView;
    NSString *languageName;
    int langTag;
}
@synthesize displayLangName;
@synthesize webView;
@synthesize regID;
@synthesize password;
-(void)autoLayout{
    
    [LayoutClass labelLayout:self.displayLangName forFontWeight:UIFontWeightRegular];
    [LayoutClass buttonLayout:self.constant1 forFontWeight:UIFontWeightRegular];
    [LayoutClass setLayoutForIPhone6:self.constant2];
    [LayoutClass setLayoutForIPhone6:self.constant3];
    [LayoutClass buttonLayout:self.constant4 forFontWeight:UIFontWeightBold];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.constant4.layer.masksToBounds = YES;
    self.constant4.layer.cornerRadius = 5.0f;
    [self autoLayout];
    [self setNavBar];
    // Do any additional setup after loading the view from its nib.

    show = YES;
    languageArray = [[NSMutableArray alloc]init];
    
    //Network Call for Language List
    NSMutableDictionary * terms = [[NSMutableDictionary  alloc]init];
    [terms setObject:@"termsandcondition" forKey:@"opcode"];
    [terms setObject:@"" forKey:@"data"];
    [terms setObject:@"" forKey:@"authToken"];
    networkHelper = [[NetworkHelper alloc]init];
    NSString * url=XmwcsConst_OPCODE_URL;
    networkHelper.serviceURLString = url;
    [networkHelper genericJSONPayloadRequestWith:terms :self :@"Language_List_Fetch"];
    loadingView= [LoadingView loadingViewInView:self.view];
    
}
-(void)setNavBar{
    self.navigationController.navigationBarHidden = NO;
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage
                                                                          imageNamed:@"back-button.png"] style:UIBarButtonItemStylePlain target:self
                                                                  action:@selector(backHandler:)];
    
    backButton.tintColor = [UIColor colorWithRed:119.0/255 green:119.0/255 blue:119.0/255 alpha:1.0];
    
    
    [self.navigationItem setLeftBarButtonItem:backButton];
}
- (void) backHandler : (id) sender
{
    
    
    [ [self navigationController]  popViewControllerAnimated:YES];
    
}
- (IBAction)languageSelectButton:(id)sender {
    if (show==YES) {
        rightView= [[UITableView alloc]init];
        rightView.delegate = self;
        rightView.dataSource = self;
        rightView.bounces = NO;
        rightView.frame = CGRectMake((self.view.bounds.size.width/2),60, (self.view.bounds.size.width/2), self.view.bounds.size.height);
        [self.view addSubview:rightView];
        show= NO;
    }
    else{
        
        [rightView removeFromSuperview];
        show = YES;
    }
  
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [languageArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        for (int i=0; i<languageArray.count; i++) {
            if (indexPath.row == i) {
                cell.textLabel.text = [[languageArray objectAtIndex:i]valueForKey:@"displaytext"];
                cell.textLabel.textAlignment = UITextAlignmentCenter;
                cell.tag = i;
    
            }
        }
    }
  
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    defaultLanguageURL= [[languageArray objectAtIndex:indexPath.row]valueForKey:@"urls"];
    languageName = [[languageArray objectAtIndex:indexPath.row]valueForKey:@"displaytext"];
    [rightView removeFromSuperview];
    loadingView= [LoadingView loadingViewInView:self.view];
    int tag = indexPath.row;
    [self loadWebView:tag];
    
}

-(void)loadWebView :(int)tag{
    langTag = tag;
    [webView setDelegate:self];
    displayLangName.text = languageName;
    NSString *urlAddress = defaultLanguageURL;
    NSURL *url = [NSURL URLWithString:urlAddress];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [webView loadRequest:requestObj];
    
    

}
-(void)webViewDidFinishLoad:(UIWebView *)webView {
    [loadingView removeView];
}
- (void) httpResponseObjectHandler : (NSString*) callName : (id) respondedObject : (id) requestedObject
{
   if([callName isEqualToString:@"Language_List_Fetch"])
   {
       if ([[respondedObject valueForKey:@"status"]isEqualToString:@"SUCCESS"]) {
           [languageArray addObjectsFromArray:[respondedObject valueForKey:@"responseData"]];
           NSLog(@"Language List: %@",languageArray);
           defaultLanguageURL= [[languageArray objectAtIndex:0]valueForKey:@"urls"];
           languageName = [[languageArray objectAtIndex:0]valueForKey:@"displaytext"];
           [self loadWebView:0];
          
       }
       
   }
    if([callName isEqualToString:@"acceptButtonClick"])
    {
        if ([[respondedObject valueForKey:@"status"]isEqualToString:@"SUCCESS"]) {
            //save user Detalis is sucessfully login
            [[NSUserDefaults standardUserDefaults] setObject:regID forKey:@"USERNAME"];
            [[NSUserDefaults standardUserDefaults] setObject:password forKey:@"PASSWORD"];
            [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"ISCHECKED"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [loadingView removeView];
            LogInVC *vc = [[LogInVC alloc]init];
            [[self navigationController]pushViewController:vc animated:YES];
            
        }
        
    }
    
   
    
}
- (void) httpFailureHandler : (NSString*) callName : (NSString*) message {
    
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Polycab Authentication!" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
    [myAlertView show];
    
}
- (IBAction)acceptButton:(id)sender {
    //network call
    NSMutableDictionary * termsAccept = [[NSMutableDictionary  alloc]init];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    
    [termsAccept setObject:@"acceptterms" forKey:@"opcode"];
    [termsAccept setObject:@"" forKey:@"authToken"];
    [dict setObject:regID forKey:@"registryid"];
    [dict setObject:[[languageArray objectAtIndex:langTag] valueForKey:@"languages_type"]  forKey:@"language"];
    [dict setObject:@"1" forKey:@"agree"];
    [dict setObject:@"0" forKey:@"disagree"];
    [dict setObject:[[languageArray objectAtIndex:langTag] valueForKey:@"version"] forKey:@"version"];
    
    [termsAccept setObject:dict forKey:@"data"];
    
    networkHelper = [[NetworkHelper alloc]init];
    NSString * url=XmwcsConst_OPCODE_URL;
    networkHelper.serviceURLString = url;
    [networkHelper genericJSONPayloadRequestWith:termsAccept :self :@"acceptButtonClick"];
    loadingView= [LoadingView loadingViewInView:self.view];
}
@end
