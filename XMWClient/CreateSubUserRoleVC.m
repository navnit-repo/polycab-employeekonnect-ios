//
//  CreateSubUserRoleVC.m
//  XMWClient
//
//  Created by dotvikios on 24/07/18.
//  Copyright © 2018 dotvik. All rights reserved.
//

#import "CreateSubUserRoleVC.h"
#import "NetworkHelper.h"
#import "LoadingView.h"
#import "HttpEventListener.h"
#import "RoleList.h"
#import "ManageSubUserScrennFlow2nd.h"
#import "XmwcsConstant.h"
#import "LayoutClass.h"
#define  RoleListViewTag 1000
@interface CreateSubUserRoleVC ()

@end

@implementation CreateSubUserRoleVC
{
   
    NetworkHelper *networkHelper;
    LoadingView *loadingView;
    NSMutableDictionary* selectRole;
    RoleList *roleList;
    int cellConut;
    long int viewCartHeight;
    int i;
    int j;
    NSMutableArray * refIDArray;
    UIScrollView *scrol;
    NSMutableArray * selectedRoleArray;
    NSMutableArray *sendRefIDSelectedButton;
}
@synthesize authToken;
@synthesize subUserReffenceID;
@synthesize submitButtonView;
@synthesize networkCallFlag;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self autoLayout];
    [self setNavigationBar];
    NSLog(@"CreateSubUserRoleVC Call");
    NSLog(@"SubUserRefID-%@",subUserReffenceID);
    refIDArray = [[NSMutableArray alloc]init];
    sendRefIDSelectedButton = [[NSMutableArray alloc]init];
    scrol = [[UIScrollView alloc]init];
    scrol.frame = CGRectMake(0, 34, self.view.frame.size.width, self.view.frame.size.height);
    [self netWorkCall];
}
-(void)setNavigationBar{
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage
                                                                          imageNamed:@"back-button.png"] style:UIBarButtonItemStylePlain target:self
                                                                  action:@selector(backHandler:)];
    
    backButton.tintColor = [UIColor whiteColor];
    
    
    [self.navigationItem setLeftBarButtonItem:backButton];
    
    UIImageView *polycabLogo = [[UIImageView alloc] initWithImage:[UIImage  imageNamed:@"polycab_logo"]];
    self.navigationItem.titleView.contentMode = UIViewContentModeCenter;
    self.navigationItem.titleView = polycabLogo;
    
}
- (void) backHandler : (id) sender
{
    
    
    [ [self navigationController]  popViewControllerAnimated:YES];
    
}
-(void)autoLayout{
    [LayoutClass labelLayout:self.constantView1 forFontWeight:UIFontWeightBold];
    [LayoutClass setLayoutForIPhone6:self.constantView2];
    [LayoutClass buttonLayout:self.constantView3 forFontWeight:UIFontWeightBold];
}

