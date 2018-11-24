//
//  AttachmentViewCell.m
//  XMWClient
//
//  Created by dotvikios on 11/09/18.
//  Copyright © 2018 dotvik. All rights reserved.
//

#import "AttachmentViewCell.h"

@implementation AttachmentViewCell
@synthesize attachmentButton;
@synthesize imageView;
@synthesize imageViewAttachButton;
@synthesize ufmrefid;
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       
       
        
        
        
        attachmentButton = [[MXButton alloc]init];
        attachmentButton = [MXButton buttonWithType:UIButtonTypeCustom];
        attachmentButton.frame =CGRectMake( self.bounds.size.width/4, 10, 240, 40);
        attachmentButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:10.0];
        attachmentButton.titleLabel.textAlignment = UITextAlignmentLeft;
        [attachmentButton setTitleColor:[UIColor colorWithRed:204.0/255 green:43.0/255 blue:43.0/255 alpha:1.0] forState:UIControlStateNormal];
        
        
        
        
        imageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.bounds.size.width/3, 60, 120, 120)];
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
        imageView.backgroundColor = [UIColor clearColor];
        imageView.layer.cornerRadius = 10;
        imageView.clipsToBounds = YES;
        [imageView setImage:[UIImage imageNamed:@"default_file_upload.png"]];
        
        
        //set imageView border
        self.imageView.layer.masksToBounds=YES;
        self.imageView.layer.borderColor= [[UIColor colorWithRed:0.192f green:0.192f blue:0.192f alpha:1.0]CGColor];
        self.imageView.layer.borderWidth= 0.5f;
        
        
        
        imageViewAttachButton = [[MXButton alloc]init];
        imageViewAttachButton = [MXButton buttonWithType:UIButtonTypeCustom];
        imageViewAttachButton.frame =CGRectMake(self.bounds.size.width/3, 60, 120, 120);
        imageViewAttachButton.backgroundColor = [UIColor clearColor];

    
        [self addSubview:attachmentButton];
        [self addSubview:imageView];
        [self addSubview:imageViewAttachButton];
    }
    return self;
}

@end
