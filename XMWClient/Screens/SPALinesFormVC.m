//  SPALinesFormVC.m
//  XMWClient
//
//  Created by Nit Navodit on 23/10/21.
//  Copyright © 2021 dotvik. All rights reserved.

#import <Foundation/Foundation.h>
#import "SPALinesFormVC.h"
#import "NetworkHelper.h"
#import "LoadingView.h"
#import "XmwcsConstant.h"
#import "HttpEventListener.h"
#import "DVAppDelegate.h"
#import "ClientVariable.h"
#import "itemsList.h"
#import "itemCell.h"
#import "AppConstants.h"
#import "XmwReportService.h"
@interface itemListDetailModel : NSObject

    @property (nonatomic, strong) NSString * color;
    @property (nonatomic, strong) NSNumber * core;
    @property (nonatomic, strong) NSString * createdate;
    @property (nonatomic, strong) NSString * field1;
    @property (nonatomic, strong) NSString * field2;
    @property (nonatomic, strong) NSString * listprice;
    @property (nonatomic, strong) NSNumber * listpricemtr;
    @property (nonatomic, strong) NSString * longDesc;
    @property (nonatomic, strong) NSString * modifieddate;
    @property (nonatomic, strong) NSString * posnr;
    @property (nonatomic, strong) NSString * primary_category;
    @property (nonatomic, strong) NSString * product;
    @property (nonatomic, strong) NSString * qty_mtr;
    @property (nonatomic, strong) NSString * quantityInUOM;
    @property (nonatomic, strong) NSString * revisionno;
    @property (nonatomic, strong) NSString * secondary_category;
    @property (nonatomic, strong) NSString * shortDesc;
    @property (nonatomic, strong) NSString * size;
    @property (nonatomic, strong) NSString * spaDiscount;
    @property (nonatomic, strong) NSString * spaTotalAmount;
    @property (nonatomic, strong) NSString * spaUnitRate;
    @property (nonatomic, strong) NSString * spaapproved;
    @property (nonatomic, strong) NSString * spalrefid;
    @property (nonatomic, strong) NSString * sparate;
    @property (nonatomic, strong) NSString * spatype;
    @property (nonatomic, strong) NSString * spavalue;
    @property (nonatomic, strong) NSString * unit_mtr;
    @property (nonatomic, strong) NSString * version;

    - (instancetype)initWithDictionary: (NSDictionary *) dictionary;

@end
@implementation itemListDetailModel : NSObject

    - (instancetype)initWithDictionary:(NSDictionary *)dictionary
    {
        self = [super init];
        if (self) {
            self.color = dictionary[@"color"] ;
            self.core = [dictionary valueForKey:@"core"] ;
            
            //[NSString stringWithFormat:@"%d", dictionary[@"core"]];
            self.createdate = dictionary[@"createdate"] ;
            self.field1 = dictionary[@"field1"] ;
            self.field2 = dictionary[@"field2"] ;
            self.listprice = dictionary[@"listprice"] ;
            self.listpricemtr = [dictionary valueForKey:@"listpricemtr"] ;
            self.modifieddate = dictionary[@"modifieddate"] ;
            self.posnr = dictionary[@"posnr"];
            self.primary_category = dictionary[@"primary_category"];
            self.product = dictionary[@"product"];
            self.qty_mtr = dictionary[@"qty_mtr"];
            self.quantityInUOM = dictionary[@"quantityInUOM"];
            self.revisionno = dictionary[@"revisionno"];
            self.secondary_category = dictionary[@"secondary_category"];
            self.shortDesc = dictionary[@"shortDesc"];
            self.size = dictionary[@"size"];
            self.spaDiscount = dictionary[@"spaDiscount"];
            self.spaTotalAmount = dictionary[@"spaTotalAmount"];
            self.spaUnitRate = dictionary[@"spaUnitRate"];
            self.spaapproved = dictionary[@"spaapproved"];
            self.spalrefid = dictionary[@"spalrefid"];
            self.sparate = dictionary[@"sparate"];
            self.spatype = dictionary[@"spatype"];
            self.spavalue = dictionary[@"spavalue"];
            self.unit_mtr = dictionary[@"unit_mtr"];
            self.version = dictionary[@"version"];
        }
        return self;
    }

@end

@interface SPALinesFormVC ()
    @property NSMutableArray * listItems;
    @property NSDictionary * lmeDetails;
    @property itemListDetailModel *itemListDetailModels;
    @property (strong, nonatomic) UIView *headerView;
    @property (strong, nonatomic) UIView *footerView;
    @property UISwitch * showLmeUISwitch;
    @property UITextView *remarksUITextView;
    @property UITextView *remarks2UITextView;
    @property UITextView *remarks3UITextView;
    @property UITextField *subTotalSPAText;
@end
@implementation SPALinesFormVC
@synthesize tableView,listItems,itemListDetailModels;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter]addObserver:self  selector:@selector(keyboardWillBeHidden:) name: UIKeyboardWillHideNotification object: nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWasShown:) name: UIKeyboardWillShowNotification  object: nil];
    
    self.listItems = [[NSMutableArray alloc] init];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height-130) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    self.tableView.backgroundColor = [UIColor whiteColor];

       // add to canvas
    [self.view addSubview:self.tableView];

    self.footerView= [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-130,self.view.frame.size.width,self.view.frame.size.height-130)];
    self.footerView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview: self.footerView];


    UIButton *buttonA = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonA addTarget:self
               action:@selector(approveBtnClicked:)
     forControlEvents:UIControlEventTouchUpInside];
    [buttonA setTitle:@"Approve" forState:UIControlStateNormal];
    buttonA.frame = CGRectMake(self.view.frame.size.width/10,15, self.view.frame.size.width/4, 50.0);
    buttonA.backgroundColor=[UIColor redColor];
    [self.footerView addSubview:buttonA];

    UIButton *buttonR = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonR addTarget:self
               action:@selector(rejectBtnClicked:)
     forControlEvents:UIControlEventTouchUpInside];
    [buttonR setTitle:@"Reject" forState:UIControlStateNormal];
    buttonR.frame = CGRectMake(buttonA.frame.size.width+buttonA.frame.origin.x + 10,15, self.view.frame.size.width/4, 50.0);
    buttonR.backgroundColor=[UIColor redColor];
    [self.footerView addSubview:buttonR];
    
    UIButton *buttonRev = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonRev addTarget:self
               action:@selector(reviseBtnClicked:)
     forControlEvents:UIControlEventTouchUpInside];
    [buttonRev setTitle:@"Revise" forState:UIControlStateNormal];
    buttonRev.frame = CGRectMake(buttonR.frame.size.width+buttonR.frame.origin.x + 10,15, self.view.frame.size.width/4, 50.0);
    buttonRev.backgroundColor=[UIColor redColor];
    [self.footerView addSubview:buttonRev];
