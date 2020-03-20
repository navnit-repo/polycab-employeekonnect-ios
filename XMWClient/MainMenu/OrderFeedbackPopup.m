//
//  OrderFeedbackPopup.m
//  QCMSProject
//
//  Created by Pradeep Singh on 8/26/15.
//  Copyright (c) 2015 dotvik. All rights reserved.
//

#import "OrderFeedbackPopup.h"

#import "BidirectionCollectionLayout.h"


CGFloat productGridLeftMargin = 0.0f;

@interface CollectionCell : UICollectionViewCell

@property (strong, nonatomic) UILabel* label;

@end

@implementation CollectionCell



@end


@interface OrderItemCollectionView : UICollectionView
@property (weak, nonatomic) UIView* headerView;
@end

@implementation OrderItemCollectionView

-(void) layoutSubviews
{
    [super layoutSubviews];
    
    CGPoint headerLocation = CGPointMake(productGridLeftMargin, self.contentOffset.y);
    
    if(self.headerView !=nil) {
        self.headerView.frame = CGRectMake(headerLocation.x, headerLocation.y, self.headerView.frame.size.width, self.headerView.frame.size.height);
    }
}

-(void) setHeaderView:(UIView *)headerView
{
    if(_headerView!=nil) {
        [_headerView removeFromSuperview];
    }
    _headerView = headerView;
    
    [self addSubview:_headerView];
    
    
}

@end

@interface OrderFeedbackPopup ()
{
    NSArray* headerItems;
    NSArray* tableRowsData;
    NSArray* columnKeys;
    CGSize cellSizes[7];
}

@property (strong, nonatomic) OrderItemCollectionView* productGrid;

@end

@implementation OrderFeedbackPopup
{
    int numOfColumns;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


+(id) createInstance
{
    
    OrderFeedbackPopup *view = (OrderFeedbackPopup *)[[[NSBundle mainBundle] loadNibNamed:@"OrderFeedbackPopup" owner:self options:nil] objectAtIndex:0];
   
    BidirectionCollectionLayout *flowLayout = [[BidirectionCollectionLayout alloc] init];
    [flowLayout setMinimumInteritemSpacing:0.0f];
    [flowLayout setMinimumLineSpacing:0.0f];
    
    
    view.productGrid = [[OrderItemCollectionView alloc] initWithFrame:CGRectMake(0, 2, view.popupContainer.frame.size.width, view.popupContainer.frame.size.height - 90) collectionViewLayout:flowLayout];
    
    view.productGrid.backgroundColor = [UIColor clearColor];
    view.productGrid.bounces = NO;
    view.productGrid.dataSource = view;
    view.productGrid.delegate = view;
    [view.productGrid registerClass:[CollectionCell class] forCellWithReuseIdentifier:@"CollectionCell"];
    
    [view.popupContainer addSubview:view.productGrid];
    
    
    return view;
}


-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    headerItems = [NSArray arrayWithObjects:@"Code", @"Description", @"Order Qty", @"Stock Qty",  @"Free Qty", @"Remarks", nil];
    columnKeys = [NSArray arrayWithObjects:@"materialCode", @"materialDesc", @"userQuantity", @"stockAvailable",  @"freeGoodQuantity",  @"offerMessage", nil];
    
    
    cellSizes[0] = CGSizeMake(80.0f, 50.0f);
    cellSizes[1] = CGSizeMake(120.0f, 50.0f);
    cellSizes[2] = CGSizeMake(40.0f, 50.0f);
    cellSizes[3] = CGSizeMake(40.0f, 50.0f);
    cellSizes[4] = CGSizeMake(40.0f, 50.0f);
    cellSizes[5] = CGSizeMake(120.0f, 50.0f);
    
    numOfColumns = 4;   // when we need to show free qty and remarks columns only when offers are avilable, then numOfColumns are 6.
    
    return self;
}


-(IBAction)okHandler:(id)sender
{
    
    if(self.delegate !=nil && [self.delegate respondsToSelector:@selector(confirmOrder)]) {
        [self.delegate confirmOrder];
    }
    [self removeFromSuperview];
    
    
}


-(IBAction)cancelHandler:(id)sender
{
    if(self.delegate !=nil && [self.delegate respondsToSelector:@selector(cancelOrder)]) {
        [self.delegate cancelOrder];
    }
    
    [self removeFromSuperview];
    
}


