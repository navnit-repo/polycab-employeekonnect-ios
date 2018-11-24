//
//  AddRowFormVC.m
//  EMSSales
//
//  Created by Puneet Arora on 28/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AddRowFormVC.h"
#import "DocumentVC.h"
#import "ReportVC.h"

#import <QuartzCore/QuartzCore.h>

#import "DotForm.h"
#import "DotFormElement.h"
#import "DotFormPost.h"
//#import "RecentRequest.h"

//#import "MitrInteger.h"
//#import "MitrString.h"
//#import "MitrHashtable.h"

//#import "MXData.h"
//#import "DataManager.h"
//#import "OfflineReportData.h"

#import "ReportTVCell.h"
#import "FormTVCell.h"
#import "EntryTVCell.h"

#import "MXButton.h"
//#import "LoadingView.h"

//#import "Reachability.h"
//#import "Database.h"
#import "XmwcsConstant.h"
#import "ClientVariable.h"
#import "DVAppDelegate.h"


#define FORM_TAG 1
#define SUBFORM_TAG 2

static const int TextFieldAnimationDuration = 0.33;

@implementation AddRowFormVC

@synthesize formTableView;
@synthesize componentArray;
@synthesize contactData,dateData;
@synthesize internetActive,isUpdateForm,isSimple,selectedRadioKey ;
@synthesize selectedSearchText;
#pragma mark - Initialization

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {}
    return self;
}

-(AddRowFormVC *) initWithData:(NSMutableDictionary *)_formData :(DotFormPost *)_formPost :(BOOL)_isFormIsSubForm:(NSMutableDictionary *)_dataForNextScreenDisplay :(NSMutableDictionary *)_dataForNextScreenPost
{
	if ( self ) 
	{
		formData                        = _formData;
		formPost                        = _formPost;
		isFormIsSubForm                 = _isFormIsSubForm;
		dataForNextScreenDisplay        = _dataForNextScreenDisplay;
		dataForNextScreenPost           = _dataForNextScreenPost;
    }	
    return self;
}

-(void) viewWillAppear:(BOOL)animated
{
    /*
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    internetReachable                   = [Reachability reachabilityForInternetConnection];
    [internetReachable startNotifier];
     */
}

-(void) initUpdateForm:(NSString *)trackId :(BOOL)isTracker
{
    NSString *formIdOfPostedData        = [formData objectForKey:@"FORM_ID_OPERATION"] ;
    NSString *operation                 = [formData objectForKey:@"FOR_OPERATION"];
    
   /*
    RecentRequest *recentRequest        = (RecentRequest *)[Database getRecentRequestForDocId:trackId:isTracker];
    formPost                            = recentRequest.formPostObj; // Check nil
    
    if ([operation isEqualToString:@"UPDATE"])
        [formData setObject:recentRequest forKey:@"RECENT_REQ_STRUCT"];
    
    formId                              = formIdOfPostedData;
    */
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initializeData];
    
    [self initializeTitle];
}

-(void) initializeData
{
     ClientVariable *clientVariables = [ClientVariable getInstance:[DVAppDelegate currentModuleContext]];
    
    if (!isSimple)
    {
        UIBarButtonItem *editButton     = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                                                            target:self action:@selector(edit)];
        editButton.title                = @"Edit";
        [[self navigationItem] setRightBarButtonItem:editButton];
        [editButton setEnabled:NO];
    }
    
    if(formPost == nil)
		formPost                        = [[DotFormPost alloc] init];
    
    sectionList                         = [[NSMutableDictionary alloc] init];
    subFormKeyRange                     = [[NSMutableDictionary alloc] init];
    sectHeaderList                      = [[NSMutableDictionary alloc] init];
    formSectKeys                        = [[NSMutableArray alloc] init];
    subFormKeys                         = [[NSMutableArray alloc] init];
    selectedSecKey                      = @"";
    formTableView.tag                   = tableTag = FORM_TAG;
    
          
    if(isFormIsSubForm)
		lastFormId                      = (NSString*) [formData  objectForKey: XmwcsConst_MENU_CONSTANT_LAST_FORM_ID];
    
	
    if (!isUpdateForm)
        formId                          = (NSString*) [formData  objectForKey: XmwcsConst_MENU_CONSTANT_FORM_ID] ;
	
    //formDef                             = (FormDefinition *)[[[MXData getInstance] getFORM_DEFMAP] getString:[[MitrString alloc] initWithString:formId]];
       
    DotForm *formdef = (DotForm*) [clientVariables.DOT_FORM_MAP objectForKey: XmwcsConst_MENU_CONSTANT_FORM_ID] ;
    
    
	//componentArray                      = [[[MXData getInstance] getFormDraw] drawSimpleScreen:formDef];
    
//	DotFormElement *componentArray			= (NSMutableArray*) [DotFormDraw formdef];
	

    //headerStr                           = formDef.formHeader; // Need to change
    autoFillData                        = [[NSMutableArray alloc] initWithObjects:@"0.0",@"0.0", nil];
    
    [self initializeSection:componentArray sectionData:sectionList keysOfSection:formSectKeys withFormId:formDef.formId];
    
    if (isUpdateForm)
        [self initializeUpdateMode];
}

-(void) initializeTitle
{
    NSUInteger actualX                  = self.navigationItem.leftBarButtonItem.width + 5;
    UILabel *label                      = [[UILabel alloc] initWithFrame:CGRectMake(actualX, 6, 320-actualX, 24)];
	label.autoresizingMask              = UIViewAutoresizingFlexibleWidth;
	label.text                          = headerStr;
    label.textColor                     = [UIColor whiteColor];
	label.backgroundColor               = [UIColor clearColor];
	[label setFont:[UIFont boldSystemFontOfSize:18.0]];
	label.textAlignment                 = UITextAlignmentCenter;
    self.navigationItem.titleView       = label; 
}

-(void) initializeUpdateMode
{
    NSMutableArray *subKeyList          = [[NSMutableArray alloc] init];
    
    for (NSString *keyStr in formSectKeys)
    {
        if ([keyStr hasPrefix:@"SUBFORM"])
            if (subKeyList == nil)
                subKeyList              = [[NSMutableArray alloc] initWithObjects:keyStr, nil];
            else
                [subKeyList addObject:keyStr];
    }
    for (NSString *str in subKeyList)
    {
        NSString *reportKey             = [str stringByReplacingOccurrencesOfString:@"SUBFORM" withString:@"REPORT"];
        [formSectKeys insertObject:reportKey atIndex:[formSectKeys indexOfObject:str]];
    }
    headerStr                           = [formData objectForKey:@"MENU_NAME"] ;
}

#pragma mark - Helper Methods