//    [self fetchData];
    [self loadModelData];
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;

    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.tableView.contentInset = contentInsets;
    self.tableView.scrollIndicatorInsets = contentInsets;
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.tableView.contentInset = contentInsets;
    self.tableView.scrollIndicatorInsets = contentInsets;
}

- (void)viewDidDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewDidDisappear:animated];
}
- (void)approveBtnClicked:(UIButton*)button
{
    NSString *str ;
    for (int i = 0; i < [self.listItems count]; i++)
    {
         self.itemListDetailModels  = [self.listItems objectAtIndex: i];
         UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        
        UITextField *rateTxt = (UITextField *)[cell.contentView viewWithTag:8];
        UITextField *discountTxt = (UITextField *)[cell.contentView viewWithTag:9];
        UITextField *quantityTxt = (UITextField *)[cell.contentView viewWithTag:10];
        
        if ([rateTxt.text isEqualToString:@""] || [discountTxt.text isEqualToString:@""] || [quantityTxt.text isEqualToString:@""])
        {
            NSLog(@"myString IS empty!");
            str = @"No";
            [self ShowAlert:@"Please Fill all fields"];
        }
        else
        {
            str = @"Yes";
        }
    }
    if ([str isEqualToString: @"Yes"])
    {
//        [self PopupView];
        [self getLME_Data];
    }
}
- (void)rejectBtnClicked:(UIButton*)button
   {
       NSLog(@"Button  clicked.");
       [self spaRejectNetworkCall];
  }

- (void)reviseBtnClicked:(UIButton*)button
   {
       NSLog(@"Button  clicked.");
       [self spaReviseNetworkCall];
  }

- (void)PopupView : (NSDictionary*)lmeDetails
{
    self.lmeDetails = lmeDetails;
    NSString* copperRate = [lmeDetails objectForKey:@"LME_COPPER"];
    NSString* aluminiumRate = [lmeDetails objectForKey:@"LME_ALUMINIUM"];
    NSString* dollarRate = [lmeDetails objectForKey:@"LME_DOLLAR_RATE"];
    NSString* lastUpdateDate = [lmeDetails objectForKey:@"LAST_UPDATE_DATE"];
    NSString* validity = [lmeDetails objectForKey:@"SPA_VALIDITY"];
    UIView *popupview = [[UIView alloc] init];
    
    popupview.frame = [UIScreen mainScreen].bounds;
    popupview.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:popupview];
    
    [self.view bringSubviewToFront:popupview];
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, popupview.frame.size.width/2, 18)];
    [label setFont:[UIFont boldSystemFontOfSize:18]];
    [label setTextAlignment: NSTextAlignmentLeft];
    [label setText:@"LME Details:"];
    [popupview addSubview:label];
    
//    UILabel *labelLine = [[UILabel alloc] initWithFrame:CGRectMake(10,label.frame.size.height+55, popupview.frame.size.width-20, 1)];
//    labelLine.backgroundColor =[UIColor blackColor];
//    [popupview addSubview:labelLine];
    
    UILabel *labelLine1 = [[UILabel alloc] initWithFrame:CGRectMake(10,label.frame.size.height+100, popupview.frame.size.width-20, 1)];
    labelLine1.backgroundColor =[UIColor lightGrayColor];
    [popupview addSubview:labelLine1];
    
    
//    NSString *str = copperRate
    
    
    UILabel *copperLbl = [[UILabel alloc] initWithFrame:CGRectMake(10,labelLine1.frame.origin.y+20, popupview.frame.size.width-20, 20)];
    copperLbl.backgroundColor =[UIColor whiteColor];
    copperLbl.text = [NSString stringWithFormat:@"Copper: %@" ,copperRate ];
    [popupview addSubview:copperLbl];
    
    UILabel *alluminiumLbl = [[UILabel alloc] initWithFrame:CGRectMake(10,copperLbl.frame.origin.y+30, popupview.frame.size.width-20, 20)];

    alluminiumLbl.text = [NSString stringWithFormat:@"Aluminium: %@" ,aluminiumRate ];
    [popupview addSubview:alluminiumLbl];
    
    UILabel *UsDollarLbl = [[UILabel alloc] initWithFrame:CGRectMake(10,alluminiumLbl.frame.origin.y+30, popupview.frame.size.width-20, 20)];

    UsDollarLbl.text = [NSString stringWithFormat:@"US Dollar: %@" ,dollarRate ];
    [popupview addSubview:UsDollarLbl];
    
    UILabel *labelLine2 = [[UILabel alloc] initWithFrame:CGRectMake(10,UsDollarLbl.frame.origin.y+30, popupview.frame.size.width-20, 1)];
    labelLine2.backgroundColor =[UIColor lightGrayColor];
    [popupview addSubview:labelLine2];
    
    UILabel *showDetailLbl = [[UILabel alloc] initWithFrame:CGRectMake(10,labelLine2.frame.origin.y+30, 300, 20)];
    showDetailLbl.text = [NSString stringWithFormat:@"Show LME Details to customer: %@" ,@"" ];
    [popupview addSubview:showDetailLbl];
    
    CGRect myFrame = CGRectMake(showDetailLbl.frame.origin.x + showDetailLbl.frame.size.width+20, showDetailLbl.frame.origin.y, 80, showDetailLbl.frame.size.height);
        //create and initialize the slider
        self.showLmeUISwitch = [[UISwitch alloc] initWithFrame:myFrame];
        //set the switch to ON
        [self.showLmeUISwitch setOn:YES];
        //attach action method to the switch when the value changes
        [self.showLmeUISwitch addTarget:self
                    action:@selector(switchIsChanged:)
                    forControlEvents:UIControlEventValueChanged];
         
        [popupview addSubview:self.showLmeUISwitch];
    
    UILabel *labelLine3 = [[UILabel alloc] initWithFrame:CGRectMake(10,showDetailLbl.frame.origin.y+40, popupview.frame.size.width-20, 1)];
    labelLine3.backgroundColor =[UIColor lightGrayColor];
    [popupview addSubview:labelLine3];
    
    UILabel *approvedRemarkLbl = [[UILabel alloc] initWithFrame:CGRectMake(10,labelLine3.frame.origin.y+30, popupview.frame.size.width-20, 20)];
    approvedRemarkLbl.text = [NSString stringWithFormat:@"Approver Remark: %@" ,@"" ];
    [popupview addSubview:approvedRemarkLbl];
  
    
    
    UITextView  *remarksTxt = [[UITextView alloc] initWithFrame:CGRectMake(10,approvedRemarkLbl.frame.origin.y+30, popupview.frame.size.width-20, 80)];
    remarksTxt.layer.borderWidth = 1.0f;
    remarksTxt.layer.cornerRadius = 2.0f;
    remarksTxt.font = [UIFont systemFontOfSize:14.0];
    remarksTxt.delegate = self;
