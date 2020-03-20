//
//  MyClaimResponse.h
//  XMWClient
//
//  Created by dotvikios on 09/07/18.
//  Copyright © 2018 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MyClaimResponseDelegate;

@interface MyClaimResponse : UIView

+(MyClaimResponse *) createInstance:(CGFloat)yOrigin;
-(void)configure:(NSDictionary *)dict;
@property (weak, nonatomic) IBOutlet UILabel *refNoLbl;
@property (weak, nonatomic) IBOutlet UILabel *dateLbl;
@property (weak, nonatomic) IBOutlet UILabel *claimTypeLbl;
@property (weak, nonatomic) IBOutlet UILabel *createdByLbl;
@property (weak, nonatomic) IBOutlet UILabel *commentLbl;
@property (weak, nonatomic) IBOutlet UILabel *statusLbl;
@property UIView *track;
@property (weak,nonatomic) id<MyClaimResponseDelegate>delegate;
@end
@protocol MyClaimResponseDelegate<NSObject>
-(void)clickButtonView:(MyClaimResponse *)track Buttontag:(long int)tag;
@end