-(NSString *) subFormInUpdateMode:(id)subFormDef:(NSString *)reportKey
{
   
}

-(id) getGradientColor:(UIView *)myView
{
    static NSMutableArray *colors           = nil;
    if (colors == nil) 
    {
        colors                              = [[NSMutableArray alloc] initWithCapacity:3];
        UIColor *color                      = nil;
        color                               = [UIColor colorWithRed:0.82 green:0.84 blue:0.87 alpha:1.0];
        [colors addObject:(id)[color CGColor]];
        color                               = [UIColor colorWithRed:0.41 green:0.41 blue:0.59 alpha:1.0];
        [colors addObject:(id)[color CGColor]];
        color                               = [UIColor colorWithRed:0.41 green:0.41 blue:0.59 alpha:1.0];
        [colors addObject:(id)[color CGColor]];
    }
    CAGradientLayer *gradient               = [CAGradientLayer layer];
    gradient.frame                          = myView.frame;
    gradient.colors                         = [NSArray arrayWithArray:colors];
    
    return gradient;
}

-(void) initializeSection:(NSMutableArray *)compArray sectionData:(NSMutableDictionary *)sectData keysOfSection:(NSMutableArray *)sectKeys 
               withFormId:(NSString *)_formId
{
     ClientVariable *clientVariables = [ClientVariable getInstance:[DVAppDelegate currentModuleContext]];
    NSMutableArray *formArray               = [[NSMutableArray alloc] init];
    NSMutableArray *buttonItems             = [[NSMutableArray alloc] init];
    NSMutableArray *contactItems            = nil;
    NSMutableArray *sectionedComp           = [[NSMutableArray alloc] initWithObjects:@"BUTTON",@"SUBFORM",@"CONTACT_FIELD", nil];
    NSString *currentType                   = @"";
    NSString *nextType                      = @"";
    int buttonCount                         = 0;
    BOOL addSection                         = NO;
    BOOL addRow                             = NO;
    id respectiveData                       = nil;
    DotFormElement *currentComp              = nil;
    
    for (int i = 0; i < [compArray count];i++)
    {   
        if (i == 0)
            addSection                      = NO;
        else if (i == ([compArray count]-1))
            addSection                      = YES;
        
        addRow                              = YES;
        currentComp                         = [compArray objectAtIndex:i];
        currentType                         = currentComp.componentType;
        
        if ([currentComp.elementId isEqualToString: @"PRODUCT"])
            respectiveData                  = autoFillData;

        if ([currentType isEqualToString: XmwcsConst_DE_COMPONENT_BUTTON])
        {
            [buttonItems addObject:currentComp];
            
            if ([currentComp.format hasPrefix: @"DOUBLE"])
                buttonCount                 = 2;
            else if ([currentComp.format hasPrefix:@"TRIPLE"])
                buttonCount                 = 3;
            else 
                buttonCount                 = 1;
            
            if ([buttonItems count] == buttonCount)
            {
                respectiveData              = [NSMutableDictionary dictionaryWithObjectsAndKeys:buttonItems,@"ButtonComponents",
                                               [currentType stringByAppendingFormat:@"%d",[sectKeys count]],@"SectionKey",
                                                                                                    _formId,@"FormId",
                                                                                           currentComp.elementId,@"componentKey",
                                                                                                      @"NO",@"IsUpdate", nil];
                buttonItems                 = [[NSMutableArray alloc] init];
            }
            else
                addRow                      = NO;
        }
        else if ([currentType isEqualToString:@"CONTACT_FIELD"])
        {
            contactData                     = [[NSMutableDictionary alloc] init];
            NSArray *itemList               = [currentComp.dependedCompValue componentsSeparatedByString:@"$"];
            
            for (NSString *str in itemList)
            {
                NSArray *keyList            = [str componentsSeparatedByString:@":"];
                contactItems                = [[NSMutableArray alloc] initWithObjects:[keyList objectAtIndex:0],@"", nil];
                [(NSMutableDictionary *)contactData setObject:contactItems forKey:[keyList objectAtIndex:1]];
            }
            currentType                     = currentComp.componentType;
            respectiveData                  = contactData;
        }
        else if ([currentType isEqualToString:@"SUBFORM"])
        {
            NSString *subFormId             = currentComp.dependedCompValue;
            DotForm *subFormDef      = (DotForm*) [clientVariables.DOT_FORM_MAP objectForKey: subFormId] ;
            //(FormDefinition *)[[[MXData getInstance] getFORM_DEFMAP].hashTable objectForKey:subFormId];
            NSString *sectionKey            = [currentType stringByAppendingFormat:@"%d",[sectKeys count]];
            NSString *reportKey             = [sectionKey stringByReplacingOccurrencesOfString:@"SUBFORM" withString:@"REPORT"];
            NSString *hasRow;
            
            if (isUpdateForm)
                hasRow                      = [self subFormInUpdateMode:subFormDef:reportKey];
            else
                hasRow                      = [formSectKeys containsObject:reportKey]?@"YES":@"NO";

  /*         respectiveData                  = [NSMutableDictionary dictionaryWithObjectsAndKeys:subFormDef.tableName,@"TableName",
                                                    [subFormDef.tableName hasPrefix:@"PRODUCT"]?autoFillData:@"NULL",@"AutoData",
                                                                                                              hasRow,@"hasRow",
                                                                                                          sectionKey,@"SectionKey",
                                                                                                           subFormId,@"FormId", nil]; */
            addRow                          = YES;
            addSection                      = YES;
        }
        else
        {
            if ([currentType isEqualToString:@"DATE_FIELD"])
            {
                if (dateData == nil)
                    dateData                = [[NSMutableDictionary alloc] init];
                
                respectiveData              = dateData;
            }
            currentType                     = @"FORM";
        }

        if ([compArray count] > (i+1))
        {
            nextType                        = ((DotFormElement *)[compArray objectAtIndex:(i+1)]).componentType;

            if (![currentType isEqualToString:nextType]  && ([sectionedComp containsObject:nextType] || [sectionedComp containsObject:currentType]) )
                addSection = YES;
            else
                addSection = NO;
        }
        
      /*  if (addRow)
            [formArray addObject:[[FormCellDescription alloc] initWithComponent:currentComp formPost:formPost data:respectiveData]];
       */
        
        if (addSection)
        {   
            [sectData setObject:formArray forKey:[currentType stringByAppendingFormat:@"%d",[sectKeys count]]];
            [sectKeys addObject:[currentType stringByAppendingFormat:@"%d",[sectKeys count]]];
            formArray                       = [[NSMutableArray alloc] init]; 
        }
    }
}

-(NSMutableArray *) getHeaderData:(DotForm *)_formDef
{
    
}

-(NSMutableArray *) getAddRowData:(DotForm *)_formDef
{
}

