//
//  DocumentScreenController.m
//  QCMSProject
//
//  Created by Ashish Tiwari on 08/10/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//

#import "DocumentScreenController.h"
#import "ClientVariable.h"
#import "DVAppDelegate.h"
#import "RecentRequestStorage.h"
#import "ClientUserLogin.h"
#import "JSONDataExchange.h"
#import "DotFormElement.h"
#import "XmwUtils.h"
#import "XmwcsConstant.h"
#import "MXButton.h"
#import "SBJson.h"
#import "DocPostResponse.h"
#import "DotFormPostUtil.h"

@interface DocumentScreenController ()

@end

@implementation DocumentScreenController
@synthesize screenId;
@synthesize maxDocId;
@synthesize docDataMap;
@synthesize dotFormPost;
@synthesize dotFormId;
@synthesize dotForm;
@synthesize parentForm;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)initwithData : (int)id : (int)docId : (RecentRequestController*)parentScreen
{
    yargufortable = 60;
    self.screenId = id;
    self.maxDocId = docId;
    self.parentForm = parentScreen;
    formContainer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
    ClientVariable* clientVariables = [ClientVariable getInstance : [DVAppDelegate currentModuleContext]];
    
	RecentRequestStorage* storage = [RecentRequestStorage getInstance];
    docDataMap = [storage getMaxDocIdDocumentAsMap:clientVariables.CLIENT_USER_LOGIN.userName :clientVariables.CLIENT_USER_LOGIN.moduleId :self.maxDocId];
    
}

- (void)viewDidLoad
{
    [self loadData];
    [self screenDisplay];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)loadData
{
    ClientVariable* clientVariables = [ClientVariable getInstance :[DVAppDelegate currentModuleContext]];
    dotFormId = [docDataMap objectForKey:XmwcsConst_RECENT_REQ_FORM_ID];
    status = [docDataMap objectForKey:XmwcsConst_RECENT_REQ_STATUS];
    NSString* postedData = [docDataMap objectForKey:@"dotFormPost"];
	
    
    SBJsonParser* sbParser = [[SBJsonParser alloc] init];
    id postedVariantMap = [sbParser objectWithString :postedData];
    id variantObj = [JSONDataExchange convertFromJsonObject:postedVariantMap];
   	dotFormPost = variantObj;
	
	   
    variantObj = [clientVariables.DOT_FORM_MAP objectForKey:dotFormId];
    dotForm = variantObj;
	   
}
-(void)screenDisplay
{
   
    if([dotForm.formSubType isEqualToString:XmwcsConst_DF_FORM_TYPE_ADD_ROW])
    {
		[self addTable];
        [self addDisplayRow:@"Tracker No" :[docDataMap objectForKey:XmwcsConst_RECENT_REQ_TRACER_NO]];
        [self addDisplayRow:@"Submitted Date" : [docDataMap objectForKey:XmwcsConst_RECENT_REQ_DOC_SUBMIT_DATE]];
        [self addDisplayRow:@"Submitted Message" :[docDataMap objectForKey:XmwcsConst_RECENT_REQ_DOC_SUBMIT_MESSAGE]];
	}
    else
    {
		[self drawDocument];
	}

    [self.view addSubview:formContainer];
}
-(void)drawDocument
{
    self.title = dotForm.screenHeader;
    NSMutableDictionary* elements = dotForm.formElements;
    DotFormDraw* dotFormDraw = [[DotFormDraw alloc]init];
    NSMutableArray* keySortList = [DotFormDraw sortFormComponents:elements];
    
    for(int i=0; i<[keySortList count]; i++)
    {
         NSString* elementId = (NSString*)[keySortList objectAtIndex:i];
        DotFormElement *dotFormElement = [elements objectForKey:elementId];
         NSString* leftLabel = dotFormElement.displayText;
        
        bool mandatory = [dotFormElement isOptionalBool];
        
        NSString* valueSetToLabel = [dotFormPost.postData objectForKey:dotFormElement.elementId];
        
        if(![dotFormElement.componentType isEqualToString:XmwcsConst_DE_COMPONENT_BUTTON] && ![dotFormElement.componentType isEqualToString:XmwcsConst_DE_COMPONENT_LABEL])
        {
            if(mandatory) {
                [self addDisplayRow : [@"*" stringByAppendingString:leftLabel] : valueSetToLabel];
               
            } else {
                [self addDisplayRow:leftLabel :valueSetToLabel];
                
            }
        }
        
     }
    [self addDisplayRow:@"Tracker No" :[docDataMap objectForKey:XmwcsConst_RECENT_REQ_TRACER_NO]];
    [self addDisplayRow:@"Submitted Date" : [docDataMap objectForKey:XmwcsConst_RECENT_REQ_DOC_SUBMIT_DATE]];
    [self addDisplayRow:@"Submitted Message" :[docDataMap objectForKey:XmwcsConst_RECENT_REQ_DOC_SUBMIT_MESSAGE]];
   
    if([status isEqualToString:@""])
    {
        
        UIImage *blueImage          = [UIImage imageNamed:@"blueButton.png"];
        UIImage *blueButtonImage    = [blueImage stretchableImageWithLeftCapWidth:12 topCapHeight:0];
        UIButton *resubmitButton       = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [resubmitButton setFrame:CGRectMake( 72.0f, 400.0f, 180.0f, 36.0f)];
        [resubmitButton setBackgroundImage:blueButtonImage forState:UIControlStateNormal];
        [resubmitButton setTitleColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0] forState: UIControlStateNormal];
        [resubmitButton setTitle:@"Resubmit" forState:UIControlStateNormal];
        [resubmitButton addTarget:self action:@selector(ReSubmitButton:) forControlEvents:UIControlEventTouchUpInside];

        
        UIView* elementContainer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
        [elementContainer addSubview:resubmitButton];
        [formContainer addSubview:elementContainer];
       
    }
}
    
