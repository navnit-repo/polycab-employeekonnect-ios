//
//  SuggestiveSearchFieldControl.m
//  XMWClient
//
//  Created by dotvikios on 30/07/19.
//  Copyright © 2019 dotvik. All rights reserved.
//

#import "SuggestiveSearchFieldControl.h"
#import "DVAppDelegate.h"
#import "DotFormPost.h"
#import "KeychainItemWrapper.h"
#import "XmwcsConstant.h"
#import "LoadingView.h"
#import "SearchResponse.h"
#import "DotSearchComponent.h"

@implementation SuggestiveSearchFieldControl
{
    LoadingView*  loadingView;
    NSMutableArray *displayCustomerNameArray;
    NSMutableArray *combineKeyValueArray;
    NSString *previousSearchText;
}
@synthesize mainTableView;
@synthesize searchResponseArray;
@synthesize mandatoryLabel , titleLabel, searchField;
- (instancetype)initWithFrame:(CGRect)frame :(int) yArguForDrawComp :(DotFormElement*) dotFormElement
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.formElement = dotFormElement;
        
        previousSearchText = @"";
        searchResponseArray = [[NSMutableArray alloc] init];
        displayCustomerNameArray = [[NSMutableArray alloc] init];
        combineKeyValueArray = [[NSMutableArray alloc] init];
        self.mandatoryLabel = [[MXLabel alloc] initWithFrame:CGRectMake(16, 11, 8, 16)];
        self.mandatoryLabel.textColor = [UIColor colorWithRed:0.968f green:0.0f blue:0.0f alpha:1.0];
        self.mandatoryLabel.backgroundColor = [UIColor clearColor];
        self.mandatoryLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.mandatoryLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
        self.mandatoryLabel.textAlignment = UITextAlignmentLeft;
        self.mandatoryLabel.text = @"*";
        
        
        self.titleLabel = [[MXLabel alloc] initWithFrame:CGRectMake(24, 11, 137, 20)];
        self.titleLabel.textColor = [UIColor colorWithRed:119.0/255 green:119.0/255 blue:119.0/255 alpha:1.0];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.adjustsFontSizeToFitWidth = YES;
        self.titleLabel.minimumFontSize = 10.0;
        self.titleLabel.textAlignment = UITextAlignmentLeft;
        self.titleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        self.titleLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:16.0];
        
        MXButton *button = [[MXButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        [button setImage:[UIImage imageNamed:@"crossicon"] forState:UIControlStateNormal];
        [button addTarget:searchField action:@selector(clearText:) forControlEvents:UIControlEventTouchUpInside];
        button.imageView.contentMode = UIViewContentModeCenter;
        
        
        self.searchField = [[MXTextField alloc] initWithFrame:CGRectMake(16, 35, self.bounds.size.width-32, 40)];
        
        mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(16,yArguForDrawComp+76, self.bounds.size.width-32, 150)];
        mainTableView.delegate = self;
        mainTableView.dataSource = self;
        mainTableView.backgroundColor = [UIColor whiteColor];
        mainTableView.tag = 10000000;
        mainTableView.layer.borderWidth = 1.0;
        mainTableView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
        self.searchField.borderStyle = UITextBorderStyleRoundedRect;
        self.searchField.returnKeyType = UIReturnKeyDone;
        self.searchField.minimumFontSize = 10.0;
        self.searchField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.searchField.autocapitalizationType = UITextAutocapitalizationTypeWords;
        self.searchField.font = [UIFont fontWithName:@"Helvetica-Light" size:16.0];
        self.searchField.adjustsFontSizeToFitWidth = TRUE;
        self.searchField.adjustsFontSizeToFitWidth = YES;
        self.searchField.textColor =[UIColor colorWithRed:119.0/255 green:119.0/255 blue:119.0/255 alpha:1.0];
        
        
        //set textfield border
        self.searchField.layer.masksToBounds=YES;
        self.searchField.layer.borderColor=[[UIColor lightGrayColor]CGColor];
        self.searchField.layer.cornerRadius=5.0f;
        self.searchField.layer.borderWidth= 1.0f;
        [self.searchField setRightView:button];
        [self.searchField setRightViewMode:UITextFieldViewModeAlways];
        [self.searchField setPlaceholder:@"Search"];
        self.searchField.delegate = self;
        
        [self.searchField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:mandatoryLabel];
        [self addSubview:titleLabel];
        [self addSubview:searchField];
//         [self addSubview:mainTableView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}
-(IBAction)clearText:(id)sender
{
    searchField.text = @"";
    [mainTableView removeFromSuperview];
    [searchField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)textFieldDidChange:(UITextField *)textField {
    NSLog(@"text changed: %@", textField.text);
    
    if (textField.text.length ==3) {
        
        if (![previousSearchText isEqualToString:textField.text]) {
             [mainTableView removeFromSuperview];
            [searchField resignFirstResponder];
            previousSearchText = textField.text;
            KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:XmwcsConst_KEYCHAIN_IDENTIFIER accessGroup:nil];
            
            NSString* username = [keychainItem objectForKey:kSecAttrAccount];
            if (username == nil) {
                username = @"";
            }
            
            
            DotSearchComponent *searchObject = [[DotSearchComponent alloc]init];
            NSMutableArray *searchValues = [searchObject getRadioGroupData: self.formElement.dependedCompName];
            
            DotFormPost *formPost = [[DotFormPost alloc]init];
            [formPost.postData setObject:textField.text forKey:@"SEARCH_TEXT"];
            [formPost.postData setObject:[[searchValues objectAtIndex:0] objectAtIndex:0] forKey:@"SEARCH_BY"];
            [formPost setModuleId:[DVAppDelegate currentModuleContext]];
            
            [formPost setDocId:self.formElement.masterValueMapping];
            
            
            UIViewController *  parentController = [[[[UIApplication sharedApplication] windows] objectAtIndex:0] rootViewController];
            
            loadingView = [LoadingView loadingViewInView:parentController.view];//self.view];
            
            NetworkHelper *networkHelper = [[NetworkHelper alloc] init];
            [networkHelper makeXmwNetworkCall:formPost :self : nil :  XmwcsConst_CALL_NAME_FOR_SEARCH];
        }
        else
        {
             displayCustomerNameArray = [[NSMutableArray alloc] init];
            [displayCustomerNameArray addObjectsFromArray:combineKeyValueArray];
            [mainTableView reloadData];
        }
        
    }
    
    else if (textField.text.length>3)
    {
        [[[UIApplication sharedApplication] keyWindow] addSubview:mainTableView];
        displayCustomerNameArray = [[NSMutableArray alloc] init];

        for (int i=0; i<combineKeyValueArray.count; i++) {
            
            NSString *name  = [combineKeyValueArray objectAtIndex:i];

            NSRange nameRange = [name rangeOfString:textField.text options:NSCaseInsensitiveSearch];
            if (nameRange.location != NSNotFound) {
                [displayCustomerNameArray addObject: name];
            }

        }
        [mainTableView reloadData];
        
        
    }
    
    else if (textField.text.length<3)
    {
        previousSearchText = @"";
        [mainTableView removeFromSuperview];
        displayCustomerNameArray = [[NSMutableArray alloc]init];
        [mainTableView reloadData];
    }
}

- (void) httpResponseObjectHandler : (NSString*) callName : (id) respondedObject : (id) requestedObject
{
    [loadingView removeView];
    if([callName isEqualToString:XmwcsConst_CALL_NAME_FOR_SEARCH]) {
        displayCustomerNameArray = [[NSMutableArray alloc] init];
        searchResponseArray = [[NSMutableArray alloc] init];
        combineKeyValueArray = [[NSMutableArray alloc ] init];
        SearchResponse *response = (SearchResponse*) respondedObject;
        [searchResponseArray addObjectsFromArray:response.searchRecord];
        
        if (searchResponseArray.count>0) {
            [mainTableView removeFromSuperview];
            [[[UIApplication sharedApplication] keyWindow] addSubview:mainTableView];
        }
        
        for (int i=0; i<searchResponseArray.count; i++) {
            
            NSMutableArray *array = [[NSMutableArray alloc] init];
            [array addObjectsFromArray:[searchResponseArray objectAtIndex:i]];
            
            NSString* key = @"";
            NSString *value = @"";
            
            if ([array objectAtIndex:0] != nil) {
                key = [array objectAtIndex:0];
            }
            
            else
            {
                key = @"NULL";
            }
            
            if ([array objectAtIndex:1] != nil) {
                value = [array objectAtIndex:1];
            }
            else
            {
                value = @"NULL";
            }
            
            NSString *customerName = [[key stringByAppendingString:@"-"] stringByAppendingString:value];
            [displayCustomerNameArray addObject:customerName];
        }
        [combineKeyValueArray addObjectsFromArray: displayCustomerNameArray];
        [mainTableView reloadData];
        
    }
}

- (void) httpFailureHandler : (NSString*) callName : (NSString*) message {
    [loadingView removeView];
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Polycab Authentication!" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
    [myAlertView show];
    
}

#pragma mark - UITableView Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger numOfSections = 0;
    if (displayCustomerNameArray.count >0)
    {
        numOfSections = 1;
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        mainTableView.backgroundView  = view;
    }
    else
    {
        UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, mainTableView.bounds.size.width, mainTableView.bounds.size.height)];
        noDataLabel.text             = @"No customer found";
        noDataLabel.textColor        = [UIColor blackColor];
        noDataLabel.textAlignment    = NSTextAlignmentCenter;
        noDataLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:12.0];
        mainTableView.backgroundView  = noDataLabel;
        mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return numOfSections;
    
    
    //    return  [chatThreadDict count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [displayCustomerNameArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = [NSString stringWithFormat:@"Cell_%ld",indexPath.row];
    
    UITableViewCell *cell = [[UITableViewCell alloc ]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];

    NSMutableAttributedString *mutableString = nil;
    NSString *sampleText = [displayCustomerNameArray objectAtIndex:indexPath.row];
    mutableString = [[NSMutableAttributedString alloc] initWithString:sampleText];
    
    NSString *pattern = searchField.text;
    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:pattern options:1 error:nil];
    
    NSRange range = NSMakeRange(0,[sampleText length]);
    [expression enumerateMatchesInString:sampleText options:1 range:range usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        NSRange californiaRange = [result rangeAtIndex:0] ;
        [mutableString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:204.0/255 green:41.0/255 blue:43.0/255 alpha:1.0] range:californiaRange];
    }];
    
    
    
    cell.textLabel.attributedText = mutableString;
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:12.0];
    cell.textLabel.textColor =[UIColor colorWithRed:119.0/255 green:119.0/255 blue:119.0/255 alpha:1.0];
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.numberOfLines = 0;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [searchField resignFirstResponder];
    searchField.text = [displayCustomerNameArray objectAtIndex:indexPath.row];
    NSArray *splitArray = [searchField.text componentsSeparatedByString:@"-"];
    
    searchField.keyvalue = [splitArray objectAtIndex:0];
    [mainTableView removeFromSuperview];
}
@end
