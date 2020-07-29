//
//  SelectedListVC.m
//  XMWClient
//
//  Created by dotvikios on 27/12/17.
//  Copyright © 2017 dotvik. All rights reserved.
//

#import "SelectedListVC.h"
#import "MXBarButton.h"
#import "Styles.h"
#import "DVAppDelegate.h"
#import "MXButton.h"


@interface SelectedListVC ()

@end

@implementation SelectedListVC
@synthesize attachedData;
@synthesize elementId;
@synthesize dropDownList;
@synthesize dropDownListKey;
@synthesize selectedPickerValue;
@synthesize selectedPickerKey;
@synthesize dropDownName;
@synthesize searchBar;
@synthesize orignalDataArray,orignalDataKeyArray;
@synthesize searchTextArray,searchTextKeyArray;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.tableSelected = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height-50) style:UITableViewStylePlain];
    self.tableSelected.delegate = self;
    self.tableSelected.dataSource = self;
    [self.view addSubview:self.tableSelected];
    self.tableSelected.backgroundColor = [UIColor whiteColor];
    
    [self configureNavigationBar];
    [self configureSearchBarAndUpdatedTableHeight];
    
    
    // Do any additional setup after loading the view from its nib.
}
-(void)configureSearchBarAndUpdatedTableHeight
{
    orignalDataKeyArray = [[NSMutableArray alloc ] init];
    orignalDataArray = [[NSMutableArray alloc ] init];
    [orignalDataArray addObjectsFromArray:dropDownList];
    [orignalDataKeyArray addObjectsFromArray:dropDownListKey];
    searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(20, 8, [[UIScreen mainScreen]bounds].size.width - 40, 44*deviceHeightRation)];
    searchBar.delegate = self;
    [searchBar setPlaceholder:@"Search"];
    [searchBar setReturnKeyType:UIReturnKeyDone];
    searchBar.enablesReturnKeyAutomatically = NO;
    [self.view addSubview:searchBar];
    
   /* old code for customize uiserachBar
    for (id subview in [[searchBar.subviews lastObject] subviews]) {
    if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
        [subview removeFromSuperview];
    }
    
    if ([subview isKindOfClass:[UITextField class]])
    {
        UITextField *textFieldObject = (UITextField *)subview;
        textFieldObject.borderStyle = UITextBorderStyleRoundedRect;
        textFieldObject.layer.masksToBounds=YES;
        textFieldObject.layer.borderColor=[[UIColor lightGrayColor]CGColor];
        textFieldObject.layer.cornerRadius=5.0f;
        textFieldObject.layer.borderWidth= 1.0f;
        break;
    }
    */
    if (@available(iOS 13.0, *)) {
                  [searchBar setBackgroundColor:[UIColor clearColor]];
                  [searchBar setBackgroundImage:[UIImage new]];
                  [searchBar setTranslucent:YES];
                  searchBar.searchTextField.borderStyle = UITextBorderStyleRoundedRect;
                  searchBar.searchTextField.layer.masksToBounds=YES;
                  searchBar.searchTextField.layer.borderColor=[[UIColor lightGrayColor]CGColor];
                  searchBar.searchTextField.layer.cornerRadius=5.0f;
                  searchBar.searchTextField.layer.borderWidth= 1.0f;
    }
    else
    {
        for (id subview in [[searchBar.subviews lastObject] subviews]) {
        if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            [subview removeFromSuperview];
        }
        
        if ([subview isKindOfClass:[UITextField class]])
        {
            UITextField *textFieldObject = (UITextField *)subview;
            textFieldObject.borderStyle = UITextBorderStyleRoundedRect;
            textFieldObject.layer.masksToBounds=YES;
            textFieldObject.layer.borderColor=[[UIColor lightGrayColor]CGColor];
            textFieldObject.layer.cornerRadius=5.0f;
            textFieldObject.layer.borderWidth= 1.0f;
            break;
        }
            
        }
    }
 
          
    

    self.tableSelected.frame = CGRectMake(self.tableSelected.frame.origin.x, searchBar.frame.size.height+searchBar.frame.origin.y, self.tableSelected.bounds.size.width, self.tableSelected.bounds.size.height-(searchBar.frame.size.height+searchBar.frame.origin.y));
}