-(NSMutableArray *) getRowElements:(DotForm *)_formDef reportData:(NSMutableArray *)rptData sectionKey:(NSString *)addRowKey
                                  :(BOOL)hasAddRow:(NSUInteger)secIndex
{
    NSMutableArray *rowList                 = nil;

    NSMutableDictionary *reportItems        = [[NSMutableDictionary alloc] initWithObjectsAndKeys:rptData,@"ReportData",
                                               @"YES",@"Selection",
                                               @"NO",@"Disclosure",
                                               _formDef.formId,@"FormId",
                                               [autoFillData mutableCopy],@"AutoData",
                                               [NSNumber numberWithInt:1],@"SelectionDiff",nil];
    
    ReportCellDescription *rptCellDesc      = [[ReportCellDescription alloc] initWithData:reportItems :@"TABLE"];
    
    if (hasAddRow)                                                                                                  // Adding to Row List
    {
        rowList                             = [sectionList objectForKey:addRowKey];
        [rowList addObject:rptCellDesc];
    }
    else                                                                                                            // Create Row
    {
        [formSectKeys insertObject:[@"REPORT" stringByAppendingFormat:@"%d",secIndex] atIndex:secIndex];
        [sectHeaderList setObject:[self getHeaderData:_formDef] forKey:[@"REPORT" stringByAppendingFormat:@"%d",secIndex]];
        rowList                             = [[NSMutableArray alloc] initWithObjects:rptCellDesc, nil];
    }
    [reportItems setObject:[NSNumber numberWithInteger:[rowList count]] forKey:@"RowNumber"];
    [sectionList setObject:rowList forKey:[@"REPORT" stringByAppendingFormat:@"%d",secIndex]];
    
    return rowList;
}

-(void) addRowDataToFormPost:(NSNumber *)addRowNumber:(DotForm *)_formDef
{
   
}

-(void) addReportElements:(NSMutableDictionary *)buttonData
{
}

-(void) fillSubForm:(NSString *)sectionKey selectRowAtIndexPath:(NSIndexPath *)anIndexPath
{
     ClientVariable *clientVariables = [ClientVariable getInstance:[DVAppDelegate currentModuleContext]];
    NSUInteger sectionIndex                         = [[sectionKey stringByReplacingOccurrencesOfString:@"SUBFORM" withString:@""] intValue];
    NSMutableArray *formCellArray                   = [sectionList objectForKey:[@"REPORT" stringByAppendingFormat:@"%d",sectionIndex]];
    ReportCellDescription *rptCellDesc              = [formCellArray objectAtIndex:anIndexPath.row];
    NSMutableDictionary *cellData                   = rptCellDesc.cellData;
    NSUInteger rowNumber                            = [(NSNumber *)[cellData objectForKey:@"RowNumber"] integerValue];
    NSString *appendStr                             = [@":" stringByAppendingFormat:@"%d",rowNumber];
    selectedRowStr                                  = [[appendStr stringByAppendingString:@"$"] stringByAppendingFormat:@"%d",anIndexPath.row];
    
    DotForm *subFormDef        = (DotForm*) [clientVariables.DOT_FORM_MAP objectForKey: XmwcsConst_MENU_CONSTANT_FORM_ID] ;

    //(DotForm *)[[[MXData getInstance] getFORM_DEFMAP] objectForKey:[cellData objectForKey:@"FormId"]];
   
   // if ([subFormDef.tableName hasPrefix:@"PRODUCT"])
       // autoFillData                                = [cellData objectForKey:@"AutoData"];
    
    [self prepareSubForm:[cellData objectForKey:@"FormId"] didSelectRowAtSectionKey:sectionKey];
    
    NSMutableDictionary *subFormData                = [subFormList objectForKey:sectionKey];
    
    for (NSString *keyStr in subFormSectKeys)
        if ([keyStr hasPrefix:@"FORM"])
        {
            NSMutableArray *subFormCellArray        = [subFormData objectForKey:keyStr];
            
            for (FormCellDescription *cellDesc in subFormCellArray)
            {
                NSMutableDictionary *formCellData   = cellDesc.cellData;
                NSString *keyStr                    = [[formCellData objectForKey:@"componentKey"] stringByAppendingString:appendStr];
                NSString *valueStr                  = [formPost.postData objectForKey:keyStr] ;
                NSString *displayStr                = [formPost.displayData objectForKey:keyStr] ;
                
                [formCellData setObject:valueStr forKey:@"value"];
                [formCellData setObject:displayStr forKey:@"displayStr"];
            }
        }
        else if ([keyStr hasPrefix:@"BUTTON"])
        {
            NSMutableArray *buttonArray             = [subFormData objectForKey:keyStr];
            
            for (FormCellDescription *cellDesc in buttonArray)
            {                
                NSMutableArray *buttonItems         = [(NSMutableDictionary *)cellDesc.cellData objectForKey:@"ButtonComponents"];
                for (DotFormElement *comp in buttonItems)
                {
                    if ([comp.elementId isEqualToString:@"ADD_ROW"])
                        [(NSMutableDictionary *)cellDesc.cellData setObject:@"YES" forKey:@"IsUpdate"];
                }
            }
        }

    [subFormTableView reloadData];
    [formTableView reloadData];
}

-(void) updateSubForm:(NSMutableDictionary *)buttonData
{
     ClientVariable *clientVariables = [ClientVariable getInstance:[DVAppDelegate currentModuleContext]];
    //DotForm *subFormDef  = (DotForm *)[[[MXData getInstance] getFORM_DEFMAP] objectForKey:[buttonData objectForKey:@"FormId"]];
    DotForm *subFormDef = (DotForm*) [clientVariables.DOT_FORM_MAP objectForKey: XmwcsConst_MENU_CONSTANT_FORM_ID] ;
    NSUInteger sectionIndex                 = [[selectedSecKey stringByReplacingOccurrencesOfString:@"SUBFORM" withString:@""] intValue];
    NSString *addRowKey                     = [@"REPORT" stringByAppendingFormat:@"%d",sectionIndex];
    NSMutableArray *reportData              = [self getAddRowData:subFormDef];
    NSArray *rowKeys                        = [selectedRowStr componentsSeparatedByString:@"$"];
    NSMutableDictionary *subFormData        = [subFormList objectForKey:selectedSecKey];

    for (NSString *keyStr in subFormSectKeys)
    {
        if ([keyStr hasPrefix:@"FORM"])
        {
            NSMutableArray *cellDataArray       = [subFormData objectForKey:keyStr];
            
            for (FormCellDescription *cellDesc in cellDataArray)
            {
                NSMutableDictionary *cellData   = cellDesc.cellData;
                NSString *valueStr              = [cellData objectForKey:@"value"];
                NSString *displayStr            = [cellData objectForKey:@"displayStr"];
                NSString *postKeyStr            = [[cellData objectForKey:@"componentKey"] stringByAppendingString:[rowKeys objectAtIndex:0]];
                [formPost.postData setObject:[[NSString alloc] initWithString:valueStr] forKey:postKeyStr];
                [formPost.displayData setObject:[[NSString alloc] initWithString:displayStr] forKey:postKeyStr];
                
                if (cellDesc.cellClass == [EntryTVCell class])                  // Clearing TextField Data.
                    [cellDesc.cellData setObject:@"" forKey:@"displayStr"];
            }
        }
    }  
    
    NSMutableArray *rowList                 = [sectionList objectForKey:addRowKey];
    ReportCellDescription *rptCellDesc      = [rowList objectAtIndex:[[rowKeys objectAtIndex:1] intValue]];
    NSMutableDictionary *cellData           = rptCellDesc.cellData;

    [cellData setObject:reportData forKey:@"ReportData"];
    [subFormKeys removeAllObjects];
}