-(void)addTable
{
    NSMutableDictionary* dotElements = dotForm.formElements;
    
    NSArray* addRowCol =  [XmwUtils breakStringTokenAsVector:dotForm.addRowColumn :@"$"];
    //QStringList* rowData = new QStringList();
    NSMutableArray* rowData = [[NSMutableArray alloc]init];
    //NSArray* headerWidthList = [[NSArray alloc]init];
    float headerWidthList;
    for(int i=0; i< [addRowCol count]; i++)
    {
        NSString* key = (NSString*)[addRowCol objectAtIndex:i];
        DotFormElement* dotFormElement = [dotElements objectForKey:key];
        
        if ([dotFormElement isComponentDisplayBool])
        {
            [rowData addObject:dotFormElement.displayText];
            int columnWidth = 320/[addRowCol count];
             headerWidthList = columnWidth;
        }
        
       
    }
    
    NSLog(@"multiple row selected");
    [self insertRow : rowData : true : headerWidthList];
    int maxRows = [[dotFormPost.displayData objectForKey:dotForm.tableName] intValue];
    
    for(int i=0; i<maxRows; i++)
    {
        NSString* appendString = [[NSString alloc] initWithFormat:@":%d", i ];
        
        if([dotFormPost.postData objectForKey:appendString]!= dotFormPost.postData)
        {
            if([[dotFormPost.postData objectForKey: appendString]isEqualToString:@"row added"])
            {
                [self drawRowsForTable : i :headerWidthList];
            }
            
        }
    }
    
    
    if([status isEqualToString:@""])
    {
       
        UIImage *blueImage          = [UIImage imageNamed:@"blueButton.png"];
        UIImage *blueButtonImage    = [blueImage stretchableImageWithLeftCapWidth:12 topCapHeight:0];
        UIButton *resubmitButton       = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [resubmitButton setFrame:CGRectMake( 72.0f, 400.0f, 180.0f, 36.0f)];
        [resubmitButton setBackgroundImage:blueButtonImage forState:UIControlStateNormal];
        [resubmitButton setTitleColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0] forState: UIControlStateNormal];
        [resubmitButton setTitle:@"Resubmit" forState:UIControlStateNormal];
        [resubmitButton addTarget:self action:@selector(ReSubmitButton:) forControlEvents:UIControlEventTouchUpInside];
        
       // connect(resubmitButton, SIGNAL(clicked()), this, SLOT(onOkClicked()));
        UIView* elementContainer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
        [elementContainer addSubview:resubmitButton];
        [formContainer addSubview:elementContainer];
        
    }
}

