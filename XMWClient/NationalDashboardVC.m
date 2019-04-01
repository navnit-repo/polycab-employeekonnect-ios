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
@interface NationalDashboardVC ()

@end

@implementation NationalDashboardVC
{
    NationalSalesAggregateCollectionView *nationalSalesAggregateCollectionView;
    NationalSalesAggregatePieView*    nationalSalesAggregatePieView;
    PaymentOutstandingPieView *   paymentOutstandingPieView;
        MarqueeLabel *lble;
    OverduePieView *overduePieView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"NationalDashboardVC call");
    // Do any additional setup after loading the view from its nib.
}
- (void)refreshTable {
    //TODO: refresh your data
    [refreshControl endRefreshing];
    [self loadCellView];
    [self.tableView reloadSections:[[NSIndexSet alloc] initWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView reloadSections:[[NSIndexSet alloc] initWithIndex:2] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView reloadSections:[[NSIndexSet alloc] initWithIndex:3] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView reloadSections:[[NSIndexSet alloc] initWithIndex:4] withRowAnimation:UITableViewRowAnimationFade];
    // [tableView reloadData];
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
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    CGFloat height = 0.0;
    if (indexPath.section ==0) {
        height = deviceHeightRation*20;
    }
    
    if (indexPath.section==1) {
        
        UIView *currentView= [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 180)];
        CGRect viewFrame=currentView.frame;
        viewFrame.origin.x=deviceWidthRation*currentView.frame.origin.x;
        viewFrame.origin.y=deviceHeightRation*currentView.frame.origin.y;
        viewFrame.size.width=deviceWidthRation*currentView.frame.size.width;
        viewFrame.size.height=deviceHeightRation*currentView.frame.size.height;
        currentView.frame=viewFrame;
        height=currentView.frame.size.height;
    }
    if (indexPath.section==2) {
        UIView *currentView= [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 271)];
        CGRect viewFrame=currentView.frame;
        viewFrame.origin.x=deviceWidthRation*currentView.frame.origin.x;
        viewFrame.origin.y=deviceHeightRation*currentView.frame.origin.y;
        viewFrame.size.width=deviceWidthRation*currentView.frame.size.width;
        viewFrame.size.height=deviceHeightRation*currentView.frame.size.height;
        currentView.frame=viewFrame;
        
        height=currentView.frame.size.height;
    }
    if (indexPath.section==3) {
        
        UIView *currentView= [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 271)];
        CGRect viewFrame=currentView.frame;
        viewFrame.origin.x=deviceWidthRation*currentView.frame.origin.x;
        viewFrame.origin.y=deviceHeightRation*currentView.frame.origin.y;
        viewFrame.size.width=deviceWidthRation*currentView.frame.size.width;
        viewFrame.size.height=deviceHeightRation*currentView.frame.size.height;
        currentView.frame=viewFrame;
        
        height=currentView.frame.size.height;
    }
    if (indexPath.section==4) {
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString* cellIdentifier = [NSString stringWithFormat:@"cell_%ld", (long)indexPath.section];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    
    
    if(indexPath.section==0) {
        
        cell.backgroundColor = [UIColor clearColor];
        
        NSString *text1 = @"Dear";
        NSString *text2;
        text2= [[NSUserDefaults standardUserDefaults] valueForKey:@"customer_name"];
        
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
        [cell addSubview:lble];
        cell.clipsToBounds = YES;
        
    }
    
    if(indexPath.section==1) {
        
        cell.backgroundColor = [UIColor clearColor];
        cell.frame=CGRectMake(10, 0,nationalSalesAggregateCollectionView.bounds.size.width-5 ,nationalSalesAggregateCollectionView.bounds.size.height-5);
        cell.layer.cornerRadius = 5;
        cell.layer.masksToBounds = true;
        [cell addSubview:nationalSalesAggregateCollectionView];
        cell.clipsToBounds = YES;
        
        
        
    }
    if (indexPath.section == 2) {
        cell.backgroundColor = [UIColor clearColor];
        
        cell.frame=CGRectMake(10, 0,nationalSalesAggregatePieView.bounds.size.width-5 ,nationalSalesAggregatePieView.bounds.size.height-5);
        cell.layer.cornerRadius = 5;
        cell.layer.masksToBounds = true;
        [cell addSubview:nationalSalesAggregatePieView];
        cell.clipsToBounds = YES;
        
    }
    if (indexPath.section == 3) {
        
        
        cell.backgroundColor = [UIColor clearColor];
        
        cell.frame=CGRectMake(10, 0,paymentOutstandingPieView.bounds.size.width-5 ,paymentOutstandingPieView.bounds.size.height-5);
        cell.layer.cornerRadius = 5;
        cell.layer.masksToBounds = true;
        [cell addSubview:paymentOutstandingPieView];
        cell.clipsToBounds = YES;
        
    }
    
    if (indexPath.section == 4) {
        
        
        cell.backgroundColor = [UIColor clearColor];
        
        cell.frame=CGRectMake(10, 0,overduePieView.bounds.size.width-5 ,overduePieView.bounds.size.height-5);
        cell.layer.cornerRadius = 5;
        cell.layer.masksToBounds = true;
        [cell addSubview:overduePieView];
        cell.clipsToBounds = YES;
        
    }
    
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section ==1) {
        
        UIActivityIndicatorView *act = [(UIActivityIndicatorView*)self.view viewWithTag:50000];
        [act startAnimating];
        
    }
    if (indexPath.section ==2) {
        UIActivityIndicatorView *act = [(UIActivityIndicatorView*)self.view viewWithTag:50001];
        [act startAnimating];
    }
    if (indexPath.section ==3) {
        UIActivityIndicatorView *act = [(UIActivityIndicatorView*)self.view viewWithTag:50002];
        [act startAnimating];
    }
    if (indexPath.section ==4) {
        UIActivityIndicatorView *act = [(UIActivityIndicatorView*)self.view viewWithTag:50003];
        [act startAnimating];
    }
    
}
@end