-(void) prepareSubForm:(NSString *)subFormId didSelectRowAtSectionKey:(NSString *)sectionKey
{


}

-(void) drawSubForm
{
    subFormView                             = [[UIView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:subFormView];
    
    UIImageView *backImageView              = [[UIImageView alloc] initWithFrame:self.view.frame];
    backImageView.image                     = [UIImage imageNamed:@"black-tile.png"];
    [subFormView addSubview:backImageView];
    
    if (subFormTableView == nil)
        subFormTableView                    = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 300, 356) style:UITableViewStyleGrouped];
    
    subFormTableView.center                 = CGPointMake(160, 254);
    subFormTableView.tag                    = SUBFORM_TAG;
    subFormTableView.delegate               = self;
    subFormTableView.dataSource             = self;
    subFormTableView.backgroundColor        = [UIColor colorWithRed:0.831f green:0.839f blue:0.871f alpha:1.0];
    [subFormView addSubview:subFormTableView];
    
    UIButton *backgroundBtn                 = [[UIButton alloc] init];
    backgroundBtn.tag                       = SUBFORM_TAG;
    backgroundBtn.frame                     = CGRectMake(290, 60,32,32);
    [backgroundBtn setBackgroundImage:[UIImage imageNamed:@"closeButton"] forState:UIControlStateNormal];
    [backgroundBtn setBackgroundImage:[UIImage imageNamed:@"closeButton"] forState:UIControlStateHighlighted];
    [backgroundBtn addTarget:self action:@selector(removeView:) forControlEvents:UIControlEventTouchUpInside];
    [subFormView bringSubviewToFront:backgroundBtn];
    [subFormView addSubview:backgroundBtn];
}

- (BOOL) validateSubForm:(BOOL)isAddRow
{   
    for (NSString *str in subFormSectKeys)
        if ([str hasPrefix:@"FORM"])
            [subFormKeys addObject:str];
    
    NSMutableDictionary *subFormData            = [subFormList objectForKey:selectedSecKey];
    
    for (NSString *keyStr in subFormKeys)
    {
        NSMutableArray *cellDataArray           = [subFormData objectForKey:keyStr];
        
        for (FormCellDescription *cellDesc in cellDataArray)
        {
            NSMutableDictionary *cellData       = (NSMutableDictionary *)cellDesc.cellData;
            NSString *valueStr                  = [cellData objectForKey:@"value"];
//            NSString *displayStr                = [cellData objectForKey:@"displayStr"];
            NSString *mandatoryStr              = [cellData objectForKey:@"mandatoryLabel"];
            
            if ([valueStr isEqualToString:@"NONE"] && [mandatoryStr isEqualToString:@"YES"])
            {
                if (isAddRow)
                {
                    UIAlertView *myAlertView    = [[UIAlertView alloc] initWithTitle:@"Info!" message:@"Please provide all Mandatory fields." delegate:self 
                                                                   cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];				
                    [myAlertView show];
                }
                return NO;
            }
            /*else if ([valueStr isEqualToString:@"NONE"] || [displayStr isEqualToString:@""])  // Can Submit Blank in case of non Mandatory
            {
                UIAlertView *myAlertView        = [[UIAlertView alloc] initWithTitle:@"Info!" message:@"Please provide some value." delegate:self 
                                                                   cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];				
                [myAlertView show];
                return NO;
            }*/
        }
    }
    return YES;
}

-(BOOL) validateForm
{
    NSMutableArray *formKeyList             = [[NSMutableArray alloc] init];
    BOOL isReport                           = NO;
    BOOL hasSubForm                         = NO;
    
    for (NSString *keyStr in formSectKeys)
        if ([keyStr hasPrefix:@"SUBFORM"])
        {
            hasSubForm                      = YES;
            NSUInteger reportSection        = [[keyStr stringByReplacingOccurrencesOfString:@"SUBFORM" withString:@""] intValue];
            NSString *reportKey             = [@"REPORT" stringByAppendingFormat:@"%d",reportSection];
            
            if ([formSectKeys containsObject:reportKey])
                isReport                    = YES;
            else
            {
                isReport                    = NO;
                break;
            }
        }
        else if ([keyStr hasPrefix:@"FORM"])
            [formKeyList addObject:keyStr];
    
    if (hasSubForm && !isReport) 
    {   
        UIAlertView *myAlertView            = [[UIAlertView alloc] initWithTitle:@"Info!" message:@"Please add at least one line item." delegate:self 
                                                               cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];				
        [myAlertView show]; 
        return NO;
    }
    
    for (NSString *formKeyStr in formKeyList)
    {
        NSMutableArray *cellDataArray       = [sectionList objectForKey:formKeyStr];
        
        for (FormCellDescription *cellDesc in cellDataArray)
        {
            NSMutableDictionary *cellData   = (NSMutableDictionary *)cellDesc.cellData;
            NSString *valueStr              = [cellData objectForKey:@"value"];
//            NSString *displayStr            = [cellData objectForKey:@"displayStr"];
            NSString *mandatoryStr          = [cellData objectForKey:@"mandatoryLabel"];
            
            if ([valueStr isEqualToString:@"NONE"] && [mandatoryStr isEqualToString:@"YES"])
            {
                UIAlertView *myAlertView    = [[UIAlertView alloc] initWithTitle:@"Info!" message:@"Please provide all Mandatory fields." delegate:self 
                                                               cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];				
                [myAlertView show];
                return NO;
            }
            /*else if ([valueStr isEqualToString:@"NONE"] || [displayStr isEqualToString:@""])  // Can Submit Blank in case of non Mandatory
            {
                UIAlertView *myAlertView    = [[UIAlertView alloc] initWithTitle:@"Info!" message:@"Please provide some value." delegate:self 
                                                               cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];				
                [myAlertView show];
                return NO;
            }*/
        }
    }
    
    return YES;
}

