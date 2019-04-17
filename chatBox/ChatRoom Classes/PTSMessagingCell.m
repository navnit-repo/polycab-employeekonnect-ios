/*
 PTSMessagingCell.m
 
 Copyright (C) 2012 pontius software GmbH
 
 This program is free software: you can redistribute and/or modify
 it under the terms of the Createive Commons (CC BY-SA 3.0) license
*/

#import "PTSMessagingCell.h"

@implementation PTSMessagingCell

static CGFloat textMarginHorizontal = 15.0f;
static CGFloat textMarginVertical = 7.5f;
static CGFloat messageTextSize = 14.0;

@synthesize sent, messageLabel, messageView, timeLabel,nameLabel, avatarImageView, balloonView;

#pragma mark -
#pragma mark Static methods

+(CGFloat)textMarginHorizontal {
    return textMarginHorizontal;
}

+(CGFloat)textMarginVertical {
    return textMarginVertical;
}

+(CGFloat)maxTextWidth {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        return 220.0f;
    } else {
        return 400.0f;
    }
}

+(CGSize)messageSize:(NSString*)message {
    return [message sizeWithFont:[UIFont systemFontOfSize:messageTextSize] constrainedToSize:CGSizeMake([PTSMessagingCell maxTextWidth], CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
}

+(UIImage*)balloonImage:(BOOL)sent isSelected:(BOOL)selected {
    if (sent == YES && selected == YES) {
        return [[UIImage imageNamed:@"chat_RoomVC"] stretchableImageWithLeftCapWidth:24 topCapHeight:15];
    } else if (sent == YES && selected == NO) {
        return [[UIImage imageNamed:@"chat_RoomVC"] stretchableImageWithLeftCapWidth:24 topCapHeight:15];
    } else if (sent == NO && selected == YES) {
        return [[UIImage imageNamed:@"chat_RoomVC"] stretchableImageWithLeftCapWidth:24 topCapHeight:15];
    } else {
        return [[UIImage imageNamed:@"chat_RoomVC"] stretchableImageWithLeftCapWidth:24 topCapHeight:15];
    }
}

#pragma mark -
#pragma mark Object-Lifecycle/Memory management

-(id)initMessagingCellWithReuseIdentifier:(NSString*)reuseIdentifier {
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        /*Selection-Style of the TableViewCell will be 'None' as it implements its own selection-style.*/
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        /*Now the basic view-lements are initialized...*/
        messageView = [[UIView alloc] initWithFrame:CGRectZero];
        messageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        
        balloonView = [[UIImageView alloc] initWithFrame:CGRectZero];
        balloonView.layer.cornerRadius = 5.0f;
        messageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        avatarImageView = [[UIImageView alloc] initWithImage:nil];
       
        /*Message-Label*/
        self.messageLabel.backgroundColor = [UIColor clearColor];
        self.messageLabel.textColor = [self colorWithHexString:@"3c3c3c"];
        self.messageLabel.font = [UIFont systemFontOfSize:messageTextSize];
        self.messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.messageLabel.numberOfLines = 0;
        
        /*Time-Label*/
        self.timeLabel.font = [UIFont boldSystemFontOfSize:12.0f];
        self.timeLabel.textColor = [self colorWithHexString:@"787878"];
        self.timeLabel.backgroundColor = [UIColor clearColor];
        
        /*Name-Label*/
        self.nameLabel.font = [UIFont boldSystemFontOfSize:12.0f];
        self.nameLabel.textColor = [UIColor redColor];
        self.nameLabel.backgroundColor = [UIColor clearColor];
        
        /*...and adds them to the view.*/
        [self.contentView addSubview: self.avatarImageView];
        [self.contentView addSubview: self.balloonView];
        
        [self.balloonView addSubview: self.nameLabel];
        [self.balloonView addSubview: self.timeLabel];
        [self.balloonView addSubview: self.messageView];
        
        [self.messageView addSubview: self.messageLabel];
        
        /*...and a gesture-recognizer, for LongPressure is added to the view.*/
        UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
        [recognizer setMinimumPressDuration:1.0f];
        [self addGestureRecognizer:recognizer];
    }
    
    return self;
}


#pragma mark -
#pragma mark Layouting

- (void)layoutSubviews {
    /*This method layouts the TableViewCell. It calculates the frame for the different subviews, to set the layout according to size and orientation.*/
    
    /*Calculates the size of the message. */
    CGSize textSize = [PTSMessagingCell messageSize:self.messageLabel.text];
    
    /*Calculates the size of the timestamp.*/
    CGSize dateSize = [self.timeLabel.text sizeWithFont:self.timeLabel.font forWidth:[PTSMessagingCell maxTextWidth] lineBreakMode:NSLineBreakByClipping];
    
    /*Initializes the different frames , that need to be calculated.*/
    CGRect balloonViewFrame = CGRectZero;
    CGRect messageLabelFrame = CGRectZero;
     CGRect nameLabelFrame = CGRectZero;
    CGRect timeLabelFrame = CGRectZero;
    CGRect avatarImageFrame = CGRectZero;
       
    if (self.sent == YES) {

        
        balloonViewFrame = CGRectMake(10.0f, 0, self.frame.size.width-70.0f, textSize.height + 2*textMarginVertical);
        
        avatarImageFrame = CGRectMake(self.frame.size.width-50.0f, timeLabelFrame.size.height, 40.0f, 40.0f);
       
        
        messageLabelFrame = CGRectMake(15.0f,  balloonViewFrame.origin.y + textMarginVertical, textSize.width, textSize.height);
        
        nameLabelFrame = CGRectMake(15.0f, 5.0f, 100, 20);
        
        timeLabelFrame = CGRectMake(100.0f,balloonViewFrame.size.height, dateSize.width, dateSize.height);
        self.balloonView.backgroundColor=[self colorWithHexString:@"e0e0e0"];


    } else {
        
        balloonViewFrame = CGRectMake(60.0f,0, self.frame.size.width-70.0f, textSize.height + 2*textMarginVertical);
        
        avatarImageFrame = CGRectMake(10.0f, timeLabelFrame.size.height, 40.0f, 40.0f);
        
        messageLabelFrame = CGRectMake(15.0f, balloonViewFrame.origin.y + textMarginVertical, textSize.width, textSize.height);
        
        nameLabelFrame = CGRectMake(15.0f, 5.0f, 100, 20);
        
        timeLabelFrame = CGRectMake(100.0f,balloonViewFrame.size.height, dateSize.width, dateSize.height);
            self.balloonView.backgroundColor=[self colorWithHexString:@"f5e4dc"];

    }
    
    self.balloonView.image = [PTSMessagingCell balloonImage:self.sent isSelected:self.selected];
    
    /*Sets the pre-initialized frames  for the balloonView and messageView.*/
    self.balloonView.frame = balloonViewFrame;
  //  self.balloonView.backgroundColor=[UIColor lightGrayColor];
    self.messageLabel.frame = messageLabelFrame;
    
    /*If shown (and loaded), sets the frame for the avatarImageView*/
    if (self.avatarImageView.image != nil) {
        self.avatarImageView.frame = avatarImageFrame;
        self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.size.height/2;
        self.avatarImageView.clipsToBounds = YES;

        
    }
    
    /*If there is next for the timeLabel, sets the frame of the timeLabel.*/
    
    if (self.timeLabel.text != nil) {
        self.timeLabel.frame = timeLabelFrame;
    }
    
    /*If there is next for the nameLabel, sets the frame of the timeLabel.*/
    
    if (self.nameLabel.text != nil) {
        self.nameLabel.frame = nameLabelFrame;
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	/*Selecting a UIMessagingCell will cause its subviews to be re-layouted. This process will not be animated! So handing animated = YES to this method will do nothing.*/
    [super setSelected:selected animated:NO];
    
    [self setNeedsLayout];
    
    /*Furthermore, the cell becomes first responder when selected.*/
    if (selected == YES) {
        [self becomeFirstResponder];
    } else {
        [self resignFirstResponder];
    }
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {

}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated {
	
}

#pragma mark -
#pragma mark UIGestureRecognizer-Handling

- (void)handleLongPress:(UILongPressGestureRecognizer *)longPressRecognizer {
    /*When a LongPress is recognized, the copy-menu will be displayed.*/
    if (longPressRecognizer.state != UIGestureRecognizerStateBegan) {
        return;
    }
    
    if ([self becomeFirstResponder] == NO) {
        return;
    }
    
    UIMenuController * menu = [UIMenuController sharedMenuController];
    [menu setTargetRect:self.balloonView.frame inView:self];
    
    [menu setMenuVisible:YES animated:YES];
}

-(BOOL)canBecomeFirstResponder {
    /*This cell can become first-responder*/
    return YES;
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    /*Allows the copy-Action on this cell.*/
    if (action == @selector(copy:)) {
        return YES;
    } else {
        return [super canPerformAction:action withSender:sender];
    }
}

-(void)copy:(id)sender {
    /**Copys the messageString to the clipboard.*/
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:self.messageLabel.text];
}

#pragma colorWithHexString
-(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}


@end


