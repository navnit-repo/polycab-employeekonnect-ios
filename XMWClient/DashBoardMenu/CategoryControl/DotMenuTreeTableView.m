#import "DotMenuTreeTableView.h"
#import "DotMenuObject.h"
#import "DotMenuTreeCell.h"
#import "DVAppDelegate.h"
#import "MarqueeLabel.h"
#import "ClientVariable.h"
#import "LogInVC.h"
static NSString *const kCellCatIdentifier = @"kCellCatIdentifier";
static NSString *const kCellSubCatIdentifier = @"kCellSubCatIdentifier";
static NSString *const kCellsuperSubCatIdentifier = @"kCellCatIdentifier";

@interface DotMenuTreeTableView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *myTableDataArray;
@property (nonatomic, strong) NSArray *myInputData;

@property (nonatomic, strong) NSMutableArray *categoryPathStringArr;

@property (nonatomic) DotMenuObject *lastSelectedObject;


@end

@implementation DotMenuTreeTableView
{
    UIViewController *root;
    UIImageView *profileImageView;
}


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupTable];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self setupTable];
    }
    return self;
}

- (id)init {
    self = [super init];
    if (self) {
        [self setupTable];
    }
    return self;
}

- (void)setupTable {
 //   self.backgroundColor = [self colorWithHexString:@"FFFFFF"];//[UIColor colorWithRed:213.0f/255.0f green:213.0f/255.0f blue:211.0f/255.0f alpha:1.0];
    
    self.backgroundColor = [UIColor whiteColor];
    self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self registerClass:[DotMenuTreeCell class] forCellReuseIdentifier:kCellCatIdentifier];
}

// Overrides

- (void)setMyDelegate:(id<DotMenuTreeTblViewDelegate>)myDelegate {
    _myDelegate = myDelegate;
    [super setDelegate:self];
    [super setDataSource:self];
}

- (void)setDelegate:(id<UITableViewDelegate>)delegate {
    [super setDelegate:self];
}

- (void)setDataSource:(id<UITableViewDataSource>)dataSource {
    [super setDataSource:self];
}

- (void)reloadData {
    self.categoryPathStringArr = nil;
    self.categoryPathStringArr = [[NSMutableArray alloc] init];
    self.myInputData = nil; // so it will fetch Data again see myInputData function
    self.myTableDataArray = nil;
    [super reloadData];
}
// Overrides

+ (NSArray *)createModalDataSourceFromJson:(id)jsonArrayObject {
    NSMutableArray *returnArr = [NSMutableArray array];
    
    // add All Category Object
    NSUInteger totalProductsCount = 0;
    
    for (id object in jsonArrayObject) {
        DotMenuObject *newObj = [[DotMenuObject alloc] initWithObject:object];
        newObj.levelDepth = 0;
        
        // if ([newObj.numberOfProducts intValue] == 0)  continue;
        
        totalProductsCount += newObj.numberOfProducts.integerValue; // needed for All Category option
        
        [returnArr addObject:newObj];
    }
    
    /*
    // Create ALL categories Object
    SDCategoryObject *allCatObj = [[SDCategoryObject alloc] init];
    allCatObj.identifier = @0;
    allCatObj.visible = YES;
    allCatObj.name = @"ALL";
    allCatObj.numberOfProducts = @(totalProductsCount);
    
    [returnArr insertObject:allCatObj atIndex:0];
     */
    
    return returnArr;
}

- (NSArray *)myInputData {
    if ((!_myInputData && self.myDelegate) || _myInputData.count == 0) {
        _myInputData = [self.myDelegate getAllMenuCategoriesDataWithSender:self];
    }
    return _myInputData? _myInputData : @[];
}

- (NSArray *)myTableDataArray {
    if (!_myTableDataArray && self.myInputData) {
        _myTableDataArray = [NSMutableArray array];
        [_myTableDataArray addObjectsFromArray:self.myInputData];
    }
    return _myTableDataArray? _myTableDataArray : @[];
}

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.myTableDataArray count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    DotMenuTreeCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellCatIdentifier];
    cell.backgroundColor = [UIColor whiteColor];
   // [cell setBackgroundColor:[UIColor whiteColor]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    DotMenuObject *currObject = self.myTableDataArray[indexPath.row];
   // cell.textLabel.text = [NSString stringWithFormat:@"%@ (%i)",currObject.name,[currObject.numberOfProducts intValue]];
    
    cell.textLabel.textColor = [UIColor colorWithRed:119.0/255 green:119.0/255 blue:119.0/255 alpha:1.0];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",currObject.MENU_NAME];
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:14];
    if ([currObject.childCategories count] > 0) {
        if ([self checkIfChildrenInserted:currObject]) {
            [cell setAccesoryType:DotMenuCellAccesoryStatusOpen];
        } else {
            [cell setAccesoryType:DotMenuCellAccesoryStatusClose];
        }
        
    } else {
        [cell setAccesoryType:DotMenuCellAccesoryStatusNone];
    }
    
    if([currObject.ACCESORY_IMAGE isEqualToString:@"Yes"])
    {
        
       // [cell setAccesoryTypeAsImage:DotMenuCellAccesoryDefaultImage : [currObject.ACCESORY_IMAGE_NUM intValue]];
        [cell setAccesoryTypeAsImageName:DotMenuCellAccesoryDefaultImage : currObject.MENU_NAME];

    }
    else
    {
        [cell setAccesoryType:DotMenuCellAccesoryStatusNone];
        
    }
    
