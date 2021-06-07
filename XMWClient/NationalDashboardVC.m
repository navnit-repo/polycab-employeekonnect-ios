//
//  NationalDashboardVC.m
//  XMWClient
//
//  Created by dotvikios on 14/02/19.
//  Copyright © 2019 dotvik. All rights reserved.
//

#import "NationalDashboardVC.h"
#import "SalesAggregateCollectionView.h"
#import "CreditDetailsCollectionView.h"
#import "OverDueCollectionView.h"
#import "NationalSalesAggregateCollectionView.h"
#import "NationalSalesAggregatePieView.h"
#import "PaymentOutstandingPieView.h"
#import "OverduePieView.h"
#import "CollectionCollectionView.h"

@interface NationalDashboardVC ()

@end

@implementation NationalDashboardVC
{
    NationalSalesAggregateCollectionView *nationalSalesAggregateCollectionView;
    NationalSalesAggregatePieView*    nationalSalesAggregatePieView;
    PaymentOutstandingPieView *   paymentOutstandingPieView;
        MarqueeLabel *lble;
    OverduePieView *overduePieView;
    
    CollectionCollectionView* paymentCollectionView;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"NationalDashboardVC call");
    // Do any additional setup after loading the view from its nib.
    
}

- (void)loadCellView
{
    nationalSalesAggregateCollectionView = [NationalSalesAggregateCollectionView createInstance];
    [nationalSalesAggregateCollectionView configure];
    
    
    nationalSalesAggregatePieView =[NationalSalesAggregatePieView createInstance];
    [nationalSalesAggregatePieView configure];
    
    
    paymentOutstandingPieView = [PaymentOutstandingPieView createInstance];
    [paymentOutstandingPieView configure];
    
    overduePieView = [OverduePieView createInstance];
    [overduePieView configure];
    
    paymentCollectionView = [CollectionCollectionView createInstance];
    [paymentCollectionView configure];
    
}
- (void)dashboardForegroundRefresh
{
    if([self timerCheck])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:XmwcsConst_NATIONALSALESAGGREGATE_CARD_AUTOREFRESH_IDENTIFIER object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:XmwcsConst_NATIONALSALESAGGREGATEPIE_CARD_AUTOREFRESH_IDENTIFIER object:nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:XmwcsConst_PAYMENTOUTSTANDING_CARD_AUTOREFRESH_IDENTIFIER object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:XmwcsConst_OVERDUEPIE_CARD_AUTOREFRESH_IDENTIFIER object:nil];
    }
   
}
- (void)refreshTable {
    //TODO: refresh your data
    [refreshControl endRefreshing];
    if([self timerCheck])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:XmwcsConst_NATIONALSALESAGGREGATE_CARD_AUTOREFRESH_IDENTIFIER object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:XmwcsConst_NATIONALSALESAGGREGATEPIE_CARD_AUTOREFRESH_IDENTIFIER object:nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:XmwcsConst_PAYMENTOUTSTANDING_CARD_AUTOREFRESH_IDENTIFIER object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:XmwcsConst_OVERDUEPIE_CARD_AUTOREFRESH_IDENTIFIER object:nil];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 7;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section==0) {
        return 1;
    }
    else if (section==1) {
        return 1;
    }
    
    else if (section ==2) {
        return 1;
    }
    else  if (section == 3) {
        return 1;
    }
    else  if (section == 4) {
        return 1;
    }
    else  if (section == 5) {
        return 1;
    } else  if (section == 6) {
        return 1;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    CGFloat height = 0.0;
    if (indexPath.section ==0) {
        height = deviceHeightRation*20;
    }
   else if (indexPath.section ==1) {
        height = 20;
    }
    
   else if (indexPath.section==2) {
        // Sales Slider
        UIView *currentView= [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 180)];
        CGRect viewFrame=currentView.frame;
        viewFrame.origin.x=deviceWidthRation*currentView.frame.origin.x;
        viewFrame.origin.y=deviceHeightRation*currentView.frame.origin.y;
        viewFrame.size.width=deviceWidthRation*currentView.frame.size.width;
        viewFrame.size.height=deviceHeightRation*currentView.frame.size.height;
        currentView.frame=viewFrame;
        height=currentView.frame.size.height;
    }
  else  if (indexPath.section==3) {
      // sales Pie chart
        UIView *currentView= [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 271)];
        CGRect viewFrame=currentView.frame;
        viewFrame.origin.x=deviceWidthRation*currentView.frame.origin.x;
        viewFrame.origin.y=deviceHeightRation*currentView.frame.origin.y;
        viewFrame.size.width=deviceWidthRation*currentView.frame.size.width;
        viewFrame.size.height=deviceHeightRation*currentView.frame.size.height;
        currentView.frame=viewFrame;
        
        height=currentView.frame.size.height;
    } else if (indexPath.section==4) {
        // Collection
        UIView *currentView= [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 180)];
        CGRect viewFrame=currentView.frame;
        viewFrame.origin.x=deviceWidthRation*currentView.frame.origin.x;
        viewFrame.origin.y=deviceHeightRation*currentView.frame.origin.y;
        viewFrame.size.width=deviceWidthRation*currentView.frame.size.width;
        viewFrame.size.height=deviceHeightRation*currentView.frame.size.height;
        currentView.frame=viewFrame;
        height=currentView.frame.size.height;
    }
   else if (indexPath.section==5) {
        // Payment outstanding
        UIView *currentView= [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 271)];
        CGRect viewFrame=currentView.frame;
        viewFrame.origin.x=deviceWidthRation*currentView.frame.origin.x;
        viewFrame.origin.y=deviceHeightRation*currentView.frame.origin.y;
        viewFrame.size.width=deviceWidthRation*currentView.frame.size.width;
        viewFrame.size.height=deviceHeightRation*currentView.frame.size.height;
        currentView.frame=viewFrame;
        
        height=currentView.frame.size.height;
    }
  else  if (indexPath.section==6) {
      // overdue
        UIView *currentView= [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 271)];
        CGRect viewFrame=currentView.frame;
        viewFrame.origin.x=deviceWidthRation*currentView.frame.origin.x;
        viewFrame.origin.y=deviceHeightRation*currentView.frame.origin.y;
        viewFrame.size.width=deviceWidthRation*currentView.frame.size.width;
        viewFrame.size.height=deviceHeightRation*currentView.frame.size.height;
        currentView.frame=viewFrame;
        
        height=currentView.frame.size.height;
    }
    return height;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 0;
    }
    else
    {
    return 16;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString* cellIdentifier = [NSString stringWithFormat:@"cell_%ld", (long)indexPath.section];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        if(indexPath.section==0) {
            // Welcome
            cell.backgroundColor = [UIColor clearColor];
            
            NSString *text1 = @"Dear";
            NSString *text2;
            text2= [[NSUserDefaults standardUserDefaults] valueForKey:@"CUSTOMER_NAME"];
            
            if (text2 == NULL) {
                text2 = @"";
            }
            
            NSString *text3 = @"Welcome to Polycab!";
            UIFont *myFont = [ UIFont fontWithName: @"Helvetica-Regular" size: 15.0 ];
            
            lble = [cell viewWithTag:10];
            [lble removeFromSuperview];
            
            lble = [[MarqueeLabel alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 20)];
            lble.tag =10;
            lble.text = [[[[[NSString stringWithFormat:@"%@",text1]stringByAppendingString:@" "]stringByAppendingString:text2]stringByAppendingString:@", "]stringByAppendingString:text3];
            lble.font  = myFont;
            lble.textColor = [UIColor colorWithRed:204.0/255.0 green:43.0/255.0 blue:43.0/255.0 alpha:1];
            lble.marqueeType = MLContinuous;
            lble.leadingBuffer = 20;
            lble.rate = 30.0;
            lble.labelize = NO;
            lble.holdScrolling = NO;
            [cell.contentView addSubview:lble];
            cell.clipsToBounds = YES;
            
        }
        else if (indexPath.section == 1)
        {
            // sync time label
            CGRect rect = [[UIScreen mainScreen] bounds];
            
            cell.backgroundColor = [UIColor clearColor];
            syncLbl = [[UILabel alloc] init];
            syncLbl.frame = CGRectMake( 20, 0, rect.size.width-40, 20);
            syncLbl.textAlignment = NSTextAlignmentRight;
            syncLbl.font = [ UIFont fontWithName: @"Helvetica-Light" size: 13.0 ];
            syncLbl.text = syncTime;
            syncLbl.textColor = [UIColor colorWithRed:204.0/255.0 green:43.0/255.0 blue:43.0/255.0 alpha:1];
            syncLbl.textAlignment = NSTextAlignmentRight;
            
            [cell.contentView addSubview:syncLbl];
        }  else   if(indexPath.section==2) {
        
            cell.backgroundColor = [UIColor clearColor];
            cell.frame=CGRectMake(10, 0,nationalSalesAggregateCollectionView.bounds.size.width-5 ,nationalSalesAggregateCollectionView.bounds.size.height-5);
            cell.layer.cornerRadius = 5;
            cell.layer.masksToBounds = true;
            [cell.contentView addSubview:nationalSalesAggregateCollectionView];
            cell.clipsToBounds = YES;
        
        } else  if (indexPath.section == 3) {
            // sales Pie chart
            cell.backgroundColor = [UIColor clearColor];
            
            cell.frame=CGRectMake(10, 0,nationalSalesAggregatePieView.bounds.size.width-5 ,nationalSalesAggregatePieView.bounds.size.height-5);
            cell.layer.cornerRadius = 5;
            cell.layer.masksToBounds = true;
            [cell.contentView addSubview:nationalSalesAggregatePieView];
            cell.clipsToBounds = YES;
        
        }  else  if (indexPath.section == 4) {
            
            cell.backgroundColor = [UIColor clearColor];
            
            cell.frame=CGRectMake(10, 0,paymentCollectionView.bounds.size.width-5, paymentCollectionView.bounds.size.height-5);
            cell.layer.cornerRadius = 5;
            cell.layer.masksToBounds = true;
            [cell.contentView addSubview:paymentCollectionView];
            cell.clipsToBounds = YES;
        
        } else  if (indexPath.section == 5) {
            // Collection
            cell.backgroundColor = [UIColor clearColor];
            
            cell.frame=CGRectMake(10, 0,paymentOutstandingPieView.bounds.size.width-5 ,nationalSalesAggregatePieView.bounds.size.height-5);
            cell.layer.cornerRadius = 5;
            cell.layer.masksToBounds = true;
            [cell.contentView addSubview:paymentOutstandingPieView];
            cell.clipsToBounds = YES;
        
        }  else if (indexPath.section == 6) {
        
            cell.backgroundColor = [UIColor clearColor];
            
            cell.frame=CGRectMake(10, 0,overduePieView.bounds.size.width-5 ,overduePieView.bounds.size.height-5);
            cell.layer.cornerRadius = 5;
            cell.layer.masksToBounds = true;
            [cell.contentView addSubview:overduePieView];
            cell.clipsToBounds = YES;
        
        }
    
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        [lble restartLabel];
    }
    
   else if (indexPath.section == 2) {
        
        UIActivityIndicatorView *act = [(UIActivityIndicatorView*)self.view viewWithTag:50000];
        [act startAnimating];
        
    }
   else if (indexPath.section == 3) {
        UIActivityIndicatorView *act = [(UIActivityIndicatorView*)self.view viewWithTag:50001];
        [act startAnimating];
    }
   else if (indexPath.section == 4) {
        UIActivityIndicatorView *act = [(UIActivityIndicatorView*)self.view viewWithTag:50002];
        [act startAnimating];
    }
  else  if (indexPath.section == 5) {
        UIActivityIndicatorView *act = [(UIActivityIndicatorView*)self.view viewWithTag:50003];
        [act startAnimating];
    }
    
}
@end
