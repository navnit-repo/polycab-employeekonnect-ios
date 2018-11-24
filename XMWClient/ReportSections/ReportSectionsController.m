//
//  ReportSectionsController.m
//  Dotvik XMW
//
//  Created Pradeep
//
//

#import "ReportSectionsController.h"

@implementation ReportSectionsController

-(void)updateData: (DotReport*) inDotReport :(ReportPostResponse*) inReportPostResponse
{
    for(ReportBaseSection* section in self.sections ) {
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"HeaderDataSectionCell"];
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"LegendDataSectionCell"];
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"TableDataSectionCell"];
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"FooterDataSectionCell"];
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"SubHeaderDataSectionCell"];

        
        [section updateData:inDotReport :inReportPostResponse];
        section.tableView = self.tableView;
        
    }
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sections.count;
}

-(NSInteger)tableView:(UITableView *)pTableView numberOfRowsInSection:(NSInteger)section {
    return [(ReportBaseSection *)[self.sections objectAtIndex:section] tableView:pTableView numberOfRowsInSection:0];
}

-(UITableViewCell *)tableView:(UITableView *)pTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ReportBaseSection * section = [self.sections objectAtIndex:indexPath.section];
    return [section tableView:pTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
}

-(CGFloat)tableView:(UITableView *)pTableView heightForHeaderInSection:(NSInteger)sectionIndex {
    ReportBaseSection * section = (ReportBaseSection *)[self.sections objectAtIndex:sectionIndex];
    return [section tableView:pTableView heightForHeaderInSection:sectionIndex];
}

-(CGFloat)tableView:(UITableView *)pTableView heightForFooterInSection:(NSInteger)sectionIndex
{
    ReportBaseSection * section = (ReportBaseSection *)[self.sections objectAtIndex:sectionIndex];
    return [section tableView:pTableView heightForFooterInSection:sectionIndex];
}

-(UIView *)tableView:(UITableView *)pTableView viewForHeaderInSection:(NSInteger)sectionIndex {
    ReportBaseSection * section = (ReportBaseSection *)[self.sections objectAtIndex:sectionIndex];
    return [section tableView:pTableView viewForHeaderInSection:sectionIndex];
}

-(UIView*)tableView:(UITableView *)pTableView viewForFooterInSection:(NSInteger)sectionIndex
{
    ReportBaseSection *section = (ReportBaseSection*)[self.sections objectAtIndex:sectionIndex];
    return [section tableView:pTableView viewForFooterInSection:sectionIndex];
}

-(CGFloat)tableView:(UITableView *)pTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ReportBaseSection * section = (ReportBaseSection *)[self.sections objectAtIndex:indexPath.section];
    return [section tableView:pTableView heightForRowAtIndexPath:indexPath];
}

-(void)tableView:(UITableView *)pTableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReportBaseSection *section = (ReportBaseSection *)[self.sections objectAtIndex:indexPath.section];
    if ([section respondsToSelector:@selector(tableView:willDisplayCell:forRowAtIndexPath:)])
    {
        [section tableView:pTableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReportBaseSection *section = [self.sections objectAtIndex:indexPath.section];
    if([section respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        [section tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}


@end
