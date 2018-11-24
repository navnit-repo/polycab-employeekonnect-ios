//
//  SearchViewController.m
//  QCMSProject
//
//  Created by Ashish Tiwari on 04/09/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//

#import "SearchViewController.h"
#import "XmwUtils.h"
#import "MXLabel.h"
#import "Styles.h"
#import "DVCheckbox.h"
#import "CreateOrderVC2.h"

@interface SearchViewController ()
{
    NSMutableDictionary* selectedRows;
    CGFloat columnOffsets[10];
    
}

@end

@implementation SearchViewController
{
    BOOL isFilterd;
    NSMutableArray * filteredArray;
    NSString *seachBarText;
}

@synthesize searchList;
@synthesize screenId;
@synthesize searchResponse;
@synthesize searchData;
@synthesize elementId;
@synthesize selectedRowElement;
@synthesize parentController;
@synthesize masterValueMapping;
@synthesize multiSelect;
@synthesize multiSelectDelegate;
@synthesize headerTitle;

@synthesize primaryCat,subCat;


int CHECKBOX_TAG_OFFSET = 9000;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        multiSelect = NO;
        
        columnOffsets[0] = 50.0f;
        columnOffsets[1] = 140.0f;
        columnOffsets[2] = 270.0f;
        columnOffsets[3] = 310.0f;
        columnOffsets[4] = 350.0f;
        columnOffsets[5] = 390.0f;
        columnOffsets[6] = 450.0f;
        columnOffsets[7] = 500.0f;
        columnOffsets[8] = 550.0f;
        columnOffsets[9] = 600.0f;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    seachBarText = @"";
    
    
    
    if(isiPhone10) {
        self.view.frame = CGRectMake(0, 64, 375, 748);
    }
    
    else if(isiPhone6Plus) {
        self.view.frame = CGRectMake(0, 64, 414, 672);
    }
    else if(isiPhone6) {
        self.view.frame = CGRectMake(0, 64, 375, 600);
    } else if(isiPhone5) {
        self.view.frame = CGRectMake(0, 64, 320, 504);
    } else {
        // 0, 64, 320, 416
        self.view.frame = CGRectMake(0, 64, 320, 416);
    }
    
    
    [self drawHeaderItem];
    [self showSearchData];
    
    
    self.searchBar.delegate  = self;
    
    
    // Do any additional setup after loading the view from its nib.
}



//-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
//    [searchBar resignFirstResponder];
//
//    if (searchBar.text.length ==0) {
//        isFilterd = false;
//    }
//    else{
//        isFilterd = true;
//        filteredArray  = [[NSMutableArray alloc]init];
//        seachBarText = searchBar.text;
//
//        for (int i=0; i<searchData.count; i++) {
//            NSArray *obj = [[NSArray alloc]initWithArray:[searchData objectAtIndex:i]];
//
//            if ([obj containsObject: seachBarText]) {
//                [filteredArray addObject:obj];
//            }
//
////            for (NSString *str in obj) {
////
////                NSRange nameRange = [str rangeOfString:searchBar.text options:NSCaseInsensitiveSearch];
////                if (nameRange.location != NSNotFound) {
////                    [filteredArray addObject:obj];
////                    break;
////
////                }
////
////            }
//
//        }
//    }
//    [self.searchList reloadData];
//
//}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(nonnull NSString *)searchText{
    if (searchText.length ==0) {
        isFilterd = false;
    }
    else{
        isFilterd = true;
        filteredArray  = [[NSMutableArray alloc]init];


        for (int i=0; i<searchData.count; i++) {
            NSArray *obj = [[NSArray alloc]initWithArray:[searchData objectAtIndex:i]];
            NSString *str;
            for (str in obj) {
                
                if ([str isKindOfClass:[NSNull class]]) {
                    str = @"";
                }
                NSRange nameRange = [str rangeOfString:searchText options:NSCaseInsensitiveSearch];
                if (nameRange.location != NSNotFound) {
                    [filteredArray addObject:obj];
                    break;

                }

            }

        }
    }
    [self.searchList reloadData];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) drawHeaderItem
{
    
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage
                                                                          imageNamed:@"back-button.png"] style:UIBarButtonItemStylePlain target:self
                                                                  action:@selector(backHandler:)];
    
    backButton.tintColor =[UIColor colorWithRed:119.0/255 green:119.0/255 blue:119.0/255 alpha:1.0];
    
    UIImageView *polycabLogo = [[UIImageView alloc] initWithImage:[UIImage  imageNamed:@"polycab_logo"]];
    self.navigationItem.titleView.contentMode = UIViewContentModeCenter;
    self.navigationItem.titleView = polycabLogo;
    [self.navigationItem setLeftBarButtonItem:backButton];
    
    
    if(multiSelect==YES) {
        UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                       style:UIBarButtonItemStyleBordered
                                                                      target:self
                                                                      action:@selector(doneHandler:)];
        backButton.tintColor = [UIColor blackColor];
        [self.navigationItem setRightBarButtonItem:backButton];
    }
    
    
    
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIColor whiteColor],NSForegroundColorAttributeName,
                                    [UIColor whiteColor],NSBackgroundColorAttributeName,nil];
    
    self.navigationController.navigationBar.titleTextAttributes = textAttributes;
    // self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    
