//
//  CreditLimitDetailsMessage.m
//  XMWClient
//
//  Created by Pradeep Singh on 30/05/21.
//  Copyright © 2021 dotvik. All rights reserved.
//

#import "CreditLimitDetailsMessage.h"
#import "NameValueTableCell.h"
#import "Styles.h"


@implementation CreditLimitDetailsMessage

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+(CreditLimitDetailsMessage*) createInstance
{
    CreditLimitDetailsMessage *view = (CreditLimitDetailsMessage *)[[[NSBundle mainBundle] loadNibNamed:@"CreditLimitDetailsMessage" owner:self options:nil] objectAtIndex:0];
     
    return view;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor colorWithWhite:0.3f alpha:0.8f];
    self.opaque = true;
    self.alpha = 1.0;
    
    self.lineTable.delegate = self;
    self.lineTable.dataSource = self;
    self.lineTable.backgroundColor = [UIColor whiteColor];
    
    self.centerPopup.layer.cornerRadius = 5.0f;
    self.centerPopup.layer.masksToBounds = YES;
    
    
    [self.lineTable registerNib:[UINib nibWithNibName:@"NameValueTableCell" bundle:nil] forCellReuseIdentifier:@"NameValueTableCell"];
    
    [self.buttonsView addSubview:[self  okButton]];
    
}

-(UIButton*) okButton
{
    UIImage *blueImage          = [UIImage imageNamed:@"blueButton.png"];
    UIImage *blueButtonImage    = [blueImage stretchableImageWithLeftCapWidth:8 topCapHeight:0];
    
    UIButton* button   = [[UIButton alloc]init];
    
    button       = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    [button setFrame:CGRectMake((self.lineTable.frame.size.width-100)/2,5, 100, 36)];
    
    [button setBackgroundImage:blueButtonImage forState:UIControlStateNormal];
    
    [button setTitleColor:[Styles buttonTextColor] forState: UIControlStateNormal];
    
    [button setTitle:@"OK" forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(okButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    NameValueTableCell *cell = (NameValueTableCell*)[tableView dequeueReusableCellWithIdentifier:@"NameValueTableCell"];
    
    // cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(self.tableRows!=nil && [self.tableRows count]>0) return [self.tableRows count];
    
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    
    CGSize rect = [self.title boundingRectWithSize:CGSizeMake(tableView.frame.size.width-10, 1024) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName: [UIFont boldSystemFontOfSize:14.0f] } context:nil].size;
    
    UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, rect.height + 20.0f)];
    
    headerView.opaque = 1;
    headerView.backgroundColor = [UIColor whiteColor];
    
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, tableView.frame.size.width-10, rect.height)];
    
    titleLabel.text = self.title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.numberOfLines = 0;
    titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    

    [headerView addSubview:titleLabel];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    CGSize rect = [self.title boundingRectWithSize:CGSizeMake(tableView.frame.size.width-10, 1024) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName: [UIFont boldSystemFontOfSize:14.0f] } context:nil].size;

    return rect.height + 20.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSArray* rowData = [self.tableRows objectAtIndex:indexPath.row];
    if([rowData count]>0) {
        NSString* leftText = [rowData objectAtIndex:0];
        
        CGSize rect = [leftText boundingRectWithSize:CGSizeMake(tableView.frame.size.width*3/5, 1024) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName: [UIFont boldSystemFontOfSize:13.0f] } context:nil].size;
        
        return rect.height + 30.0f;
    }
    
    
    return 44.0f;

}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NameValueTableCell *nvCell = (NameValueTableCell*)cell;
    
    nvCell.leftLabel.numberOfLines = 0;
    nvCell.leftLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    NSArray* rowData = [self.tableRows objectAtIndex:indexPath.row];
    
    NSString* leftText = [rowData objectAtIndex:0];
    
    CGSize rect = [leftText boundingRectWithSize:CGSizeMake(tableView.frame.size.width*3/5, 1024) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName: [UIFont boldSystemFontOfSize:13.0f] } context:nil].size;
    
    
    CGRect oldFrame = nvCell.leftLabel.frame;
    
    
    nvCell.leftLabel.frame = CGRectMake(oldFrame.origin.x, oldFrame.origin.y, oldFrame.size.width, rect.height + 15.0f);
    
    oldFrame = nvCell.rightLabel.frame;
    nvCell.rightLabel.frame = CGRectMake(oldFrame.origin.x, oldFrame.origin.y, oldFrame.size.width, rect.height + 15.0f);
    
    
    if([rowData count]==0) {
        nvCell.leftLabel.text = @"";
        nvCell.rightLabel.text = @"";
    } else if([rowData count]==1) {
        nvCell.leftLabel.text = [rowData objectAtIndex:0];
        nvCell.rightLabel.text = @"";
    } else if([rowData count]>1) {
        nvCell.leftLabel.text = [rowData objectAtIndex:0];
        nvCell.rightLabel.text = [rowData objectAtIndex:1];
    }
}


-(void)okButtonHandler:(id) sender
{
    [self removeFromSuperview];    
}

@end
