//
//  DVCheckbox.h
//  QCMSProject
//
//  Created by Pradeep Singh on 4/12/14.
//  Copyright (c) 2014 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DVCheckbox;


@protocol DVCheckboxDelegate <NSObject>
-(void) hasChecked:(DVCheckbox*) sender;
-(void) hasUnchecked:(DVCheckbox*) sender;
@end


@interface DVCheckbox : UIView
{
    BOOL checked;
    BOOL enabled;
    NSString* context;
      UIImageView* imageHolder;
    id<DVCheckboxDelegate> checkboxDelegate;
    NSString *elementId;
}
@property    UIImageView* imageHolder;
@property NSString* context;
@property id<DVCheckboxDelegate> checkboxDelegate;
@property NSString *elementId;
- (id)initWithFrame:(CGRect)frame check:(BOOL) checkFlag enable:(BOOL) enableFlag;
-(void) configureCheckBoxCheck:(BOOL) checkFlag enable:(BOOL) enableFlag;

-(void) setCheck:(BOOL) flag;
-(void) setEnable:(BOOL) flag;

-(BOOL) isEnabled;
-(BOOL) isChecked;

@end
