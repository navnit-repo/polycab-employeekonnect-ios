//
//  XMWAbout.m
//  QCMSProject
//
//  Created by Pradeep Singh on 10/6/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//

#import "XMWAbout.h"
#import <QuartzCore/QuartzCore.h>
#import "MXButton.h"

extern CGPathRef NewPathWithRoundRect(CGRect rect, CGFloat cornerRadius);


@implementation XMWAbout

@synthesize closeDelegate;

// returns the constructed view, already added as a subview of the aSuperview
//	(and hence retained by the superview)
//
+ (id)loadingViewInView:(UIView *)aSuperview handler:(id<XMWAboutCloseDelegate>) handler
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
	XMWAbout *aboutView = [[XMWAbout alloc] initWithFrame:[aSuperview bounds]];
	
    if (!aboutView)
		return nil;
	aboutView.closeDelegate = handler;
	aboutView.opaque = NO;
	aboutView.autoresizingMask =	UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[aSuperview addSubview:aboutView];
	
	const CGFloat DEFAULT_LABEL_WIDTH = 320.0;
    const CGFloat DEFAULT_LABEL_HEIGHT = 50.0;
    CGRect labelFrame = CGRectMake(0, 0, DEFAULT_LABEL_WIDTH, DEFAULT_LABEL_HEIGHT);
    
    UILabel *loadingLabel =	[[UILabel alloc] initWithFrame:labelFrame];
    loadingLabel.text = @"About";//[Language get:@"LOADING" alter:nil];
    loadingLabel.textColor = [UIColor blackColor];
    loadingLabel.backgroundColor = [UIColor clearColor];
    loadingLabel.textAlignment = UITextAlignmentCenter;
    loadingLabel.font = [UIFont boldSystemFontOfSize:[UIFont labelFontSize]];
    loadingLabel.autoresizingMask =	UIViewAutoresizingFlexibleLeftMargin |	UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleTopMargin |	UIViewAutoresizingFlexibleBottomMargin;
	
	[aboutView addSubview:loadingLabel];
    
    
    
    UILabel *aboutTextLabel =	[[UILabel alloc] initWithFrame:CGRectMake(0, DEFAULT_LABEL_HEIGHT, DEFAULT_LABEL_WIDTH, DEFAULT_LABEL_HEIGHT*4)];
    aboutTextLabel.text = @"mKonnect\r\nBuild Versions: iOS 2.1, XMW 2.1\r\nDeveloped by Dotvik Solutions.\r\nwww.dotvik.com";
    aboutTextLabel.numberOfLines = 0;
    aboutTextLabel.textColor = [UIColor blackColor];
    aboutTextLabel.backgroundColor = [UIColor clearColor];
    aboutTextLabel.textAlignment = UITextAlignmentCenter;
    //aboutTextLabel.font = [UIFont boldSystemFontOfSize:[UIFont labelFontSize]];
    aboutTextLabel.autoresizingMask =	UIViewAutoresizingFlexibleLeftMargin |	UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleTopMargin |	UIViewAutoresizingFlexibleBottomMargin;
	
	[aboutView addSubview:aboutTextLabel];

	
    UIImage *blueImage          = [UIImage imageNamed:@"blueButton.png"];
	UIImage *blueButtonImage    = [blueImage stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	UIButton *closeButton       = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[closeButton setFrame:CGRectMake( 72.0f, 220.0f, 180.0f, 36.0f)];
	[closeButton setBackgroundImage:blueButtonImage forState:UIControlStateNormal];
	[closeButton setTitleColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0] forState: UIControlStateNormal];
	[closeButton setTitle:@"Close" forState:UIControlStateNormal];
    [closeButton addTarget:aboutView action:@selector(closeAbout:) forControlEvents:UIControlEventTouchUpInside];
	
    
    [aboutView addSubview:closeButton];
    
	// Set up the fade-in animation
	CATransition *animation = [CATransition animation];
	[animation setType:kCATransitionFade];
	[[aSuperview layer] addAnimation:animation forKey:@"layerAnimation"];
	
	return aboutView;
}


// Animates the view out from the superview. As the view is removed from the
// superview, it will be released.
//
- (void)removeView
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	UIView *aSuperview = [self superview];
	[super removeFromSuperview];
	
	// Set up the animation
	CATransition *animation = [CATransition animation];
	[animation setType:kCATransitionFade];
	
	[[aSuperview layer] addAnimation:animation forKey:@"layerAnimation"];
}

- (IBAction)closeAbout:(id)sender
{
    [self removeFromSuperview];
    
    if(closeDelegate) {
        [closeDelegate  aboutClosed];
    }
}

// Draw the view.
//
- (void)drawRect:(CGRect)rect
{
	rect.size.height -= 1;
	rect.size.width -= 1;
	
	const CGFloat RECT_PADDING = 8.0;
	rect = CGRectInset(rect, RECT_PADDING, RECT_PADDING);
	
	const CGFloat ROUND_RECT_CORNER_RADIUS = 5.0;
	CGPathRef roundRectPath = NewPathWithRoundRect(rect, ROUND_RECT_CORNER_RADIUS);
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	const CGFloat BACKGROUND_OPACITY = 1.0;
	CGContextSetRGBFillColor(context, 100, 100, 100, BACKGROUND_OPACITY);
	CGContextAddPath(context, roundRectPath);
	CGContextFillPath(context);
	
	const CGFloat STROKE_OPACITY = 0.25;
	CGContextSetRGBStrokeColor(context, 1, 1, 1, STROKE_OPACITY);
	CGContextAddPath(context, roundRectPath);
	CGContextStrokePath(context);
	
	CGPathRelease(roundRectPath);
}




@end
