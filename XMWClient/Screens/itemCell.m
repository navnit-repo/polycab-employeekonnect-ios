//
//  itemCell.m
//  polycab
//
//  Created by Shivangi on 27/10/21.
//
#import <Foundation/Foundation.h>
#import "itemCell.h"
 
@implementation itemCell
 
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
 
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
 
    // Configure the view for the selected state
}
 
@end
