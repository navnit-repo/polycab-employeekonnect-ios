//
//  CollectionCollectionView.m
//  XMWClient
//
//  Created by Pradeep Singh on 07/06/21.
//  Copyright © 2021 dotvik. All rights reserved.
//

#import "CollectionCollectionView.h"
#import "DVAppDelegate.h"
#import "NetworkHelper.h"
#import "DotFormPost.h"
#import "XmwReportService.h"
#import "XmwcsConstant.h"
#import "AppConstants.h"
#import "SalesCell.h"
#import "LayoutClass.h"
#import "CurrencyConversationClass.h"
#import "CollectionReportVC.h"
#import "ClientVariable.h"


@interface CollectionCollectionView ()
{
    DotFormPost* formPost;
    ReportPostResponse* collectionResponse;
    NSMutableArray* collectionData;
    
    CurrencyConversationClass* currencyFormat;
    NSString* rupee;
    
}

@end

@implementation CollectionCollectionView


+(CollectionCollectionView*) createInstance

{
    CollectionCollectionView *view = (CollectionCollectionView *)[[[NSBundle mainBundle] loadNibNamed:@"CollectionCollectionView" owner:self options:nil] objectAtIndex:0];
    
    return view;
}


- (void)awakeFromNib
{
    [super awakeFromNib];
    
    collectionData = [[NSMutableArray alloc] init];
    currencyFormat = [[CurrencyConversationClass alloc] init];
    rupee = @"\u20B9";
    
    
}


