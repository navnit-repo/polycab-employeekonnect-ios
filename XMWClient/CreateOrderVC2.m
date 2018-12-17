//
//  CreateOrderVC2.m
//  XMWClient
//
//  Created by dotvikios on 10/08/18.
//  Copyright © 2018 dotvik. All rights reserved.
//

#import "CreateOrderVC2.h"
#import "SearchViewController.h"
#import "CreateOrderDisplayCell.h"
#import "Styles.h"
#import "NetworkHelper.h"
#import "LoadingView.h"
#import "XmwcsConstant.h"
#import "HttpEventListener.h"
#import "LayoutClass.h"
#import "DVAppDelegate.h"
@interface CreateOrderVC2 ()<SearchViewMultiSelectDelegate>
@end
@implementation CreateOrderVC2{
   
    NSMutableArray *numberOfCell;
    UITableView *mainTableView;
    long int totalCell;
    CreateOrderDisplayCell *displayCell;
    NSMutableArray *alreadyAddDisplayCellData;
    LoadingView *loadingView;
    NetworkHelper *networkHelper;
    NSMutableArray* removeTag;
    BOOL isKeyboardOpen;
    int  movedbyHeight;
    CGSize keyboardSize;
    UITextField* activeTextField;
    BOOL returnPress;
  
}
@synthesize itemName,orderRefNo,dateofDelivery;
@synthesize mainView;
-(void)autoLayout{
    [LayoutClass labelLayout:self.itemName forFontWeight:UIFontWeightBold];
    [LayoutClass labelLayout:self.constant1 forFontWeight:UIFontWeightThin];
     [LayoutClass labelLayout:self.orderRefNo forFontWeight:UIFontWeightBold];
    [LayoutClass labelLayout:self.constant2 forFontWeight:UIFontWeightThin];
    [LayoutClass labelLayout:self.dateofDelivery forFontWeight:UIFontWeightBold];
    [LayoutClass buttonLayout:self.constant3 forFontWeight:UIFontWeightRegular];
    [LayoutClass buttonLayout:self.constant4 forFontWeight:UIFontWeightRegular];
    [LayoutClass labelLayout:self.constant5 forFontWeight:UIFontWeightRegular];
    [LayoutClass setLayoutForIPhone6:self.mainView];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self autoLayout];
     NSLog(@"CreateOrderVC2 call");
    alreadyAddDisplayCellData = [[NSMutableArray alloc]init];
    [self setDataOwnCustomeView];
    [self addCustomeTableView];
 
}
-(void)addCustomeTableView{
    mainTableView = [[UITableView alloc]init];
    mainTableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    mainTableView.backgroundColor = [UIColor whiteColor];
    mainTableView.clipsToBounds = YES;
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    mainTableView.bounces = NO;
    mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:mainTableView];

    
    //check already add lob data
    if ([[NSUserDefaults standardUserDefaults] valueForKey:self.itemName.text]!=nil) {
        NSLog(@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:self.itemName.text]);
        [alreadyAddDisplayCellData addObjectsFromArray:[[NSUserDefaults standardUserDefaults] valueForKey:self.itemName.text]];
    }
    
}
-(void)setDataOwnCustomeView{
    NSLog(@"Forward Data Display :-%@",forwardedDataDisplay);
    NSLog(@"Post Data :-%@",forwardedDataPost);

    self.itemName.text = [NSString stringWithFormat:@"%@", [forwardedDataDisplay valueForKey:@"BUSINESS_VERTICAL"]];
    self.orderRefNo.text = [NSString stringWithFormat:@"%@", [forwardedDataDisplay valueForKey:@"PURCH_NO"]];
    self.dateofDelivery.text =  [NSString stringWithFormat:@"%@", [forwardedDataDisplay valueForKey:@"DELIVERY_DATE"]];
    
    
    
}
- (IBAction)addFormCatalogueButton:(id)sender {
    long int tag = [sender tag];
    NSLog(@"%ld",tag);
    NSLog(@"Button Clicked");
   
    
    NSMutableDictionary* buttonTag =[[NSMutableDictionary alloc]init];
                 // buttonTag = @{@"ButtonTag": @(tag)};
    [buttonTag setObject:[NSString stringWithFormat:@"%ld",tag] forKey:@"ButtonTag"];
    [buttonTag setObject:[forwardedDataDisplay valueForKey:@"BUSINESS_VERTICAL"] forKey:@"BUSINESS_VERTICAL"];
   
    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:@"setButtonHandler" object:self userInfo:buttonTag];
    
    [[NSUserDefaults standardUserDefaults] setObject:[forwardedDataPost valueForKey:@"REGISTRY_ID"] forKey:@"REGISTRY_ID"];
    
   
}
- (IBAction)searchProductsButton:(id)sender {
    long int tag = [sender tag];
    NSLog(@"%ld",tag);
    NSLog(@"Button Clicked");
   
    NSMutableDictionary* buttonTag =[[NSMutableDictionary alloc]init];
    [buttonTag setObject:[NSString stringWithFormat:@"%ld",tag] forKey:@"ButtonTag"];
    [buttonTag setObject:self.itemName.text forKey:@"itemName"];
    [buttonTag setObject:[forwardedDataDisplay valueForKey:@"BUSINESS_VERTICAL"] forKey:@"BUSINESS_VERTICAL"];

    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:@"setButtonHandler" object:self userInfo:buttonTag];
     [[NSUserDefaults standardUserDefaults] setObject:[forwardedDataPost valueForKey:@"REGISTRY_ID"] forKey:@"REGISTRY_ID"];

}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(section==0) {
        // Search View section
        return 1;
        
    }
    else if(section==1) {
        // Display Cell section
        return [alreadyAddDisplayCellData count];
        
    }
    else if (section==2)
    {
        //add place order Button
        return 1;
    }
    return 0;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.section==0) {
        UIView *currentView= [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 132)];
        CGRect viewFrame=currentView.frame;
        viewFrame.origin.x=deviceWidthRation*currentView.frame.origin.x;
        viewFrame.origin.y=deviceHeightRation*currentView.frame.origin.y;
        viewFrame.size.width=deviceWidthRation*currentView.frame.size.width;
        viewFrame.size.height=deviceHeightRation*currentView.frame.size.height;
        currentView.frame=viewFrame;
        return currentView.frame.size.height;
    }
    
    else if(indexPath.section==1) {
        return 100.0f*deviceHeightRation;
    }
    else if (indexPath.section==2)
    {
        return 44.0f;
    }
    return 0.0f;
    
    

}
-(UIButton*) placeOrderButton
{
    UIImage *blueImage          = [UIImage imageNamed:@"blueButton.png"];
    UIImage *blueButtonImage    = [blueImage stretchableImageWithLeftCapWidth:8 topCapHeight:0];

    UIButton *searchButton   = [[UIButton alloc]init];
    
    searchButton       = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    [searchButton setFrame:CGRectMake(self.view.bounds.size.width/2,5, 160, 36)];
    
    [searchButton setBackgroundImage:blueButtonImage forState:UIControlStateNormal];
    
    [searchButton setTitleColor:[Styles buttonTextColor] forState: UIControlStateNormal];
    
    [searchButton setTitle:@"Place an Order" forState:UIControlStateNormal];
    
    [searchButton addTarget:self action:@selector(placeOrderButtonHandler) forControlEvents:UIControlEventTouchUpInside];
    
    return searchButton;
}
- (void) placeOrderButtonHandler
{
    loadingView= [LoadingView loadingViewInView:self.view];
    NSString *authToken= [[NSUserDefaults standardUserDefaults] valueForKey:@"AUTH_TOKEN"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc]init];

    
    NSMutableArray * array = [[NSMutableArray alloc]init];
    removeTag = [[NSMutableArray alloc]init];
    for (int i=0; i<alreadyAddDisplayCellData.count; i++) {
      
        CreateOrderDisplayCell *vc = [(CreateOrderDisplayCell*) self.view viewWithTag:i+100];
        NSString *checkTextFiledEmpty =  [[NSString alloc]init];
        checkTextFiledEmpty = vc.valueTxtFld.text;
        if (checkTextFiledEmpty.length !=0) {
           NSLog(@"Qnty:%@",checkTextFiledEmpty);
            long int tag = vc.tag-100;
            NSLog(@"Cell Tag: %ld",tag);
            [removeTag addObject:[NSString stringWithFormat:@"%ld",tag] ];
            
            NSMutableDictionary *line_items = [[NSMutableDictionary alloc]init];
            [line_items setObject:[[alreadyAddDisplayCellData objectAtIndex:tag] objectAtIndex:2] forKey:@"INVENTORY_ITEM_ID"];
            [line_items setObject:[[alreadyAddDisplayCellData objectAtIndex:tag] objectAtIndex:0] forKey:@"ITEM_CODE"];
            [line_items setObject:[[alreadyAddDisplayCellData objectAtIndex:tag] objectAtIndex:1] forKey:@"ITEM_DESC"];
            [line_items setObject:checkTextFiledEmpty forKey:@"QTY"];
            [array addObject:line_items];
            
        }
     
    }
    [data setObject:array forKey:@"pc_so_line_items"];
    if ([array count] != 0) {
        
        NSMutableDictionary *header = [[NSMutableDictionary alloc]init];
        [header setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"REGISTRY_ID"] forKey:@"USERNAME"];
        [header setObject:[NSString stringWithFormat:@"%@", [forwardedDataPost valueForKey:@"BUSINESS_VERTICAL"]]forKey:@"CUSTOMER_NAME"];
        [header setObject:[NSString stringWithFormat:@"%@", [forwardedDataPost valueForKey:@"BUSINESS_VERTICAL"]] forKey:@"ACCOUNT_NUMBER"];
        [header setObject:[NSString stringWithFormat:@"%@", [forwardedDataPost valueForKey:@"BILL_TO"]] forKey:@"BILL_TO"];
        [header setObject:[NSString stringWithFormat:@"%@", [forwardedDataPost valueForKey:@"SHIP_TO"]] forKey:@"SHIP_TO"];
        [header setObject:@"" forKey:@"REMARK"];
        [header setObject:[NSString stringWithFormat:@"%@", [forwardedDataDisplay valueForKey:@"DELIVERY_DATE"]] forKey:@"DELIVERY_DATE"];
        [header setObject:[NSString stringWithFormat:@"%@", [forwardedDataDisplay valueForKey:@"PURCH_NO"]] forKey:@"PURCHASE_NUMBER"];
        
        
        [data setObject:header forKey:@"pc_so_header"];
        
        NSMutableDictionary *sendDict = [[NSMutableDictionary alloc]init];
        [sendDict setObject:data forKey:@"data"];
        [sendDict setObject:authToken forKey:@"authToken"];
        [sendDict setValue:@"createSalesOrder" forKey:@"opcode"];
        
        
        networkHelper = [[NetworkHelper alloc]init];
        
        NSString *url = XmwcsConst_OPCODE_URL;
        networkHelper.serviceURLString = url;
      [networkHelper genericJSONPayloadRequestWith:sendDict :self :@"createSalesOrder"];
    }

    else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"PolyCab" message:@"Please enter quantity minimum of one product." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [loadingView removeView];
        [alert show];
        
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    //pending

    
}