//    UIColor *level0 = [UIColor colorWithRed:(0xdb/255.0) green:(0x31/255.0) blue:(0x31/255.0) alpha:1];
//    UIColor *level1 = [UIColor colorWithRed:(0xdb/255.0) green:(0x31/255.0) blue:(0x31/255.0) alpha:1];
//    UIColor *level2 = [UIColor colorWithRed:(125.0/255.0) green:(125.0/255.0) blue:(125.0/255.0) alpha:1];
//    UIColor *level3 = [UIColor colorWithRed:(150.0/255.0) green:(150.0/255.0) blue:(150.0/255.0) alpha:1];
//    
//
//    switch (currObject.levelDepth) {
//        case 0: {
//            [cell.textLabel setTextColor:level0];
//            NSMutableAttributedString *titltTxt = [[NSMutableAttributedString alloc] initWithString:currObject.MENU_NAME];
//            [titltTxt addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0] range:NSMakeRange(0, currObject.MENU_NAME.length)];
//            [titltTxt addAttribute:NSForegroundColorAttributeName value:level0 range:NSMakeRange(0, currObject.MENU_NAME.length)];
//            //[titltTxt appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" (%i)",[currObject.numberOfProducts intValue]]]];
//            cell.textLabel.attributedText = titltTxt;
//            cell.textLabel.numberOfLines = 0;
//            break;
//        }
//        case 1:
//            [cell.textLabel setTextColor:level1];
//            cell.textLabel.font = [UIFont systemFontOfSize:13.0];
//            cell.textLabel.numberOfLines = 0;
//            break;
//        case 2:
//            [cell.textLabel setTextColor:level2];
//            cell.textLabel.font = [UIFont systemFontOfSize:12.0];
//            cell.textLabel.numberOfLines = 0;
//            break;
//        default:
//            [cell.textLabel setTextColor:level3];
//            cell.textLabel.font = [UIFont systemFontOfSize:11.0];
//            cell.textLabel.numberOfLines = 0;
//            break;
//    }
//    tableView.separatorColor = [UIColor lightGrayColor];
   
     return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
   
 return 80*deviceHeightRation;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ClientVariable* clientVariables = [ClientVariable getInstance : [DVAppDelegate currentModuleContext] ];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 110*deviceHeightRation)];
    view.backgroundColor = [UIColor colorWithRed:204.0/255 green:41.0/255 blue:43.0/255 alpha:1.0];
    
    profileImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 35, 30*deviceWidthRation, 30*deviceHeightRation)];

    [profileImageView setContentMode:UIViewContentModeScaleAspectFill];
    profileImageView.backgroundColor = [UIColor clearColor];
    
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"profileImageData"]!=NULL) {
        [profileImageView setImage:[UIImage imageWithData:[[NSUserDefaults standardUserDefaults]valueForKey:@"profileImageData"]]];
    }
    else{
    [profileImageView setImage:[UIImage imageNamed:@"user_icon.png"]];
    }
    profileImageView.layer.borderWidth=1.0;
    profileImageView.layer.masksToBounds = false;
    profileImageView.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor whiteColor]);
    profileImageView.layer.cornerRadius = profileImageView.frame.size.height/2;
    profileImageView.clipsToBounds = true;
    
    UIButton *pickerButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 35, 40*deviceWidthRation, 40*deviceHeightRation)];
    [pickerButton addTarget:self action:@selector(pickerButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *customerName = [[UILabel alloc]initWithFrame:CGRectMake(profileImageView.frame.origin.x+profileImageView.frame.size.width+5, 30, 220*deviceWidthRation, 25*deviceHeightRation)];
//    customerName.text =[[NSUserDefaults standardUserDefaults] valueForKey:@"CUSTOMER_NAME"];
    customerName.text = [[clientVariables.CLIENT_MASTERDETAIL.masterDataRefresh valueForKey:@"USER_PROFILE"] valueForKey:@"customer_name"];
    customerName.textColor = [UIColor whiteColor];
    customerName.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
    
    customerName.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    customerName.lineBreakMode = UILineBreakModeWordWrap;
    customerName.adjustsFontSizeToFitWidth = NO;
    customerName.numberOfLines = 1;
    customerName.textAlignment = UITextAlignmentLeft;
 
    
    
    
    UILabel *regID = [[UILabel alloc]initWithFrame:CGRectMake(profileImageView.frame.origin.x+profileImageView.frame.size.width+5, 55, 80*deviceWidthRation, 20*deviceHeightRation)];
 //   regID.textColor =  [UIColor colorWithRed:119.0/255 green:119.0/255 blue:119.0/255 alpha:1.0];
     regID.textColor =  [UIColor whiteColor];
    regID.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
    
    NSString* username = [[NSUserDefaults standardUserDefaults] objectForKey:@"USERNAME"];
    
    regID.text = username;
 
    UIView*underLine = [[UIView alloc]initWithFrame:CGRectMake(10, regID.frame.origin.y+regID.frame.size.height+5, tableView.frame.size.width, 0.5)];
    //underLine.backgroundColor = [UIColor colorWithRed:119.0/255 green:119.0/255 blue:119.0/255 alpha:1.0];
     underLine.backgroundColor = [UIColor whiteColor];
    
    [view addSubview:profileImageView];
    [view addSubview:customerName];
    [view addSubview:regID];
    [view addSubview:pickerButton];
    [view addSubview:underLine];
    return view;
}
-(IBAction)pickerButtonHandler:(id)sender{
    
    NSMutableArray *array = [[NSMutableArray alloc] initWithObjects:@"Take a Photo",@"Gallery",nil];
    
    UIAlertView *fileAttachmentAlertView = [[UIAlertView alloc] initWithTitle:@"File Upload"
                                                                      message:nil delegate:self
                                                            cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    
    fileAttachmentAlertView.alertViewStyle = UIAlertViewStyleDefault;
    
    for(NSString *buttonTitle in array)
    {
        [fileAttachmentAlertView addButtonWithTitle:buttonTitle];
    }
    fileAttachmentAlertView.tag = 100; //handle alertview action according to tag
    
    [fileAttachmentAlertView show];
}


- (void)takePhoto {
    
    if (! [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertView *deviceNotFoundAlert = [[UIAlertView alloc] initWithTitle:@"No Device" message:@"Camera is not available"
                                                                     delegate:nil
                                                            cancelButtonTitle:@"Okay"
                                                            otherButtonTitles:nil];
        [deviceNotFoundAlert show];
        
    } else {
        
        UIImagePickerController *cameraPicker = [[UIImagePickerController alloc] init];
        cameraPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        cameraPicker.allowsEditing = YES;
        cameraPicker.delegate =self;
        
      
        root = [[[[UIApplication sharedApplication] windows] objectAtIndex:0] rootViewController];
        
        [root presentViewController:cameraPicker animated:YES completion:nil];
    }
    
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag == 100){ // file attachment alertview
        
        NSString *click = [alertView buttonTitleAtIndex:buttonIndex];
        
        if([click isEqualToString:@"Take a Photo"])
        {
            
            [self takePhoto];
            
        }
        else if([click isEqualToString: @"Gallery"])
        {
            [self selectPhotoFromGallery];
        }
        
    }
    
    else if (alertView.tag == 101){ // file attachment alertview
        
        //       alertView
        
    }
    
}



- (void)selectPhotoFromGallery {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    
    root = [[[[UIApplication sharedApplication] windows] objectAtIndex:0] rootViewController];
    
    [root presentViewController:picker animated:YES completion:nil];
    
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
  
    [root dismissViewControllerAnimated:YES completion:NULL];
    
    UIImage *originalImage=[info objectForKey:UIImagePickerControllerOriginalImage];

    CGFloat newwidth = 960;
    CGFloat newheight = (originalImage.size.height / originalImage.size.width) * newwidth;

    CGRect rect = CGRectMake(0.0,0.0,newwidth,newheight);
    UIGraphicsBeginImageContext(rect.size);
    [originalImage drawInRect:rect];
    originalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();


    NSData *data = UIImageJPEGRepresentation (
                                              originalImage,
                                              0.0
                                              );
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"profileImageData"];
    
    [profileImageView setImage:[UIImage imageWithData:data]];
    
}


-(NSInteger) tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DotMenuObject *currObject = self.myTableDataArray[indexPath.row];
    return currObject.levelDepth*4;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DotMenuObject *currObject = self.myTableDataArray[indexPath.row];
    [self updateCategoryPathWithCategory:currObject];
    
    if([currObject.childCategories count] > 0) {
        BOOL isAlreadyInserted=[self checkIfChildrenInserted:currObject];
        
        if(isAlreadyInserted) {
            currObject.isOpen = NO;
            [self miniMizeThisRows:currObject.childCategories];
        } else {
            currObject.isOpen = YES;
            NSUInteger count=indexPath.row+1;
            NSMutableArray *arCells=[NSMutableArray array];
            for(NSDictionary *dInner in currObject.childCategories ) {
                [arCells addObject:[NSIndexPath indexPathForRow:count inSection:0]];
                [self.myTableDataArray insertObject:dInner atIndex:count++];
            }
            [tableView insertRowsAtIndexPaths:arCells withRowAnimation:UITableViewRowAnimationLeft];
        }
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone]; // reload for arrow status
    } else {
        if (self.myDelegate && [self.myDelegate respondsToSelector:@selector(didSelectMenuCategory:withCategoryPathString:sender:)])
            [self.myDelegate didSelectMenuCategory:currObject withCategoryPathString:[self.categoryPathStringArr componentsJoinedByString:@">>"] sender:self];
    }
    
    if (currObject.levelDepth == 0) {
        // check if new parent category and minimise previously opened
        if (self.lastSelectedObject != currObject) {
            [self removeLastOpenCategory];
        }
        
        self.lastSelectedObject = currObject;
    }
}

