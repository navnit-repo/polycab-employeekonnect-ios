//
//  SearchProductByCatalogVC.m
//  XMWClient
//
//  Created by dotvikios on 17/08/18.
//  Copyright © 2018 dotvik. All rights reserved.
//

#import "SearchProductByCatalogVC.h"
@interface SearchProductByCatalogVC ()

@end

@implementation SearchProductByCatalogVC
{
    NSString *searchButtonClickTag;
    NSArray* radioGroupData;
    
}
@synthesize itmeName;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parentForm:(FormVC *)parent formElement:(NSString *)formElementId elementData:(NSString *)masterValueMapping radioGroupData:(NSMutableArray *)keyValueDoubleArray :(NSString *)buttonSender{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if(self!=nil) {
        self.parentController = parent;
        self.elementId = formElementId;
        self.inMasterValueMapping = masterValueMapping;
        radioGroupData = keyValueDoubleArray;
        searchButtonClickTag = buttonSender;
        NSLog(@"Button Tag %@ ",searchButtonClickTag);
    }
    
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage
                                                                          imageNamed:@"back-button.png"] style:UIBarButtonItemStylePlain target:self
                                                                  action:@selector(backHandler:)];
    
    backButton.tintColor = [UIColor colorWithRed:119.0/255 green:119.0/255 blue:119.0/255 alpha:1.0];
    
    UIImageView *polycabLogo = [[UIImageView alloc] initWithImage:[UIImage  imageNamed:@"polycab_logo"]];
    self.navigationItem.titleView.contentMode = UIViewContentModeCenter;
    self.navigationItem.titleView = polycabLogo;
    [self.navigationItem setLeftBarButtonItem:backButton];
    
    
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.bounces = NO;
    
    

}
- (void) backHandler : (id) sender {
    if(multiSelectDelegate !=nil && [multiSelectDelegate respondsToSelector:@selector(selectionCancelled)]) {
        [multiSelectDelegate selectionCancelled];
    }
    [ [self navigationController]  popViewControllerAnimated:YES];
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if(indexPath.section==1) {
        // this section is for browsing product catalog
        cell = [self catTreeTableView:tableView cellForRowAtIndexPath:indexPath];
    }
    
    return cell;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section==1) {
        UIView* holderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
        
        UILabel* browserSectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width , 22)];
        browserSectionLabel.text = @"ADD FROM CATALOGUE";
        [browserSectionLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
        browserSectionLabel.textAlignment = UITextAlignmentCenter;
        browserSectionLabel.backgroundColor = [UIColor whiteColor];
        
         NSLog(@"%@",itmeName);
        
        UILabel* itemValue = [[UILabel alloc] initWithFrame:CGRectMake(0, 23, self.view.frame.size.width , 21)];
        itemValue.text = [[@"FOR"stringByAppendingString:@" "]stringByAppendingString:itmeName];
        [itemValue setFont:[UIFont fontWithName:@"Helvetica-Light" size:16]];
        itemValue.textColor = [UIColor colorWithRed:119.0/255 green:119.0/255 blue:119.0/255 alpha:1.0];
        itemValue.textAlignment = UITextAlignmentCenter;
        itemValue.backgroundColor = [UIColor whiteColor];
        
        
        [holderView addSubview:browserSectionLabel];
        [holderView addSubview:itemValue];
        
        return holderView;
    }
    return nil;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==0) {
    // search section
    return 0;
    
}
    else if(section==1) {
    // catalog tree section
    return [self.myCatTableDataArray count];
    
}
    return 0;
    
}
-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section==0) {
        // return 44.0f;
        return 0.0f;
    } else if(section==1) {
        return 44.0f;
    }
    return 0.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0) {
        return 0.0f;
        }
        
     else if(indexPath.section==1) {
        return 40.0f;
    }
    return 0.0f;
}



@end