-(void) setDocPostRespnose:(DocPostResponse *)docPostRespnose
{
    _docPostRespnose = docPostRespnose;
    
    tableRowsData = (NSArray*)[self.docPostRespnose.submittedData objectForKey:@"T_DISPLAY"];
    
    if([self anyOffersAvailable]) {
        numOfColumns = 6;
    } else {
        numOfColumns = 4;
    }
    
    
    // now add headers as well
    CGFloat xOffset = 0.0;
    CGFloat width = 105.0f;
    UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 700, 30)];
    
    for(int i=0; i<numOfColumns;i++) {
        width = cellSizes[i].width;
        UILabel* itemLabel = [[UILabel alloc] initWithFrame:CGRectMake(xOffset, 0, width, 30)];
        xOffset = xOffset + width + 2.0f;
        itemLabel.text = [headerItems objectAtIndex:i];
        itemLabel.font = [UIFont systemFontOfSize:12.0f];
        itemLabel.textColor = [UIColor whiteColor];
        itemLabel.numberOfLines = 0;
        
        [headerView addSubview:itemLabel];
    }
    
    headerView.frame = CGRectMake(0.0f, 0.0f, xOffset, 30);
    
    headerView.backgroundColor = [UIColor colorWithRed:12.0f/255.0f green:60.0f/255.0f blue:107.0f/255.0f alpha:1.0f];

    
    
    [self.productGrid setHeaderView:headerView];
    
    self.orderMessage.text = self.docPostRespnose.submittedMessage;
    self.orderMessage.font = [UIFont systemFontOfSize:12.0f];
    self.orderMessage.numberOfLines = 0;
    
}


#pragma mark - UICollectionViewDataSource, UICollectionViewDelegate


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
   // columnKeys = [NSArray arrayWithObjects:@"materialCode", @"materialDesc", @"stockAvailable", @"freeGoodCategory", @"freeGoodQuantity", @"freeMaterial", @"offerMessage", nil];
    
    if(indexPath.row<7) {
        return cellSizes[indexPath.row];
    }
    return CGSizeMake(100.0f, 50.0f);
}

#pragma mark - UICollectionViewDelegate


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
}

#pragma merk - UICollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return numOfColumns;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [tableRowsData count];
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 2.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if(section==0) {
        return UIEdgeInsetsMake(25, productGridLeftMargin, 5, 10);
    } else {
        return UIEdgeInsetsMake(2, productGridLeftMargin, 5, 10);
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionCell * cell = (CollectionCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCell" forIndexPath:indexPath];
    
    if(cell.label==nil) {
        cell.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, cellSizes[indexPath.row].width, 50)];
        cell.label.font = [UIFont systemFontOfSize:12.0f];
        [cell.contentView addSubview:cell.label];
    }

    
   // [columnKeys objectAtIndex:indexPath.row]
    NSDictionary* rowDict = [tableRowsData objectAtIndex:indexPath.section];
    
    NSString* displayText = [rowDict objectForKey:[columnKeys objectAtIndex:indexPath.row]];
    NSString *regex = @"^[-+]?[0-9]*.?[0-9]+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL match = [predicate evaluateWithObject:displayText];
    
    if(match) {
        cell.label.textAlignment = NSTextAlignmentCenter;
    } else {
        cell.label.textAlignment = NSTextAlignmentLeft;
    }
    
    cell.label.text = [rowDict objectForKey:[columnKeys objectAtIndex:indexPath.row]];
    cell.label.numberOfLines = 0;
    cell.label.frame = CGRectMake(2, 0, cellSizes[indexPath.row].width-2, 50);
    
    cell.backgroundColor = [UIColor whiteColor];

    return cell;
}

-(BOOL) anyOffersAvailable
{
    BOOL retVal = NO;
    
    for(int i=0; i<[tableRowsData count]; i++) {
        NSDictionary* rowData = [tableRowsData objectAtIndex:i];
        NSNumber* offerQty = [rowData objectForKey:@"freeGoodQuantity"];
        if([offerQty floatValue]>0.0f) {
            retVal = YES;
        }
    }
   
    return retVal;
}



@end
