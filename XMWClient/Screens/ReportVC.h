//
//  ReportVC.h
//  EMSSales
//
//  Created by Puneet Arora on 14/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReportPostResponse.h"
#import "DotReportDraw.h"
#import "DotReport.h"
#import "HttpEventListener.h"
#import "LoadingView.h"
#import "ReportTabularDataSection.h"
#import "ReportSectionsController.h"


@protocol DrilldownControlDelegate <NSObject>
-(void) handleDrilldownForRow:(NSInteger) rowIndex withRowData:(NSArray*) rowData;
@end


@interface ReportVC : UIViewController <HttpEventListener>
{
@protected
    NSMutableDictionary *reportCompMap;
    NSMutableArray *sectionArray;
    ReportSectionsController* sectionController;
    NSMutableArray *docIdData;
    
    NSUInteger trackerIndex;
    int selectionDiff;
    
    
    ReportPostResponse *reportPostResponse;
    DotReport *dotReport;
    NSMutableDictionary *forwardedDataDisplay;
    NSMutableDictionary *forwardedDataPost;
    DotReportDraw *dotReportDraw;
    LoadingView* loadingView;
    
    int screenId;
    
    UIImageView  *imageView;
    
    BOOL needRefresh;
    UITableView *reportTableView;
    UISearchBar *searchBar;
    float titleLblHeight;
}
@property  float titleLblHeight;
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) UITableView *reportTableView;

@property (strong, nonatomic) NSMutableDictionary *menuDetailMap;
@property (strong, nonatomic) NSMutableDictionary *dataForNextScreen;
@property (strong, nonatomic) NSMutableDictionary *nextScreenPost;
@property NSMutableDictionary *forwardedDataDisplay;
@property  NSMutableDictionary *forwardedDataPost;

@property int screenId;
@property ReportPostResponse* reportPostResponse;
@property DotReport *dotReport;

@property (strong, nonatomic) DotFormPost* requestFormPost;

// for PowerPlus, need custom drilldown handler concept
@property (nonatomic, assign) id<DrilldownControlDelegate> drilldownDelegate;


-(id) initWithDocIds:(NSMutableArray *)_docIdData;

-(void) initializeView;

-(void) drawHeaderItem;

-(void) drawTitle:(NSString *)headerStr;

-(id) getGradientColor:(UIView *)_view;

-(void) initializeHeaderData;

-(void) initializeTableData;

-(IBAction) buttonPressed:(id) sender;

@property  NSMutableArray* downloadHistoryMenuList;
@property  UIImageView  *imageView;


// for overriding stuff

-(void) makeReportScreenV2;
-(ReportTabularDataSection*) addTabularDataSection;
- (void) httpResponseObjectHandler : (NSString*) callName : (id) respondedObject : (id) requestedObject;
- (void) httpFailureHandler : (NSString*) callName : (NSString*) message;

-(void)setNeedRefresh:(BOOL) inNeedRefresh;



@end