-(void) prepareFormPost
{
    for (NSString *keyStr in formSectKeys)
    {
        if ([keyStr hasPrefix:@"FORM"])
        {
            NSMutableArray *cellDataArray       = [sectionList objectForKey:keyStr];
            
            for (FormCellDescription *cellDesc in cellDataArray)
            {
                NSMutableDictionary *cellData   = (NSMutableDictionary *)cellDesc.cellData;
                NSString *valueStr              = [cellData objectForKey:@"value"];
                NSString *displayStr            = [cellData objectForKey:@"displayStr"];
                [formPost.postData setObject:[[NSString alloc] initWithString:valueStr] forKey:[cellData objectForKey:@"componentKey"]];
                [formPost.displayData setObject:[[NSString alloc] initWithString:displayStr] forKey:[cellData objectForKey:@"componentKey"]];
            }
        }
    }
    
   //DotFormPost.integrationXMLId           = formDe.importIntegrationId;
	//formPost.docId                      = formDef.formId;
	//DotFormPost.docDesc                    = formDef.formHeader;
	
	if([formDef.formSubType isEqualToString:@"VIEWDIRECT"])
		NSLog(@"Will Handle this later.");
    
  // DotFormPost.module                     = [[MXData getInstance] getModule];
    formPost.moduleId                  = @"xess";
}

-(NSMutableDictionary *) getSectionDataForDocumentView:(NSMutableArray *)keyList:(NSMutableDictionary *)headerData
{
    NSMutableDictionary *sectionData        = [[NSMutableDictionary alloc] init];
    NSMutableArray *compArray               = [[NSMutableArray alloc] init];
    
    for (NSString *keyStr in formSectKeys)
    {
        if ([keyStr hasPrefix:@"REPORT"])
        {
            [sectionData setObject:[sectionList objectForKey:keyStr] forKey:keyStr];
            [headerData setObject:[sectHeaderList objectForKey:keyStr] forKey:keyStr];
            [keyList addObject:keyStr];
        }
        else if ([keyStr hasPrefix:@"FORM"])
        {
            NSMutableArray *cellDescItems   = [sectionList objectForKey:keyStr];
            
            for (FormCellDescription *cellDesc in cellDescItems)
                [compArray addObject:cellDesc.formComponent];
        }
    }
    [sectionData setObject:compArray forKey:@"FORM"];
    [keyList addObject:@"FORM"];
    
    return sectionData;
}


#pragma mark - Action Methods

-(void) deSelect:(id)sender
{
	[(UITableView *)sender deselectRowAtIndexPath:[(UITableView *)sender indexPathForSelectedRow] animated:YES];
}

-(void) keyboardDownAtNumPad:(id)sender
{
    [((MXButton *)sender).attachedData resignFirstResponder];
    [sender removeFromSuperview];
}

- (void) edit
{    
    [formTableView setEditing:!(formTableView.editing) animated:YES];
    
    if(formTableView.editing == YES) 
    {   
        UIBarButtonItem *doneButton         = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                            target:self action:@selector(edit)];
        [[self navigationItem] setRightBarButtonItem:doneButton];
    } 
    else 
    {   
        UIBarButtonItem *editButton         = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                                                            target:self action:@selector(edit)];
        [[self navigationItem] setRightBarButtonItem:editButton];
        BOOL hasReport                      = NO;
        
        for (NSString *keyStr in formSectKeys)
            if ([keyStr hasPrefix:@"REPORT"])
            {
                hasReport                   = YES;
                break;
            }
        
        if (!hasReport)
            [editButton setEnabled:NO];
    }
}

-(void) multiButtonPressed:(id)sender
{   
    NSMutableDictionary *buttonData                 = ((MXButton *)sender).attachedData;
    [buttonData setObject:((MXButton *)sender).elementId forKey:@"KeyValue"];
    [self performSelector:@selector(submitPressed:) withObject:buttonData];
}

-(void) submitPressed:(id)sender
{
    
}

-(void) addLineItemPressed:(id)sender
{    
    NSMutableDictionary *buttonData                 = (NSMutableDictionary *)sender;
    NSString *tableName                             = [buttonData objectForKey:@"TableName"];
    
    if ([tableName hasPrefix:@"PRODUCT"]) 
    {
        NSMutableArray *autoData                    = [buttonData objectForKey:@"AutoData"];
        [autoData replaceObjectAtIndex:0 withObject:@"0.0"];
        [autoData replaceObjectAtIndex:1 withObject:@"0.0"];
        autoFillData                                = autoData;
    }
    
    [self prepareSubForm:[buttonData objectForKey:@"FormId"] didSelectRowAtSectionKey:[buttonData objectForKey:@"SectionKey"]];
    [subFormTableView reloadData];
}

-(void) removeView:(id)sender
{
    tableTag                                        = FORM_TAG;
    [subFormView removeFromSuperview];
}

- (void) showLoadingView
{/*
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	loadingView = [LoadingView loadingViewInView:self.view];
  */
}

-(void) dismissLoadingView
{
    /*
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[loadingView removeView];
     */
}

