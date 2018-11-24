//
//  TrackClaimVC.h
//  XMWClient
//
//  Created by dotvikios on 10/07/18.
//  Copyright © 2018 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyClaimResponse.h"

@interface TrackClaimVC : UIViewController
@property long int trackButton;
@property NSMutableArray * trackClaimArray;
@property NSString * claimType;
@property NSString * claimSubType;
@property NSString * reason;
@property NSString * comment;
@property NSString * status;
@property NSString *claimNo;
@property (weak, nonatomic) IBOutlet UILabel *claimNoDisplay;
@property (weak, nonatomic) IBOutlet UIView *haderView;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property (weak, nonatomic) IBOutlet UILabel *claimTypeLbl;
@property (weak, nonatomic) IBOutlet UILabel *claimSubTypeLbl;
@property (weak, nonatomic) IBOutlet UILabel *reasonLbl;
@property (weak, nonatomic) IBOutlet UILabel *commentsLbl;

@property (weak, nonatomic) IBOutlet UILabel *statusLbl;

@end
