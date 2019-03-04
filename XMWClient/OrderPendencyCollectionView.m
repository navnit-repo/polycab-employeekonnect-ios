//
//  OrderPendencyCollectionView.m
//  XMWClient
//
//  Created by dotvikios on 09/08/18.
//  Copyright © 2018 dotvik. All rights reserved.
//

#import "OrderPendencyCollectionView.h"
#import "ClientVariable.h"
#import "XmwReportService.h"
#import "DotFormPost.h"
#import "AppConstants.h"
#import "OrderPendencyCell.h"
#import "LayoutClass.h"
#import "DVAppDelegate.h"
#import "ProgressBarView.h"
@implementation OrderPendencyCollectionView
{
    NSMutableArray *dataArray;
    ReportPostResponse* barChartResponseData;
    DotFormPost *barChartPostRqst;
    OrderPendencyCell * orderPendencyCell;
    UIView *blankView;
    ProgressBarView *barView;
}
@synthesize collectionView;
@synthesize pageIndicator;
+(OrderPendencyCollectionView*) createInstance

{
    OrderPendencyCollectionView *view = (OrderPendencyCollectionView *)[[[NSBundle mainBundle] loadNibNamed:@"OrderPendencyCollectionView" owner:self options:nil] objectAtIndex:0];
    
    return view;
}
-(void)autoLayout{
    [LayoutClass setLayoutForIPhone6:self.mainView];
    [LayoutClass setLayoutForIPhone6:self.collectionView];
    [LayoutClass setLayoutForIPhone6:self.pageIndicator];
    
    
}
- (void)configure{
    [self autoLayout];
    [self shadowView];
     dataArray = [[NSMutableArray alloc]init];
    self.collectionView.delegate= self;
    self.collectionView.dataSource= self;
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.bounces = NO;
    [self networkCall];
}

-(void)shadowView{
    // *** Set masks bounds to NO to display shadow visible ***
    self.mainView.layer.masksToBounds = NO;
    // *** Set light gray color as shown in sample ***
    self.mainView.layer.shadowColor = [UIColor grayColor].CGColor;
    //    // *** *** Use following to add Shadow top, left ***
    //    self.mainView.layer.shadowOffset = CGSizeMake(-5.0f, -5.0f);
    
    // *** Use following to add Shadow bottom, right ***
    //self.avatarImageView.layer.shadowOffset = CGSizeMake(5.0f, 5.0f);
    
    // *** Use following to add Shadow top, left, bottom, right ***
    self.mainView.layer.shadowOffset = CGSizeZero;
    self.mainView.layer.shadowRadius = 5.0f;
    
    // *** Set shadowOpacity to full (1) ***
    self.mainView.layer.shadowOpacity = 5.0f;
    
    
}

