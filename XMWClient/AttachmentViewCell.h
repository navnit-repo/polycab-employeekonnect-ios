//
//  AttachmentViewCell.h
//  XMWClient
//
//  Created by dotvikios on 11/09/18.
//  Copyright © 2018 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXButton.h"
@interface AttachmentViewCell : UIView
{
    MXButton *attachmentButton;
    UIImageView *imageView;
    MXButton *imageViewAttachButton;
    NSString *ufmrefid;
}
@property MXButton *attachmentButton;
@property  UIImageView *imageView;
@property MXButton *imageViewAttachButton;
@property NSString *ufmrefid;;
@end
