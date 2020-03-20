//
//  SearchProductListVC.m
//  XMWClient
//
//  Created by dotvikios on 12/10/18.
//  Copyright © 2018 dotvik. All rights reserved.
//

#import "SearchProductListVC.h"

@interface SearchProductListVC ()

@end

@implementation SearchProductListVC
{
    UISearchBar *searchBar;
    BOOL isFilterd;
    NSMutableArray * filteredArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self searchView];
    isFilterd = false;
    
    self.tableSelected.frame =CGRectMake(0, 40, [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height-110);
    
    
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(nonnull NSString *)searchText{
    if (searchText.length ==0) {
        isFilterd = false;
    }
    else{
        isFilterd = true;
        filteredArray  = [[NSMutableArray alloc]init];
        for (NSString *str in dropDownList) {
            
            NSRange nameRange = [str rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if (nameRange.location != NSNotFound) {
                [filteredArray addObject:str];
            }
        }
   }
    [self.tableSelected reloadData];

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isFilterd) {
        return filteredArray.count;
    }
    return [dropDownList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
 
    
    if([self.checkedIndexPath isEqual:indexPath])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    //return [dropDownList objectAtIndex:row];
    if (isFilterd) {
         cell.textLabel.text = [filteredArray objectAtIndex:indexPath.row];
    }
    else
    {
    cell.textLabel.text = [dropDownList objectAtIndex:indexPath.row];
    }
    return cell;
}


-(void)searchView{
    UIView *searchView = [[UIView alloc]init];
    
    searchView.frame = CGRectMake(0, 0, self.view.frame.size.width, 40);
    searchView.backgroundColor = [UIColor whiteColor];
    
    searchBar = [[UISearchBar alloc]init];
    searchBar.frame =CGRectMake(0, 0, searchView.frame.size.width, 40);
    searchBar.backgroundColor =[UIColor whiteColor];
    searchBar.delegate = self;
    searchBar.layer.backgroundColor = (__bridge CGColorRef _Nullable)([UIColor whiteColor]);
    [searchView addSubview:searchBar];
    
    [self.view addSubview:searchView];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    // Do the search...
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(self.checkedIndexPath)
        
    {
        UITableViewCell* uncheckCell = [tableView
                                        cellForRowAtIndexPath:self.checkedIndexPath];
        uncheckCell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    if([[dropDownList objectAtIndex:indexPath.row] isEqualToString:@"<Search>"])
    {
        self.checkedIndexPath = nil;
    } else {
        UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        if (isFilterd) {
            selectedPickerValue = [filteredArray objectAtIndex:indexPath.row];
            selectedPickerKey = [filteredArray objectAtIndex:indexPath.row];
            elementId = [filteredArray objectAtIndex:indexPath.row];
            self.checkedIndexPath = indexPath;
        }
        else{
        selectedPickerValue = [dropDownList objectAtIndex:indexPath.row];
        selectedPickerKey = [dropDownListKey objectAtIndex:indexPath.row];
        elementId = [dropDownListKey objectAtIndex:indexPath.row];
        self.checkedIndexPath = indexPath;
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
@end
