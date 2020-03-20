//
//  CustomeReportHeader.m
//  XMWClient
//
//  Created by dotvikios on 03/10/18.
//  Copyright © 2018 dotvik. All rights reserved.
//

#import "CustomeReportHeader.h"
#import "DotReportElement.h"
#import "DispatchDetailsMapVC.h"
#import "DVAppDelegate.h"
@implementation CustomeReportHeader

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *keyOfComp =  (NSString *) [sortedElementIds objectAtIndex :indexPath.row];
    DotReportElement *dotReportElement = (DotReportElement *) [reportElements objectForKey:keyOfComp];
    NSMutableDictionary * headerData = self.reportPostResponse.headerData;
    NSString*Value =  (NSString*) [headerData objectForKey:dotReportElement.elementId];
    
    if ([keyOfComp isEqualToString:@"VEHICLE_NO"]) {
        DispatchDetailsMapVC *vc = [[DispatchDetailsMapVC alloc]init];
        vc.vehicleNo = Value;
        [[self.reportVC navigationController ] pushViewController:vc animated:YES];
        
    }
}
@end
