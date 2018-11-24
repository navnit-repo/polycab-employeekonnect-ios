//
//  MyDetailsReportHeaderSection.m
//  XMWClient
//
//  Created by dotvikios on 31/10/18.
//  Copyright © 2018 dotvik. All rights reserved.
//

#import "MyDetailsReportHeaderSection.h"

@implementation MyDetailsReportHeaderSection


-(UIView *)viewNoStyle:(NSIndexPath *)indexPath
{
    CGFloat screenWidth = self.tableView.frame.size.width;
    NSString *keyOfComp =  (NSString *) [sortedElementIds objectAtIndex :indexPath.row];
    DotReportElement *dotReportElement = (DotReportElement *) [reportElements objectForKey:keyOfComp];
    
    CGSize calcLeftSize = [dotReportElement.displayText boundingRectWithSize:CGSizeMake(screenWidth/2-10, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName: [UIFont systemFontOfSize:14] } context:nil].size;
    
    
    NSString *headerValue = [self computeHeaderLineValue:dotReportElement];
    CGSize calcRightSize = [headerValue boundingRectWithSize:CGSizeMake(screenWidth/2-10, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName: [UIFont systemFontOfSize:14] } context:nil].size;
    
    
    int headerRowHeight = calcLeftSize.height;
    
    if(headerRowHeight<calcRightSize.height) {
        headerRowHeight = calcRightSize.height;
    }
    
    headerRowHeight = headerRowHeight + 10;
    
    UIView *elementContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, headerRowHeight) ];
    
    UILabel *lblHeaderTitle = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, screenWidth/2 - 10, calcLeftSize.height)];
    lblHeaderTitle.text = dotReportElement.displayText;
    [lblHeaderTitle setFont:[UIFont systemFontOfSize:14 weight:UIFontWeightBold]];
    lblHeaderTitle.tag = 11;
    
    [elementContainer addSubview:lblHeaderTitle];
    
    UILabel *lblHeaderValue = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth/2+5, 5, screenWidth/2 - 10, calcRightSize.height)];
    //[lblHeaderValue setFont:[UIFont systemFontOfSize:14]];
    [lblHeaderValue setFont:[UIFont systemFontOfSize:14 weight:UIFontWeightRegular]];
    
    lblHeaderValue.text  = headerValue;
    lblHeaderValue.textColor = [UIColor colorWithRed:119.0/255 green:119.0/255 blue:119.0/255 alpha:1.0];
    lblHeaderValue.numberOfLines = 0;
    lblHeaderValue.tag = 12;
    
    [elementContainer addSubview:lblHeaderValue];
    
    //If this field value is use in Next Screen
    if([dotReportElement isUseForwardBool]) {
        [self.forwardedDataDisplay setObject:headerValue forKey:dotReportElement.elementId];
        [self.forwardedDataPost setObject:headerValue forKey:dotReportElement.elementId];
    }
    
    return elementContainer;
}

@end
