//
//  DVCheckbox.m
//  QCMSProject
//
//  Created by Pradeep Singh on 4/12/14.
//  Copyright (c) 2014 dotvik. All rights reserved.
//

#import "DVCheckbox.h"

@interface DVCheckbox ()
{
    UIImage* checkedImage;
    UIImage* uncheckedImage;
//    UIImageView* imageHolder;
}
@end

@implementation DVCheckbox


@synthesize context;
@synthesize checkboxDelegate;
@synthesize imageHolder;
- (id)initWithFrame:(CGRect)frame check:(BOOL) checkFlag enable:(BOOL) enableFlag
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        checkedImage = [UIImage imageNamed:@"checkedbox"];
        uncheckedImage = [UIImage imageNamed:@"checkbox"];
        
        checked = checkFlag;
        enabled = enableFlag;
        
        imageHolder = [[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width - 40)/2, (frame.size.height - 40)/2, 40, 40)];   //   100, - 40 30, 200 - 40
        
        if(checked == YES) {
            imageHolder.image = checkedImage;
        } else {
            imageHolder.image = uncheckedImage;
        }
        
        imageHolder.contentMode = UIViewContentModeCenter;
        
        if(enabled==YES) {
            self.userInteractionEnabled = YES;
            imageHolder.userInteractionEnabled = YES;
        } else {
            self.userInteractionEnabled = NO;
            imageHolder.userInteractionEnabled = NO;
            
        }
        
        UITapGestureRecognizer* tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandling:)];
        tapGestureRecognizer.numberOfTapsRequired = 1;
        tapGestureRecognizer.numberOfTouchesRequired = 1;
        [imageHolder addGestureRecognizer:tapGestureRecognizer];
        
        [self addSubview:imageHolder];
        
    }
    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        // Initialization code
        checkedImage = [UIImage imageNamed:@"checkedbox"];
        uncheckedImage = [UIImage imageNamed:@"checkbox"];
        
        checked = NO;
        enabled = YES;
        
        imageHolder = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width - 30)/2, (self.frame.size.height - 26)/2, 30, 26)];   //   100, - 40 30, 200 - 40
        
        if(checked == YES) {
            imageHolder.image = checkedImage;
        } else {
            imageHolder.image = uncheckedImage;
        }
        
        imageHolder.contentMode = UIViewContentModeCenter;
        
        if(enabled==YES) {
            self.userInteractionEnabled = YES;
            imageHolder.userInteractionEnabled = YES;
        } else {
            self.userInteractionEnabled = NO;
            imageHolder.userInteractionEnabled = NO;
            
        }
        
        UITapGestureRecognizer* tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandling:)];
        tapGestureRecognizer.numberOfTapsRequired = 1;
        tapGestureRecognizer.numberOfTouchesRequired = 1;
        [imageHolder addGestureRecognizer:tapGestureRecognizer];
        
        [self addSubview:imageHolder];
        
    }
    
    return self;
}


-(void) configureCheckBoxCheck:(BOOL) checkFlag enable:(BOOL) enableFlag
{
    if(checkFlag==YES) {
        imageHolder.image = checkedImage;
        checked = YES;
    } else {
        imageHolder.image = uncheckedImage;
        checked = NO;
    }
    
    if(enableFlag==YES) {
        self.userInteractionEnabled = YES;
        imageHolder.userInteractionEnabled = YES;
    } else {
        self.userInteractionEnabled = NO;
        imageHolder.userInteractionEnabled = NO;
    }
}

-(IBAction)tapHandling:(UITapGestureRecognizer*)sender
{
    if(checked==YES) {
        imageHolder.image = uncheckedImage;
        checked = NO;
        if(checkboxDelegate!=nil && [self.checkboxDelegate respondsToSelector:@selector(hasUnchecked:)]) {
            [self.checkboxDelegate hasUnchecked:self];
        }
        
    } else {
        imageHolder.image = checkedImage;
        checked = YES;
        if(checkboxDelegate!=nil && [self.checkboxDelegate respondsToSelector:@selector(hasChecked:)]) {
            [self.checkboxDelegate hasChecked:self];
        }
    }
    
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */


-(void) setCheck:(BOOL) flag
{
    checked = flag;
}
-(void) setEnable:(BOOL) flag
{
    enabled = flag;
}

-(BOOL) isEnabled
{
    return enabled;
}

-(BOOL) isChecked
{
    return checked;
}
@end