-(void) configureNavigationBar
{
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.opaque = YES;
    self.navigationController.navigationBar.translucent = NO;
   

    //Do any additional setup after loading the view, typically from a nib.
    UILabel *titleLabelView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)]; //<<---- Actually will be auto-resized according to frame of navigation bar;
    [titleLabelView setBackgroundColor:[UIColor clearColor]];
    [titleLabelView setTextAlignment: NSTextAlignmentCenter];
    [titleLabelView setTextColor:[UIColor whiteColor]];
    [titleLabelView setFont:[UIFont systemFontOfSize:16 weight:UIFontWeightBold]]; //<<--- Greatest font size
    [titleLabelView setAdjustsFontSizeToFitWidth:YES]; //<<---- Allow shrink
    // [titleLabelView setAdjustsLetterSpacingToFitWidth:YES];  //<<-- Another option for iOS 6+
    titleLabelView.text = dropDownName;
    
    self.navigationItem.titleView = titleLabelView;
    
    
    // Need to add Our left back button
    
    
//    UIImage *iconImage = [[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//    UIImageView* backImageView = [[UIImageView alloc] initWithImage:iconImage];
    
//    MXButton *BtnSpace = [[MXButton alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
//    MXButton *leftButton = [[MXButton alloc] initWithTitle:@"Cancel"
//                                                           style:UIBarButtonItemStyleBordered  target:self
//                                                          action:@selector(cancelBarButtonPressed:)];
    
    UIButton* leftBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftBackButton setFrame:CGRectMake( 0.0f, 0.0f, 60.0f, 30.0f)];
      [leftBackButton setTitle:@"Cancel" forState:UIControlStateNormal];
    leftBackButton.backgroundColor = [UIColor clearColor];
    [leftBackButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal ];

    [leftBackButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBackButton];
    leftButtonItem.target           = self;

    self.navigationItem.leftBarButtonItem  = leftButtonItem;
    
    
    // For right side menu button
//    MXButton *doneButton = [[MXButton alloc] initWithTitle:@"Done"
//                                                           style:UIBarButtonItemStyleBordered  target:self
//                                                          action:@selector(donePicker:)];
//    doneButton.elementId = [button elementId];
//    doneButton.attachedData = [button attachedData];
    
    UIButton *rightBackButton  = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBackButton setFrame:CGRectMake( 0.0f, 0.0f, 60.0f, 30.0f)];
      [rightBackButton setTitle:@"Done" forState:UIControlStateNormal];
    rightBackButton.backgroundColor = [UIColor clearColor];
    [rightBackButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal ];
    



    [rightBackButton addTarget:self action:@selector(btnDone:) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBackButton];
    rightButtonItem.target           = self;


    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:rightButtonItem, nil] animated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(IBAction)backButtonAction:(id) sender
{
    [self.delegate cancel:self context:@""];

    [self.navigationController popViewControllerAnimated:YES];
    
}
//-(void) done:(SelectedListVC*) selectedListVC context:(NSString*) context code:(NSString*) code display:(NSString*) display;

-(IBAction)btnDone:(id)sender {
    
    if(self.checkedIndexPath!=nil) {
      //  NSDictionary* objDict = [dropDownList objectAtIndex:self.checkedIndexPath.row];
        
//        [self.delegate done:self context:nil code:[[objDict objectForKey:selectedPickerKey]description]display:[objDict objectForKey:selectedPickerValue]];
        [self.delegate done:self context:elementId code:selectedPickerKey display:selectedPickerValue];
    }
    else
    {
        [self.delegate cancel:self context:@""];
        
       // [self.navigationController popViewControllerAnimated:YES];
    }
   [self.navigationController popViewControllerAnimated:YES];
  
    
}

// TABLEVIEW //
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return [dropDownList count];
}