//    remarksTxt.text = @"Remarks";
//    remarksTxt.textColor = [UIColor lightGrayColor];
    remarksTxt.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
    [popupview addSubview:remarksTxt];
    self.remarksUITextView = remarksTxt;
    UILabel *approvedRemarkLbl2 = [[UILabel alloc] initWithFrame:CGRectMake(10,remarksTxt.frame.origin.y+remarksTxt.frame.size.height+20, popupview.frame.size.width-20, 20)];
    approvedRemarkLbl2.text = [NSString stringWithFormat:@"Approver Remark 2: %@" ,@"" ];
    [popupview addSubview:approvedRemarkLbl2];
  
    
    
    UITextView  *remarksTxt2 = [[UITextView alloc] initWithFrame:CGRectMake(10,approvedRemarkLbl2.frame.origin.y+30, popupview.frame.size.width-20, 80)];
    remarksTxt2.layer.borderWidth = 1.0f;
    remarksTxt2.layer.cornerRadius = 2.0f;
    remarksTxt2.font = [UIFont systemFontOfSize:14.0];
    remarksTxt2.delegate = self;
//    remarksTxt2.text = @"Remarks";
//    remarksTxt2.textColor = [UIColor lightGrayColor];
    remarksTxt2.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
    [popupview addSubview:remarksTxt2];
    self.remarks2UITextView = remarksTxt2;
    UILabel *approvedRemarkLbl3 = [[UILabel alloc] initWithFrame:CGRectMake(10,remarksTxt2.frame.origin.y+remarksTxt2.frame.size.height+20, popupview.frame.size.width-20, 20)];
    approvedRemarkLbl3.text = [NSString stringWithFormat:@"Approver Remark 3: %@" ,@"" ];
    [popupview addSubview:approvedRemarkLbl3];
  
    
    
    UITextView  *remarksTxt3 = [[UITextView alloc] initWithFrame:CGRectMake(10,approvedRemarkLbl3.frame.origin.y+30, popupview.frame.size.width-20, 80)];
    remarksTxt3.layer.borderWidth = 1.0f;
    remarksTxt3.layer.cornerRadius = 2.0f;
    remarksTxt3.font = [UIFont systemFontOfSize:14.0];
    remarksTxt3.delegate = self;
//    remarksTxt3.te = @"Remarks";
//    remarksTxt3.textColor = [UIColor lightGrayColor];
    remarksTxt3.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
    [popupview addSubview:remarksTxt3];
    self.remarks3UITextView = remarksTxt3;
    
    UIButton *btnApprove = [UIButton buttonWithType:UIButtonTypeCustom];
       [btnApprove addTarget:self
                  action:@selector(RemarksApproveBtnClicked:)
        forControlEvents:UIControlEventTouchUpInside];
       [btnApprove setTitle:@"Approve" forState:UIControlStateNormal];
    btnApprove.frame = CGRectMake(10,remarksTxt3.frame.origin.y+remarksTxt3.frame.size.height+20, popupview.frame.size.width-20, 50);
    btnApprove.backgroundColor=[UIColor redColor];
       [popupview addSubview:btnApprove];
   

    
}

- (void) switchIsChanged:(UISwitch *)paramSender{
     
    if ([paramSender isOn]){
        NSLog(@"The switch is turned on.");
    } else {
        NSLog(@"The switch is turned off.");
    }
     
}
- (void)RemarksApproveBtnClicked:(UIButton*)button
   {
         NSLog(@"Button  clicked.");
       NSString * remarks = self.remarksUITextView.text;
       NSString * remarks2 = self.remarks2UITextView.text;
       NSString * remarks3 = self.remarks3UITextView.text;
//       NSString * showLmeFlag =  ? @"YES" : @"NO";
       if([remarks stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0
          && [remarks2 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0
          && [remarks3 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0){
           [self ShowAlert:@"Please enter remarks"];
           return;
       }
       
       
          
       [self spaActionNetworkCall:@"approved" withLmeDetail:self.lmeDetails withShowLmeFlag:[self.showLmeUISwitch isOn] withRemark:remarks withRemark2:remarks2 withRemark3:remarks3];
  }
-(void)loadModelData
{
    for (NSDictionary *dict in _spaRequestObject[@"data"][@"spalines"])
    {
        itemListDetailModel *item
//                                      self.itemListDetailModels
        = [[itemListDetailModel alloc] initWithDictionary:dict];
        [self.listItems addObject: item];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
       //When json is loaded stop the indicator
   
        [self.tableView reloadData];
       });
}
-(void)fetchData
{

    NSURLSessionConfiguration *defaultSessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultSessionConfiguration];

    // Setup the request with URL
    NSURL *url = [NSURL URLWithString:@"https://api.starsgyan.com/PolyCab_Rest.json"];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];

    // Convert POST string parameters to data using UTF8 Encoding
    NSString *postParams = @"";
    NSData *postData = [postParams dataUsingEncoding:NSUTF8StringEncoding];

    // Convert POST string parameters to data using UTF8 Encoding
    [urlRequest setHTTPMethod:@"GET"];
    [urlRequest setHTTPBody:postData];

    // Create dataTask
    NSURLSessionDataTask *dataTask = [defaultSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

        NSDictionary *results = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        //JSON Parsing....
        NSString *message = results[@"Message"];
        
      
        if (results[@"data"])
    {
        
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
           dispatch_async(queue, ^{
           //Load the json on another thread
               if([results[@"data"] isKindOfClass:[NSDictionary class]])
                              {
                                  
                                  for (NSDictionary *dict in results[@"data"][@"spalines"])
                                  {
                                      itemListDetailModel *item
//                                      self.itemListDetailModels
                                      = [[itemListDetailModel alloc] initWithDictionary:dict];
                                      [self.listItems addObject: item];
                                  }
                                       
                              }
           dispatch_async(dispatch_get_main_queue(), ^{
              //When json is loaded stop the indicator
          
               [self.tableView reloadData];
              });
           });
 

        
  
        
        
       
      // NSDictionary* albumsvideo = results[@"data"];

        }
        else
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"App"
                                                                           message:message
                                                                    preferredStyle:UIAlertControllerStyleAlert]; // 1
            UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"Ok"
                                                                  style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                      NSLog(@"You pressed button one");
                                                                  }]; // 2


            [alert addAction:firstAction]; // 4

            [self presentViewController:alert animated:YES completion:nil];
        }



    }];

    // Fire the request
    [dataTask resume];
}



#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 100;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 100)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width-20, 18)];
    [label setFont:[UIFont boldSystemFontOfSize:15]];
    [label setTextAlignment: NSTextAlignmentCenter];
    [label setText:@"SPA Approval Lines"];
    [view addSubview:label];
    [view setBackgroundColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]];
    
    UILabel *labelSub = [[UILabel alloc] initWithFrame:CGRectMake(10,label.frame.size.height+10, tableView.frame.size.width-150, 18)];
    [labelSub setFont:[UIFont boldSystemFontOfSize:15]];
    [labelSub setTextAlignment: NSTextAlignmentLeft];
    [labelSub setText:[NSString stringWithFormat: @"SPA Request ID: %@",self.spahrefid]];
    [view addSubview:labelSub];
    
    UIButton *remarksButton = [[UIButton alloc] initWithFrame:CGRectMake(labelSub.frame.size.width+ 20,label.frame.size.height+10, 80, 18)];
        [remarksButton setFont:[UIFont boldSystemFontOfSize:15]];
