//
//  CreateOrderVC1.m
//  XMWClient
//
//  Created by dotvikios on 10/08/18.
//  Copyright © 2018 dotvik. All rights reserved.
//

#import "CreateOrderVC1.h"
#import "CreateOrderVC2.h"
#import "DotFormPostUtil.h"
#import "ClientVariable.h"

@interface CreateOrderVC1 ()

@end

@implementation CreateOrderVC1
{
    ClientVariable * clienResponse;
    NSMutableDictionary *clientMasterData;
    NSString* codeLOB;
    

}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"CreateOrderVC1 call");
    clientMasterData = [[NSMutableDictionary alloc]init];
    [clientMasterData setDictionary:[ClientVariable getInstance].CLIENT_MASTERDETAIL.masterDataRefresh];
    NSLog(@"Master Data- %@",clientMasterData);
    
    
    //set ship to and bill to dropdown field nill

    NSMutableArray  *dropDownData = [[NSMutableArray alloc]init];
    NSMutableArray *key =[[NSMutableArray alloc]init];
    NSMutableArray *value= [[NSMutableArray alloc]init];

   

    MXButton *mxbutton1 = (MXButton*)[self getDataFromId:@"SHIP_TO_button"];
    [key addObject:@""];
    [value addObject:@""];
    [dropDownData addObject:key];
    [dropDownData addObject:value];
    mxbutton1.attachedData =dropDownData;
    NSLog(@"accessoryView details %@",   [mxbutton1 description]);

    MXButton *mxbutton2 = (MXButton*)[self getDataFromId:@"BILL_TO_button"];
    [key addObject:@""];
    [value addObject:@""];
    [dropDownData addObject:key];
    [dropDownData addObject:value];
    mxbutton2.attachedData =dropDownData;
    NSLog(@"accessoryView details %@",   [mxbutton2 description]);


}
- (void)done:(SelectedListVC *)selectedListVC context:(NSString *)context code:(NSString *)code display:(NSString *)display{
    
   NSString *search= [self.mxButton.elementId stringByReplacingOccurrencesOfString:@"_button" withString:@""];
    MXTextField *dropDownField = (MXTextField *) [self getDataFromId:search];
    dropDownField.keyvalue = code;
    dropDownField.text = display;
    
    if ([dropDownField.elementId isEqualToString:@"BUSINESS_VERTICAL"]) {
        NSString *selectDropDownValue;
        selectDropDownValue= dropDownField.text;
        NSLog(@"Selected Value- %@",selectDropDownValue);
        NSLog(@"Element ID- %@",[dropDownField elementId ]);
        
        // Example 8004-Conduits
        NSString *value = selectDropDownValue;
        NSRange pos = [value rangeOfString:@"-"];
        codeLOB = [value substringToIndex:pos.location];
        NSLog(@"Code: %@",codeLOB);
        
        //set ship to and bill to dropdown field nill
        MXTextField* shiptoDropdownField = (MXTextField*)[self getDataFromId:@"SHIP_TO"];
        shiptoDropdownField.text = @"";


        NSMutableArray  *dropDownData = [[NSMutableArray alloc]init];
        NSMutableArray *key1 =[[NSMutableArray alloc]init];
        NSMutableArray *value1= [[NSMutableArray alloc]init];


        MXTextField* billtoDropdownField = (MXTextField*)[self getDataFromId:@"BILL_TO"];
        billtoDropdownField.text = @"";

        MXButton *mxbutton2 = (MXButton*)[self getDataFromId:@"BILL_TO_button"];
        [key1 addObject:@""];
        [value1 addObject:@""];
        [dropDownData addObject:key1];
        [dropDownData addObject:value1];
        mxbutton2.attachedData =dropDownData;
        NSLog(@"dropdownfield details %@",   [billtoDropdownField description]);
        NSLog(@"accessoryView details %@",   [mxbutton2 description]);
        
       
    }
  else if ([dropDownField.elementId isEqualToString:@"SHIP_TO"]) {
        MXTextField* billtoDropdownField = (MXTextField*)[self getDataFromId:@"BILL_TO"];
        billtoDropdownField.text = @"";
    }
    
    [self setData:codeLOB :[dropDownField elementId ]];
    
    
    
}

-(void)setData:(NSString*)code :(NSString *)elementID{
   
    if([elementID isEqualToString :@"BUSINESS_VERTICAL"])
    {
        NSMutableArray *array = [[NSMutableArray alloc]init];
        NSString *SHIP_TO = [[@"SHIP_TO"stringByAppendingString:@"_"]stringByAppendingString:code];
        NSLog(@"%@",SHIP_TO);
        [array addObjectsFromArray:[clientMasterData valueForKey:SHIP_TO]];
        
        MXButton *mxbutton = (MXButton*)[self getDataFromId:@"SHIP_TO_button"];
        mxbutton.attachedData =  [self shortListAccordingToSelectData:array];
        
        [self setObjectIndexAt0Data:[self shortListAccordingToSelectData:array] :@"SHIP_TO"];

        NSLog(@"dropdownfield details %@",   [mxbutton description]);
        
        
    }
    else if ([elementID isEqualToString :@"SHIP_TO"])
    {
        NSMutableArray *array = [[NSMutableArray alloc]init];
        NSString *BILL_TO = [[@"BILL_TO"stringByAppendingString:@"_"]stringByAppendingString:code];
        NSLog(@"%@",BILL_TO);
        [array addObjectsFromArray:[clientMasterData valueForKey:BILL_TO]];
        
        MXButton *mxbutton = (MXButton*)[self getDataFromId:@"BILL_TO_button"];
        mxbutton.attachedData =[self shortListAccordingToSelectData:array];
        
        [self setObjectIndexAt0Data:[self shortListAccordingToSelectData:array] :@"BILL_TO"];

        NSLog(@"accessoryView details %@",   [mxbutton description]);
    }
}

-(NSArray*)shortListAccordingToSelectData:(NSArray*)array{
    NSMutableArray  *dropDownData = [[NSMutableArray alloc]init];
    NSMutableArray *key =[[NSMutableArray alloc]init];
    NSMutableArray *value= [[NSMutableArray alloc]init];
    for ( int i=0 ; i < array.count; i++) {
        
        [key addObject:[[array objectAtIndex:i] objectAtIndex:0]];
        [value addObject:[[array objectAtIndex:i] objectAtIndex:1]];
        
    }
    [dropDownData addObject:key];
    [dropDownData addObject:value];
    
    
    return dropDownData;
}
-(void)setObjectIndexAt0Data:(NSArray*)data :(NSString*)elementID{
    if ([elementID isEqualToString:@"SHIP_TO"]) {
                MXTextField* shiptoDropdownField = (MXTextField*)[self getDataFromId:@"SHIP_TO"];
                shiptoDropdownField.text = [[data objectAtIndex:1]objectAtIndex:0];
        [self setData:codeLOB :@"SHIP_TO"];
    }
    
    if ([elementID isEqualToString:@"BILL_TO"]) {
        MXTextField* billtoDropdownField = (MXTextField*)[self getDataFromId:@"BILL_TO"];
        billtoDropdownField.text = [[data objectAtIndex:1]objectAtIndex:0];
    }
    
    
}

@end