#pragma mark - Table View Delegates

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView.tag == FORM_TAG)
    {
        NSString *sectionKey                        = [formSectKeys objectAtIndex:section];
        
        if ([sectionKey hasPrefix:@"REPORT"])
        {
            NSMutableArray *headerData              = [sectHeaderList objectForKey:sectionKey];
            
            if ([headerData count] > 0)
            {
                int screenWidth                     = tableView.frame.size.width;// - (20 * 1);
                UIView *headerView                  = [[UIView alloc] initWithFrame:CGRectMake(0, 0,tableView.frame.size.width, 44)];	
                
                int lblWidth                        = screenWidth/[headerData count]; 
                int lblHeight                       = 42;
                int start_X                         = 0;
                NSString *heading                   = [[NSString alloc] init];
                
                for (int i = 0; i < [headerData count]; i++) 
                {
                    heading                         = [headerData objectAtIndex:i];
                    
                    if (heading == NULL) 
                        heading = @"";
                    
                    start_X                         = (lblWidth * i)+2;
                    
                    UIFont *lblFont                 = [UIFont fontWithName:@"Helvetica" size:11.0];
                    CGSize lblConstraintSize        = CGSizeMake(lblWidth-3, MAXFLOAT);
                    CGSize lblSize                  = [heading sizeWithFont:lblFont constrainedToSize:lblConstraintSize lineBreakMode:UILineBreakModeWordWrap];
                    lblHeight                       = MAX(lblSize.height, lblHeight);
                    
                    UILabel *headerLabel			= [[UILabel alloc] initWithFrame:CGRectMake(start_X, 2, lblWidth/*-3*/, lblHeight)];
                    headerLabel.text				= heading;
                    headerLabel.lineBreakMode		= UILineBreakModeWordWrap;
                    headerLabel.numberOfLines		= 0;
                    headerLabel.textColor			= [UIColor whiteColor];
                    headerLabel.textAlignment		= UITextAlignmentCenter;
                    headerLabel.backgroundColor		= [UIColor clearColor];
                    headerLabel.font				= [UIFont fontWithName:@"Helvetica" size:11.0];
                    headerLabel.baselineAdjustment	= UIBaselineAdjustmentAlignCenters;
                    
                    headerView.frame                = CGRectMake(0, 0, headerView.frame.size.width, lblHeight + 2);
                    [headerView addSubview:headerLabel];
                }
                [headerView.layer insertSublayer:[self getGradientColor:headerView] atIndex:0];
                
                return headerView;
            }
        }
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView.tag == FORM_TAG)
    {
        NSString *sectionKey                        = [formSectKeys objectAtIndex:section];
        
        if ([sectionKey hasPrefix:@"REPORT"])
        {
            NSMutableArray *headerData              = [sectHeaderList objectForKey:sectionKey];
            
            if ([headerData count] > 0)
            {
                int screenWidth                     = tableView.frame.size.width - (20 * 1);
                int lblWidth                        = screenWidth/[headerData count]; 
                int lblHeight                       = 42;
                
                for (int i = 0; i < [headerData count]; i++) 
                {
                    NSString *value                 = [headerData objectAtIndex:i];
                    UIFont *lblFont                 = [UIFont fontWithName:@"Helvetica" size:11.0];
                    CGSize lblConstSize             = CGSizeMake(lblWidth-3, MAXFLOAT);
                    CGSize lblSize                  = [value sizeWithFont:lblFont constrainedToSize:lblConstSize lineBreakMode:UILineBreakModeWordWrap];
                    lblHeight                       = MAX(lblHeight,lblSize.height);
                }
                return lblHeight + 2;
            }
        }
    }

    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == SUBFORM_TAG)
    {
        NSMutableDictionary *subFormData            = [subFormList objectForKey:selectedSecKey];
        NSString *sectKeyStr                        = [subFormSectKeys objectAtIndex:section];
        return [[subFormData objectForKey:sectKeyStr] count];
    }
    
    NSString *keyStr                                = [formSectKeys objectAtIndex:section];
    return [[sectionList objectForKey:keyStr] count];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView 
{
    if (tableView.tag == SUBFORM_TAG)
        return [subFormSectKeys count];
    
	return [formSectKeys count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *sectionKey;
    NSMutableArray *cellDataArray;
    NSMutableDictionary *subFormData;
    UITableViewCellStyle cellStyle;
    
    tableView.separatorStyle                = UITableViewCellSeparatorStyleSingleLine;
    tableView.separatorColor                = [UIColor colorWithRed:0.831 green:0.839 blue:0.871 alpha:1.0];
    
    if (tableView.tag == SUBFORM_TAG)
    {
        subFormData                         = [subFormList objectForKey:selectedSecKey];
        sectionKey                          = [subFormSectKeys objectAtIndex:indexPath.section];
        cellDataArray                       = [subFormData objectForKey:sectionKey];
    }
    else
    {
        sectionKey                          = [formSectKeys objectAtIndex:indexPath.section];
        cellDataArray                       = [sectionList objectForKey:sectionKey];
    }
    
    if ([sectionKey hasPrefix:@"BUTTON"] || [sectionKey hasPrefix:@"SUBFORM"])
        cellStyle                           = UITableViewCellStyleDefault;
    else
        cellStyle                           = UITableViewCellStyleValue2;
    
    if ([sectionKey hasPrefix:@"REPORT"])
    {
        ReportCellDescription *rptCellDesc  = [cellDataArray objectAtIndex:indexPath.row];
        NSString *cellIdentifier            = [rptCellDesc.cellClass reuseIdentifier];
        ReportTVCell *reportCell            = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (reportCell == nil)
            reportCell                      = [[rptCellDesc.cellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        [reportCell configureCellData:rptCellDesc.cellData tableView:tableView atIndexPath:indexPath];
        
        return reportCell;
    }
    else
    {
        FormCellDescription *formCellDesc   = [cellDataArray objectAtIndex:indexPath.row];
        NSString *cellIdentifier            = [formCellDesc.cellClass reuseIdentifier];
        FormTVCell *formCell                = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (formCell == nil)
            formCell = [[formCellDesc.cellClass alloc] initWithStyle:cellStyle reuseIdentifier:cellIdentifier];
        
        if (!isUpdateForm)
        {
            if ([[formCellDesc.cellData objectForKey:@"componentKey"] isEqualToString:@"PRICE"])
                [formCellDesc.cellData setObject:[autoFillData objectAtIndex:0] forKey:@"displayStr"];
            else if ([[formCellDesc.cellData objectForKey:@"componentKey"] isEqualToString:@"PRODUCT_VAT"])
                [formCellDesc.cellData setObject:[autoFillData objectAtIndex:1] forKey:@"displayStr"];
        }
        else
            [formCellDesc.cellData setObject:@"YES" forKey:@"IsUpdate"];
        
        [formCell configureCellData:formCellDesc.cellData tableView:tableView atIndexPath:indexPath];
        
        return formCell;
    } 
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    NSString *sectionKey                    = [formSectKeys objectAtIndex:indexPath.section];
    
    if ([sectionKey hasPrefix:@"REPORT"])
    {
        NSMutableArray *cellDataArray       = [sectionList objectForKey:sectionKey];
        ReportCellDescription *rptCellDesc  = [cellDataArray objectAtIndex:indexPath.row];
        NSMutableDictionary *cellData       = rptCellDesc.cellData;
        NSMutableArray *rowItems            = [cellData objectForKey:@"ReportData"];
        int screenWidth                     = tableView.frame.size.width - (20 * 1);
        int lblWidth                        = screenWidth/[rowItems count]; 
        int lblHeight                       = 38;

        for (NSString *mitrStr in rowItems)
        {   
            UIFont *lblFont                 = [UIFont fontWithName:@"Helvetica" size:11.0];
            CGSize lblConstraintSize        = CGSizeMake(lblWidth-3, MAXFLOAT);
            CGSize lblSize                  = [mitrStr  sizeWithFont:lblFont constrainedToSize:lblConstraintSize
                     lineBreakMode:UILineBreakModeWordWrap];
            
            lblHeight                       = MAX(lblSize.height, lblHeight);
        }

        return lblHeight+12;
    }
    else
    {
        NSString *titleText                     = ((DotFormElement *)[componentArray objectAtIndex:indexPath.row]).displayText;
        CGSize maxLabelSize                     = CGSizeMake(90, MAXFLOAT);
        CGSize titleSize                        = [titleText sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:12.0] constrainedToSize:maxLabelSize 
                                                            lineBreakMode:UILineBreakModeWordWrap];
        
        if (titleSize.height > 30)
            return (titleSize.height + 14);
        
        return 50;
    }
    /*
    else
    {
        NSMutableArray *cellDataArray       = [sectionList objectForKey:sectionKey];
        FormCellDescription *formCellDesc   = [cellDataArray objectAtIndex:indexPath.row];
        FormTVCell *formCell                = (FormTVCell *)cell;
    }*/
    
    /*FormComponent *tempComponent = (FormComponent *)[componentArray objectAtIndex:indexPath.row];
     if([tempComponent.componentType isEqualToString:@"LABEL_GROUP"])
     return 26;*/
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)anIndexPath
{
    id cell                                 = [aTableView cellForRowAtIndexPath:anIndexPath];
    
    if ([cell isKindOfClass:[FormTVCell class]])
        [(FormTVCell *)cell handleSelection:aTableView];
    else if ([cell isKindOfClass:[ReportTVCell class]])
    {
        for (UIView *subview in [((UITableViewCell *)cell).contentView subviews])
            [subview removeFromSuperview];
        
        NSString *sectionKey                = [@"SUBFORM" stringByAppendingFormat:@"%d",anIndexPath.section];
        NSMutableDictionary *selData        = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"ADD_ROW",@"Selection",
                                               sectionKey,@"SectionKey",nil];
        [(ReportTVCell *)cell handleSelection:aTableView didSelectRowAtIndexPath:anIndexPath:selData];
    }
    else
        return;
}

#pragma Table View Editing Delegates

- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    NSString *sectionKey                    = [formSectKeys objectAtIndex:indexPath.section];

    if ([sectionKey hasPrefix:@"REPORT"])
        return UITableViewCellEditingStyleDelete;
    
    return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)aTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath 
{
     ClientVariable *clientVariables = [ClientVariable getInstance:[DVAppDelegate currentModuleContext]];
    if (editingStyle == UITableViewCellEditingStyleDelete) 
	{
        NSString *sectionKey                = [formSectKeys objectAtIndex:indexPath.section];
        NSMutableArray *cellDataArray       = [sectionList objectForKey:sectionKey];
        ReportCellDescription *rptCellDesc  = [cellDataArray objectAtIndex:indexPath.row];
        NSMutableDictionary *cellData       = rptCellDesc.cellData;
        NSUInteger rowNumber                = [(NSNumber *)[cellData objectForKey:@"RowNumber"] integerValue];
        
        DotForm *subFormDef          = [clientVariables.DOT_FORM_MAP objectForKey: XmwcsConst_MENU_CONSTANT_FORM_ID];
    //    NSArray *components                 = [subFormDef.components allValues];
        NSString *appendStr                 = [@":" stringByAppendingFormat:@"%d",rowNumber];
        
    /*    for (DotFormElement *comp in components)
        {
            if (![comp.componentType isEqualToString:@"BUTTON"])
            {
                NSString *postStrKey        = [comp.elementId stringByAppendingString:appendStr];
                [formPost.postData removeObjectForKey:postStrKey];
                [formPost.displayData removeObjectForKey:postStrKey];
            }
        }
     */
        
     //   [formPost.postData removeObjectForKey:[subFormDef.tableName stringByAppendingString:appendStr]];
      // [formPost.displayData removeObjectForKey:[subFormDef.tableName stringByAppendingString:appendStr]];
        
        [cellDataArray removeObjectAtIndex:indexPath.row];
        
        if ([cellDataArray count] == 0)
        {
            [formSectKeys removeObject:sectionKey];
            [sectionList removeObjectForKey:sectionKey];
            [sectHeaderList removeAllObjects];
            
            [formTableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationTop];
            [self performSelector:@selector(edit)];
            NSUInteger subFormIndex         = [[sectionKey stringByReplacingOccurrencesOfString:@"REPORT" withString:@""] intValue];
            NSString *subFormSectionKey     = [@"SUBFORM" stringByAppendingFormat:@"%d",subFormIndex];
            NSUInteger sectionIndex         = [formSectKeys indexOfObject:subFormSectionKey];
            NSMutableArray *cellArray       = [sectionList objectForKey:subFormSectionKey];
            FormCellDescription *cellDesc   = [cellArray objectAtIndex:0];
            [cellDesc.cellData setObject:@"NO" forKey:@"hasRow"];
            [formTableView reloadSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationNone];
        }
        else
            [formTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationTop];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath 
{
    if ([cell isKindOfClass:[ReportTVCell class]])
    {
        if (([indexPath row] % 2) )
            cell.backgroundColor            = [UIColor colorWithRed:0.745 green:0.847 blue:0.871 alpha:1.0];
        else 
            cell.backgroundColor            = [UIColor whiteColor];
    }
}

#pragma mark - Address Book Delegate Methods

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker 
{
	[self dismissModalViewControllerAnimated:YES];	
}

- (BOOL)peoplePickerNavigationController: (ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person 
{	
    NSString *firstName                     = [[NSString alloc] init];
    NSString *lastName                      = [[NSString alloc] init];
	
    firstName                               = (__bridge NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
	lastName                                = (__bridge NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);	
    NSString *concatStr                     = [firstName stringByAppendingString:@" "];
    
    if (lastName != NULL)
        concatStr                           = [concatStr stringByAppendingString:lastName];
    
    ABMultiValueRef multiPhones             = ABRecordCopyValue(person, kABPersonPhoneProperty);
    ABMultiValueRef emailRecords            = ABRecordCopyValue(person, kABPersonEmailProperty);
    
    NSString *phoneNumber                   = (__bridge NSString *)ABMultiValueCopyValueAtIndex(multiPhones, 0);
    NSString *emailId                       = (__bridge NSString *)ABMultiValueCopyValueAtIndex(emailRecords, 0);
    
    for (NSString *keyStr in [(NSMutableDictionary *)contactData allKeys]) 
    {
        NSMutableArray *contactItems        = [(NSMutableDictionary *)contactData objectForKey:keyStr];
        NSString *objStr                    = [contactItems objectAtIndex:0]; 
        
        if ([objStr isEqualToString:@"FIRST_NAME"])
            [contactItems replaceObjectAtIndex:1 withObject:firstName];
        else if ([objStr isEqualToString:@"LAST_NAME"])
            [contactItems replaceObjectAtIndex:1 withObject:lastName];
        else if ([objStr isEqualToString:@"FIRST_NAME+LAST_NAME"])
            [contactItems replaceObjectAtIndex:1 withObject:concatStr];
        else if ([objStr isEqualToString:@"EMAIL"])
            [contactItems replaceObjectAtIndex:1 withObject:emailId];
        else if ([objStr isEqualToString:@"PHONE_NO"])
            [contactItems replaceObjectAtIndex:1 withObject:phoneNumber];
    }
    
    if (tableTag == SUBFORM_TAG)
        [subFormTableView reloadData];
    else
        [formTableView reloadData];
    
    [self dismissModalViewControllerAnimated:YES];	
    return NO;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    return YES;
}

#pragma mark - Handle TextField Sliding/Scrolling 

- (void)keyboardWillHideNotification:(NSNotification *)aNotification
{
	if (textFieldAnimatedDistance == 0)
		return;
	
	CGRect viewFrame                        = self.view.frame;
	viewFrame.size.height += textFieldAnimatedDistance;
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:TextFieldAnimationDuration];
	[self.view setFrame:viewFrame];
	[UIView commitAnimations];
    
	textFieldAnimatedDistance               = 0;
}

- (void)keyboardWillShowNotification:(NSNotification *)aNotification
{
	[self keyboardWillHideNotification:nil];

	UIView *parentView                          = [cellField superview];
	while (parentView != nil && ![parentView isEqual:self.view])
	{
		parentView                              = [parentView superview];
	}
	if (parentView == nil)
		return;
	
	CGRect keyboardRect                         = CGRectZero;

	if (UIKeyboardFrameEndUserInfoKey != nil)
		keyboardRect = [self.view.superview convertRect:[[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue] fromView:nil];
	else
	{
		NSArray *topLevelViews                  = [self.view.window subviews];
		if ([topLevelViews count] == 0)
			return;
		
		UIView *topLevelView                    = [[self.view.window subviews] objectAtIndex:0];
		
		// UIKeyboardBoundsUserInfoKey is used as an actual string to avoid deprecated warnings in the compiler.

		keyboardRect                            = [[[aNotification userInfo] objectForKey:@"UIKeyboardBoundsUserInfoKey"] CGRectValue];
		keyboardRect.origin.y                   = topLevelView.bounds.size.height - keyboardRect.size.height;
		keyboardRect                            = [self.view.superview convertRect:keyboardRect fromView:topLevelView];
	}
	
	CGRect viewFrame                            = self.view.frame;
	textFieldAnimatedDistance                   = 0;
    
	if (keyboardRect.origin.y < viewFrame.origin.y + viewFrame.size.height)
	{
		textFieldAnimatedDistance               = (viewFrame.origin.y + viewFrame.size.height) - (keyboardRect.origin.y - viewFrame.origin.y);
		viewFrame.size.height                   = keyboardRect.origin.y - viewFrame.origin.y;
        
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:TextFieldAnimationDuration];
		[self.view setFrame:viewFrame];
		[UIView commitAnimations];
	}
	
    UITableView *tableView;
    
    if (tableTag == SUBFORM_TAG)
        tableView                               = subFormTableView;
    else
        tableView                               = formTableView;
    
	const CGFloat TextFieldScrollSpacing        = 40;
	CGRect textFieldRect                        = [tableView convertRect:cellField.bounds fromView:cellField];
	textFieldRect                               = CGRectInset(textFieldRect, 0, -TextFieldScrollSpacing);
    
    [tableView scrollRectToVisible:textFieldRect animated:NO];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowNotification:) 
                                                 name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHideNotification:)
                                                name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
	if (cellField)
		[self keyboardWillHideNotification:nil];
   
   // [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];  // For Reachability Change.
}

#pragma mark - TextField Delegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];	
	return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    cellField                                   = textField;
    UIView *parentOfParent                      = cellField.superview.superview;
    NSIndexPath *indexPathForCell               = nil;  
    
    if (tableTag == SUBFORM_TAG)
        indexPathForCell                        = [subFormTableView indexPathForCell:(EntryTVCell *)parentOfParent];
    else
        indexPathForCell                        = [formTableView indexPathForCell:(EntryTVCell *)parentOfParent];
    selectedIndexPath                           = indexPathForCell;
    
    if (textField.keyboardType == UIKeyboardTypeNumberPad)
    {
        MXButton *keyBoardDown                  = [[MXButton alloc] initWithFrame:CGRectMake(0, 44, 320, 200)];
        keyBoardDown.backgroundColor            = [UIColor clearColor];
        keyBoardDown.elementId                 = cellField.elementId;
        [keyBoardDown addTarget:self action:@selector(keyboardDownAtNumPad:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:keyBoardDown];
    }
}

/*
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSLog(@"Text:%@",cellField.text);    
    return YES;
}*/

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
//    NSLog(@"textFieldDidEndEditing text:%@",cellField.text);
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
	UIView *parentOfParent                      = cellField.superview.superview;
    NSMutableArray *dataArray                   = nil;
    NSString *sectionKey                        = NULL;
    NSIndexPath *indexPathForCell               = nil;  
    
	if ([parentOfParent isKindOfClass:[EntryTVCell class]])
	{
//		EntryTVCell *cell                       = (EntryTVCell *)parentOfParent;
        
        if (tableTag == SUBFORM_TAG)
        {
            indexPathForCell                    = selectedIndexPath;
            sectionKey                          = [subFormSectKeys objectAtIndex:indexPathForCell.section];
            NSMutableDictionary *subFormData    = [subFormList objectForKey:selectedSecKey];
            dataArray                           = [subFormData objectForKey:sectionKey];
        }
        else
        {   
            indexPathForCell                    = selectedIndexPath;
            sectionKey                          = [formSectKeys objectAtIndex:indexPathForCell.section];
            dataArray                           = [sectionList objectForKey:sectionKey];
        }
        
        FormCellDescription *cellDesc           = [dataArray objectAtIndex:indexPathForCell.row];
		NSMutableDictionary *rowData            = cellDesc.cellData;
		[rowData setObject:cellField.text forKey:@"value"];
        [rowData setObject:cellField.text forKey:@"displayStr"];
        [rowData setObject:@"NO" forKey:@"IsDefault"];
	}
    
    if ([cellField isEqual:textField])
        cellField                               = nil;
}

#pragma mark - Post Request

-(void) postRequest:(NSData *)postData: (BOOL) isSubmit
{	
    
    
}


#pragma mark - Network Status Methods

- (void) reachabilityChanged: (NSNotification* )note
{
	Reachability* curReach = [note object];
	[self updateNetworkStatus: curReach];
}

- (void) updateNetworkStatus:(Reachability *) curReach
{
    
    
}

#pragma mark - Clean Ups

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}


@end
