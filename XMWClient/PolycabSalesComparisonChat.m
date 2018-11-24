//
//  PolycabSalesComparisonChat.m
//  XMWClient
//
//  Created by dotvikios on 16/10/18.
//  Copyright © 2018 dotvik. All rights reserved.
//

#import "PolycabSalesComparisonChat.h"
#import "LayoutClass.h"
#import "AppConstants.h"
@interface PolycabSalesComparisonChat ()

@end

@implementation PolycabSalesComparisonChat

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBar];
    [self autoLayout];
    
    
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
    
    
    [ [self navigationController]  popViewControllerAnimated:YES];
    
}

-(void)autoLayout
{
    [LayoutClass setLayoutForIPhone6:self.segmentControl];
    
}

- (DotFormPost *)salesReportFormPost:(NSString *)fromDate toDate:(NSString *)toDate{
    DotFormPost *dotFormPost = [[DotFormPost alloc]init];
    
    [dotFormPost setAdapterId:@"DOT_REPORT_5_SALES_COMPARISON_DASHBOARD"];
    [dotFormPost setAdapterType:@"CLASSLOADER"];
    [dotFormPost setModuleId:AppConst_MOBILET_ID_DEFAULT];
    
    NSMutableDictionary *sendData = [[NSMutableDictionary alloc]init];
    [sendData setObject:@"" forKey:@"CUSTOMER_ACCOUNT"];
    [sendData setObject:fromDate forKey:@"FROM_DATE"];
    [sendData setObject:toDate forKey:@"TO_DATE"];
    [dotFormPost setPostData:sendData];
    
     return dotFormPost;
}

@end