- (BOOL)checkIfChildrenInserted: (DotMenuObject *)parentObject {
    BOOL childrenInserted=NO;
    
    for(DotMenuObject *dInner in parentObject.childCategories ){
        NSUInteger index=[self.myTableDataArray indexOfObject:dInner];
        childrenInserted=(index>0 && index!=NSIntegerMax);
        if(childrenInserted) break;
    }
    return childrenInserted;
}

-(void)miniMizeThisRows:(NSArray*)ar{
    
    for(DotMenuObject *dInner in ar ) {
        NSUInteger indexToRemove=[self.myTableDataArray indexOfObject:dInner];
        NSArray *arInner=dInner.childCategories;
        if(arInner && [arInner count]>0){
            [self miniMizeThisRows:arInner];
        }
        
        if([self.myTableDataArray indexOfObject:dInner]!=NSNotFound) {
            [self.myTableDataArray removeObject:dInner];
            [self deleteRowsAtIndexPaths:[NSArray arrayWithObject:
                                                    [NSIndexPath indexPathForRow:indexToRemove inSection:0]
                                                    ]
                                  withRowAnimation:UITableViewRowAnimationRight];
        }
    }
}

- (void)removeLastOpenCategory {
    if (self.lastSelectedObject) {
        [self miniMizeThisRows:self.lastSelectedObject.childCategories];
        NSIndexPath *indexPAthCatMain = [NSIndexPath indexPathForRow:[self.myTableDataArray indexOfObject:self.lastSelectedObject] inSection:0];
        [self reloadRowsAtIndexPaths:@[indexPAthCatMain] withRowAnimation:UITableViewRowAnimationNone]; // reload for arrow status
    }
}

