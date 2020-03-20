//
//  MultipleFileAttachmentView.h
//  XMWClient
//
//  Created by Tushar Gupta on 20/08/19.
//  Copyright © 2019 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXButton.h"
#import "MXLabel.h"
#import "FormVC.h"
NS_ASSUME_NONNULL_BEGIN

@interface MultipleFileAttachmentView : UIView <UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,UIDocumentInteractionControllerDelegate>
@property (nonatomic, retain) MXButton * addMore;
@property (nonatomic, retain) UITableView *imageTableView;
@property (nonatomic, strong) NSMutableArray * ufmrefidArray;
- (instancetype)initWithFrame:(CGRect)frame :(FormVC*) formVC;
@property  bool isUploadImageOnServer;
@property UIDocumentInteractionController *docController;
@property (nonatomic, strong) DotFormElement *formElement;
@property (nonatomic, strong) NSString *singleUFMRefid;
@end

NS_ASSUME_NONNULL_END
