//
//  detailsTableView.m
//  XMWClient
//
//  Created by dotvikios on 13/12/18.
//  Copyright © 2018 dotvik. All rights reserved.
//

#import "detailsTableView.h"

@interface detailsTableView ()

@end

@implementation detailsTableView

@synthesize dataArray;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.bounces = NO;
    NSLog(@"Data %@",dataArray);
    [self headerView];
}
-(UIView*)drawView:(long int)index{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 40)];
    view.backgroundColor = [UIColor clearColor];

    
    UILabel *regID = [[UILabel alloc]initWithFrame:CGRectMake(5, 10, 80,30 )];
   
    regID.textAlignment = UITextAlignmentLeft;
    regID.font = [UIFont fontWithName:@"Helvetica-Regular" size:12.0];
    regID.text= [[dataArray objectAtIndex:index]objectAtIndex:0];
    // regID.textColor = [UIColor whiteColor];
    
    [view addSubview:regID];
    
    UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(85, 10, 80,30 )];
   
    name.textAlignment = UITextAlignmentCenter;
    name.font = [UIFont fontWithName:@"Helvetica-Regular" size:12.0];
    name.text= [[dataArray objectAtIndex:index]objectAtIndex:1];
    // name.textColor = [UIColor whiteColor];
    [view addSubview:name];
    UILabel *amount = [[UILabel alloc]initWithFrame:CGRectMake(165, 10, 120,30 )];
 
    amount.textAlignment = UITextAlignmentRight;
    amount.font = [UIFont fontWithName:@"Helvetica-Regular" size:12.0];
    amount.text= [[dataArray objectAtIndex:index]objectAtIndex:2];   // amount.textColor = [UIColor whiteColor];
    [view addSubview:amount];
    return view;
}
-(void)headerView{
    
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage
                                                                          imageNamed:@"back-button"]  style:UIBarButtonItemStylePlain target:self
                                                                  action:@selector(backHandler:)];
    
    
    
    backButton.tintColor = [UIColor colorWithRed:119.0/255 green:119.0/255 blue:119.0/255 alpha:1.0];
    
    
    UIImageView *polycabLogo = [[UIImageView alloc] initWithImage:[UIImage  imageNamed:@"polycab_logo"]];
    self.navigationItem.titleView.contentMode = UIViewContentModeCenter;
    self.navigationItem.titleView = polycabLogo;
    [self.navigationItem setLeftBarButtonItem:backButton];
}
- (void) backHandler : (id) sender
{
    [ [self navigationController]  popViewControllerAnimated:YES];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
         return dataArray.count;
    }
    else
        return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString* cellIdentifier = [NSString stringWithFormat:@"cell_%ld", (long)indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

             [cell addSubview:[self drawView:indexPath.row]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
        
    
    
    
   
    
    return cell;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 40)];
    view.backgroundColor = [UIColor redColor];
    
    
    UILabel *regID = [[UILabel alloc]initWithFrame:CGRectMake(5, 10, 80,30 )];
    regID.textAlignment = UITextAlignmentLeft;
    regID.font = [UIFont fontWithName:@"Helvetica-Regular" size:12.0];
    regID.text= @"RegID";
    regID.textColor = [UIColor whiteColor];
    
    [view addSubview:regID];
    
    UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(85, 10, 80,30 )];
    name.textAlignment = UITextAlignmentCenter;
    name.font = [UIFont fontWithName:@"Helvetica-Regular" size:12.0];
    name.text= @"Name";
    name.textColor = [UIColor whiteColor];
    [view addSubview:name];
    UILabel *amount = [[UILabel alloc]initWithFrame:CGRectMake(165, 10, 80,30 )];
    amount.textAlignment = UITextAlignmentRight;
    amount.font = [UIFont fontWithName:@"Helvetica-Regular" size:12.0];
    amount.text= @"Amount";
    amount.textColor = [UIColor whiteColor];
    [view addSubview:amount];
    
    
    return view;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
@end
