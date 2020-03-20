//
//  ChatRoom.h
//  Path Map
//
//  Created by Yatharth Singh on 11/05/16.
//  Copyright © 2016 Yatharth Singh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PTSMessagingCell.h"


@interface ChatRoomVC : UIViewController<UITextViewDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
@property UITableView* mainTable;
@property NSDictionary* userDict;
@property NSString* isFromStr;


#pragma mark IBOutlets
@property (weak, nonatomic) IBOutlet UIButton *message1BtnOutlet;
@property (weak, nonatomic) IBOutlet UIButton *message2BtnOutlet;
@property (weak, nonatomic) IBOutlet UIButton *message3BtnOutlet;

@property (weak, nonatomic) IBOutlet UIImageView *targetImage;
@property (weak, nonatomic) IBOutlet UILabel *targetName;
@property (weak, nonatomic) IBOutlet UIView *hintview;
@property (weak, nonatomic) IBOutlet UITextView *chatTextview;

@property (weak, nonatomic) IBOutlet UIImageView *blockImgView;
@property (weak, nonatomic) IBOutlet UIImageView *recommendImgView;
@property (weak, nonatomic) IBOutlet UIButton *reportAbuseBtnOutlet;

#pragma mark IBActions
- (IBAction)backBtnHandler:(id)sender;
- (IBAction)reportAbussiveBtnHandler:(id)sender;

- (IBAction)sendBtnClickHandler:(id)sender;

- (IBAction)message1ClickHandler:(id)sender;
- (IBAction)message2ClickHandler:(id)sender;
- (IBAction)message3ClickHandler:(id)sender;



@end
