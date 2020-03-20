//
//  DocumentScreenController.h
//  QCMSProject
//
//  Created by Ashish Tiwari on 08/10/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DotFormPost.h"
#import "DotForm.h"
#import "RecentRequestController.h"
#import "NetworkHelper.h"
#import "HttpEventListener.h"
#import "LoadingView.h"

@interface DocumentScreenController : UIViewController<HttpEventListener>
{
    int screenId;
	int maxDocId;
	NSMutableDictionary* docDataMap;
	DotFormPost* dotFormPost;
	NSString* dotFormId;
	NSString* status;
	DotForm* dotForm;
    UIView* formContainer;
    RecentRequestController* parentForm;
    LoadingView* loadingView;
    int yargufortable;
}
@property int screenId;
@property int maxDocId;
@property NSMutableDictionary* docDataMap;
@property DotFormPost* dotFormPost;
@property NSString* dotFormId;
@property NSString* status;
@property DotForm* dotForm;
@property RecentRequestController* parentForm;

-(void)initwithData : (int) id : (int) docId : (id) parent;
-(void) loadData;
-(void) screenDisplay;
-(void)drawDocument;
-(void) addTable;
-(void)insertRow : (NSMutableArray*) data : (BOOL) isHeader : (float)headerWidthList;
-(void)drawRowsForTable : (int) rowNo :(float)headerWidthList;
-(IBAction)ReSubmitButton:(id)sender;


@end
