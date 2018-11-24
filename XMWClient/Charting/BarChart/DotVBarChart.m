//
//  DotVBarChart.m
//  QCMSProject
//
//  Created by Pradeep Singh on 1/7/15.
//  Copyright (c) 2015 dotvik. All rights reserved.
//
//
//

#import "DotVBarChart.h"
#import "DotVerticalBarCell.h"

#define CELL_CONTENT_TAG 9000

@interface DotVBarChart ()
{
    
}

@end

@implementation DotVBarChart

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


#pragma mark -  UICollectionView Datasource


+(DotVBarChart*) createInstance
{
    DotVBarChart *view = (DotVBarChart *)[[[NSBundle mainBundle] loadNibNamed:@"DotVBarChart" owner:self options:nil] objectAtIndex:0];
    view.barChartsTableView.delegate = view;
    view.barChartsTableView.dataSource = view;
    
    // [view.barChartsTableView registerClass:[DotVerticalBarCell class] forCellWithReuseIdentifier:@"DotVerticalBarCell"];
    
    
    [view.barChartsTableView registerNib:[UINib nibWithNibName:@"DotVerticalBarCell" bundle:nil] forCellWithReuseIdentifier:@"DotVerticalBarCell"];
    
    return view;
}

-(void) updateLayout
{
    CGRect vAxisFrame = self.verticalAxisView.frame;
    self.verticalAxisView.frame = CGRectMake(vAxisFrame.origin.x, vAxisFrame.origin.y, vAxisFrame.size.width, [UIScreen mainScreen].bounds.size.height);
    
    
    CGRect legendFrame = self.legendView.frame;
    self.legendView.frame = CGRectMake(legendFrame.origin.x, [UIScreen mainScreen].bounds.size.height - legendFrame.size.height - 64,
                                       [UIScreen mainScreen].bounds.size.width - self.verticalAxisView.frame.size.width, legendFrame.size.height);
    
    
    CGRect tableFrame = self.barChartsTableView.frame;
    
    self.barChartsTableView.frame = CGRectMake(tableFrame.origin.x, tableFrame.origin.y, [UIScreen mainScreen].bounds.size.width - self.verticalAxisView.frame.size.width, [UIScreen mainScreen].bounds.size.height  - self.legendView.frame.size.height - 64 );
    
    
    
}

-(NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSUInteger numOfItems = 10;
    // todo we need to implement here
    
    return numOfItems;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier =  @"DotVerticalBarCell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    

    // depending on the indexPath, we need to set the view
    cell.contentView.backgroundColor = [UIColor lightGrayColor];
    cell.contentView.frame = cell.bounds;
    
    
    if([cell isKindOfClass:[DotVerticalBarCell class]]) {
        DotVerticalBarCell* vBarCell = (DotVerticalBarCell*) cell;
        [vBarCell updateLayout];
    }
    
    
    return cell;
}


#pragma mark -  UICollectionView Delegate


-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
 
    
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Deselect item
    
    
}


#pragma mark – UICollectionViewDelegateFlowLayout

// 1
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
   return    CGSizeMake(44, self.barChartsTableView.frame.size.height );
}

// 3
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0;
}



@end