- (void)updateCategoryPathWithCategory:(DotMenuObject *)categoryObject {
    if (categoryObject.levelDepth == self.categoryPathStringArr.count)
    {
        [self.categoryPathStringArr addObject:categoryObject.identifier.stringValue];
    }
    else
    {
        [self.categoryPathStringArr subarrayWithRange:NSMakeRange(0, categoryObject.levelDepth + 1)];
        
        [self.categoryPathStringArr setObject:categoryObject.identifier.stringValue atIndexedSubscript:categoryObject.levelDepth ];
    }
}

- (void)selectMenuCategoryWithPanelXPath:(NSString *)categoryPanelXPath {
    NSArray *arraySequenceCatselected = [categoryPanelXPath componentsSeparatedByString:@">>"];
    
    NSUInteger searchIndexPointer = 0;
    for (NSString *catIdStr in arraySequenceCatselected) {
        for (; searchIndexPointer<[self.myTableDataArray count]; searchIndexPointer++) {
            
            DotMenuObject *object = self.myTableDataArray[searchIndexPointer];
            if ([object.identifier.stringValue isEqualToString:catIdStr]) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:searchIndexPointer inSection:0];
                if (object.childCategories.count > 0)
                    [self tableView:self didSelectRowAtIndexPath:indexPath]; // select tableview row to expand
                else {
                    [self selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
                    return;
                }
                break;
            }
        }
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
