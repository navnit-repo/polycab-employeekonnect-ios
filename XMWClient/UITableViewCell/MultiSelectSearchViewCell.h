//
//  MultiSelectViewCell.h
//  QCMSProject
//
//  Created by Pradeep Singh on 8/2/15.
//  Copyright (c) 2015 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MultiSelectPopup.h"
#import "DotFormElement.h"


@class FormVC;


@interface MultiSelectSearchViewCell : UIView <MultiSelectDelegate, UICollectionViewDataSource, UICollectionViewDelegate>


@property (nonatomic, retain) UILabel* titleLabel;
@property (nonatomic, retain) UILabel* mandatoryLabel;
@property (nonatomic, retain) UIButton* selectButton;
@property (nonatomic, retain) UILabel* displaySelectedItems;


-(void) configureViewCell:(FormVC*) formVC  element:(DotFormElement*) formElement masterDisplayList:(NSArray*) displayItems masterValueList:(NSArray*) valueItems extendedProperty:(NSDictionary*)extendedProperty;


-(NSArray*) selectedValueItems;

-(NSArray*) selectedDisplayItems;

@end
