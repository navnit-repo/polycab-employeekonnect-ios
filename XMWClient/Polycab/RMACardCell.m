//
//  RMACardCell.m
//  XMWClient
//
//  Created by dotvikios on 24/09/18.
//  Copyright © 2018 dotvik. All rights reserved.
//

#import "RMACardCell.h"
#import "LayoutClass.h"
#import "MXButton.h"
#import "SelectedListVC.h"
#import "RMAVC2.h"
#import "FormVC.h"

@implementation RMACardCell
{
    SelectedListVC * selectedListVC;
    NSArray *keys;
    NSArray *values;
}


+ (RMACardCell *)createInstance{
    RMACardCell *view = (RMACardCell *) [[[NSBundle mainBundle] loadNibNamed:@"RMACardCell" owner:self options:nil]objectAtIndex:0];
    return view;
}
@synthesize reasonForReturnTextField;
-(void)autoLayout{
    [LayoutClass setLayoutForIPhone6:self.constantView1];
    [LayoutClass setLayoutForIPhone6:self.constantView2];
    [LayoutClass labelLayout:self.constantView3 forFontWeight:UIFontWeightRegular];
    [LayoutClass labelLayout:self.constantView5 forFontWeight:UIFontWeightRegular];
    [LayoutClass labelLayout:self.constantView7 forFontWeight:UIFontWeightRegular];
    [LayoutClass labelLayout:self.constantView9 forFontWeight:UIFontWeightRegular];
    [LayoutClass labelLayout:self.constantView11 forFontWeight:UIFontWeightRegular];
    
    
  
    
    [LayoutClass textfieldLayout:self.constantView4 forFontWeight:UIFontWeightRegular];
    [LayoutClass textfieldLayout:self.constantView6 forFontWeight:UIFontWeightRegular];
    [LayoutClass textfieldLayout:self.constantView8 forFontWeight:UIFontWeightRegular];
    [LayoutClass textfieldLayout:self.constantView10 forFontWeight:UIFontWeightRegular];
    [LayoutClass textfieldLayout:self.costantView12 forFontWeight:UIFontWeightRegular];
   
    
   
    [LayoutClass setLayoutForIPhone6:self.costantView13];
    [self.costantView13 addTarget:self action:@selector(dropDownPressed) forControlEvents:UIControlEventTouchUpInside];

}
-(void)dropDownPressed{
    [self.delegate cellTag:self :self.tag];
}
- (void)configCellBlankCard:(int)tag{
    [self autoLayout];
    
    NSMutableArray  *dropDownData = [[NSMutableArray alloc]init];
    
    NSMutableDictionary *rmaReason = [[NSMutableDictionary alloc]init];
    [rmaReason setDictionary:[[NSUserDefaults standardUserDefaults]valueForKey:@"RMA_REASON"]];

    
    keys= [rmaReason allKeys];
    values =[rmaReason allValues];
    
    [dropDownData addObject:keys];
    [dropDownData addObject:values];
    
    self.mxButton.attachedData = dropDownData;
    self.mxButton.elementId = @"RMA_REASON_button";
    self.reasonForReturnTextField.elementId = @"RMA_REASON";
    
    self.reasonForReturnTextField.delegate= self;
    self.productCategoryTextField.delegate = self;
    self.skuCodeTextField.delegate= self;
    self.quantityTextField.delegate = self;
    self.polycabInvoiceTextField.delegate= self;
    
    
    self.reasonForReturnTextField.text = @"";
    self.productCategoryTextField.text = @"";
    self.skuCodeTextField.text = @"";
    self.quantityTextField.text = @"";
    self.polycabInvoiceTextField.text = @"";
    
    self.crossButton.tag = tag;
    [self.crossButton addTarget:self action:@selector(buttonHandler:) forControlEvents:UIControlEventTouchUpInside];
    

    self.productCategoryTextField.userInteractionEnabled= YES;
    self.reasonForReturnTextField.userInteractionEnabled= NO;
    self.skuCodeTextField.userInteractionEnabled= YES;
    self.quantityTextField.userInteractionEnabled= YES;
    self.polycabInvoiceTextField.userInteractionEnabled= YES;
    
}
- (void)configCell:(NSDictionary *)data :(NSString *)invoiceNO :(int)tag{
    [self autoLayout];
    
    NSMutableArray  *dropDownData = [[NSMutableArray alloc]init];
    keys= [[[NSUserDefaults standardUserDefaults]valueForKey:@"RMA_REASON"] allKeys];
    values =[[[NSUserDefaults standardUserDefaults]valueForKey:@"RMA_REASON"] allValues];
    
    [dropDownData addObject:keys];
    [dropDownData addObject:values];

    self.mxButton.attachedData = dropDownData;
    self.mxButton.elementId = @"RMA_REASON_button";
    self.reasonForReturnTextField.elementId = @"RMA_REASON";
    
    reasonForReturnTextField.delegate = self;
    self.reasonForReturnTextField.text = @"";
    
    self.productCategoryTextField.text = [data valueForKey:@"BU_GROUP"];
    self.skuCodeTextField.text = [data valueForKey:@"ITEM_CODE"];
  
    self.quantityTextField.text = [data valueForKey:@"QUANTITY"];

    self.polycabInvoiceTextField.text = invoiceNO;
    
    self.crossButton.tag = tag;
    [self.crossButton addTarget:self action:@selector(buttonHandler:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(IBAction)buttonHandler:(id)sender{
    
    [self.delegate crossButtonHandler:self :[sender tag]];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return true;
}

-(void) deleteView:(NSNotification*) notification
{
    CGFloat yAxis = [[notification.object valueForKey:@"yAxis"] floatValue];
    CGFloat height = [[notification.object  valueForKey:@"height"] floatValue];
    if (self.frame.origin.y > yAxis) {
         self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y-height, self.frame.size.width, self.frame.size.height);
        self.tag = self.tag-1;
        self.crossButton.tag = self.crossButton.tag-1;
        NSLog(@"Updated card View Tag : %ld",self.tag);
    }

}
@end
