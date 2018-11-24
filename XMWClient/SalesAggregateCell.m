//
//  SalesAggregateCell.m
//  XMWClient
//
//  Created by dotvikios on 08/08/18.
//  Copyright © 2018 dotvik. All rights reserved.
//

#import "SalesAggregateCell.h"

@implementation SalesAggregateCell
@synthesize ftdDataSetLbl,mtdDataSetLbl,ytdDataSetLbl;

- (void)awakeFromNib {
    [super awakeFromNib];

}
- (void)configure:(NSString *)ftdData :(NSString *)mtdData :(NSString *)ytdData{
    self.ftdDataSetLbl.text = ftdData;
    self.mtdDataSetLbl.text = mtdData;
    self.ytdDataSetLbl.text = ytdData;
}
@end
