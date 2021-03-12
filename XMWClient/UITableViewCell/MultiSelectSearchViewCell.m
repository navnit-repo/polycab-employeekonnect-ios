//
//  MultiSelectSearchViewCell.m
//  QCMSProject
//
//  Created by Pradeep Singh on 8/2/15.
//  Copyright (c) 2015 dotvik. All rights reserved.
//

#import <objc/runtime.h>

#import "MultiSelectSearchViewCell.h"
#import "DotFormElement.h"
#import "MultiSelectViewCell.h"
#import "MultiSelectPopup.h"
#import "DotSearchComponent.h"
#import "SearchFormControl.h"
#import "ClientVariable.h"
#import "DVAppDelegate.h"
#import "LoadingView.h"


@interface UIButton (CrossButtonForCell)
@property NSNumber* itemIndex;
@end

@implementation UIButton (CrossButtonForCell)
- (NSNumber*)itemIndex;
{
    return objc_getAssociatedObject(self, "itemIndex");
}

- (void)setItemIndex:(NSNumber*)property;
{
    objc_setAssociatedObject(self, "itemIndex", property, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end



@interface MultiSelectSearchViewCell ()
{
    DotFormElement* dotFormElement;
    NSMutableArray* masterDisplayList;
    NSMutableArray* masterValueList;
    NSDictionary* extendedPropertyMap;
    NSArray* searchFilterFields;
    
    NSMutableArray* selectedValueItems;
    NSMutableArray* selectedDisplayItems;
    
    SearchFormControl*  searchPopUp;
    FormVC* parentFormVC;
    
    LoadingView* loadingView;
    
}

@property (strong, nonatomic) UIView* rightView;


@end

@implementation MultiSelectSearchViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(void) configureViewCell:(FormVC*) formVC  element:(DotFormElement*) formElement masterDisplayList:(NSArray*) displayItems masterValueList:(NSArray*) valueItems extendedProperty:(NSDictionary*)extendedProperty
{
    parentFormVC = formVC;
    dotFormElement = formElement;
    masterDisplayList = displayItems;
    masterValueList = valueItems;
    extendedPropertyMap = extendedProperty;
    NSString* searchFilters = [extendedPropertyMap objectForKey:@"SEARCH_FILTER"];
    searchFilterFields = [searchFilters componentsSeparatedByString:@","];
    
    /*
    NSRegularExpression *testExpression = [NSRegularExpression regularExpressionWithPattern:@"\\W"
                                                                                    options:NSRegularExpressionCaseInsensitive error:nil];
    searchFilterFields = [testExpression matchesInString:searchFilters
                                               options:0
                                                 range:NSMakeRange(0, [searchFilters length])];
    NSLog(@"%@",searchFilterFields);
     */


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
    
    
    if([dotFormElement isOptionalBool])
        self.mandatoryLabel.hidden	= YES;
    else
        self.mandatoryLabel.hidden	= NO;
    
    self.titleLabel.text = dotFormElement.displayText;
    
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
    
    NSString *groupName;
    NSString *masterValueMapping;
    NSString *elementId;
    
    groupName	= dotFormElement.dependedCompName;
    masterValueMapping  = dotFormElement.masterValueMapping;
    elementId   = dotFormElement.elementId;

    DotSearchComponent *searchObject = [[DotSearchComponent alloc]init];
    NSMutableArray *searchValues = [searchObject getRadioGroupData: groupName];
    
    
    CGRect textFrame = CGRectMake(0,0,320,320);//(20, 90, 280, 300) ;
    searchPopUp = [[SearchFormControl alloc] initWithFrame:textFrame :searchValues :0 :parentFormVC :masterValueMapping :elementId :dotFormElement.displayText];
    searchPopUp.buttonsDelegate = self;
    
    [parentFormVC.view addSubview:searchPopUp];
    
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
        textLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 32)];
        textLabel.tag = 101;
        textLabel.font = [UIFont systemFontOfSize:13.0f];
        [cell.contentView addSubview:textLabel];
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


-(void) searchAction:(NSString*) userText selectionKey:(NSString*)key;
{
    // run search query here
    
    DotFormPost *formPost = [[DotFormPost alloc]init];
    [formPost.postData setObject:userText forKey:DotSearchConst_SEARCH_TEXT];
    [formPost.postData setObject:key forKey:DotSearchConst_SEARCH_BY];
    
    [formPost setModuleId: [DVAppDelegate currentModuleContext]];
    [formPost setDocId: dotFormElement.masterValueMapping];
    
    
    for(NSString* field in searchFilterFields) {
        id compObj = [parentFormVC getDataFromId:field];
        if([compObj isKindOfClass:[MultiSelectViewCell class]]) {
            MultiSelectViewCell* multiSelectControl = (MultiSelectViewCell*)compObj;
            NSArray* filterFieldData = [multiSelectControl selectedValueItems];
            NSMutableString* filterFieldPost = [[NSMutableString alloc] init];
            for(int i=0; i<[filterFieldData count]; i++) {
                [filterFieldPost appendString: [filterFieldData objectAtIndex:i]];
                if(i<([filterFieldData count]-1)) {
                    [filterFieldPost appendString:@","];
                }
            }
            
            NSString* mappedSearchField = [extendedPropertyMap objectForKey:field];
            
            if(mappedSearchField!=nil && [mappedSearchField length]>0) {
                [formPost.postData setObject:filterFieldPost forKey:mappedSearchField];
            } else {
                 [formPost.postData setObject:filterFieldPost forKey:field];
            }
        } else if([compObj isKindOfClass:[MXTextField class]]) {
            MXTextField *textField = (MXTextField*)compObj;
            NSString* filterFieldData =  textField.text;
            
            DotFormElement* filterFieldElement = [parentFormVC.dotForm.formElements objectForKey:field];
            
            if ([filterFieldElement.componentType isEqualToString: XmwcsConst_DE_COMPONENT_DROPDOWN]) {
                filterFieldData =  textField.keyvalue;
                
                // we need to use if component is dropdown, textField.keyvalue ;
            }
            
            NSString* mappedSearchField = [extendedPropertyMap objectForKey:field];
                
            if(mappedSearchField!=nil && [mappedSearchField length]>0) {
                [formPost.postData setObject:filterFieldData forKey:mappedSearchField];
            } else {
                [formPost.postData setObject:filterFieldData forKey:field];
            }
        }
    }
    
    
    loadingView = [LoadingView loadingViewInView:parentFormVC.view];
    
    NetworkHelper *networkHelper = [[NetworkHelper alloc] init];
    [networkHelper makeXmwNetworkCall:formPost :self : nil :  XmwcsConst_CALL_NAME_FOR_SEARCH];

}

-(void) searchCancel
{
        // do nothing here
    
}


- (void) httpResponseObjectHandler : (NSString*) callName : (id) respondedObject : (id) requestedObject
{
    [loadingView removeFromSuperview];
    SearchResponse *searchResponse = (SearchResponse*)respondedObject;
    
    masterDisplayList = [[NSMutableArray alloc] initWithCapacity:[searchResponse.searchRecord count]];
    masterValueList = [[NSMutableArray alloc] initWithCapacity:[searchResponse.searchRecord count]];
    for(int i=0; i< [searchResponse.searchRecord count]; i++) {
        NSArray* dataOfEachRecord = [searchResponse.searchRecord objectAtIndex:i];
        
        if([dataOfEachRecord count]>=2) {
            NSString* displayValueItem = [NSString stringWithFormat:@"%@ - %@", [dataOfEachRecord objectAtIndex:0], [dataOfEachRecord objectAtIndex:1] ];
            [masterDisplayList addObject:displayValueItem];
            [masterValueList addObject:[dataOfEachRecord objectAtIndex:0]];
        }
    }
    
    
     MultiSelectPopup* popup = [MultiSelectPopup createInstanceWithData:masterDisplayList title:dotFormElement.displayText];
     popup.multiSelectDelegate = self;
    
     [[UIApplication sharedApplication].keyWindow addSubview:popup];
}


- (void) httpFailureHandler : (NSString*) callName : (NSString*) message
{
    
     [loadingView removeFromSuperview];
    
}


-(IBAction)crossButtonForDelete:(id)sender
{
    UIButton* crossButton = (UIButton*) sender;
    
    NSLog(@"Selected item to delete is %@", [crossButton.itemIndex description]);
    
    
    UICollectionView*  collectionView = (UICollectionView*)[self viewWithTag:1001];
    
    if(collectionView!=nil) {
        [collectionView performBatchUpdates:^{
            [selectedValueItems removeObjectAtIndex:[crossButton.itemIndex intValue]];
            [selectedDisplayItems removeObjectAtIndex:[crossButton.itemIndex intValue]];
            
            NSIndexPath *indexPath =[NSIndexPath indexPathForRow:[crossButton.itemIndex intValue] inSection:0];
            [collectionView deleteItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
            
        } completion:^(BOOL finished) {
            
        }];
        
    }
    
    
}

@end