//        [remarksButton setTextAlignment: NSTextAlignmentLeft];
//        [remarksButton setTitle:"Remarks" forState: UIControlState.]
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    remarksButton.backgroundColor = [UIColor redColor];
        [remarksButton setTitle:@"Remarks" forState:UIControlStateNormal];
    [remarksButton addTarget:self action:@selector(remarksButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
//        [button sizeToFit];
//        [remarksButton setText:[NSString stringWithFormat: @"Remarks",""]];
        [view addSubview:remarksButton];
    
    UILabel *subDisc = [[UILabel alloc] initWithFrame:CGRectMake(10, labelSub.frame.size.height*2+20, self.view.frame.size.width/4+20, 30)];
    [subDisc setFont:[UIFont boldSystemFontOfSize:15]];
    [subDisc setTextAlignment: NSTextAlignmentLeft];
    [subDisc setText:@"Single Discount: "];
    [view addSubview:subDisc];
    
    UITextField *discountTxt = [[UITextField alloc] initWithFrame:CGRectMake(subDisc.frame.size.width+10, labelSub.frame.size.height*2+20, self.view.frame.size.width/4+5, 30)];
   
    discountTxt.tag = 100; // Set a constant for this
    discountTxt.font = [UIFont systemFontOfSize:14.0];
    discountTxt.layer.borderWidth = 1.0f;
    discountTxt.layer.cornerRadius = 2.0f;
    discountTxt.placeholder = @"Discount";
    [view addSubview:discountTxt];
    [discountTxt setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    discountTxt.delegate = self ;
    discountTxt.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
    [discountTxt addTarget:self action:@selector(SingleDiscountTxtDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    UILabel *subTotalSPA = [[UILabel alloc] initWithFrame:CGRectMake(discountTxt.frame.origin.x + discountTxt.frame.size.width + 20, labelSub.frame.size.height*2+20, self.view.frame.size.width/3+20, 30)];
    [subTotalSPA setFont:[UIFont boldSystemFontOfSize:15]];
    [subTotalSPA setTextAlignment: NSTextAlignmentLeft];
    [subTotalSPA setText:@"Total SPA: "];
    [view addSubview:subTotalSPA];
    
    self.subTotalSPAText = [[UITextField alloc] initWithFrame:CGRectMake(subTotalSPA.frame.origin.x+subTotalSPA.frame.size.width+10, labelSub.frame.size.height*2+20, self.view.frame.size.width/4+5, 30)];
   
    self.subTotalSPAText.tag = 100; // Set a constant for this
    self.subTotalSPAText.font = [UIFont systemFontOfSize:14.0];
    self.subTotalSPAText.layer.borderWidth = 1.0f;
    self.subTotalSPAText.layer.cornerRadius = 2.0f;
    self.subTotalSPAText.text = @"";
    self.subTotalSPAText.enabled = false;
//    subTotalSPAText.placeholder = @"Discount";
    [view addSubview:self.subTotalSPAText];
    [self.subTotalSPAText setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    self.subTotalSPAText.delegate = self ;
    self.subTotalSPAText.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
    [self.subTotalSPAText addTarget:self action:@selector(SingleDiscountTxtDidChange:) forControlEvents:UIControlEventEditingChanged];
 
    return view;
}

-(void) remarksButtonAction:(UIButton*)sender
 {
     
     NSString *customerRemarks = _spaRequestObject[@"data"][@"customer_remarks"];
//     NSString *customerRemarks1 = _spaRequestObject[@"data"][@"customer_remarks1"];
//     NSString *customerRemarks2 = _spaRequestObject[@"data"][@"customer_remarks2"];
//        NSLog(@"you clicked on button %@", sender.tag);
     UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Customer Remarks" message: customerRemarks delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
 }
// number of section(s), now I assume there is only 1 section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView
{
    return 1;
}

// number of row in the section, I assume there is only 1 row
- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section
{
    return self.listItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    itemCell *cell = nil;
      
    
    UITextField *singleDiscountTxt = (UITextField *)[self.tableView viewWithTag:100];
    static NSString *CellIdentifier = @"itemsListId";

    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
           if (cell == nil)
           {
               NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"itemCell"
                                                                       owner:self options:nil];
               cell = (itemCell *)[nibs objectAtIndex:0];
           }
    self.itemListDetailModels  = [self.listItems objectAtIndex: indexPath.row];
    cell.descriptionLbl.text = self.itemListDetailModels.product;
    
    cell.descriptionLbl.lineBreakMode = NSLineBreakByWordWrapping;
    cell.descriptionLbl.numberOfLines = 0;
    
    cell.subcategoryLbl.text = self.itemListDetailModels.primary_category;
    cell.MtrLbl.text = [NSString stringWithFormat:@"%@",self.itemListDetailModels.listpricemtr];
    cell.sizeLbl.text = [NSString stringWithFormat:@"%@",self.itemListDetailModels.size];
    
    
    cell.coreLbl.text = [NSString stringWithFormat:@"%@",self.itemListDetailModels.core];
    cell.unitLbl.text = [NSString stringWithFormat:@"%@",self.itemListDetailModels.unit_mtr];
    
    cell.lpLbl.text = [NSString stringWithFormat:@"%@",self.itemListDetailModels.listprice];
//    cell.totalValueLbl.text = [NSString stringWithFormat:@"%@",self.itemListDetailModels.listpricemtr];
    cell.rqRateLbl.text = [NSString stringWithFormat:@"%@",self.itemListDetailModels.spavalue];
    double newRateDiff  = ([self.itemListDetailModels.listpricemtr floatValue] - [self.itemListDetailModels.spavalue floatValue]);
    double discount =  (newRateDiff * 100)/[self.itemListDetailModels.listpricemtr floatValue];
    
    cell.rqDiscLbl.text = [NSString stringWithFormat:@"%.2f",discount];
    cell.quantityLbl.text = [NSString stringWithFormat:@"%@",self.itemListDetailModels.qty_mtr];
    [cell.rateTxt addTarget:self action:@selector(rateTxtDidChange:) forControlEvents:UIControlEventEditingChanged];
    [cell.rateTxt setKeyboardType:UIKeyboardTypeNumberPad];
    [cell.discountTxt addTarget:self action:@selector(discountTxtDidChange:) forControlEvents:UIControlEventEditingChanged];
    [cell.discountTxt setKeyboardType:UIKeyboardTypeNumberPad];
//    [cell.quantityTxt addTarget:self action:@selector(quantityTxtDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    if (singleDiscountTxt.text.length>0)
    {
        cell.discountTxt.text = singleDiscountTxt.text;
        
        double myDiscount = [cell.discountTxt.text doubleValue];
        double actualRate = [self.itemListDetailModels.listpricemtr doubleValue];
      if (myDiscount > 0 && myDiscount<=100)
      {
        double Rate =  (myDiscount * actualRate)/100 ;
        double newRate  = (actualRate - Rate);
     
        
          cell.rateTxt.text = [NSString stringWithFormat:@"%.2f",newRate];
          cell.totalSPAValue.text = [NSString stringWithFormat:@"%.2f",newRate* [self.itemListDetailModels.qty_mtr doubleValue]];
      }
      else
      {
       
          
          [self ShowAlert:@"Discount can not be greater than 100%"];
          
          cell.discountTxt.text = @"";
          cell.rateTxt.text = @"";
      }
    }
    return cell;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPathh:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"anIdentifier";

    UILabel *descriptionLbl;
    UILabel *subcategoryLbl;
    UILabel *LP_MeterLbl;
    UILabel *sizeLbl;
    UILabel *CoreLbl;
    UILabel *UnitLbl;
    UILabel *priceLbl;
    UITextField *rateTxt;
    UITextField *discountTxt;
    UITextField *quantityTxt;
    UILabel *totalValueLbl;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
       
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        self.itemListDetailModels  = [self.listItems objectAtIndex: indexPath.row];
        
        

        descriptionLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width-60, 35)];
        descriptionLbl.numberOfLines = 0 ;
        descriptionLbl.lineBreakMode = NSLineBreakByWordWrapping;
        descriptionLbl.tag = 1; // Set a constant for this
        descriptionLbl.font = [UIFont systemFontOfSize:14.0];
        
        [cell.contentView addSubview:descriptionLbl];
        
        
        subcategoryLbl = [[UILabel alloc] initWithFrame:CGRectMake(10,descriptionLbl.frame.size.height, self.view.frame.size.width-60, 35)];
        subcategoryLbl.tag = 2; // Set a constant for this
        subcategoryLbl.font = [UIFont systemFontOfSize:14.0];
        
        
        [cell.contentView addSubview:subcategoryLbl];
        
        
        LP_MeterLbl = [[UILabel alloc] initWithFrame:CGRectMake(10,subcategoryLbl.frame.origin.y+subcategoryLbl.frame.size.height, self.view.frame.size.width/2, 25)];
        LP_MeterLbl.tag = 3; // Set a constant for this
        LP_MeterLbl.font = [UIFont systemFontOfSize:14.0];
        
        [cell.contentView addSubview:LP_MeterLbl];
        
        
        sizeLbl = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2,subcategoryLbl.frame.origin.y+subcategoryLbl.frame.size.height, self.view.frame.size.width/2, 25)];
        sizeLbl.tag = 4; // Set a constant for this
        sizeLbl.font = [UIFont systemFontOfSize:14.0];
        
        [cell.contentView addSubview:sizeLbl];
        
        
        CoreLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, LP_MeterLbl.frame.origin.y+LP_MeterLbl.frame.size.height, self.view.frame.size.width/3, 25)];
        CoreLbl.tag = 5; // Set a constant for this
        CoreLbl.font = [UIFont systemFontOfSize:14.0];
        
        [cell.contentView addSubview:CoreLbl];
        
        UnitLbl = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/3, LP_MeterLbl.frame.origin.y+LP_MeterLbl.frame.size.height, self.view.frame.size.width/3, 25)];
        UnitLbl.tag = 6; // Set a constant for this
        UnitLbl.font = [UIFont systemFontOfSize:14.0];
        [cell.contentView addSubview:UnitLbl];

        
        priceLbl = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width/3) * 2, LP_MeterLbl.frame.origin.y+LP_MeterLbl.frame.size.height, self.view.frame.size.width/3, 25)];
    
        priceLbl.tag = 7; // Set a constant for this
        priceLbl.font = [UIFont systemFontOfSize:14.0];
        [cell.contentView addSubview:priceLbl];
        
        rateTxt = [[UITextField alloc] initWithFrame:CGRectMake(10, CoreLbl.frame.origin.y+CoreLbl.frame.size.height, self.view.frame.size.width/3-15, 40)];
       
        rateTxt.tag = 8; // Set a constant for this
        rateTxt.font = [UIFont systemFontOfSize:14.0];
        rateTxt.layer.borderWidth = 1.0f;
        rateTxt.layer.cornerRadius = 2.0f;
        rateTxt.placeholder = @"Rate";
        [cell.contentView addSubview:rateTxt];
        [rateTxt setKeyboardType:UIKeyboardTypeNumberPad];
        rateTxt.delegate = self ;
        rateTxt.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
        [rateTxt addTarget:self action:@selector(rateTxtDidChange:) forControlEvents:UIControlEventEditingChanged];
       
        discountTxt = [[UITextField alloc] initWithFrame:CGRectMake(self.view.frame.size.width/3+5, CoreLbl.frame.origin.y+CoreLbl.frame.size.height, self.view.frame.size.width/3-15, 40)];
        discountTxt.layer.borderWidth = 1.0f;
        discountTxt.layer.cornerRadius = 2.0f;
        discountTxt.tag = 9; // Set a constant for this
        [discountTxt setKeyboardType:UIKeyboardTypeNumberPad];
        discountTxt.font = [UIFont systemFontOfSize:14.0];
        discountTxt.placeholder = @"Discount";
        discountTxt.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
        [cell.contentView addSubview:discountTxt];
        [discountTxt addTarget:self action:@selector(discountTxtDidChange:) forControlEvents:UIControlEventEditingChanged];
        
        quantityTxt = [[UITextField alloc] initWithFrame:CGRectMake((self.view.frame.size.width/3)*2, CoreLbl.frame.origin.y+CoreLbl.frame.size.height, self.view.frame.size.width/3-15, 40)];
        quantityTxt.layer.borderWidth = 1.0f;
        quantityTxt.layer.cornerRadius = 2.0f;
        quantityTxt.tag = 10; // Set a constant for this
        quantityTxt.font = [UIFont systemFontOfSize:14.0];
        [quantityTxt setKeyboardType:UIKeyboardTypeNumberPad];
        quantityTxt.placeholder = @"Quantity";
        quantityTxt.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
        [cell.contentView addSubview:quantityTxt];
        [quantityTxt addTarget:self action:@selector(quantityTxtDidChange:) forControlEvents:UIControlEventEditingChanged];
        
        
        
        
        totalValueLbl = [[UILabel alloc] initWithFrame:CGRectMake(10,quantityTxt.frame.origin.y+quantityTxt.frame.size.height, self.view.frame.size.width-60, 50)];
        totalValueLbl.numberOfLines = 0 ;
        totalValueLbl.lineBreakMode = NSLineBreakByWordWrapping;
        totalValueLbl.tag = 11; // Set a constant for this
        totalValueLbl.font = [UIFont systemFontOfSize:14.0];
        [cell.contentView addSubview:totalValueLbl];
        
        
    }
    else
    {
        descriptionLbl = (UILabel *)[cell.contentView viewWithTag:1];
    }
    CGFloat fontSize = 14.f;
    
    
    
    NSString * Desc =[NSString stringWithFormat:@"Description: %@",self.itemListDetailModels.product];
    
    NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc] initWithString:Desc];
    [attributedString setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:fontSize]}
                             range:NSMakeRange(0, 11)];
    
    [descriptionLbl setAttributedText: attributedString];
    
    NSString * subCat = [NSString stringWithFormat:@"Subcategory: %@",self.itemListDetailModels.primary_category];
    
    NSMutableAttributedString* attributedString1 = [[NSMutableAttributedString alloc] initWithString:subCat];
    [attributedString1 setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:fontSize]}
                               range:NSMakeRange(0, 12)];
    
    [subcategoryLbl setAttributedText: attributedString1];
    
    NSString * LP_Meter =[NSString stringWithFormat:@"LP/Mtr: %@",self.itemListDetailModels.listpricemtr];
    NSMutableAttributedString* attributedString2 = [[NSMutableAttributedString alloc] initWithString:LP_Meter];
    [attributedString2 setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:fontSize]}
                             range:NSMakeRange(0, 7)];
    [LP_MeterLbl setAttributedText: attributedString2];
    
    
    NSString * size = [NSString stringWithFormat:@"Size: %@",self.itemListDetailModels.size];
    NSMutableAttributedString* attributedString3 = [[NSMutableAttributedString alloc] initWithString:size];
    [attributedString3 setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:fontSize]}
                             range:NSMakeRange(0, 5)];
    [sizeLbl setAttributedText: attributedString3];
    
    NSString * core = [NSString stringWithFormat:@"Core: %@",self.itemListDetailModels.core];
    NSMutableAttributedString* attributedString4 = [[NSMutableAttributedString alloc] initWithString:core];
    [attributedString4 setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:fontSize]}
                             range:NSMakeRange(0, 5)];
    [CoreLbl setAttributedText: attributedString4];
    
    NSString * unit = @"Unit: METER";
    NSMutableAttributedString* attributedString5 = [[NSMutableAttributedString alloc] initWithString:unit];
    [attributedString5 setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:fontSize]}
                             range:NSMakeRange(0, 5)];
    [UnitLbl setAttributedText: attributedString5];
    
    NSString * price =[NSString stringWithFormat:@"Price: %@",self.itemListDetailModels.listpricemtr];
    NSMutableAttributedString* attributedString6 = [[NSMutableAttributedString alloc] initWithString:price];
    [attributedString6 setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:fontSize]}
                             range:NSMakeRange(0, 6)];
    [priceLbl setAttributedText: attributedString6];
    
    
    
    
    NSString * totalValue =[NSString stringWithFormat:@"Total Value: %@",self.itemListDetailModels.listpricemtr];
    NSMutableAttributedString* attributedString10 = [[NSMutableAttributedString alloc] initWithString:totalValue];
    [attributedString10 setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:fontSize]}
                             range:NSMakeRange(0, 13)];
    [totalValueLbl setAttributedText: attributedString10];
    


    return cell;
}