//    UILabel*  titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 40)];
//    titleLabel.text = headerTitle;
//    titleLabel.textColor = [UIColor blackColor];
//    titleLabel.textAlignment = NSTextAlignmentCenter;
//    titleLabel.backgroundColor = [UIColor clearColor];
//    [self.navigationItem setTitleView: titleLabel];
//    
//    self.navigationItem.backBarButtonItem.tintColor = [UIColor blackColor];

}


- (void) backHandler : (id) sender {
    if(multiSelectDelegate !=nil && [multiSelectDelegate respondsToSelector:@selector(selectionCancelled)]) {
        [multiSelectDelegate selectionCancelled];
    }
    [ [self navigationController]  popViewControllerAnimated:YES];
}


- (void) doneHandler : (id) sender {
    
  
    if(multiSelectDelegate !=nil&& [multiSelectDelegate respondsToSelector:@selector(multipleItemsSelected::)]
       )
    {        
       [multiSelectDelegate multipleItemsSelected:self.searchResponse.searchHeaderDetail   :selectedRows.allValues];
        
    }
    [ [self navigationController]  popViewControllerAnimated:YES];
   
}


-(void)showSearchData
     {
         NSMutableArray *data = searchResponse.searchRecord;
         [self drawSearchTable : data ];
     }
     
-(void)drawSearchTable :(NSMutableArray *)data
{
     NSMutableArray *records = searchResponse.searchRecord;
    CGRect screenRect = self.view.bounds;
    CGFloat screenWidth = screenRect.size.width;
    
    self.searchData = records;
    
    if([records count]>0) {
        CGFloat screenHeight = [records count]*50;
    
        if(screenHeight > self.view.bounds.size.height) {
            screenHeight = self.view.bounds.size.height;
        }

        if (primaryCat || subCat !=nil) {
            UILabel* browserSectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width , 22)];
            browserSectionLabel.text = primaryCat;
            [browserSectionLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
            browserSectionLabel.textAlignment = UITextAlignmentCenter;
            browserSectionLabel.backgroundColor = [UIColor whiteColor];
            browserSectionLabel.tag = 50;
        
            UILabel* itemValue = [[UILabel alloc] initWithFrame:CGRectMake(0, 23, self.view.frame.size.width , 21)];
            itemValue.text = subCat;
            [itemValue setFont:[UIFont fontWithName:@"Helvetica-Light" size:16]];
            itemValue.textColor = [UIColor colorWithRed:119.0/255 green:119.0/255 blue:119.0/255 alpha:1.0];
            itemValue.textAlignment = UITextAlignmentCenter;
            itemValue.backgroundColor = [UIColor whiteColor];
            itemValue.tag = 51;
            [self.view addSubview:browserSectionLabel];
            [self.view addSubview:itemValue];
            
            
            self.searchBar.frame = CGRectMake(0, 45, self.searchBar.frame.size.width, self.searchBar.frame.size.height);
            
            searchList = [[UITableView alloc]initWithFrame:CGRectMake(0, 105, screenWidth, screenHeight-105) style:UITableViewStylePlain];
        }
        
        else{
            [[self.view viewWithTag:50]removeFromSuperview];
            [[self.view viewWithTag:51]removeFromSuperview];
            
        searchList = [[UITableView alloc]initWithFrame:CGRectMake(0, 60, screenWidth, screenHeight-60) style:UITableViewStylePlain];
        
        }
        [self.searchList setDelegate:self];
        [self.searchList setDataSource:self];
        [self.view addSubview:searchList];
    } else {
        
        UILabel* userMessage = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 320, 30)];
        userMessage.text = @"No records found";
        
        [self.view addSubview:userMessage];
    }
    
}


- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}



- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    if (isFilterd) {
        return filteredArray.count;
    }
    return [searchData count];
}
#pragma mark - Table View Delegates


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *simpleTableIdentifier = [NSString stringWithFormat:@"SimpleTableItem:%d", indexPath.row ];
    
    CGFloat screenWidth = self.view.bounds.size.width;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:simpleTableIdentifier];
          cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSMutableArray* row;
        if (isFilterd) {
            row= [filteredArray objectAtIndex:indexPath.row];
        }
        else{
            row = [searchData objectAtIndex:indexPath.row];
        }
        NSInteger width = 0;
        
        if(multiSelect==YES) {
            DVCheckbox* checkBox = [[DVCheckbox alloc] initWithFrame:CGRectMake(5, 5, 40, 40) check:NO enable:YES];
            checkBox.checkboxDelegate = self;
            [cell addSubview:checkBox];
            width = (screenWidth-50)/[row count];
            
            checkBox.tag = CHECKBOX_TAG_OFFSET + indexPath.row;
        } else {
            width = screenWidth/[row count];
            
        }
        
//        for(int cntComponent = 0; cntComponent <[row count]; cntComponent++)
//        {
//            NSString *componentType = (NSString *)[row objectAtIndex:cntComponent];
//
//            CGFloat lowerOffset = columnOffsets[cntComponent];
//            CGFloat upperOffset = columnOffsets[cntComponent+1];
//            UIView* firstCol = [[UIView alloc] initWithFrame:CGRectMake(lowerOffset, 0, upperOffset - lowerOffset, 50)];
//            UILabel *label1   = [[UILabel alloc] initWithFrame:CGRectMake(2, 0, upperOffset - lowerOffset - 4, 50)];
//
//            label1.text                              = [row objectAtIndex:cntComponent];
//            label1.textColor                         = [UIColor blackColor];
//            label1.numberOfLines = 0;
//            label1.font = [UIFont systemFontOfSize:12];
//
//            [firstCol addSubview:label1];
//            [cell  addSubview: firstCol];
//        }
        
