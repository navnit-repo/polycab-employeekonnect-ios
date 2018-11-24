//
//  ReportHeaderSection.h
//  QCMSProject
//
//  Created by Pradeep Singh on 7/27/14.
//  Copyright (c) 2014 dotvik. All rights reserved.
//

#import "ReportBaseSection.h"
#import "DotReportElement.h"

@interface ReportHeaderSection : ReportBaseSection
{
    NSArray* sortedElementIds;
    NSMutableDictionary* reportElements;
    
}
@property(nonatomic,retain) NSMutableDictionary* forwardedDataDisplay;
@property(nonatomic,retain) NSMutableDictionary* forwardedDataPost;
-(NSString*) computeHeaderLineValue:(DotReportElement*) dotReportElement;
-(UIView *)viewNoStyle:(NSIndexPath *)indexPath;
@end
