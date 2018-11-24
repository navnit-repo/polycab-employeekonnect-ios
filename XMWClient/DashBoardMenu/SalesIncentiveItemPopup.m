//
//  SalesIncentiveItemPopup.m
//  QCMSProject
//
//  Created by Pradeep Singh on 2/11/15.
//  Copyright (c) 2015 dotvik. All rights reserved.
//

#import "SalesIncentiveItemPopup.h"

@implementation SalesIncentiveItemPopup

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


+(SalesIncentiveItemPopup*) createInstance
{
    
    SalesIncentiveItemPopup *view = (SalesIncentiveItemPopup *)[[[NSBundle mainBundle] loadNibNamed:@"SalesIncentiveItemPopup" owner:self options:nil] objectAtIndex:0];
    
    view.tableView.delegate = view;
    view.tableView.dataSource = view;
    
    view.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - view.frame.size.width)/2,
                            ([UIScreen mainScreen].bounds.size.height - view.frame.size.height)/2, view.frame.size.width, view.frame.size.height);
   // view.backgroundColor = [UIColor whiteColor];
    view.layer.borderWidth = 3.0f;
    
    view.popupHolderView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    view.popupHolderView.layer.borderWidth = 3.0f;
    view.popupHolderView.backgroundColor = [UIColor whiteColor];
    
    view.tableView.bounces = NO;
    view.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    view.layer.cornerRadius = 5.0;
    view.layer.masksToBounds = YES;
    
    
    view.cancelButton.layer.cornerRadius = 4.0;
    view.cancelButton.layer.masksToBounds = YES;
    
    [view.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"lineItemCell"];
    

    return view;
}



+(SalesIncentiveItemPopup*) createInstanceWithData:(NSArray*) lineData
{
    
    
    SalesIncentiveItemPopup *view = (SalesIncentiveItemPopup *)[[[NSBundle mainBundle] loadNibNamed:@"SalesIncentiveItemPopup" owner:self options:nil] objectAtIndex:0];
    
    view.tableView.delegate = view;
    view.tableView.dataSource = view;
    view.lineItemData = lineData;

    NSInteger popupHeight = 44 + ([view.lineItemData count]-1)*30 + 44;
    if(popupHeight > view.frame.size.height) {
        popupHeight = view.frame.size.height;
    }
    
    view.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - view.frame.size.width)/2,
                            ([UIScreen mainScreen].bounds.size.height - view.frame.size.height)/2, view.frame.size.width, view.frame.size.height);
    // view.backgroundColor = [UIColor whiteColor];
  //  view.layer.borderWidth = 3.0f;

    
    view.popupHolderView.frame = CGRectMake((view.frame.size.width - 300)/2, (view.frame.size.height-popupHeight)/2, 300, popupHeight);
    
    view.popupHolderView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    view.popupHolderView.layer.borderWidth = 2.0f;
    view.popupHolderView.backgroundColor = [UIColor whiteColor];
    
    view.tableView.bounces = NO;
    view.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    view.layer.cornerRadius = 5.0;
    view.layer.masksToBounds = YES;
    
    
    view.cancelButton.layer.cornerRadius = 4.0;
    view.cancelButton.layer.masksToBounds = YES;
    
    [view.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"lineItemCell"];
    
    
    return view;
}



#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.lineItemData!=nil && ([self.lineItemData count] > 1)) {
        return [self.lineItemData count] - 1;
    } else {
        return 0;
    }
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray* rowData = [self.lineItemData objectAtIndex:(indexPath.row + 1)];
    if([rowData count]>2) {
        return 50.0f;
    }
    return 30.0f;
}


-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"lineItemCell"];
    
    if(cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"lineItemCell"];
    }
    
    /*
    UILabel* textLabel = (UILabel*)[cell.contentView viewWithTag:101];
    if(textLabel==nil) {
        textLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 0.0f, self.frame.size.width-10, 32.0f)];
        textLabel.font = [UIFont systemFontOfSize:13.0f];
        
        textLabel.tag = 101;
        [cell.contentView addSubview:textLabel];
    }
     */
    return cell;
}



#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.frame.size.width, 40.0f)];
    view.backgroundColor = [UIColor whiteColor];

    
    if(self.lineItemData!=nil && ([self.lineItemData count] > 1)) {
        NSArray* rowData = [self.lineItemData objectAtIndex:0];
        
        CGFloat xOffset = 2.0f;
        CGFloat columnWidth = (self.tableView.frame.size.width - (xOffset*[rowData count]))/[rowData count];
        
        for(int i=0; i<[rowData count]; i++) {
            UILabel*   textLabel = [[UILabel alloc] initWithFrame:CGRectMake(xOffset, 0.0f, columnWidth, 40.0f)];
            textLabel.tag = 101;
            textLabel.font = [UIFont systemFontOfSize:13.0f];
            textLabel.numberOfLines = 0;
            textLabel.text = [rowData objectAtIndex:i];
            [view addSubview:textLabel];
            xOffset = xOffset + columnWidth + 2.0f;
        }
    }
    
    return view;
    
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    
}

-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    for (UIView* view in [cell.contentView subviews]) {
        [view removeFromSuperview];
    }
    
    CGFloat height =  [self tableView:tableView heightForRowAtIndexPath:indexPath];
    
        NSArray* rowData = [self.lineItemData objectAtIndex:(indexPath.row + 1)];
    
        CGFloat xOffset = 2.0f;
        CGFloat columnWidth = (self.tableView.frame.size.width - (xOffset*[rowData count]))/[rowData count];
        
        for(int i=0; i<[rowData count]; i++) {
            UILabel*   textLabel = [[UILabel alloc] initWithFrame:CGRectMake(xOffset, 0.0f, columnWidth, height)];
            textLabel.tag = 101;
            textLabel.font = [UIFont systemFontOfSize:12.0f];
            textLabel.numberOfLines = 0;
            textLabel.lineBreakMode = NSLineBreakByWordWrapping;
            textLabel.text = [rowData objectAtIndex:i];
            [cell.contentView addSubview:textLabel];
            xOffset = xOffset + columnWidth + 2.0f;
        }
   
}

- (IBAction)handleClose:(id)sender {
    
    [self removeFromSuperview];
}


@end