#pragma mark UITableViewDelegate


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* text = @"";
    
    if ([[dropDownList objectAtIndex:indexPath.row] isKindOfClass:[NSNull class]]) {
        text = @"";
    } else{
        text = [dropDownList objectAtIndex:indexPath.row];
    }
    
    // tableView.frame.size.width - 20;
    CGSize labelFrameSize = CGSizeMake(tableView.frame.size.width - 20, tableView.frame.size.height);
    
    CGSize expectedSize = [text boundingRectWithSize:labelFrameSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName: [UIFont systemFontOfSize:17] } context:nil].size;
    
    if(expectedSize.height < 25.0f) {
        return 44.0f;
    }  else {
        return expectedSize.height + 25.0f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *simpleTableIdentifier = @"SimpleTableItem";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
//    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
//    }
    if([self.checkedIndexPath isEqual:indexPath])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
        //return [dropDownList objectAtIndex:row];
    
    //NSNULL Class check my code
    NSString *text;
  //  NSLog(@"%@",dropDownList );
    if ([[dropDownList objectAtIndex:indexPath.row] isKindOfClass:[NSNull class]]) {
        text = @"";
    }
    else{
        text = [dropDownList objectAtIndex:indexPath.row];
    }
    
    cell.textLabel.attributedText = [self getAttributedString:text];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;

    return cell;
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
        selectedPickerValue = [dropDownList objectAtIndex:indexPath.row];
        selectedPickerKey = [dropDownListKey objectAtIndex:indexPath.row];
        
        // Pradeep: 2020-07-29, elementId is the context id from which this control popped.
        // elementId = [dropDownListKey objectAtIndex:indexPath.row];
        self.checkedIndexPath = indexPath;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
    if(self.checkedIndexPath!=nil) {
        //  NSDictionary* objDict = [dropDownList objectAtIndex:self.checkedIndexPath.row];
        
        //        [self.delegate done:self context:nil code:[[objDict objectForKey:selectedPickerKey]description]display:[objDict objectForKey:selectedPickerValue]];
         [self.delegate done:self context:elementId code:selectedPickerKey display:selectedPickerValue];
         [self.navigationController popViewControllerAnimated:YES];
    }

    
    
}


#pragma mark - searchBar handler
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSLog(@"%@",searchText);
    searchTextArray = [[NSMutableArray alloc]init];
    searchTextKeyArray = [[NSMutableArray alloc ] init];
    if (searchText.length>0) {

        for (int i=0; i<orignalDataArray.count; i++) {
            NSString *name  = [orignalDataArray objectAtIndex:i];
            
            NSRange nameRange = [name rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if (nameRange.location != NSNotFound) {
                [searchTextArray addObject: [orignalDataArray objectAtIndex:i]];
                [searchTextKeyArray addObject:[orignalDataKeyArray objectAtIndex:i]];
            }
            
        }
        dropDownListKey = [[NSMutableArray alloc ] init];
        dropDownList =[[NSMutableArray alloc]init];
        [dropDownList addObjectsFromArray:searchTextArray];
        [dropDownListKey addObjectsFromArray:searchTextKeyArray];
        
        [self.tableSelected reloadData];
    }
    else
    {   dropDownList  = [[NSMutableArray alloc]init];
        dropDownListKey = [[NSMutableArray alloc ] init];
        [dropDownList addObjectsFromArray:orignalDataArray];
        [dropDownListKey addObjectsFromArray:orignalDataKeyArray];
        [self.tableSelected reloadData];
    }
    
}


-(NSMutableAttributedString*) getAttributedString :(NSString*) cellText
{
    UIColor *searchTextColor = [UIColor colorWithRed:220.0/255.0 green:86.0/255.0 blue:35.0/255.0 alpha:1.0];
    
    NSMutableAttributedString *mutableString = nil;
    NSString *sampleText = @"";
    if (cellText !=nil) {
        sampleText = cellText;
    }
    
    mutableString = [[NSMutableAttributedString alloc] initWithString:sampleText];
    NSString *pattern = @"";
    if (searchBar.text != nil) {
        pattern = searchBar.text;
    }
    //        NSString *pattern = self.reportVC.searchBar.text;
    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:pattern options:1 error:nil];
    
    NSRange range = NSMakeRange(0,[sampleText length]);
    [expression enumerateMatchesInString:sampleText options:1 range:range usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        NSRange californiaRange = [result rangeAtIndex:0] ;
        [mutableString addAttribute:NSForegroundColorAttributeName value:searchTextColor range:californiaRange];
    }];
    
    return mutableString;
    
}
@end