- (void) httpResponseObjectHandler : (NSString*) callName : (id) respondedObject : (id) requestedObject
{
    [loadingView removeView];
    
    if ([callName isEqualToString:@"createSalesOrder"]) {
        if ([[respondedObject valueForKey:@"status"] isEqualToString:@"SUCCESS"]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Polycab" message:[respondedObject valueForKey:@"message"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
            
            // remove cell
            NSMutableArray *updatedArrayList = [[NSMutableArray alloc]init];
            for (int i=0; i<[alreadyAddDisplayCellData count]; i++) {
                BOOL contains;
                NSString *str = [NSString stringWithFormat:@"%i", i];
                contains = [removeTag containsObject:str];
                if (contains==false) {
                    [updatedArrayList addObject:[alreadyAddDisplayCellData objectAtIndex:i]];
                }
                else {
                 //do nothing
                }
            }
            alreadyAddDisplayCellData = [[NSMutableArray alloc]init];
            [alreadyAddDisplayCellData addObjectsFromArray:updatedArrayList];
            //locally save cell
            [[NSUserDefaults standardUserDefaults] setObject:alreadyAddDisplayCellData forKey:self.itemName.text];
            
            
             [mainTableView reloadData];
            
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Polycab" message:[respondedObject valueForKey:@"message"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
   
    }
}

- (void) httpFailureHandler : (NSString*) callName : (NSString*) message {
    [loadingView removeView];
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Polycab" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
    [myAlertView show];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if(indexPath.section==0) {
//        mainView.frame = CGRectMake(0, 0, self.view.frame.size.width, 132);
        [cell addSubview:mainView];
        cell.clipsToBounds = YES;
        
    
    }
    
    
  else if(indexPath.section==1) {
       cell = [self displayTableViewCell:tableView cellForRowAtIndexPath:indexPath];
       cell.clipsToBounds = YES;
      
     }
  
  else if(indexPath.section==2) {
    if ([alreadyAddDisplayCellData count]!=0){
      cell = [tableView dequeueReusableCellWithIdentifier:@"placeOrderButton"];
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
      if(cell==nil) {
          cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"placeOrderButton"];
          cell.selectionStyle = UITableViewCellSelectionStyleNone;
          [cell.contentView addSubview:[self placeOrderButton]];
      }
  }
  }
    return cell;
}

