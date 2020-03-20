//
//  MyClaimVC.m
//  XMWClient
//
//  Created by dotvikios on 05/07/18.
//  Copyright © 2018 dotvik. All rights reserved.
//

#import "MyClaimVC.h"
#import "NetworkHelper.h"
#import "HttpEventListener.h"
#import "LoadingView.h"
#import "MyClaimResponse.h"
#import "TrackClaimVC.h"
#define InvoiceStartTag 1000

@interface MyClaimVC ()

@end

@implementation MyClaimVC
{
     NSDateFormatter* dateFormatter;
    NSDateFormatter *from;
     DVPeriodCalendar *calendar;
     NetworkHelper* networkHelper;
     LoadingView *loadingView;
    MyClaimResponse *claimResponseView;
    NSMutableDictionary *claimResponseData;
    UIScrollView *scroll;
    int cellHeight;
}
@synthesize view1;
@synthesize fromDate;
@synthesize toDate;
@synthesize topView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    topView.frame= CGRectMake(0, 0, self.view.frame.size.width,34);
    [self.view addSubview:topView];
    
    NSLog(@"My Cliam VC Call");
    [self loadForm];
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *presentDate = [dateFormatter stringFromDate:[NSDate date]];
    toDate.text = presentDate;
    
    from = [[NSDateFormatter alloc]init];
    [from setDateFormat:@"yyyy-MM-01"];
    NSString *startMonthDay = [from stringFromDate:[NSDate date]];
    fromDate.text = startMonthDay;
   
    self.view1.tag= 1;
    
    //Network Call
    NSString *userName;
    userName= [[NSUserDefaults standardUserDefaults] objectForKey:@"USERNAME"];
 
    NSDictionary *requestData = [[NSDictionary alloc]initWithObjectsAndKeys:userName,@"CUSTOMER",startMonthDay,@"FROM_DATE",presentDate,@"TO_DATE",nil];
    
    NSMutableDictionary * claimsCAll = [[NSMutableDictionary  alloc]init];
    
    [claimsCAll setObject:requestData forKey:@"data"];
    [claimsCAll setObject:@"customerClaims" forKey:@"opcode"];
    networkHelper = [[NetworkHelper alloc]init];
    NSString * url=@"http://qamkonnect.havells.com:8080/xmwcsdealermkonnect/store";
    networkHelper.serviceURLString = url;
    [networkHelper genericJSONPayloadRequestWith:claimsCAll :self :@"claimsCAll"];
    loadingView= [LoadingView loadingViewInView:self.view];
    
    
    //TapGestureRecognizer
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc]init];
    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changePeriodAction:)];
    [view1 addGestureRecognizer:tapGesture];
    
    
    cellHeight = 200;
    scroll = [[UIScrollView alloc]init];
}
-(void)loadForm{
    //load empty formVC
}

-(void) changePeriodAction:(UITapGestureRecognizer*) gesture
{
    NSInteger columnIndex = gesture.view.tag;
    
    NSLog(@"Column is %ld", columnIndex);
    
    
    DVPeriodCalendar* periodCalendar = [[DVPeriodCalendar alloc] initWithNibName:@"DVPeriodCalendar" bundle:nil];
    periodCalendar.contextId = [NSString stringWithFormat:@"%ld", columnIndex];
    periodCalendar.calendarDelegate  = self;


    DVDateStruct* todayStruct = [DVDateStruct fromNSDate:[NSDate date]];
    [todayStruct setDay:1];
    [todayStruct setYear:(todayStruct.year-4)];

    // we can only go back to 4 years
    periodCalendar.fromLowerDate = [todayStruct convertToNSDate];
    periodCalendar.fromUpperDate = [NSDate date];

    todayStruct = [DVDateStruct fromNSDate:[NSDate date]];
    [todayStruct setDay:1];
    periodCalendar.fromDisplayDate  = [self dafaultFromDateForColumn:columnIndex];

    // we need to set propper to date field variables
    todayStruct = [DVDateStruct fromNSDate:[NSDate date]];
    [todayStruct setDay:1];
    [todayStruct setYear:(todayStruct.year-4)];
    periodCalendar.toLowerDate = [todayStruct convertToNSDate];
    periodCalendar.toUpperDate = [NSDate date];
    periodCalendar.toDisplayDate = [self dafaultFromDateForColumn:columnIndex];

    UIViewController* rootController = [[UIApplication sharedApplication].keyWindow rootViewController];

    [rootController presentViewController:periodCalendar animated:YES completion:nil];

    
}
-(NSDate*) dafaultFromDateForColumn:(NSInteger) columnIndex
{
    DotFormPost* formPost = nil;

    
    
    if(columnIndex==1) {
      
    }

    return [dateFormatter dateFromString:[formPost.postData objectForKey:@"FROM_DATE" ]];
}

-(NSDate*) dafaultToDateForColumn:(NSInteger) columnIndex
{
    DotFormPost* formPost = nil;
    
 if(columnIndex==1) {
}
    
    return [dateFormatter dateFromString:[formPost.postData objectForKey:@"TO_DATE" ]];
}
#pragma mark - DVPeriodCalendarDelegate

