//
//  SharedMenuOptionView
//
//  Created by Ashish Tiwari
//  Copyright (c) 2013 dotvik. All rights reserved.
//

#import "DownloadHistoryMenuView.h"
#import "MXButton.h"


@implementation DownloadHistoryMenuView

@synthesize downloadTable;
@synthesize downloadHistoryList;
@synthesize percentageLabel;
@synthesize firstProgress;
@synthesize _percentage;

@synthesize reportVc;

- (id)initWithFrame:(CGRect)frame withMenu:(NSArray*) menus handler:(id<DownloadHistoryMenuHandler>) historyMenuHandler;
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.downloadHistoryList = [[NSMutableArray alloc] initWithArray:menus];
        
        downloadTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) style:UITableViewStylePlain];
        [self.downloadTable setDelegate:self];
        [self.downloadTable setDataSource:self];
        [self addSubview:downloadTable];
        
        downloadHistoryMenuHandler = historyMenuHandler;
        downloadTable.backgroundColor = [self colorWithHexString : @"EDECEC"];//EDECEC[UIColor grayColor];
        self.reportVc = historyMenuHandler;
       
        
    }
    return self;
}

-(IBAction)downloadHistoryClicked:(id)sender
{
    MXButton* menuButton = (MXButton*) sender;
    [downloadHistoryMenuHandler downloadHistoryClicked:[menuButton.elementId   intValue]];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return downloadHistoryList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell:%d", indexPath.row];
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    if (cell!=nil)
    {
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.tag = indexPath.row;
        
        UIView *containerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 160, 50)];
        containerView.backgroundColor = [UIColor clearColor];
        UILabel *textLable = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 160, 30)];
        textLable.backgroundColor = [UIColor clearColor];
        textLable.font =  [UIFont systemFontOfSize:16.0];
        textLable.textAlignment = UITextAlignmentLeft;
        textLable.textColor = [UIColor blackColor];
        textLable.text = [self.downloadHistoryList objectAtIndex:indexPath.row];;
        
        [containerView addSubview:textLable];
        [cell addSubview:containerView];
        
                
        
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
    
}

#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"row is :%d",indexPath.row);
    // [downloadHistoryMenuHandler downloadHistoryClicked:indexPath.row];
   
   
/*
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    UIView* container = [cell viewWithTag:indexPath.row];
    
    
        [self.firstProgress removeFromSuperview];
        [self.percentageLabel removeFromSuperview];

    
    self.firstProgress = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
    self.firstProgress.frame = CGRectMake(10, 35 ,100, 50.0f);
    [self.firstProgress setTag:200];
    [self.firstProgress setProgress:self._percentage];
        self.firstProgress.tintColor = [UIColor redColor];
  //  [firstProgress setCenter:CGPointMake(CGRectGetMidX(self.bounds), firstProgress.center.y)];
    
    self.firstProgress.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    [container addSubview:self.firstProgress];
    
    self.percentageLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 28, 50, 15)];//CGRectMake(0, CGRectGetMaxY(firstProgress.frame), 100.0f, 15)];
    [self.percentageLabel setText:[NSString stringWithFormat:@"%.0f%%", _percentage * 100]];
    [self.percentageLabel setTextColor:[UIColor redColor]];
    [self.percentageLabel setTag:300];
    self.percentageLabel.font = [UIFont systemFontOfSize:12];
    
   // [percentageLabel sizeToFit];
   // [percentageLabel setCenter:CGPointMake(CGRectGetMidX(self.bounds), percentageLabel.center.y)];
    
    [container addSubview:self.percentageLabel];
       
    
    [self performSelector:@selector(changePercentage:) withObject:@(0.0f) afterDelay:1.0f];
*/
    
}
- (void)changePercentage:(NSNumber *)percentage
{
    CGFloat _percentage = [percentage floatValue];
    
    [self.firstProgress setProgress:_percentage];
    [self.percentageLabel setText:[NSString stringWithFormat:@"%.0f%%", _percentage * 100]];
    
    if (_percentage < 1.0f) {
        [self performSelector:@selector(changePercentage:) withObject:@(_percentage + 0.1f) afterDelay:1.0f];
    } else {
        [self.firstProgress removeFromSuperview];
        [self.percentageLabel removeFromSuperview];
    }
}


-(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}


@end
