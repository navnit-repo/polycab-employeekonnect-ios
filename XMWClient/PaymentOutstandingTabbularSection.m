//
//  PaymentOutstandingTabbularSection.m
//  XMWClient
//
//  Created by dotvikios on 20/11/18.
//  Copyright © 2018 dotvik. All rights reserved.
//

#import "PaymentOutstandingTabbularSection.h"
#import "SalesIncentiveItemPopup.h"
#import "ReportVC.h"
@interface PaymentOutstandingTabbularSection ()

@end

@implementation PaymentOutstandingTabbularSection

{
    UIViewController *root;
}


//-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSMutableArray* row = [recordTableData objectAtIndex:indexPath.row];
//    NSMutableArray* lineItemArrayForPopup = [[NSMutableArray alloc] init];
//    [lineItemArrayForPopup addObject:[NSArray arrayWithObjects:@"LOB Name:", [row objectAtIndex:6], nil]];
//    [lineItemArrayForPopup addObject:[NSArray arrayWithObjects:@"Current Year Sale:", [row objectAtIndex:7], nil]];
//
//   SalesIncentiveItemPopup* contentPopup = [SalesIncentiveItemPopup createInstanceWithData:lineItemArrayForPopup];
//
//          [[UIApplication sharedApplication].keyWindow addSubview:contentPopup];
//
//}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"Report Screen Controller : handleRowSelected");
    NSString* expandProperty;
    BOOL isDrillDown = [self clickableAndExpandable :indexPath.row :&expandProperty];
    NSLog(@"expandProperty");
    
    NSMutableArray *records = recordTableData;
    NSArray* rowData = [records objectAtIndex:indexPath.row];
    
    if([expandProperty isEqualToString:@""]!=0)
    {
        // handle expandable
        //SystemToast *toast = new SystemToast(this);
        
        //toast->setBody(expandProperty);
        //toast->setPosition(SystemUiPosition::MiddleCenter);
        //toast->show();
        
        return;
    }
    if([[rowData objectAtIndex:0]isEqualToString:@"RECPT"])//for polycab RECPT check
    {
        isDrillDown = NO;
    }
    
    if(isDrillDown) {
     
        if(self.reportVC.drilldownDelegate !=nil && [self.reportVC.drilldownDelegate respondsToSelector:@selector(handleDrilldownForRow: withRowData:)]) {
            NSMutableArray *records = recordTableData;
            NSArray* rowData = [records objectAtIndex:indexPath.row];
            [self.reportVC.drilldownDelegate handleDrilldownForRow:indexPath.row  withRowData:rowData];
        } else {
            [self handleDrillDown: indexPath.row : self.reportVC.forwardedDataDisplay : self.reportVC.forwardedDataPost];
        }
    }
    
}

@end
