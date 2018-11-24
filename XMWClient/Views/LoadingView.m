//
//  LoadingView.m
//  XMW Base client
//
//  Created by Ashish Tiwari on 22/05/2013.
//  Copyright (c) 2013 Dotvik Solutions. All rights reserved.
//

#import "LoadingView.h"
#import <QuartzCore/QuartzCore.h>
#import "SBJson.h"
#import "DVAppDelegate.h"


CGPathRef NewPathWithRoundRect(CGRect rect, CGFloat cornerRadius)
{
	//
	// Create the boundary path
	//
	CGMutablePathRef path = CGPathCreateMutable();
	CGPathMoveToPoint(path, NULL,
					  rect.origin.x,
					  rect.origin.y + rect.size.height - cornerRadius);
	
	// Top left corner
	CGPathAddArcToPoint(path, NULL,
						rect.origin.x,
						rect.origin.y,
						rect.origin.x + rect.size.width,
						rect.origin.y,
						cornerRadius);
	
	// Top right corner
	CGPathAddArcToPoint(path, NULL,
						rect.origin.x + rect.size.width,
						rect.origin.y,
						rect.origin.x + rect.size.width,
						rect.origin.y + rect.size.height,
						cornerRadius);
	
	// Bottom right corner
	CGPathAddArcToPoint(path, NULL,
						rect.origin.x + rect.size.width,
						rect.origin.y + rect.size.height,
						rect.origin.x,
						rect.origin.y + rect.size.height,
						cornerRadius);
	
	// Bottom left corner
	CGPathAddArcToPoint(path, NULL,
						rect.origin.x,
						rect.origin.y + rect.size.height,
						rect.origin.x,
						rect.origin.y,
						cornerRadius);
	
	// Close the path at the rounded rect
	CGPathCloseSubpath(path);
	
	return path;
}

static NSMutableDictionary* g_QuotesMap = nil;

@implementation LoadingView

+ (NSMutableDictionary*) quotesMap {
    if(g_QuotesMap==nil) {
        srandomdev();
        NSString* pathForQuotesJson = [[NSBundle mainBundle] pathForResource:@"quotes"  ofType:@"json"];
    
        SBJsonParser* sbParser = [[SBJsonParser alloc] init];
        NSData* jsonData = [[NSData alloc] initWithContentsOfFile:pathForQuotesJson];
        g_QuotesMap = (NSMutableDictionary*)[sbParser objectWithData:jsonData];
    }
    return g_QuotesMap;
}

+ (NSString*) getRandonQuote
{
    NSMutableDictionary* quotesMap = [LoadingView quotesMap];
    if(quotesMap!=nil) {
        int idx = random() % quotesMap.count;
        NSString* key = [[quotesMap allKeys] objectAtIndex:idx];
        return [quotesMap objectForKey:key];
    } else {
        return @"";
    }
}

// returns the constructed view, already added as a subview of the aSuperview
//	(and hence retained by the superview)
//
+ (id)loadingViewInView:(UIView *)aSuperview
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
	LoadingView *loadingView = [[LoadingView alloc] initWithFrame:[aSuperview bounds]];
	
    if (!loadingView)
		return nil;
	
	loadingView.opaque = NO;
	loadingView.autoresizingMask =	UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[aSuperview addSubview:loadingView];
	
	const CGFloat DEFAULT_LABEL_WIDTH = 280.0;
    const CGFloat DEFAULT_LABEL_HEIGHT = 100.0;
    CGRect labelFrame = CGRectMake(0, 0, DEFAULT_LABEL_WIDTH, DEFAULT_LABEL_HEIGHT);
    
    UILabel *loadingLabel =	[[UILabel alloc] initWithFrame:labelFrame];
    
    // loadingLabel.text = @"Loading..";//[Language get:@"LOADING" alter:nil];
    
  //  loadingLabel.text = [LoadingView getRandonQuote];
    loadingLabel.numberOfLines = 0;
    
    loadingLabel.textColor = [UIColor whiteColor];
    loadingLabel.backgroundColor = [UIColor clearColor];
    loadingLabel.textAlignment = UITextAlignmentCenter;
    loadingLabel.font = [UIFont boldSystemFontOfSize:[UIFont labelFontSize]];
    loadingLabel.autoresizingMask =	UIViewAutoresizingFlexibleLeftMargin |	UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleTopMargin |	UIViewAutoresizingFlexibleBottomMargin;
	
	//[loadingView addSubview:loadingLabel];
	
	UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	//[loadingView addSubview:activityIndicatorView];
    
	activityIndicatorView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin |	UIViewAutoresizingFlexibleRightMargin |
	UIViewAutoresizingFlexibleTopMargin |	UIViewAutoresizingFlexibleBottomMargin;
	[activityIndicatorView startAnimating];
	
   //pending work
    
    CGRect rect = [[UIScreen mainScreen]bounds];
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    UIView *backGroundView = [[UIView alloc]init];
    
    backGroundView.frame = CGRectMake(20, height/3, width-40, 100);
    backGroundView.backgroundColor = [UIColor whiteColor];
    backGroundView.layer.cornerRadius = 5;
    backGroundView.layer.masksToBounds = YES;
    
   
    
    UIImageView *image = [[UIImageView alloc]init];
    image.frame = CGRectMake(30, 30, 80*deviceWidthRation, 20);
    [image setImage:[UIImage imageNamed:@"polycab_logo.png"]];
    
    [backGroundView addSubview:image];
    
    UILabel *lbl = [[UILabel alloc]init];
    lbl.frame = CGRectMake(image.frame.size.width+40, 20, 200*deviceWidthRation, 40);
    lbl.text = @"Please wait, Loading...";
    lbl.font = [UIFont systemFontOfSize:15*deviceWidthRation];
    lbl.textColor = [UIColor lightGrayColor];
    [backGroundView addSubview:lbl];
   
    
    [backGroundView addSubview:activityIndicatorView];
    
    
    
    
     [loadingView addSubview:backGroundView];
  //  UIView * view = [[UIView alloc]initWithFrame:labelFrame];
    
  
    
	CGFloat totalHeight = loadingLabel.frame.size.height +	activityIndicatorView.frame.size.height;
    labelFrame.origin.x = floor(0.5 * (loadingView.frame.size.width - DEFAULT_LABEL_WIDTH));
    labelFrame.origin.y = floor(0.5 * (loadingView.frame.size.height - totalHeight));
    loadingLabel.frame = labelFrame;
	
    
	CGRect activityIndicatorRect = activityIndicatorView.frame;
    activityIndicatorRect.origin.x = image.frame.size.width+40;
    activityIndicatorRect.origin.y = 50;
	activityIndicatorView.frame = activityIndicatorRect;
    activityIndicatorView.color = [UIColor redColor];
	
	// Set up the fade-in animation
	CATransition *animation = [CATransition animation];
	[animation setType:kCATransitionFade];
	[[aSuperview layer] addAnimation:animation forKey:@"layerAnimation"];
	
	return loadingView;
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
	
	const CGFloat BACKGROUND_OPACITY = 0.5;
	CGContextSetRGBFillColor(context, 0, 0, 0, BACKGROUND_OPACITY);
	CGContextAddPath(context, roundRectPath);
	CGContextFillPath(context);
	
	const CGFloat STROKE_OPACITY = 0.25;
	CGContextSetRGBStrokeColor(context, 1, 1, 1, STROKE_OPACITY);
	CGContextAddPath(context, roundRectPath);
	CGContextStrokePath(context);
	
	CGPathRelease(roundRectPath);
}


@end