#pragma mark - UITableViewDelegate
// when user tap the row, what action you want to perform
- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"selected %d row", indexPath.row);
    [self.view endEditing:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
 {
     return 300;
 }



- (void)discountTxtDidChange:(UITextField *)textField
{
    
    
        CGPoint origin = textField.frame.origin;
        CGPoint point = [textField.superview convertPoint:origin toView:self.tableView];
        NSIndexPath * indexPath = [self.tableView indexPathForRowAtPoint:point];
        self.itemListDetailModels  = [self.listItems objectAtIndex: indexPath.row];
    
    


        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
        UITextField *rateTxt = (UITextField *)[cell.contentView viewWithTag:8];

    UITextField *discountTxt = (UITextField *)[cell.contentView viewWithTag:9];
    
      double myDiscount = [discountTxt.text doubleValue];
      double actualRate = [self.itemListDetailModels.listpricemtr doubleValue];
      double Rate =  (myDiscount * actualRate)/100 ;
      double newRate  = (actualRate - Rate);
         
      rateTxt.text = [NSString stringWithFormat:@"%.2f",newRate];
        UILabel *totalSpaValueLbl = (UILabel *)[cell.contentView viewWithTag:11];
    totalSpaValueLbl.text = [NSString stringWithFormat:@"%.2f", newRate *  [self.itemListDetailModels.qty_mtr doubleValue]];
      
    self.itemListDetailModels.spaapproved = [NSString stringWithFormat:@"%.2f",newRate];
       
    
}



- (void)rateTxtDidChange:(UITextField *)textField
{
    

    CGPoint origin = textField.frame.origin;
    CGPoint point = [textField.superview convertPoint:origin toView:self.tableView];
    NSIndexPath * indexPath = [self.tableView indexPathForRowAtPoint:point];
    self.itemListDetailModels  = [self.listItems objectAtIndex: indexPath.row];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
    
        UITextField *rateTxt = (UITextField *)[cell.contentView viewWithTag:8];
    UITextField *discountTxt = (UITextField *)[cell.contentView viewWithTag:9];
    
        double myRate = [rateTxt.text doubleValue];
        self.itemListDetailModels.spaapproved = [NSString stringWithFormat:@"%.2f",myRate];
        double actualRate = [self.itemListDetailModels.listpricemtr doubleValue];
        double getDiscount =  (actualRate - myRate) ;
        double newDiscount  = ( (getDiscount * 100)/actualRate);
        NSLog(@"Display Int Value:%f",newDiscount);
        
        discountTxt.text = [NSString stringWithFormat:@"%.2f",newDiscount];
    UILabel *totalSpaValueLbl = (UILabel *)[cell.contentView viewWithTag:11];
    totalSpaValueLbl.text = [NSString stringWithFormat:@"%.2f", myRate *  [self.itemListDetailModels.qty_mtr doubleValue]];

}

- (void)quantityTxtDidChange:(UITextField *)textField
{
    
    CGPoint origin = textField.frame.origin;
    CGPoint point = [textField.superview convertPoint:origin toView:self.tableView];
    NSIndexPath * indexPath = [self.tableView indexPathForRowAtPoint:point];
    self.itemListDetailModels  = [self.listItems objectAtIndex: indexPath.row];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
    
    UITextField *rateTxt = (UITextField *)[cell.contentView viewWithTag:8];
    UITextField *quantityTxt = (UITextField *)[cell.contentView viewWithTag:10];
    UILabel *totalValueTxt = (UILabel *)[cell.contentView viewWithTag:11];
    
    double myquantity = [quantityTxt.text intValue];
    double currentRate =  [rateTxt.text doubleValue] ;
    double totalValues  = ( myquantity * currentRate);
    NSLog(@"Display Int Value:%f",totalValues);
    
  //  totalValueTxt.text = [NSString stringWithFormat:@"%.2f",totalValue];
    
    CGFloat fontSize = 14.f;
    NSString * totalValue = [NSString stringWithFormat:@"Total Value: %.2f",totalValues];
    NSMutableAttributedString* attributedString10 = [[NSMutableAttributedString alloc] initWithString:totalValue];
    [attributedString10 setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:fontSize]}
                             range:NSMakeRange(0, 13)];
    [totalValueTxt setAttributedText: attributedString10];
    

    
}

