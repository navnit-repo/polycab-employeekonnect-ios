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

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.tableSelected = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height-50) style:UITableViewStylePlain];
    self.tableSelected.delegate = self;
    self.tableSelected.dataSource = self;
    [self.view addSubview:self.tableSelected];
    self.tableSelected.backgroundColor = [UIColor whiteColor];
    
    [self configureNavigationBar];
   
    
    
    // Do any additional setup after loading the view from its nib.
}


-(void) configureNavigationBar
{
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.opaque = YES;
    self.navigationController.navigationBar.translucent = NO;
   
    
    
    
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
    [leftBackButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal ];

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
    [rightBackButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal ];
    



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
    
    //NSNULL Class check my code
    NSString *text;
    NSLog(@"%@",dropDownList );
    if ([[dropDownList objectAtIndex:indexPath.row] isKindOfClass:[NSNull class]]) {
        text = @"";
    }
    else{
    text = [dropDownList objectAtIndex:indexPath.row];
    }
    cell.textLabel.text =text;
    ////
    
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
        elementId = [dropDownListKey objectAtIndex:indexPath.row];
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
@end
