//
//  ChatRoomsVC.h
//  XMWClient
//
//  Created by dotvikios on 12/04/19.
//  Copyright © 2019 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PTSMessagingCell.h"
NS_ASSUME_NONNULL_BEGIN

@interface ChatRoomsVC : UIViewController <UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>
{
    NSString *subject;
    NSString *chatThreadId;
    NSString *withChatPersonName;
    NSString * chatStatus;
    NSMutableArray *chatHistoryArray;
    NSString *nameLbltext;
}
@property NSString *nameLbltext;
@property NSMutableArray *chatHistoryArray;
@property (weak, nonatomic) IBOutlet UIButton *popupAcceptButtonOulate;
@property (weak, nonatomic) IBOutlet UILabel *popupSubjectLbl;
@property NSString *chatStatus;
@property NSString *withChatPersonName;
@property NSString *chatThreadId;
@property NSString *subject;
@property (weak, nonatomic) IBOutlet UIView *lineView1;
@property (weak, nonatomic) IBOutlet UIView *lineView2;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *subjectLbl;
@property (weak, nonatomic) IBOutlet UIButton *acceptButtonOutlet;
@property (weak, nonatomic) IBOutlet UITableView *chatRoomTableView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *acceptButtonPopUpView;
@property (weak, nonatomic) IBOutlet UITextView *popupTextView;

@end

NS_ASSUME_NONNULL_END