- (void) ShowAlert:(NSString *)Message {
    UIAlertController * alert=[UIAlertController alertControllerWithTitle:nil
                                                                  message:@""
                                                           preferredStyle:UIAlertControllerStyleAlert];
    UIView *firstSubview = alert.view.subviews.firstObject;
    UIView *alertContentView = firstSubview.subviews.firstObject;
    for (UIView *subSubView in alertContentView.subviews) {
        subSubView.backgroundColor = [UIColor colorWithRed:141/255.0f green:0/255.0f blue:254/255.0f alpha:1.0f];
    }
    NSMutableAttributedString *AS = [[NSMutableAttributedString alloc] initWithString:Message];
    [AS addAttribute: NSForegroundColorAttributeName value: [UIColor whiteColor] range: NSMakeRange(0,AS.length)];
    [alert setValue:AS forKey:@"attributedTitle"];
    [self presentViewController:alert animated:YES completion:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alert dismissViewControllerAnimated:YES completion:^{
        }];
    });
}


- (void)SingleDiscountTxtDidChange:(UITextField *)textField
{
    
    UITextField *singleDiscountTxt = (UITextField *)[self.tableView viewWithTag:100];
    
   // singleDiscountTxt.text = @"100";
    double mySingleDiscount = [singleDiscountTxt.text doubleValue];
    if (mySingleDiscount < 0 || mySingleDiscount>100)
    {
        singleDiscountTxt.text = @"";
        
        [self ShowAlert:@"Discount can not be greater than 100%"];
        for (int i = 0; i < [self.listItems count]; i++)
        {
             self.itemListDetailModels  = [self.listItems objectAtIndex: i];
             UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            
            UITextField *discountTxt = (UITextField *)[cell.contentView viewWithTag:9];
            UITextField *rateTxt = (UITextField *)[cell.contentView viewWithTag:8];
            discountTxt.text = @"";
            rateTxt.text = @"";
            
        }
    }
    else
    {
           for (int i = 0; i < [self.listItems count]; i++)
           {
                self.itemListDetailModels  = [self.listItems objectAtIndex: i];
                UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
               
               UITextField *discountTxt = (UITextField *)[cell.contentView viewWithTag:9];
               UITextField *rateTxt = (UITextField *)[cell.contentView viewWithTag:8];
               discountTxt.text = singleDiscountTxt.text;
               
               double myDiscount = [discountTxt.text doubleValue];
               double actualRate = [self.itemListDetailModels.listpricemtr doubleValue];
             if (myDiscount > 0 && myDiscount<=100)
             {
               double Rate =  (myDiscount * actualRate)/100 ;
               double newRate  = (actualRate - Rate);
            
               
               rateTxt.text = [NSString stringWithFormat:@"%.2f",newRate];
               self.itemListDetailModels.spaapproved = [NSString stringWithFormat:@"%.2f",newRate];
                 
                 UILabel *totalSpaValueLbl = (UILabel *)[cell.contentView viewWithTag:11];
                 totalSpaValueLbl.text = [NSString stringWithFormat:@"%.2f", newRate *  [self.itemListDetailModels.qty_mtr doubleValue]];

             }
//             else
//             {
//
//
//                 [self ShowAlert:@"Discount can not be greater than 100%"];
//
//                 discountTxt.text = @"";
//                 rateTxt.text = @"";
//             }
             
           }
    
    }
              
}

