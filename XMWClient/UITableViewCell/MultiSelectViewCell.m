//
//  MultiSelectViewCell.m
//  QCMSProject
//
//  Created by Pradeep Singh on 8/2/15.
//  Copyright (c) 2015 dotvik. All rights reserved.
//

#import "MultiSelectViewCell.h"
#import "DotFormElement.h"
#import "MultiSelectPopup.h"

@interface MultiSelectViewCell ()
{
    DotFormElement* _dotFormElement;
    NSArray* masterDisplayList;
    NSArray* masterValueList;
    
    NSMutableArray* selectedValueItems;
    NSMutableArray* selectedDisplayItems;
    
}

@property (strong, nonatomic) UIView* rightView;

@end

@implementation MultiSelectViewCell

- (void)awakeFromNib {
    // Initialization code
}



-(void) configureViewCellFor:(DotFormElement*) formElement masterDisplayList:(NSArray*) displayItems masterValueList:(NSArray*) valueItems
{
    
    _dotFormElement = formElement;
    masterDisplayList = displayItems;
    masterValueList = valueItems;
    
    
    UIView* upperView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    upperView.backgroundColor = [UIColor clearColor];
    
    // Initialization code
    self.mandatoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(4, 11, 8, 16)];
    self.mandatoryLabel.textColor = [UIColor colorWithRed:0.968f green:0.0f blue:0.0f alpha:1.0];
    self.mandatoryLabel.backgroundColor = [UIColor clearColor];
    self.mandatoryLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.mandatoryLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
    self.mandatoryLabel.textAlignment = NSTextAlignmentLeft;
    self.mandatoryLabel.text = @"*";
    [upperView addSubview:self.mandatoryLabel];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 6, 137, self.frame.size.height - 4)];
    self.titleLabel.textColor = [UIColor colorWithRed:0.227f green:0.227f blue:0.227f alpha:1.0];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;

    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    self.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13.0];
    [upperView addSubview:self.titleLabel];
    
    
    if([_dotFormElement isOptionalBool])
        self.mandatoryLabel.hidden	= YES;
    else
        self.mandatoryLabel.hidden	= NO;
    
    self.titleLabel.text = _dotFormElement.displayText;
    
    
    self.rightView = [[UIView alloc] initWithFrame:CGRectMake( 144, 6, 169, self.frame.size.height-8)];
    self.rightView.backgroundColor = [UIColor whiteColor];
    [self.rightView.layer setCornerRadius:5.0f];
    [self.rightView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [self.rightView.layer setBorderWidth:0.5f];
    
    
    UIImageView* arrowImage =  [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Icon-Arrow"]];
    arrowImage.frame = CGRectMake(170 - 30, 4, 32, 32);
    
    [self.rightView addSubview:arrowImage];
    
    [upperView addSubview:self.rightView];
    
    [self addSubview:upperView];
    
    upperView.userInteractionEnabled = YES;
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandling:)];
    tapGesture.numberOfTapsRequired = 1;
    [upperView addGestureRecognizer:tapGesture];
    
}

-(IBAction)tapHandling:(id)sender
{
    NSLog(@"tap handled here");
    
    MultiSelectPopup* popup = [MultiSelectPopup createInstanceWithData:masterDisplayList title:_dotFormElement.displayText];
    popup.multiSelectDelegate = self;
    if(selectedDisplayItems!=nil) {
        [popup setInitialSelectedList:selectedDisplayItems];
    }
    [[UIApplication sharedApplication].keyWindow addSubview:popup];
    
}


#pragma mark -  MultiSelectDelegate
-(void) selected:(MultiSelectPopup*) multiSelectPopup items:(NSArray*) itemIndices
{
    if(selectedValueItems==nil) {
        selectedValueItems = [[NSMutableArray alloc] init];
    } else {
        [selectedValueItems removeAllObjects];
    }
    
    if(selectedDisplayItems==nil) {
        selectedDisplayItems = [[NSMutableArray alloc] init];
    } else {
        [selectedDisplayItems removeAllObjects];
    }
    
    
    for(NSString* itemIndex in itemIndices) {
        NSInteger itemIndexValue = [itemIndex integerValue];
        if(itemIndexValue<[masterDisplayList count]) {
            [selectedDisplayItems addObject:[masterDisplayList objectAtIndex:[itemIndex integerValue]]];
            [selectedValueItems addObject:[masterValueList objectAtIndex:[itemIndex integerValue]]];
        }
    }
    
    
    // Now we have selected list, we should display selected items now
    [self configureViewForSelectedItems];
    
    if(self.selectDelegate!=nil && [self.selectDelegate respondsToSelector:@selector(multipleItemSelected:)]) {
        [self.selectDelegate multipleItemSelected:self];
    }
    
}


-(void) configureViewForSelectedItems
{
    
    UICollectionView*  collectionView = (UICollectionView*)[self viewWithTag:1001];
    
    if(collectionView==nil) {
    
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        [flowLayout setMinimumInteritemSpacing:0.0f];
        [flowLayout setMinimumLineSpacing:0.0f];
        
        collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake( 0, 0, 135, 32) collectionViewLayout:flowLayout];
        [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"CollectionViewCell"];
        
        collectionView.delegate = self;
        collectionView.dataSource	= self;
        collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        collectionView.showsVerticalScrollIndicator	 = NO;
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.backgroundColor = [UIColor whiteColor];
        collectionView.tag = 1001;
    
        [self.rightView addSubview:collectionView];
        
    } else {
        [collectionView reloadData];
    }

}


#pragma mark - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [selectedDisplayItems count];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"CollectionViewCell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    UILabel *textLabel = (UILabel *)[cell viewWithTag:101];
    if(textLabel==nil) {
        textLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 32)];
        textLabel.tag = 101;
        textLabel.font = [UIFont systemFontOfSize:13.0f];
        [cell addSubview:textLabel];
    }
    textLabel.text = [selectedDisplayItems objectAtIndex:indexPath.row];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    
    UILabel * label = [[UILabel alloc] init];
    [label setTranslatesAutoresizingMaskIntoConstraints:NO];
    label.font = [UIFont systemFontOfSize:13.0f];
    
    [label setText:[selectedDisplayItems objectAtIndex:indexPath.row]];
    CGSize labelSize = [label intrinsicContentSize];
    
    return CGSizeMake(labelSize.width + 6, 32);
}



-(NSArray*) selectedValueItems
{
    return selectedValueItems;
}

-(NSArray*) selectedDisplayItems
{
    return selectedDisplayItems;
}


-(DotFormElement*) dotFormElement
{
    return _dotFormElement;
}

@end