- (UITableViewCell *)displayTableViewCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell;
           if(cell==nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"displayCell"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [cell setBackgroundColor:[UIColor clearColor]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            
            displayCell = [CreateOrderDisplayCell CreateInstance];
            displayCell.delegate = self;
               long int cancelButtonTag = indexPath.row;
               long int arrayObjectTag = indexPath.row;
            
               [displayCell configure:[alreadyAddDisplayCellData objectAtIndex:arrayObjectTag] :cancelButtonTag];
               long int cellTag = indexPath.row +100;
               displayCell.tag = cellTag;
            displayCell.frame = CGRectMake(0 , 0, self.view.frame.size.width, 97.0f);
            
            [cell addSubview:displayCell];
            displayCell.clipsToBounds = YES;
            
            
    


    }
    else {
        // One table view style will not allow 0 value for some reason
        return cell;
    }
    
    

    

    return cell;
}

- (NSArray *)dictionaryByReplacingNullsWithStrings :(NSMutableArray *)array {
    
    for (int i=0; i<array.count; i++) {
        NSLog(@"%@",[array objectAtIndex:i]);
        
        NSString *value =( NSString*)[array objectAtIndex:i];
                                            if ([value isKindOfClass:[NSNull class]]) {

                                                [array replaceObjectAtIndex:i withObject:@""];
                                            
                                            }
                                            else{
                                                // not change data
                                            }
        
    }

    NSLog(@"After Remove Null :%@",array);
    return array;
    
}