-(void) spaRejectNetworkCall {
    [self spaActionNetworkCall:@"rejected" withLmeDetail:nil withShowLmeFlag:false withRemark:nil withRemark2:nil withRemark3:nil];
}

-(void) spaReviseNetworkCall {
    [self spaReviseNetworkCall:@"revise remark"];
}
-(void) spaActionNetworkCall :(NSString*)approverActionStatus withLmeDetail:(NSDictionary*)lmeDetails withShowLmeFlag: (BOOL) showLmeToCustomer withRemark:(NSString*) remark withRemark2:(NSString*) remark2 withRemark3:(NSString*) remark3
{
    loadingView = [LoadingView loadingViewInView:self.view];
    ClientVariable* clientVariables = [ClientVariable getInstance : [DVAppDelegate currentModuleContext] ];
    NSMutableArray *spaLines = [[NSMutableArray alloc]init];
    
    for (int cntElement = 0; cntElement < [self.listItems count]; cntElement++) {
        itemListDetailModel *approvedLine = [self.listItems objectAtIndex:cntElement];
        NSMutableDictionary *lineItem = [[NSMutableDictionary alloc]init];
        [lineItem setValue:approvedLine.spalrefid  forKey:@"spalrefId"];
        [lineItem setValue:approvedLine.spaapproved  forKey:@"approvedValue"];
        [spaLines addObject:lineItem];
    }
    NSMutableDictionary *requestDataDict = [[NSMutableDictionary alloc]init];
    [requestDataDict setValue:self.spahrefid  forKey:@"spahrefId"];
    if([approverActionStatus isEqualToString:@"approved"]){
        if(lmeDetails!=nil){
            [requestDataDict setValue:[lmeDetails objectForKey:@"LME_COPPER"]  forKey:@"lmeCopper"];
            [requestDataDict setValue:[lmeDetails objectForKey:@"LME_DOLLAR_RATE"]  forKey:@"usdInr"];
            [requestDataDict setValue:[lmeDetails objectForKey:@"LME_ALUMINIUM"]  forKey:@"lmeAluminium"];
        }
        if(remark!=nil){
            [requestDataDict setValue:remark  forKey:@"approverRemarks"];
        }
        if(remark2!=nil){
            [requestDataDict setValue:remark2  forKey:@"approverRemarks2"];
        }
        if(remark3!=nil){
            [requestDataDict setValue:remark3  forKey:@"approverRemarks3"];
        }
    
        [requestDataDict setValue:showLmeToCustomer ? @"YES" : @"NO"  forKey:@"showLmeDetails"];
        [requestDataDict setValue:self.spa_payment_terms  forKey:@"spa_payment_terms"];
    }
    
    
    [requestDataDict setValue:clientVariables.CLIENT_USER_LOGIN.userName  forKey:@"approvedBy"];
    [requestDataDict setObject:spaLines  forKey:@"spaLines"];
//                        var username = "<%=(String)session.getAttribute("username")%>";
//
//
//                        var OrderPingRequest = {"opcode":"SPA_REQUEST_APPROVE", "authToken": authToken, "status":status,"data":requestData};
    
    NSMutableDictionary *opcodeRequestDict = [[NSMutableDictionary alloc]init];
    [opcodeRequestDict setValue:@"SPA_REQUEST_APPROVE" forKey:@"opcode"];
    [opcodeRequestDict setValue:clientVariables.CLIENT_LOGIN_RESPONSE.authToken forKey:@"authToken"];
    [opcodeRequestDict setValue:approverActionStatus forKey:@"status"];
    [opcodeRequestDict setObject:requestDataDict forKey:@"data"];
    
    
    // Pradeep, 2020-06-26 We need to disable back button
    // so that user cannot go back
    
    networkHelper = [[NetworkHelper alloc]init];
    
    NSString *url = XmwcsConst_OPCODE_URL;
    networkHelper.serviceURLString = url;
    [networkHelper genericJSONPayloadRequestWith:opcodeRequestDict :self :@"SPA_REQUEST_APPROVE"];
}


