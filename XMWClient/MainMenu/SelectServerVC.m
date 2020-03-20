//
//  SelectServerVC.m
//  QCMSProject
//
//  Created by Pradeep Singh on 7/23/15.
//  Copyright (c) 2015 dotvik. All rights reserved.
//

#import "SelectServerVC.h"
#import "Styles.h"
#import "RadioTableViewCell.h"
#import "XmwcsConstant.h"

@interface SelectServerVC ()
{
    RadioGroup* radioGroup;
}

@end

@implementation SelectServerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    [self createSelectionView];
    
    
    [self drawHeaderItem];
}

-(void) createSelectionView
{
    int serverIndex = 0;
    NSString* currentServerStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"KEY_SERVER"];
    if([currentServerStr isEqualToString:@"Production"]) {
        serverIndex = 2;
    }
    else if ([currentServerStr isEqualToString:@"QA"])
    {
        serverIndex = 1;
    }
    else if([currentServerStr isEqualToString:@"DEV"]){
        serverIndex = 0;
    }
    else{
        serverIndex = 2;
    }
    UIView *subContainer = [[UIView alloc]initWithFrame:CGRectMake(0, 65, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    NSArray* serverList = [NSArray arrayWithObjects:@"Dev", @"QA", @"Production", nil];
    radioGroup = [[RadioGroup alloc]initWithFrame:CGRectMake(20, 30, 280, 200) :serverList :serverIndex : serverList];
    
    [subContainer addSubview:radioGroup];

    
    [self.view addSubview:subContainer];
}

-(void) drawHeaderItem
{
    
    self.navigationController.navigationBarHidden = NO;
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage
                                                                          imageNamed:@"back-button.png"] style:UIBarButtonItemStylePlain target:self
                                                                  action:@selector(backHandler:)];
    
    backButton.tintColor = [UIColor colorWithRed:119.0/255 green:119.0/255 blue:119.0/255 alpha:1.0];
    
    
    [self.navigationItem setLeftBarButtonItem:backButton];
    
    
    UILabel*  titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 40)];
    titleLabel.text = @"Select Server";
    titleLabel.textColor = [Styles headerTextColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    [self.navigationItem setTitleView: titleLabel];
    self.navigationController.navigationBar.tintColor = [Styles barButtonTextColor];

    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self
                                                                                    action:@selector(saveButtonHandler:)] ;
    
    
    [self.navigationItem setRightBarButtonItem:rightBarButton];
}


- (void) backHandler : (id) sender
{
      self.navigationController.navigationBarHidden = YES;
    
    [ [self navigationController]  popViewControllerAnimated:YES];
    
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


-(void)saveButtonHandler:(id) sender
{
    
    NSLog(@"Server Selected is %ld  : %@" , (long)radioGroup.selectedIndex, radioGroup.selectedKey);
    [[NSUserDefaults standardUserDefaults] setObject:radioGroup.selectedKey forKey:@"KEY_SERVER"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
     // 0 - Dev, 1 - QA, 2 - Production
    if([radioGroup.selectedKey isEqualToString:@"Dev"]) {
        XmwcsConst_SERVICE_URL = XmwcsConst_SERVICE_URL_DEV;
        XmwcsConst_SERVICE_URL_NOTIFY_CONTEXT = XmwcsConst_SERVICE_URL_NOTIFY_CONTEXT_DEV;
        XmwcsConst_PRODUCT_TREE_SERVICE_URL = XmwcsConst_PRODUCT_TREE_SERVICE_URL_DEV;
        XmwcsConst_SERVICE_URL_APP_CONTROL = XmwcsConst_SERVICE_URL_APP_CONTROL_DEV;
        XmwcsConst_OPCODE_URL = XmwcsConst_SERVICE_URL_OPCODE_SERVICE_DEV;
        XmwcsConst_FILE_UPLOAD_URL = XmwcsConst_SERVICE_URL_FILE_UPLOAD_SERVICE_DEV;
        XmwcsConst_CHAT_URL= XmwcsConst_SERVICE_URL_CHAT_SERVICE_DEV;
    } else if([radioGroup.selectedKey isEqualToString:@"QA"]) {
        // also set developer / qa server URLs here
        XmwcsConst_SERVICE_URL = XmwcsConst_SERVICE_URL_DEMO;
        XmwcsConst_SERVICE_URL_NOTIFY_CONTEXT = XmwcsConst_SERVICE_URL_NOTIFY_CONTEXT_DEMO;
        XmwcsConst_PRODUCT_TREE_SERVICE_URL = XmwcsConst_PRODUCT_TREE_SERVICE_URL_DEMO;
        XmwcsConst_SERVICE_URL_APP_CONTROL = XmwcsConst_SERVICE_URL_APP_CONTROL_DEMO;
        XmwcsConst_OPCODE_URL = XmwcsConst_SERVICE_URL_OPCODE_SERVICE_DEMO;
        XmwcsConst_FILE_UPLOAD_URL =XmwcsConst_SERVICE_URL_FILE_UPLOAD_SERVICE_DEMO;
        XmwcsConst_CHAT_URL= XmwcsConst_SERVICE_URL_CHAT_SERVICE_DEMO;
    } else {
        // also set production server URLs here.
        XmwcsConst_SERVICE_URL = XmwcsConst_SERVICE_URL_PROD;
        XmwcsConst_SERVICE_URL_NOTIFY_CONTEXT = XmwcsConst_SERVICE_URL_NOTIFY_CONTEXT_PROD;
        XmwcsConst_PRODUCT_TREE_SERVICE_URL = XmwcsConst_PRODUCT_TREE_SERVICE_URL_PROD;
        XmwcsConst_SERVICE_URL_APP_CONTROL = XmwcsConst_SERVICE_URL_APP_CONTROL_PROD;
        XmwcsConst_OPCODE_URL = XmwcsConst_SERVICE_URL_OPCODE_SERVICE_PROD;
        XmwcsConst_FILE_UPLOAD_URL = XmwcsConst_SERVICE_URL_FILE_UPLOAD_SERVICE_PROD;
        XmwcsConst_CHAT_URL= XmwcsConst_SERVICE_URL_CHAT_SERVICE_PROD;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