-(void) fromDate:(DVDateStruct*) fromDateStruct toDate:(DVDateStruct*) toDateStruct  context:(NSString*) contextId
{
    if(fromDateStruct !=nil && toDateStruct !=nil) {
        
         NSString *fromSelectedDate = [dateFormatter stringFromDate:[fromDateStruct convertToNSDate]];
        
         NSString *toSelectedDate = [dateFormatter stringFromDate:[toDateStruct convertToNSDate]];
        fromDate.text= fromSelectedDate;
        toDate.text = toSelectedDate;
        
        if([contextId isEqualToString:@"1"]) {
            //Network Call
            NSString *userName;
            userName= [[NSUserDefaults standardUserDefaults] objectForKey:@"USERNAME"];
            
            NSDictionary *requestData = [[NSDictionary alloc]initWithObjectsAndKeys:userName,@"CUSTOMER",fromSelectedDate,@"FROM_DATE",toSelectedDate,@"TO_DATE",nil];
            
            NSMutableDictionary * claimsCAll = [[NSMutableDictionary  alloc]init];
            
            [claimsCAll setObject:requestData forKey:@"data"];
            [claimsCAll setObject:@"customerClaims" forKey:@"opcode"];
            networkHelper = [[NetworkHelper alloc]init];
            NSString * url=@"http://qamkonnect.havells.com:8080/xmwcsdealermkonnect/store";
            networkHelper.serviceURLString = url;
            [networkHelper genericJSONPayloadRequestWith:claimsCAll :self :@"claimsCAll"];
            loadingView= [LoadingView loadingViewInView:self.view];
            
        }
        
    }
    
    
}
- (void) httpResponseObjectHandler : (NSString*) callName : (id) respondedObject : (id) requestedObject
{
    [loadingView removeView];
    claimResponseData = [[NSMutableDictionary alloc]init];
    [claimResponseData setDictionary:respondedObject];
 
    NSLog(@"Claims%@",claimResponseData);
    
    [self cellDataLoad];
}
- (void) httpFailureHandler : (NSString*) callName : (NSString*) message {
    [loadingView removeView];
    
    
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Polycab Authentication!" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
    [myAlertView show];
    
}

-(void)cellDataLoad{
    
    NSArray* responseData = [claimResponseData objectForKey:@"responseData"];
    if (responseData.count == 0) {
        scroll.hidden = YES;
       
    }
    else{
        scroll.hidden = NO;
        scroll = [[UIScrollView alloc]init];
        scroll.frame = CGRectMake(0, 34, self.view.frame.size.width, self.view.frame.size.height);
        scroll.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:scroll];
      
       
        long int viewCartHeight = 0;
         int cellConut =0;
    viewCartHeight = viewCartHeight + [responseData count];
    for ( int i=0 ; i < responseData.count; i++) {

        claimResponseView = [MyClaimResponse createInstance:cellConut*190];
   
        claimResponseView.delegate = self;
        [claimResponseView configure:[responseData objectAtIndex:i]];

        claimResponseView.frame= CGRectMake(0, (cellConut*cellHeight), 320,200);
       
        [scroll addSubview:claimResponseView];
         cellConut = cellConut+1;
        claimResponseView.tag = InvoiceStartTag + i;
        
     
        NSLog(@"%i View Cart Tag:- %ld",i+1,claimResponseView.tag);
    }
    [scroll setContentSize:CGSizeMake(320 , (viewCartHeight *200)+34)];
}
    
}
- (IBAction)clearFilterButton:(id)sender {
    [self viewDidLoad];
}
- (void)clickButtonView:(MyClaimResponse *)track Buttontag:(long)tag{
    long int selectButton= tag-1000;
    TrackClaimVC *vc = [[TrackClaimVC alloc]init];
  
   NSArray* responseData = [claimResponseData objectForKey:@"responseData"];
    NSDictionary *trackClaim = [responseData objectAtIndex:selectButton];
    
    
    
    NSString *claimType= [NSString stringWithFormat:@"%@",[trackClaim objectForKey:@"TYPE_CODE"]];
    NSString *claimSubType = [NSString stringWithFormat:@"%@",[trackClaim objectForKey:@"SUBTYPE_CODE"]];
    NSString *reason = [NSString stringWithFormat:@"%@",[trackClaim objectForKey:@"REASON_CODE"]];
    NSString *comments =[NSString stringWithFormat:@"%@",[trackClaim objectForKey:@"REASON"]];
    NSString *claimNo =[NSString stringWithFormat:@"%@",[trackClaim objectForKey:@"CLAIM_NO"]];
    if ([[NSString stringWithFormat:@"%@",[trackClaim objectForKey:@"ZSTATUS1"]] isEqualToString:@"REJECTED" ]|| [[NSString stringWithFormat:@"%@",[trackClaim objectForKey:@"ZSTATUS2"]] isEqualToString:@"REJECTED"] ||[[NSString stringWithFormat:@"%@",[trackClaim objectForKey:@"ZSTATUS3"]] isEqualToString:@"REJECTED" ]) {
         NSString *status= @"REJECTED";
        vc.status = status;
    }
    else{
        if ([[NSString stringWithFormat:@"%@",[trackClaim objectForKey:@"STATUS"]] isEqualToString:@"A" ]) {
             NSString *status= @"APPROVED";
            vc.status = status;
        }
        else if([[NSString stringWithFormat:@"%@",[trackClaim objectForKey:@"STATUS"]] isEqualToString:@"R" ]){
             NSString *status= @"OPEN";
             vc.status = status;
        }
    }

    vc.claimType= claimType;
    vc.claimSubType = claimSubType;
    vc.reason =reason;
    vc.comment = comments;
    vc.claimNo = claimNo;
    
    
    NSMutableArray *claimRecords = [[NSMutableArray alloc]init];
    
    
    NSArray *itemRow = [trackClaim objectForKey:@"itemrows"];
    
    
        for (int i=0; i<itemRow.count; i++) {
            
            [claimRecords addObject:itemRow[i]];
          }
    vc.trackClaimArray = claimRecords;
    [[self navigationController ] pushViewController:vc animated:YES];
    
    
}



@end