-(void)loadRole{
    NSArray* responseData = [selectRole objectForKey:@"responseData"];
    viewCartHeight = viewCartHeight + [responseData count];
    for ( i=0 ; i < responseData.count; i++) {
        NSMutableDictionary *rold = [[NSMutableDictionary alloc]init];
        [rold setDictionary:[responseData objectAtIndex:i]];
        roleList = [RoleList createInstance: cellConut*60];
        cellConut = cellConut+1;
        int roleListTag = [[rold valueForKey:@"roleId"] intValue];
        [refIDArray addObject:[rold valueForKey:@"roleId"]];
        NSLog(@"%d",roleListTag);
        roleList.tag = roleListTag;
        [roleList configure:[responseData objectAtIndex:i]];
        [scrol addSubview:roleList];
        j= j+1;
    }
    
    [scrol setContentSize:CGSizeMake(scrol.frame.size.width , (viewCartHeight *60)-60)];
    [self.view addSubview:scrol];
  //  submitButtonView.frame = CGRectMake(0, self.view.frame.size.height-30, 320, 60);
    [self.view addSubview:submitButtonView];
    
}
-(void)netWorkCall{
    
    loadingView= [LoadingView loadingViewInView:self.view];
    NSMutableDictionary *data = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *selectRole = [[NSMutableDictionary alloc]init];
    [selectRole setObject:data forKey:@"data"];
    [selectRole setObject:authToken forKey:@"authToken"];
    [selectRole setValue:@"selectrole" forKey:@"opcode"];
    
    
    networkHelper = [[NetworkHelper alloc]init];
    NSString * url=XmwcsConst_OPCODE_URL;
    networkHelper.serviceURLString = url;
    [networkHelper genericJSONPayloadRequestWith:selectRole :self :@"selectrole"];
}
- (void)httpResponseObjectHandler:(NSString *)callName :(id)respondedObject :(id)requestedObject{
    [loadingView removeView];
    if ( [callName isEqualToString:@"selectrole"]) {
        if([[respondedObject valueForKey:@"status"]isEqualToString:@"SUCCESS"])
        {
            selectRole = [[NSMutableDictionary alloc]init];
            [selectRole setDictionary: respondedObject];
            NSLog(@"%@",selectRole);
            [self loadRole];
        }
    }
    
    else if ( [callName isEqualToString:@"selectedrolelist"]) {
        if([[respondedObject valueForKey:@"status"]isEqualToString:@"SUCCESS"])
        {
            ManageSubUserScrennFlow2nd *vc = [[ManageSubUserScrennFlow2nd alloc]init];
            vc.authToken = authToken;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
    }
    else if ( [callName isEqualToString:@"getsubuserselectedrolelist"]) {
        if([[respondedObject valueForKey:@"status"]isEqualToString:@"SUCCESS"])
        {    [loadingView removeView];
            selectedRoleArray = [[NSMutableArray alloc]init];
            
            NSMutableDictionary * mutableDict = [NSMutableDictionary dictionary];
            for (NSDictionary * formElements in [respondedObject valueForKey:@"Selected_Role"])
            {
                //for fetch role id
                [mutableDict addEntriesFromDictionary:formElements];
                [selectedRoleArray addObject:[mutableDict valueForKey:@"roleId"]];
            }
           
              [self loadRoleAlreadyClicked];
      
        }
    }
}
-(void)submitRefIDFetchArray{
    for (int i=0; i<refIDArray.count; i++) {
         int roleListTag = [[refIDArray objectAtIndex:i] intValue];
        RoleList *vc = [(RoleList*)self.view viewWithTag:roleListTag];
        if (vc.checkBoxButton.tag ==1) {
            NSString *buttonTitle = vc.checkBoxButton.titleLabel.text;
            [sendRefIDSelectedButton addObject:buttonTitle];
        }
       
    }
}
- (IBAction)submitButton:(id)sender {
    loadingView= [LoadingView loadingViewInView:self.view];
    [self submitRefIDFetchArray];
    NSLog(@"%@",sendRefIDSelectedButton);
    NSLog(@"%@",refIDArray);
    
    NSMutableDictionary *selectedrolelist = [[NSMutableDictionary alloc]init];
    [selectedrolelist setObject:sendRefIDSelectedButton forKey:@"refid"];
    [selectedrolelist setObject:subUserReffenceID forKey:@"subrefid"];
    [selectedrolelist setObject:authToken forKey:@"authToken"];
    [selectedrolelist setValue:@"selectedrolelist" forKey:@"opcode"];
    networkHelper = [[NetworkHelper alloc]init];
    NSString * url=XmwcsConst_OPCODE_URL;
    networkHelper.serviceURLString = url;
    [networkHelper genericJSONPayloadRequestWith:selectedrolelist :self :@"selectedrolelist"];
    
}
-(void)loadRoleAlreadyClicked{
    //chanege Button Icon
    for (int i=0; i< selectedRoleArray.count; i++) {
      
        NSString * result = [selectedRoleArray objectAtIndex:i] ;
        int tag = [result intValue];
        RoleList *view = [(RoleList *)self.view viewWithTag:tag];
        view.checkBoxImageView.image = [UIImage imageNamed:@"checkedbox.png"];
        view.checkBoxButton.tag = 1;
    }

}
-(void)loadClickedRoleNetWorkCall{
   // loadingView= [LoadingView loadingViewInView:self.view];
    NSMutableDictionary *data = [[NSMutableDictionary alloc]init];
    [data setObject:subUserReffenceID forKey:@"subuserrefid"];
    NSMutableDictionary *getSelectedRole = [[NSMutableDictionary alloc]init];
    [getSelectedRole setObject:data forKey:@"data"];
    [getSelectedRole setObject:authToken forKey:@"authToken"];
    [getSelectedRole setValue:@"getsubuserselectedrolelist" forKey:@"opcode"];
    
    
    networkHelper = [[NetworkHelper alloc]init];
    NSString * url=XmwcsConst_OPCODE_URL;
    networkHelper.serviceURLString = url;
    [networkHelper genericJSONPayloadRequestWith:getSelectedRole :self :@"getsubuserselectedrolelist"];
}
- (void)viewDidAppear:(BOOL)animated{
    if (networkCallFlag==true) {
        [self loadClickedRoleNetWorkCall];
    }
}
- (void) httpFailureHandler : (NSString*) callName : (NSString*) message {
    [loadingView removeView];
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Polycab Authentication!" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
    [myAlertView show];
    
}

@end