//        LVBS09CXSWY2004C2.5SA001S,
//        FG-CoCSN-InX02-RdYwBeBk-BdY03-ArG02-OsY03-4C2.5,
//        1001,
//        MTR,
//        BLACK,
//        4C,
//        2.5 SQ MM,
//        1100V,
//        METER,
//        101
        
        
        //change for polycab seearch list view comment previous code
        NSString *appendString= @"";
        for(int cntComponent = 0; cntComponent <[row count]; cntComponent++)
        {
            NSString *componentType =(NSString *)[row objectAtIndex:cntComponent];
            if ([componentType isKindOfClass:[NSNull class]]) {
                componentType = @"";
            }
            else{
            componentType = (NSString *)[row objectAtIndex:cntComponent];
            }
            appendString = [appendString stringByAppendingString: componentType];;
            appendString= [appendString stringByAppendingString:@" "];
        
        }
        NSLog(@"%@",appendString);
       
        
                    UIView* firstCol = [[UIView alloc] initWithFrame:CGRectMake(50, 0, 250, 60)];
                    UILabel *label1   = [[UILabel alloc] initWithFrame:CGRectMake(2, 0, 250, 60)];
        
        
        
        
                    label1.text                              = appendString;
                    label1.textColor                         = [UIColor blackColor];
                    label1.numberOfLines = 0;
                    label1.font = [UIFont systemFontOfSize:12];
        label1.backgroundColor = [UIColor clearColor];
        label1.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        label1.lineBreakMode = NSLineBreakByWordWrapping;
        label1.adjustsFontSizeToFitWidth = YES;
        label1.textAlignment = UITextAlignmentLeft;
        label1.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
                    [firstCol addSubview:label1];                
                    [cell  addSubview: firstCol];
        
        
        
 //   }
    
    tableView.separatorColor =  [UIColor colorWithRed:0.41 green:0.41 blue:0.59 alpha:1.0];
    return cell;
    
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
    
}

-(void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
        
    [self handleDrillDown: indexPath.row];
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}


-(void)handleDrillDown : (NSInteger)position
{
    if (isFilterd) {
        selectedRowElement= (NSMutableArray *)[filteredArray objectAtIndex:position];
    }
    else{
      selectedRowElement = (NSMutableArray *)[searchResponse.searchRecord objectAtIndex:position];
    }
    
    
    //selectedRowElement = (NSMutableArray *)[searchResponse.searchRecord objectAtIndex:position];
    
    NSString *key; 
	NSString *name; 
    key = [selectedRowElement objectAtIndex:0];
    name =[selectedRowElement objectAtIndex:1];
    
    if(multiSelect==NO) {
        [parentController searchItemSelected : position : selectedRowElement: elementId : masterValueMapping];
        [[self navigationController] popViewControllerAnimated:YES];
    }
    
    
}


#pragma mark - DVCheckboxDelegate

-(void) hasChecked:(DVCheckbox*) sender
{
    if(selectedRows==nil) {
        selectedRows = [[NSMutableDictionary alloc] init];
    }
    
    int rowIdx = sender.tag - CHECKBOX_TAG_OFFSET;
    
    if(rowIdx>=0) {
        @try {
            if (isFilterd) {
                [selectedRows setObject:[filteredArray objectAtIndex:rowIdx] forKey:[NSString stringWithFormat:@"%d", rowIdx]];
            }
            else{
                [selectedRows setObject:[searchData objectAtIndex:rowIdx] forKey:[NSString stringWithFormat:@"%d", rowIdx]];
            }
            
            
           // [selectedRows setObject:[searchData objectAtIndex:rowIdx] forKey:[NSString stringWithFormat:@"%d", rowIdx]];
        }
        @catch (NSException *exception) {
            NSLog(@"Exception in hasChecked: %@", exception.description);
        }
        @finally {
            // not do anything here
        }

    }
    
}


-(void) hasUnchecked:(DVCheckbox*) sender
{
    int rowIdx = sender.tag - CHECKBOX_TAG_OFFSET;
    if(rowIdx>=0 && selectedRows!=nil) {
        @try {
            
            if (isFilterd) {
                [selectedRows setObject:[filteredArray objectAtIndex:rowIdx] forKey:[NSString stringWithFormat:@"%d", rowIdx]];
            }
            else{
                [selectedRows setObject:[searchData objectAtIndex:rowIdx] forKey:[NSString stringWithFormat:@"%d", rowIdx]];
            }
            
          //  [selectedRows removeObjectForKey:[NSString stringWithFormat:@"%d", rowIdx]];
        }
        @catch (NSException *exception) {
            NSLog(@"Exception in hasUnchecked: %@", exception.description);
        }
        @finally {
            // not do anything here
        }
    }
}




@end
