//
//  DotVerticalBarCell.h
//  QCMSProject
//
//  Created by Pradeep Singh on 1/16/15.
//  Copyright (c) 2015 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DotVerticalBarCell : UICollectionViewCell

+(DotVerticalBarCell*) createInstance;


@property (weak, nonatomic) IBOutlet UIView* barView;
@property (weak, nonatomic) IBOutlet UIView* bottomAxisPartView;

-(void)updateLayout;

@end