-(void)networkCall{
    
   
    
//    // add blank view
    blankView = [[UIView alloc]initWithFrame:CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width-20, self.bounds.size.height)];
    blankView.backgroundColor = [UIColor clearColor];

    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(10, 8, 150*deviceWidthRation, 15*deviceHeightRation)];
    lbl.text = @"Order Pendency";
    lbl.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
    [blankView addSubview:lbl];


    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
     activityIndicatorView.tag = 50002;
    activityIndicatorView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin |    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleTopMargin |    UIViewAutoresizingFlexibleBottomMargin;
    [activityIndicatorView startAnimating];
    activityIndicatorView.hidesWhenStopped = NO;





    [blankView addSubview:activityIndicatorView];

    [self.mainView addSubview:blankView];
    
    
    
    CGRect activityIndicatorRect = activityIndicatorView.frame;
    activityIndicatorRect.origin.x = blankView.frame.size.width/2;
    activityIndicatorRect.origin.y = blankView.frame.size.height/2;
    activityIndicatorView.frame = activityIndicatorRect;
    activityIndicatorView.color = [UIColor redColor];
    
    
    
    
    NSLocale* currentDate = [NSLocale currentLocale];
    [[NSDate date] descriptionWithLocale:currentDate];
    NSString *fromDate;
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    // or @"yyyy-MM-dd hh:mm:ss a" if you prefer the time with AM/PM
    NSLog(@"%@",[dateFormatter stringFromDate:[NSDate date]]);
    NSString *toDate = [dateFormatter stringFromDate:[NSDate date]];
    NSLog(@"To date : %@",toDate);
    
    
    NSDateFormatter *checkMonth = [[NSDateFormatter alloc] init];
    [checkMonth setDateFormat:@"01/05/yyyy"];
    NSLog(@"%@",[checkMonth stringFromDate:[NSDate date]]);
    
    NSString *date1=[checkMonth stringFromDate:[NSDate date]]; //01-05-current year
    NSString *date2=[dateFormatter stringFromDate:[NSDate date]]; //current to date
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"dd/MM/yyyy"];
    NSDate *dtOne=[format dateFromString:date1];
    NSDate *dtTwo=[format dateFromString:date2];
    NSComparisonResult result;
    result = [dtOne compare:dtTwo];
    
    if (result == NSOrderedAscending) {
        NSDate *date = [NSDate date];
        NSDateComponents *setPreviousYear = [[NSDateComponents alloc] init];
        [setPreviousYear setMonth:-5];
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDate *newDate = [calendar dateByAddingComponents:setPreviousYear toDate:date options:0];
        NSLog(@"newDate -> %@",newDate);
        
        NSDateFormatter *dateFormatterFormDate=[[NSDateFormatter alloc] init];
        [dateFormatterFormDate setDateFormat:@"dd/MM/yyyy"];
        NSLog(@"%@",[dateFormatterFormDate stringFromDate:newDate]);
        fromDate =[dateFormatterFormDate stringFromDate:newDate];
        
        
    }
    else{
        NSDate *date = [NSDate date];
        NSDateComponents *setPreviousYear = [[NSDateComponents alloc] init];
        [setPreviousYear setMonth:-5];
        [setPreviousYear setYear:-1];
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDate *newDate = [calendar dateByAddingComponents:setPreviousYear toDate:date options:0];
        NSLog(@"newDate -> %@",newDate);
        
        NSDateFormatter *dateFormatterFormDate=[[NSDateFormatter alloc] init];
        [dateFormatterFormDate setDateFormat:@"dd/MM/yyyy"];
        NSLog(@"%@",[dateFormatterFormDate stringFromDate:newDate]);
        fromDate =[dateFormatterFormDate stringFromDate:newDate];
    }
  
    
    barChartPostRqst = [[DotFormPost alloc]init];
    [barChartPostRqst setAdapterId:@"DOT_REPORT_SALES_ORDER_PENDENCY_DASHBOARD"];
    [barChartPostRqst setAdapterType:@"CLASSLOADER"];
    [barChartPostRqst setReportCacheRefresh:@"true"];
    [barChartPostRqst setModuleId:AppConst_MOBILET_ID_DEFAULT];
    NSMutableDictionary *sendData = [[NSMutableDictionary alloc]init];
    [sendData setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"USERNAME"]  forKey:@"User_Id"];
    [sendData setObject:fromDate forKey:@"FROM_DATE"];
    [sendData setObject:toDate forKey:@"TO_DATE"];
    [barChartPostRqst setPostData:sendData];
    
    
    
   
    
    
    
    XmwReportService* reportService = [[XmwReportService alloc] initWithPostData:barChartPostRqst withContext:@"barChartPostRqst"];
    
    [reportService fetchReportUsingSuccess:^(DotFormPost* formPosted, ReportPostResponse* reportResponse) {
        
        
        // we should receive report response data here
        barChartResponseData = reportResponse;
        [dataArray addObjectsFromArray:barChartResponseData.tableData];
        NSLog(@"Bar Chart Data: %@",dataArray);
        
            [self.collectionView reloadData];
        
        
    }   fail:^(DotFormPost* formPosted, NSString* message) {
        // we should receive error response here
        
        
    }];
    
    
}
#pragma mark : Collection View Datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [dataArray count];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(self.collectionView.frame.size.width, 289*deviceHeightRation);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat width = scrollView.frame.size.width;
    NSInteger page = (scrollView.contentOffset.x + (0.5f * width)) / width;
    NSInteger moveToPage = page;
    moveToPage = moveToPage % [dataArray count];;
    pageIndicator.currentPage = moveToPage;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
    if (dataArray.count!=0) {
        [blankView removeFromSuperview];
        for (int i=0;i<dataArray.count; i++ ) {
            
            
            
            if (indexPath.row ==i) {
                orderPendencyCell = [OrderPendencyCell createInstance];
                [orderPendencyCell config:[dataArray objectAtIndex:i]];
                [cell addSubview:orderPendencyCell];
                cell.clipsToBounds = YES;
            }
        }
    }
    
   
    pageIndicator.numberOfPages = [dataArray count];
    return cell;
}

@end
