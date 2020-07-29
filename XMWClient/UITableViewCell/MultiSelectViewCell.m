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
#import "XmwUtils.h"
@interface MultiSelectViewCell ()
{
    DotFormElement* _dotFormElement;
//    NSArray* masterDisplayList;
//    NSArray* masterValueList;
    
//    NSMutableArray* selectedValueItems;
//    NSMutableArray* selectedDisplayItems;
    
}

@end

@implementation MultiSelectViewCell
@synthesize upperView;
@synthesize masterValueList,masterDisplayList;
@synthesize selectedDisplayItems,selectedValueItems;
- (void)awakeFromNib {
    // Initialization code
}



-(void) configureViewCellFor:(DotFormElement*) formElement masterDisplayList:(NSArray*) displayItems masterValueList:(NSArray*) valueItems
{
    
    _dotFormElement = formElement;
    masterDisplayList = displayItems;
    masterValueList = valueItems;
    
    
    upperView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    upperView.backgroundColor = [UIColor clearColor];
    
    // Initialization code
    self.mandatoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 11, 8, 16)];
    self.mandatoryLabel.textColor = [UIColor colorWithRed:0.968f green:0.0f blue:0.0f alpha:1.0];
    self.mandatoryLabel.backgroundColor = [UIColor clearColor];
    self.mandatoryLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.mandatoryLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
    self.mandatoryLabel.textAlignment = NSTextAlignmentLeft;
    self.mandatoryLabel.text = @"*";
    [upperView addSubview:self.mandatoryLabel];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(24, 11, 137, 20)];
    // self.titleLabel.textColor = [UIColor colorWithRed:0.227f green:0.227f blue:0.227f alpha:1.0];
    self.titleLabel.textColor = [UIColor colorWithRed:119.0/255 green:119.0/255 blue:119.0/255 alpha:1.0];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    self.titleLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:16.0];
    [upperView addSubview:self.titleLabel];
    
    
    if([_dotFormElement isOptionalBool])
        self.mandatoryLabel.hidden    = YES;
    else
        self.mandatoryLabel.hidden    = NO;
    
    self.titleLabel.text = _dotFormElement.displayText;
    
    
    self.rightView = [[UIView alloc] initWithFrame:CGRectMake( 16, 35, self.bounds.size.width-32, 40)];
    self.rightView.backgroundColor = [UIColor whiteColor];
    [self.rightView.layer setCornerRadius:5.0f];
    [self.rightView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [self.rightView.layer setBorderWidth:1.0f];
    
    
    UIImageView* arrowImage =  [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"downarrow_right_arrow"]];
    arrowImage.frame = CGRectMake(self.rightView.frame.size.width-25, 4, 27, 27);
    arrowImage.contentMode = UIViewContentModeCenter;
    [self.rightView addSubview:arrowImage];
    
    [upperView addSubview:self.rightView];
    
    [self addSubview:upperView];
    
    upperView.userInteractionEnabled = YES;
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandling:)];
    tapGesture.numberOfTapsRequired = 1;
    [upperView addGestureRecognizer:tapGesture];
    
    [self configureDefaults];
    
}
-(void) configureDefaults
{
    
    if(_dotFormElement.defaultVal !=nil && [_dotFormElement.defaultVal length]>0) {
        NSDictionary* defMap = [XmwUtils getExtendedPropertyMap:_dotFormElement.defaultVal];
        NSString* displayValue = [defMap objectForKey:@"VALUE"];
        NSString* postValue = [defMap objectForKey:@"KEY"];
        
        if(displayValue!=nil && [displayValue length]>0) {
            NSInteger defIdx = [self hasItem:displayValue inItems:masterDisplayList];
            if(defIdx>=0) {
                NSArray* selectedIndices = [NSArray arrayWithObject:[NSNumber numberWithInt:defIdx]];
                [self selected:nil items:selectedIndices];
            }
        }
    }
}
-(NSInteger) hasItem:(NSString*) item inItems:(NSArray*) stringItems
{
    NSInteger retVal = -1;
    
    for(int i=0; i<[stringItems count];i++) {
        if([item caseInsensitiveCompare:[stringItems objectAtIndex:i]] == NSOrderedSame) {
            retVal = i;
            break;
        }
    }
    return retVal;
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
        
        collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake( 0, 0, self.bounds.size.width-75, 32) collectionViewLayout:flowLayout];
        [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"CollectionViewCell"];
        
        collectionView.delegate = self;
        collectionView.dataSource    = self;
        collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        collectionView.showsVerticalScrollIndicator     = NO;
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.backgroundColor = [UIColor clearColor];
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
        textLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.bounds.size.width-35, 20)];
        textLabel.tag = 101;
        textLabel.font = [UIFont systemFontOfSize:13.0f];
        textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        textLabel.textColor =  [UIColor colorWithRed:119.0/255 green:119.0/255 blue:119.0/255 alpha:1.0];
//        textLabel.backgroundColor = [UIColor lightGrayColor];
//        textLabel.layer.masksToBounds=YES;
        textLabel.layer.borderColor= [[UIColor lightGrayColor]CGColor];
        textLabel.layer.borderWidth= 1.0f;
   
        [cell addSubview:textLabel];
    }
    textLabel.text = [selectedDisplayItems objectAtIndex:indexPath.row];
    [textLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    CGSize labelSize = [textLabel intrinsicContentSize];
    textLabel.frame = CGRectMake(textLabel.frame.origin.x, textLabel.frame.origin.y, labelSize.width+6, 20);
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    
    UILabel * label = [[UILabel alloc] init];
    [label setTranslatesAutoresizingMaskIntoConstraints:NO];
    label.font = [UIFont systemFontOfSize:13.0f];
    
    [label setText:[selectedDisplayItems objectAtIndex:indexPath.row]];
    CGSize labelSize = [label intrinsicContentSize];
    
    return CGSizeMake(labelSize.width + 18, 32);
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

- (void)setEditDisplayItemsAndValueItems:(NSArray *)displayItem :(NSArray *)valueItem
{
    
    selectedValueItems= [[NSMutableArray alloc]init];
    selectedDisplayItems = [[NSMutableArray alloc] init];
    [selectedDisplayItems addObjectsFromArray:displayItem];
    [selectedValueItems addObjectsFromArray:valueItem];
    [self configureViewForSelectedItems];
}
-(void)setDisplayItemsAndValueItems :(NSString*)displayItem :(NSString*)valueItem
{
    NSData *webData = [displayItem dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSArray *displayItemArray = [NSJSONSerialization JSONObjectWithData:webData options:0 error:&error];
    NSLog(@"%@",displayItemArray);
    
    NSData *webData1 = [valueItem dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error1;
    NSArray *valueItemArray = [NSJSONSerialization JSONObjectWithData:webData1 options:0 error:&error1];
    NSLog(@"%@",valueItemArray);
    selectedValueItems= [[NSMutableArray alloc]init];
    selectedDisplayItems = [[NSMutableArray alloc] init];
    
    for (int i=0; i<displayItemArray.count; i++) {
        [selectedDisplayItems addObject:[displayItemArray objectAtIndex:i]];
        [selectedValueItems addObject:[valueItemArray objectAtIndex:i]];
    }
    [self configureViewForSelectedItems];
}
@end