-(void) spaReviseNetworkCall :(NSString*) remark
{
    loadingView = [LoadingView loadingViewInView:self.view];
    ClientVariable* clientVariables = [ClientVariable getInstance : [DVAppDelegate currentModuleContext] ];
    
    NSMutableDictionary *requestDataDict = [[NSMutableDictionary alloc]init];
    [requestDataDict setValue:self.spahrefid  forKey:@"spahrefid"];
//    [requestDataDict setValue:self.spahrefid  forKey:@"spahrefid"];
    [requestDataDict setValue:remark  forKey:@"remark"];
    
    
    
    [requestDataDict setValue:clientVariables.CLIENT_USER_LOGIN.userName  forKey:@"revisedBy"];
//    [requestDataDict setObject:spaLines  forKey:@"spaLines"];
//                        var username = "<%=(String)session.getAttribute("username")%>";
//
//
//                        var OrderPingRequest = {"opcode":"SPA_REQUEST_APPROVE", "authToken": authToken, "status":status,"data":requestData};
    
    NSMutableDictionary *opcodeRequestDict = [[NSMutableDictionary alloc]init];
    [opcodeRequestDict setValue:@"TO_BE_REVISE" forKey:@"opcode"];
    [opcodeRequestDict setValue:clientVariables.CLIENT_LOGIN_RESPONSE.authToken forKey:@"authToken"];
//    [opcodeRequestDict setValue:approverActionStatus forKey:@"status"];
    [opcodeRequestDict setObject:requestDataDict forKey:@"data"];
    
    
    // Pradeep, 2020-06-26 We need to disable back button
    // so that user cannot go back
    
    networkHelper = [[NetworkHelper alloc]init];
    
    NSString *url = XmwcsConst_OPCODE_URL;
    networkHelper.serviceURLString = url;
    [networkHelper genericJSONPayloadRequestWith:opcodeRequestDict :self :@"TO_BE_REVISE"];
}

-(void) getLME_Data
{
    
    loadingView = [LoadingView loadingViewInView:self.view];
    DotFormPost* formPost = [[DotFormPost alloc] init];
    
    formPost.moduleId = AppConst_MOBILET_ID_DEFAULT;
    
    formPost.adapterId = @"DR_LME_DETAILS";
    formPost.adapterType = @"CLASSLOADER";

    XmwReportService* reportService = [[XmwReportService alloc] initWithPostData:formPost withContext:@"DR_LME_DETAILS"];
    
    
    [reportService fetchReportUsingSuccess:^(DotFormPost* formPosted, ReportPostResponse* reportResponse) {
        
//        NSString* copperRate = [reportResponse.headerData objectForKey:@"LME_COPPER"];
//        NSString* aluminiumRate = [reportResponse.headerData objectForKey:@"LME_ALUMINIUM"];
//        NSString* dollarRate = [reportResponse.headerData objectForKey:@"LME_DOLLAR_RATE"];
//        NSString* lastUpdateDate = [reportResponse.headerData objectForKey:@"LAST_UPDATE_DATE"];
//        NSString* validity = [reportResponse.headerData objectForKey:@"SPA_VALIDITY"];
        
//        NSMutableString* lmeNote = [[NSMutableString alloc] init];
//        [lmeNote appendFormat:@"Price based on Copper %@", copperRate];
//        [lmeNote appendFormat:@" $/ton,\r\nAlluminium %@", aluminiumRate];
//        [lmeNote appendFormat:@" $/ton, $ Rate %@", dollarRate];
//        [lmeNote appendFormat:@" Rs. Valid for %@ days.", validity];
//        self.lmeNoteLbl.text = lmeNote;
        [self PopupView:reportResponse.headerData];
        
    }   fail:^(DotFormPost* formPosted, NSString* message) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Polycab" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
        [myAlertView show];
    }];
}
- (void) httpResponseObjectHandler:(NSString*) callName :(id) respondedObject :(id) requestedObject
{
    [loadingView removeView];
    
    [super httpResponseObjectHandler:callName :respondedObject :requestedObject];
    
    if ([callName isEqualToString:@"SPA_REQUEST_APPROVE"]) {
                
        if ([respondedObject valueForKey:@"status"]!=nil) {
             NSLog(@"Post Data = %@",respondedObject);
            NSString *status_flag = [respondedObject valueForKey:@"status"];
            if ([status_flag isEqualToString:@"SUCCESS"]) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"SPA Request Approval" message: [respondedObject valueForKey:@"message"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
                NSArray *viewControllers = [self.navigationController viewControllers];
                [self.navigationController popToViewController:viewControllers[viewControllers.count - 3] animated:YES];
            }else{
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error : SPA Approval Unsuccessful" message: [respondedObject valueForKey:@"message"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
//            else
//            {
//                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Polycab" message: [[respondedObject valueForKey:@"so_header"]valueForKey:@"ERROR_MESSAGE"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//                [alert show];
//            }
        }
    }else if ([callName isEqualToString:@"TO_BE_REVISE"]) {
        
        if ([respondedObject valueForKey:@"status"]!=nil) {
             NSLog(@"Post Data = %@",respondedObject);
            NSString *status_flag = [respondedObject valueForKey:@"status"];
            if ([status_flag isEqualToString:@"SUCCESS"]) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"SPA Request Status" message: [respondedObject valueForKey:@"message"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
                NSArray *viewControllers = [self.navigationController viewControllers];
                [self.navigationController popToViewController:viewControllers[viewControllers.count - 3] animated:YES];
            }else{
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error : SPA Revision Unsuccessful" message: [respondedObject valueForKey:@"message"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
//            else
//            {
//                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Polycab" message: [[respondedObject valueForKey:@"so_header"]valueForKey:@"ERROR_MESSAGE"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//                [alert show];
//            }
        }
    }
        
    

}

- (void) httpFailureHandler : (NSString*) callName : (NSString*) message {
    [loadingView removeView];
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Polycab" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
    [myAlertView show];
    
}
@end


