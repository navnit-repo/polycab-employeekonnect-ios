//
//  ReportBaseSection.m
//  Dotvik XMW
//
//  Created by Pradeep
//
//

#import "ReportBaseSection.h"

@interface ReportBaseSection()

@property(retain,nonatomic) NSMutableDictionary* cacheViewDict;

@end

@implementation ReportBaseSection

-(instancetype)init {
    self = [super init];
    if (self) {
        _cacheViewDict = [[NSMutableDictionary alloc] init];
    }
    return self;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    reportSection = indexPath.section;
    
    return 44.0f;  //this is default height
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0; // this is default height for the header
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;  // this is default view for the header
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0; // this is default height for the footer
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil; // this default view for the footer
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.numberOfRows;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if(cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}



-(void)updateData: (DotReport*) inDotReport :(ReportPostResponse*) inReportPostResponse
{
    self.dotReport = inDotReport;
    self.reportPostResponse = inReportPostResponse;
}




@end
