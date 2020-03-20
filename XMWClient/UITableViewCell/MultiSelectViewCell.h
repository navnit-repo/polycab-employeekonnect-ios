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



@protocol MultiSelectViewDelegate <NSObject>

-(void) multipleItemSelected:(id) sender;

@end


@interface MultiSelectViewCell : UIView <MultiSelectDelegate, UICollectionViewDataSource, UICollectionViewDelegate>


@property (nonatomic, retain) UILabel* titleLabel;
@property (nonatomic, retain) UILabel* mandatoryLabel;
@property (nonatomic, retain) UIButton* selectButton;
@property (nonatomic, retain) UILabel* displaySelectedItems;

@property (strong, nonatomic) id<MultiSelectViewDelegate> selectDelegate;


-(void) configureViewCellFor:(DotFormElement*) formElement masterDisplayList:(NSArray*) displayItems masterValueList:(NSArray*) valueItems;


-(NSArray*) selectedValueItems;

-(NSArray*) selectedDisplayItems;

-(DotFormElement*) dotFormElement;

@end
