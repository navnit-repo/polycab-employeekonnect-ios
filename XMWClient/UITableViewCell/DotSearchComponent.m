//
//  DotSearchComponent.m
//  QCMSProject
//
//  Created by Ashish Tiwari on 21/06/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//

#import "DotSearchComponent.h"
#import "ClientVariable.h"
#import "XmwcsConstant.h"
#import "XmwUtils.h"
#import "MXRadioButtonGroup.h"
#import "RadioGroup.h"
#import "RadioButton.h"
#import "DVAppDelegate.h"




NSString *const DotSearchConst_POP_SEARCH_BUTTON_ID = @"POP_SEARCH_BUTTON_ID";
NSString *const DotSearchConst_SEARCH_TEXT_FIELD_ID = @"SEARCH_TEXT_FIELD_ID";
NSString *const DotSearchConst_SEARCH_TEXT = @"SEARCH_TEXT";
NSString *const DotSearchConst_SEARCH_BY = @"SEARCH_BY";
NSString *const DotSearchConst_SEARCH_MASTER_ID = @"";


@implementation DotSearchComponent

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


-(void) showSearchScreen : (FormVC *) form : (NSString *) title : (NSString *) searchBy : (NSString *) id : (NSString*) masterValueMapping

{
    
  NSString *const DotSearchConst_SEARCH_MASTER_ID = masterValueMapping;
    //Transition transitionSelection = CommonTransitions.createSlide(CommonTransitions.SLIDE_VERTICAL, false, 1000);
    //final Dialog  searchDialog = new Dialog(title);
   // searchDialog.setTransitionInAnimator(transitionSelection);
           
   // DotTextField dotTextField = new DotTextField("", SEARCH_TEXT_FIELD_ID,StyleConstant.SCREEN_WIDTH);
    
    //form.putToDataIdMap(dotTextField, SEARCH_TEXT_FIELD_ID);
    //searchDialog.addComponent(dotTextField);
    
    MXRadioButtonGroup *buttonGroup  = [[MXRadioButtonGroup alloc] init];
    //ButtonGroup buttonGroup  = new ButtonGroup();
    NSMutableArray *groupObjectData = (NSMutableArray *) [self  getRadioGroupData : searchBy];
    NSMutableArray *arrayOfRadioKey = [groupObjectData objectAtIndex:0] ;
    NSMutableArray *arrayOfRadioValue = [groupObjectData objectAtIndex:1] ;
    [self addRadioGroup : searchBy :  id];
    
    /*    //String [] arrayOfRadioValue = (String[]) groupObjectData[1];
    for(int cntRadio = 0; cntRadio < arrayOfRadioKey.count ; cntRadio++) {
        [self ad
        //RadioButton *elementRadio = [RadioButton alloc]init (arrayOfRadioValue[cntRadio], "", arrayOfRadioKey[cntRadio]);
        //searchDialog.addComponent(elementRadio);
        [buttonGroup add : elementRadio ];
        buttonGroup.add(elementRadio);
    }
    
    DotButton dotButton = new DotButton(XmwUtils.getLanguageConstant(LanguageConstant.SEARCH),POP_SEARCH_BUTTON_ID,null);
    MyStyle.getButtonStyle(dotButton);
    dotButton.addActionListener(form);
    
    //searchDialog.addComponent(dotButton);
    //searchDialog.show();
    //dotButton.addActionListener(form);
    */
    
}

-(void)addRadioGroup : (NSString *) searchBy : (NSString *) id
{
	//QList< QStringList* >* groupObjectData = getRadioGroupData(searchBy);
     NSMutableArray *groupObjectData = (NSMutableArray *) [self  getRadioGroupData : searchBy];
	//QStringList* arrayOfRadioKey = groupObjectData->at(0);
	//QStringList* arrayOfRadioValue = groupObjectData->at(1);
    NSMutableArray *arrayOfRadioKey = [groupObjectData objectAtIndex:0] ;
    NSMutableArray *arrayOfRadioValue = [groupObjectData objectAtIndex:1] ;
    
    //m_dotRadioGroup = new DotRadioGroup();
     RadioGroup *elementRadio = [[RadioGroup alloc]init];
       
    for(int cntRadio = 0; cntRadio <[arrayOfRadioKey count] ; cntRadio++)
    {
    
        RadioButton *elementRadio = [[RadioButton alloc]initWithFrame:CGRectMake(10, 20, 100, 100) :TRUE :2];
        [elementRadio addSubview:elementRadio];
        //	m_dotRadioGroup->add(Option::create().text(arrayOfRadioValue->at(cntRadio)));
	}
    
    
	//m_dotRadioGroup->setId(QString("SEARCH_").append(id));
   // m_dotRadioGroup->setAttachedData(QVariant(*arrayOfRadioKey));
    //[elementRadio.att
	//contentContainer->add(m_dotRadioGroup);
	//delete arrayOfRadioKey;
	//delete arrayOfRadioValue;
	//delete groupObjectData;
    
}




-(NSMutableArray *) getRadioGroupData : (NSString *) groupName
{
    ClientVariable *clientVariables = [ClientVariable getInstance:[DVAppDelegate currentModuleContext]];
    NSMutableDictionary *searchGroupMap = (NSMutableDictionary *) [clientVariables.CLIENT_APP_MASTER_DATA   objectForKey : XmwcsConst_DE_SEARCH_GROUP];
                                                                 
    NSMutableArray  *breakGroupVec =  (NSMutableArray *) [XmwUtils breakStringTokenAsVector:groupName :@"$"];
               
    if (XmwcsConst_IS_DEBUG)
    {
       
    }
    NSMutableArray * groupData = [[NSMutableArray alloc] initWithCapacity: 2];
   
    // breakGroupVec.size()
    
    NSMutableArray * groupKey = [[NSMutableArray alloc] initWithCapacity: breakGroupVec.count];
    NSMutableArray * groupValue = [[NSMutableArray alloc] initWithCapacity: breakGroupVec.count];
    
    for (int cntGroup = 0; cntGroup < [breakGroupVec count]; cntGroup++) {
        NSString* key = [breakGroupVec objectAtIndex:cntGroup];
        NSString* value = [searchGroupMap  objectForKey: key ];
        if (value != nil) {
            [groupKey insertObject:key atIndex:cntGroup];
            [groupValue insertObject:value atIndex:cntGroup];
        }
    }
    
    [groupData insertObject:groupKey atIndex:0];
    [groupData insertObject:groupValue atIndex:1];
    
    return groupData;
}




@end