- (void)multipleItemsSelected:(NSArray *)headerData :(NSArray *)selectedRows{
    if ( selectedRows!= nil) {
        numberOfCell = [[NSMutableArray alloc]init];
        for (int i=0; i<selectedRows.count;i++) {
        [numberOfCell addObject:[self dictionaryByReplacingNullsWithStrings:[selectedRows objectAtIndex:i]]];
        }
        [alreadyAddDisplayCellData  addObjectsFromArray:numberOfCell];
    
       [[NSUserDefaults standardUserDefaults] setObject:alreadyAddDisplayCellData forKey:self.itemName.text];
        
        
        
        [mainTableView reloadData];
    }
    
    
}
- (void)buttonDelegate:(long)tag{
    [alreadyAddDisplayCellData removeObjectAtIndex:tag];
    NSLog(@"%@",alreadyAddDisplayCellData);
    [[NSUserDefaults standardUserDefaults] setObject:alreadyAddDisplayCellData forKey:self.itemName.text];
    [mainTableView reloadData];
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    movedbyHeight = 0;
    
    if(isKeyboardOpen){
        //touch on textbox
        self.view.frame  = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + movedbyHeight, self.view.frame.size.width, self.view.frame.size.height);
    }
    
    isKeyboardOpen=true;
    
    
    NSDictionary* info = [aNotification userInfo];
    keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    
    CGRect textFieldRect = [self.view.window convertRect:activeTextField.bounds fromView:activeTextField];
    
    CGRect viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
    
    NSLog(@"FormVC keyboardWasShown");
    NSLog(@"activeTextField.frame.origin.y = %f", activeTextField.frame.origin.y);
    NSLog(@"self.view.frame.size.height = %f", self.view.frame.size.height);
    
    
    
    if(textFieldRect.origin.y > (viewRect.size.height - keyboardSize.height)) {
        movedbyHeight =  textFieldRect.origin.y - (viewRect.size.height  - keyboardSize.height);
        movedbyHeight = movedbyHeight+activeTextField.bounds.size.height-60;
        //movedbyHeight =  textFieldRect.origin.y - keyboardSize.height ;
        
        self.view.frame  = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - movedbyHeight, self.view.frame.size.width, self.view.frame.size.height);
        
        
        
    }
    
    
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    
    
    isKeyboardOpen=false;
    NSLog(@"FormVC keyboardWillBeHidden");
    
    
    
    self.view.frame  = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y +movedbyHeight, self.view.frame.size.width, self.view.frame.size.height);
    
    
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    returnPress =YES;
    return true;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    activeTextField = textField;
    returnPress = NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason
{
    if (returnPress==YES) {
        activeTextField = textField;
    }
    else if(returnPress == NO){
        activeTextField = textField;
        [self keyboardWillBeHidden:self];
    }
}


@end
