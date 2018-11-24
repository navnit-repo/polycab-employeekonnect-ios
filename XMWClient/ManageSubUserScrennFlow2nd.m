//
//  ManageSubUserScrennFlow2nd.m
//  XMWClient
//
//  Created by dotvikios on 23/07/18.
//  Copyright © 2018 dotvik. All rights reserved.
//

#import "ManageSubUserScrennFlow2nd.h"
#import "NetworkHelper.h"
#import "LoadingView.h"
#import "Data.h"
#import "CreateSubUserVC.h"
#import "ManageSubUserEdit.h"
#import "XmwcsConstant.h"
#import "LayoutClass.h"
#import "ManageSubUserVC.h"
#define  DataViewStartTag 1000
@interface ManageSubUserScrennFlow2nd ()

@end

@implementation ManageSubUserScrennFlow2nd
{
    NetworkHelper *networkHelper;
    LoadingView *loadingView;
    Data *dataView;
    NSMutableDictionary *fetchData;
     int cellConut;
    long int viewCartHeight;
    int i;
    int j;
    
}
@synthesize authToken;
@synthesize scroll;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.constantView1.layer.masksToBounds = YES;
    self.constantView1.layer.cornerRadius = 5.0f;
    
    [self autoLayout];
    [self setNavigationBar];
    NSLog(@"%@",authToken);
    [self netWorkCAll];
}
-(void)setNavigationBar{
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage
                                                                          imageNamed:@"back-button.png"] style:UIBarButtonItemStylePlain target:self
                                                                  action:@selector(backHandler:)];
    
    backButton.tintColor = [UIColor colorWithRed:119.0/255 green:119.0/255 blue:119.0/255 alpha:1.0];
    
    
    [self.navigationItem setLeftBarButtonItem:backButton];
    
    UIImageView *polycabLogo = [[UIImageView alloc] initWithImage:[UIImage  imageNamed:@"polycab_logo"]];
    self.navigationItem.titleView.contentMode = UIViewContentModeCenter;
    self.navigationItem.titleView = polycabLogo;
    
}
- (void) backHandler : (id) sender
{
    [[self navigationController]  popViewControllerAnimated:YES];
}
-(void)autoLayout{
    
    [LayoutClass buttonLayout:self.constantView1 forFontWeight:UIFontWeightBold];
    [LayoutClass setLayoutForIPhone6:self.constantView2];
    
}
-(void)dataLoad{
     NSArray* responseData = [fetchData objectForKey:@"data"];
    viewCartHeight = viewCartHeight + [responseData count];
     for ( i=0 ; i < responseData.count; i++) {
     dataView = [Data createInstance: cellConut*40];
     dataView.delegate = self;
     cellConut = cellConut+1;
     dataView.tag = DataViewStartTag + j;
     [dataView configure:[responseData objectAtIndex:i]];
     [scroll addSubview:dataView];
     j= j+1;
     }

[scroll setContentSize:CGSizeMake(self.scroll.frame.size.width , (viewCartHeight *40))];
}
-(void)netWorkCAll{
    
    //network Call
    loadingView= [LoadingView loadingViewInView:self.view];
    NSString *userName;
    userName= [[NSUserDefaults standardUserDefaults] objectForKey:@"USERNAME"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc]init];
    [data setObject:userName forKey:@"registry_id"];
    NSMutableDictionary *subUserDict = [[NSMutableDictionary alloc]init];
    [subUserDict setObject:data forKey:@"data"];
    [subUserDict setObject:authToken forKey:@"authToken"];
    [subUserDict setValue:@"subuserlist" forKey:@"opcode"];
    
    
    networkHelper = [[NetworkHelper alloc]init];
    NSString * url=XmwcsConst_OPCODE_URL;
    networkHelper.serviceURLString = url;
    [networkHelper genericJSONPayloadRequestWith:subUserDict :self :@"subuserlist"];
}


- (void)httpResponseObjectHandler:(NSString *)callName :(id)respondedObject :(id)requestedObject{
    [loadingView removeView];
    if ( [callName isEqualToString:@"subuserlist"]) {
        if([[respondedObject valueForKey:@"status"]isEqualToString:@"SUCCESS"])
        {
            
            fetchData = [[NSMutableDictionary alloc]init];
            [fetchData setDictionary:respondedObject];
            NSLog(@"%@",fetchData);
            [self dataLoad];
        }
    }
}
- (void) httpFailureHandler : (NSString*) callName : (NSString*) message {
    [loadingView removeView];
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Polycab Authentication!" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
    [myAlertView show];
    
}

- (IBAction)addButton:(id)sender {
    CreateSubUserVC *vc = [[CreateSubUserVC alloc]init];
    vc.auth_Token = authToken;
    [self.navigationController pushViewController:vc animated:YES];
}



- (void)userID_RegID:(NSString *)userID :(NSString *)regcode refID:(NSString *)userRefID{
    ManageSubUserEdit *vc = [[ManageSubUserEdit alloc]init];
    vc.userid = userID;
    vc.regID = regcode;
    vc.authToken = authToken;
    vc.subuserrefid = userRefID;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
