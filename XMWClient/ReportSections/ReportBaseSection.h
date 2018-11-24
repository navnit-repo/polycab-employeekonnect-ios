//
//  ReportBaseSection.h
//  Dotvik XMW
//
//  Created by Pradeep
//
//

#import <Foundation/Foundation.h>

@class ReportVC;
@class DotReport;
@class ReportPostResponse;


@interface ReportBaseSection : NSObject <UITableViewDelegate, UITableViewDataSource>
{
    NSInteger reportSection;
}

@property(nonatomic, retain) ReportVC* reportVC;
@property(nonatomic,retain) DotReport* dotReport;
@property(nonatomic, retain) ReportPostResponse* reportPostResponse;
@property(nonatomic,assign) NSInteger numberOfRows;
@property(nonatomic, assign) NSString* componentPlace;

@property(nonatomic,assign) UITableView* tableView;


-(void)updateData: (DotReport*) inDotReport :(ReportPostResponse*) inReportPostResponse;


/*
 // coming from delegate
-(NSInteger)tableView:(UITableView *)pTableView numberOfRowsInSection:(NSInteger)section;
-(UITableViewCell *)tableView:(UITableView *)pTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
-(CGFloat)tableView:(UITableView *)pTableView heightForHeaderInSection:(NSInteger)sectionIndex;
-(CGFloat)tableView:(UITableView *)pTableView heightForFooterInSection:(NSInteger)sectionIndex;
-(UIView *)tableView:(UITableView *)pTableView viewForHeaderInSection:(NSInteger)sectionIndex;
-(UIView*)tableView:(UITableView *)pTableView viewForFooterInSection:(NSInteger)sectionIndex;

-(CGFloat)tableView:(UITableView *)pTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

-(void)tableView:(UITableView *)pTableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

 */

@end
