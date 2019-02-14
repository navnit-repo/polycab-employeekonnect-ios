//
//  SalesCell.h
//  XMWClient
//
//  Created by dotvikios on 04/09/18.
//  Copyright © 2018 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SalesCell : UIView
+(SalesCell*) createInstance;
@property (weak, nonatomic) IBOutlet UILabel *ftdDataSetLbl;
@property (weak, nonatomic) IBOutlet UILabel *mtdDataSetLbl;
@property (weak, nonatomic) IBOutlet UILabel *ytdDataSetLbl;
@property (weak, nonatomic) IBOutlet UILabel *displayName;
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIView *ftdView;
@property (weak, nonatomic) IBOutlet UIView *mtdView;
@property (weak, nonatomic) IBOutlet UIView *ytdView;
@property (weak, nonatomic) IBOutlet UILabel *constantLbl1;
@property (weak, nonatomic) IBOutlet UILabel *constantLbl2;
@property (weak, nonatomic) IBOutlet UILabel *constantLbl3;
@property (weak, nonatomic) IBOutlet UILabel *constantLbl4;
-(void)configure:(NSArray*)ftdData :(NSArray*)mtdData :(NSArray*)ytdData;
-(void)autoLayout;
-(NSString*)formateCurrency:(NSString *)actualAmount;
@end