-(void)addDisplayRow : (NSString*) leftLabel :  (NSString*) rightText
{
    
    UIView* elementContainer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
    UILabel* leftTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, yargufortable, 320/2, 30)];
    leftTitle.text = leftLabel;
    [elementContainer addSubview:leftTitle];
    
    UILabel* rightValue = [[UILabel alloc]initWithFrame:CGRectMake(320/2, yargufortable, 320/2, 30)];
    rightValue.text = rightText;
    [elementContainer addSubview:rightValue];
    
    [formContainer addSubview:elementContainer];
    yargufortable = yargufortable+30;
    
}
-(void)insertRow : (NSMutableArray*) data : (BOOL)isHeader : (float)headerWidthList
{
    
    UIView* contentContainer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
    for(int j=0; j<[data count]; j++)
    {
        int placeHolderWidth = headerWidthList;
         UIView* placeHolder = [[UIView alloc]initWithFrame:CGRectMake(0, yargufortable, placeHolderWidth, 480)];
        if(isHeader){
            UILabel* textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, yargufortable, placeHolderWidth, 30)];
            textLabel.text = [data objectAtIndex:j];
            NSString* teststring =textLabel.text;//for data check
            [placeHolder addSubview:textLabel];
            
            // set different color
        }else{
            UILabel* textArea = [[UILabel alloc]initWithFrame:CGRectMake(0, yargufortable, placeHolderWidth, 30)];
            textArea.text = [data objectAtIndex:j];
            [placeHolder addSubview:textArea];
        }
        
        [contentContainer addSubview:placeHolder];
        yargufortable = yargufortable+30;
    }
   [formContainer addSubview:contentContainer];
}

-(void)drawRowsForTable : (int) rowNo : (float)headerWidthList
{
     NSArray* addRowCol = [XmwUtils breakStringTokenAsVector:dotForm.addRowColumn :@"$"];
     NSMutableDictionary* dotElements = dotForm.formElements;
    
    NSMutableArray* rowData = [[NSMutableArray alloc]init];
    
    for (int j = 0; j < [addRowCol count]; j++)
    {
        NSString* key = [addRowCol objectAtIndex:j];
        DotFormElement* dotFormElement = [dotElements objectForKey:key];
        
        if([dotFormElement isComponentDisplayBool])
        {
            NSString* appendString = dotFormElement.elementId;
            
            if([dotFormPost.postData objectForKey:appendString]!= dotFormPost.postData)
            {
                // to cover case when form submitted without adding a row.
                if(rowNo==1) {
                    [rowData addObject:[dotFormPost.displayData objectForKey:appendString]];
                    }
            }
            else
            {
                [appendString stringByAppendingFormat:@":%d",rowNo];
                [rowData addObject:[dotFormPost.displayData objectForKey:appendString]];
            }
            
        }
    }
    [self insertRow:rowData :false : headerWidthList];
    
}

-(IBAction)ReSubmitButton:(id)sender
{
    loadingView = [LoadingView loadingViewInView:self.view];
    NetworkHelper* networkHelper = [[NetworkHelper alloc] init];
    [networkHelper makeXmwNetworkCall:dotFormPost :self : nil : XmwcsConst_CALL_NAME_FOR_SUBMIT];
    
    
}
- (void) httpResponseObjectHandler : (NSString*) callName : (id) respondedObject : (id) requestedObject
{
    [loadingView removeFromSuperview];
    
    if([callName isEqualToString:XmwcsConst_CALL_NAME_FOR_SUBMIT])
    {
        DocPostResponse* docPostResponse = (DocPostResponse*) respondedObject;
        NSString* message = docPostResponse.submittedMessage;
        NSString* displayMessage = @"";
        DotFormPostUtil* dotFormPostUtil = [[DotFormPostUtil alloc]init];
       [dotFormPostUtil storeRecentRequest:dotForm :dotFormPost :docPostResponse :true];
        
        
       /* if(message.indexOf('$')>-1) {
            QStringList list = message.split("$", QString::SkipEmptyParts);
            for(int i=0; i<list.count();i++) {
                if(list.at(i).compare("null", Qt::CaseInsensitive) !=0) {
                    displayMessage.append(QString::number(i, 10));
                    displayMessage.append(". ");
                    displayMessage.append(list.at(i));
                    displayMessage.append("\n");
                }
            }
        } else {
            displayMessage = message;
        }*/
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Server Response!" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
        [myAlertView show];
        
    }
    
    
}
@end