-(void)autoLayout{
    [LayoutClass setLayoutForIPhone6:self.mainView];
    [LayoutClass setLayoutForIPhone6:self.collectionView];
    [LayoutClass labelLayout:self.underCellLbl forFontWeight:UIFontWeightRegular];
    [LayoutClass setLayoutForIPhone6:self.pageIndicator];
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

-(void)configure
{
    [self autoLayout];
    [self shadowView];
    
    maxCellArray = [[NSMutableArray alloc]init];
    
    self.collectionView.delegate= self;
    self.collectionView.dataSource= self;
    
     [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.bounces = NO;
    
    
    [self loadingView];
    [self networkCall];

}

-(void)autoRefresh
{
    [self loadingView];
    [noDataView removeFromSuperview];
    [_underCellLbl removeFromSuperview];
    
    numberOfCell = 0;
    _pageIndicator.numberOfPages = numberOfCell;
    [self.collectionView reloadData];
    
    [self networkCall];
    
}

-(void)loadingView{
    // add loading View
    
    [blankView removeFromSuperview];
    
    blankView = [[UIView alloc]initWithFrame:CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width-20, self.bounds.size.height)];
    blankView.backgroundColor = [UIColor clearColor];
    
    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(10, 8, 150*deviceWidthRation, 15*deviceHeightRation)];
    lbl.text = @"Collection";
    lbl.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
    [blankView addSubview:lbl];
    
    
    
    activityIndicatorView = [[UIActivityIndicatorView alloc]
                             initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    activityIndicatorView.center=blankView.center;
    activityIndicatorView.tag = 50000;
    [activityIndicatorView startAnimating];
    activityIndicatorView.color = [UIColor redColor];
    activityIndicatorView.hidesWhenStopped = NO;
    activityIndicatorView.hidden = NO;
    
    [blankView addSubview:activityIndicatorView];
    [self.mainView addSubview:blankView];
    
}


-(void) networkCall
{

    formPost = [[DotFormPost alloc]init];
    [formPost setAdapterId:@"DR_COLLECTION_ANALYSIS_BU_WISE"];
    [formPost setAdapterType:@"CLASSLOADER"];
    [formPost setModuleId:AppConst_MOBILET_ID_DEFAULT];
    [formPost setDocDesc:@"Collection BU Wise"];
    
    NSMutableDictionary *sendData = [[NSMutableDictionary alloc]init];
    [sendData setObject:@"" forKey:@"CUSTOMER_ACCOUNT"];

    [formPost setPostData:sendData];
    
    XmwReportService* reportService = [[XmwReportService alloc] initWithPostData:formPost withContext:@"collectionReportCall"];
    
    [reportService fetchReportUsingSuccess:^(DotFormPost* formPosted, ReportPostResponse* reportResponse) {
        // we should receive report response data here
        
        collectionResponse = reportResponse;
        
        if(reportResponse!=nil && reportResponse.tableData !=nil && [reportResponse.tableData count]>0) {
            
            collectionData = reportResponse.tableData;
            numberOfCell = [collectionData count];
            
            [_collectionView reloadData];
            
        } else {
            // no data available
            
        }
        
        
    }   fail:^(DotFormPost* formPosted, NSString* message) {
        // we should receive error response here
        
    }];
    
    
}


#pragma mark - Collection View Datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return numberOfCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.collectionView.frame.size.width, 120*deviceHeightRation);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat width = scrollView.frame.size.width;
    NSInteger page = (scrollView.contentOffset.x + (0.5f * width)) / width;
    NSInteger moveToPage = page;
    
    moveToPage = moveToPage % [collectionData count];
    _pageIndicator.currentPage = moveToPage;
    
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];

    
    [blankView removeFromSuperview];
    
    SalesCell* salesCell = [SalesCell createInstance];
    [LayoutClass setLayoutForIPhone6:salesCell];
    [salesCell autoLayout];
   
    NSArray* rowData = [collectionData objectAtIndex:indexPath.row];
    
    if([rowData count]==8) {
        salesCell.constantLbl1.text = @"Collection - ";
        
        CGSize calcLeftSize = [salesCell.constantLbl1.text boundingRectWithSize:CGSizeMake(collectionView.frame.size.width-10, 1024) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName: salesCell.constantLbl1.font } context:nil].size;
        
        salesCell.displayName.frame = CGRectMake(calcLeftSize.width +
                                                  salesCell.constantLbl1.frame.origin.x,
                                                  salesCell.displayName.frame.origin.y,
                                                  salesCell.displayName.frame.size.width,
                                                 salesCell.displayName.frame.size.height);
        salesCell.displayName.text = [rowData objectAtIndex:0];
        
        
        
        
        salesCell.lftdDisplacyLbl.text = [self currencyDisplay:[rowData objectAtIndex:1]];
        salesCell.ftdDataSetLbl.text = [self currencyDisplay:[rowData objectAtIndex:3]];
        
        salesCell.lmtdDisplayLbl.text = [self currencyDisplay:[rowData objectAtIndex:4]];
        salesCell.mtdDataSetLbl.text = [self currencyDisplay:[rowData objectAtIndex:6]];
        
        salesCell.ytdDataSetLbl.text = [self currencyDisplay:[rowData objectAtIndex:7]];
    }
    
    NSInteger tagId = 1000 + indexPath.row;
    salesCell.tag = tagId;

    [[cell.contentView viewWithTag:tagId] removeFromSuperview];
    
    [cell.contentView addSubview:salesCell];
    cell.clipsToBounds = YES;
            
   
    //set under lable text
    NSString *text = @"Above data is a representation Total Sales of";
    
    NSLocale* currentDate = [NSLocale currentLocale];
    [[NSDate date] descriptionWithLocale:currentDate];
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy"];
    NSLog(@"%@",[dateFormatter stringFromDate:[NSDate date]]);
    NSString *currentYear =[dateFormatter stringFromDate:[NSDate date]];
    
    NSLog(@"Current Year : %@",currentYear);
    
    [_underCellLbl removeFromSuperview];
    _underCellLbl.text =[[[NSString stringWithFormat:@"%@",text]stringByAppendingString:@" "]stringByAppendingString:currentYear];
    
    _pageIndicator.numberOfPages = numberOfCell;
    _pageIndicator.transform = CGAffineTransformMakeScale(0.7, 0.7);
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UIViewController *root;
    root = [[[[UIApplication sharedApplication] windows]objectAtIndex:0]rootViewController];
    
    ClientVariable* clientVariable = [ClientVariable getInstance];
    
    ReportVC *reportVC = [clientVariable reportVCForId:formPost.adapterId];
    
    reportVC.screenId = AppConst_SCREEN_ID_REPORT;
    reportVC.reportPostResponse = collectionResponse;
    
    
    SWRevealViewController *reveal = (SWRevealViewController*)root;
      [(UINavigationController*)reveal.frontViewController pushViewController:reportVC animated:YES];

}


-(NSString*) currencyDisplay:(NSString*) amountValue
{
    
    if([amountValue isKindOfClass:[NSString class]] && [amountValue length]>0) {
        NSString* cleanedString = [[amountValue stringByReplacingOccurrencesOfString:@"," withString:@""]
                                   stringByTrimmingCharactersInSet: [NSCharacterSet symbolCharacterSet]];
    
        return [NSString stringWithFormat:@"%@%@", rupee, [currencyFormat formateCurrency:cleanedString]];
    } else
        return @"";
}


@end
