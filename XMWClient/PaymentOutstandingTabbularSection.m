//
//  PaymentOutstandingTabbularSection.m
//  XMWClient
//
//  Created by dotvikios on 20/11/18.
//  Copyright © 2018 dotvik. All rights reserved.
//

#import "PaymentOutstandingTabbularSection.h"
#import "SalesIncentiveItemPopup.h"

@interface PaymentOutstandingTabbularSection ()

@end

@implementation PaymentOutstandingTabbularSection

{
    UIViewController *root;
}


-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray* row = [recordTableData objectAtIndex:indexPath.row];
    NSMutableArray* lineItemArrayForPopup = [[NSMutableArray alloc] init];
    [lineItemArrayForPopup addObject:[NSArray arrayWithObjects:@"LOB Name:", [row objectAtIndex:6], nil]];
    [lineItemArrayForPopup addObject:[NSArray arrayWithObjects:@"Current Year Sale:", [row objectAtIndex:7], nil]];
   
   SalesIncentiveItemPopup* contentPopup = [SalesIncentiveItemPopup createInstanceWithData:lineItemArrayForPopup];
    
          [[UIApplication sharedApplication].keyWindow addSubview:contentPopup];

}
@end
