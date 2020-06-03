//
//  CreateOrderDisplayCell.m
//  XMWClient
//
//  Created by dotvikios on 21/08/18.
//  Copyright © 2018 dotvik. All rights reserved.
//

#import "CreateOrderDisplayCell.h"
#import "LayoutClass.h"
#import "CreateOrderVC2.h"
#import "SWRevealViewController.h"
@implementation CreateOrderDisplayCell
{
    NSArray* packSizeFeatureVerticals;
}


@synthesize titleLbl,descriptionLbl,cancelButton,valueTxtFld,measurementLbl,priceLabel,mainDescLbl,packSizeLabel,dividerLine;

+ (CreateOrderDisplayCell *)CreateInstance{
    CreateOrderDisplayCell *view = (CreateOrderDisplayCell *) [[[NSBundle mainBundle] loadNibNamed:@"CreateOrderDisplayCell" owner:self options:nil] objectAtIndex:0];
    return view;
}

-(void)autoLayout{
    [LayoutClass setLayoutForIPhone6:self.mainView];
    [LayoutClass labelLayout:self.titleLbl forFontWeight:UIFontWeightBold];
    [LayoutClass labelLayout:self.descriptionLbl forFontWeight:UIFontWeightRegular];
    [LayoutClass labelLayout:self.mainDescLbl forFontWeight:UIFontWeightRegular];
    [LayoutClass textfieldLayout:self.valueTxtFld forFontWeight:UIFontWeightRegular];
    [LayoutClass setLayoutForIPhone6:self.cancelButton];
    [LayoutClass labelLayout:self.measurementLbl forFontWeight:UIFontWeightRegular];
    [LayoutClass labelLayout:self.priceLabel forFontWeight:UIFontWeightBold];
    [LayoutClass setLayoutForIPhone6:self.dividerLine];
    [LayoutClass labelLayout:self.packSizeLabel forFontWeight:UIFontWeightBold];
    UIToolbar *keyboardDoneButtonView = [[UIToolbar alloc] init];
    [keyboardDoneButtonView sizeToFit];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStyleBordered target:self
                                                                  action:@selector(doneClicked:)];
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:doneButton, nil]];
    valueTxtFld.inputAccessoryView = keyboardDoneButtonView;
    [valueTxtFld addTarget:self
                    action:@selector(textFieldDidChange:)
          forControlEvents:UIControlEventEditingChanged];
    
    
    packSizeFeatureVerticals = @[@"PP & Flexibles", @"Fan and Appliances", @"Lighting And Luminary", @"Switches", @"Switchgear", @"Dowells" , @"Lighting", @"Luminary"];
       
       // // Tushar, For PP & Flexibles
       // Pradeep,
       // Fan and Appliances,
       // Lighting And Luminary, Switches, Switchgear,
       // and Dowells
    
}
- (IBAction)doneClicked:(id)sender
{
     [self.delegate textFieldValue:self.valueTxtFld :self.cancelButton.tag];
    NSLog(@"Done Clicked.");
    [self endEditing:YES];
    
   
    
}


- (void)configure:(NSArray *)array :(long)buttonTag :(NSString *)verticalName :(NSString *)quntyValue
{
    if (array!=nil) {
        [self autoLayout];
        self.valueTxtFld.delegate = self;
        NSLog(@"Display Field :%@",array);
        NSString *isCodeStr =[array objectAtIndex:11];
        
        if ([verticalName isEqualToString:@"Cables"]) {
            if ([isCodeStr isEqualToString:@"NA"] || isCodeStr ==nil || [isCodeStr isKindOfClass:[NSNull class]]) {
                self.titleLbl.text = [array objectAtIndex:0];
            }
            else{
                self.titleLbl.text = [[[[[array objectAtIndex:0] stringByAppendingString:@" "] stringByAppendingString:@"/"] stringByAppendingString:@" "] stringByAppendingString:[array objectAtIndex:11]];
            }
        }
        else
        {
            self.titleLbl.text = [array objectAtIndex:0];
        }
        
        
        self.valueTxtFld.text = quntyValue;
        
        self.measurementLbl.text = [array objectAtIndex:3];
        self.descriptionLbl.text = [[[[[[[[[[[[[[[array objectAtIndex:1]stringByAppendingString:@" "]stringByAppendingString:[array objectAtIndex:2]]stringByAppendingString:@" "]stringByAppendingString:[array objectAtIndex:3]]stringByAppendingString:@" "]stringByAppendingString:[array objectAtIndex:4]]stringByAppendingString:@" "]stringByAppendingString:[array objectAtIndex:5]]stringByAppendingString:@" "]stringByAppendingString:[array objectAtIndex:6]]stringByAppendingString:@" "]stringByAppendingString:[array objectAtIndex:7]]stringByAppendingString:@" "] stringByAppendingString:[array objectAtIndex:8]];
        
        
        self.priceLabel.text =[NSString stringWithFormat:@"Price: %@",[array objectAtIndex:9]];
        self.mainDescLbl.text =[array objectAtIndex:10];
        self.cancelButton.tag = buttonTag;
        [self.cancelButton setImage:[UIImage imageNamed:@"crossicon.png"] forState:UIControlStateNormal];
        self.cancelButton.contentMode = UIViewContentModeCenter;
        self.cancelButton.tintColor = [UIColor blackColor];
        [self.cancelButton addTarget:self action:@selector(setCancelButtonHandler) forControlEvents:UIControlEventTouchUpInside];
        
        
        // Tushar, For PP & Flexibles
        // Pradeep,
        // Fan and Appliances,
        // Lighting And Luminary, Switches, Switchgear,
        // and Dowells
        
        if ([packSizeFeatureVerticals containsObject:verticalName]) {
                    NSInteger  packSize = [array[array.count - 1] integerValue];
            if (packSize > 0) {
                self.packSizeLabel.text = [NSString stringWithFormat:@"Pack Size: %@",array[array.count - 1]];
                
                self.valueTxtFld.elementId = verticalName;
                self.valueTxtFld.attachedData = array[array.count - 1];
            }
            else
            {
                // remove devider line and pack size label
                
                [self.dividerLine removeFromSuperview];
                [self.packSizeLabel removeFromSuperview];
                
            }
        }
        
        else
        {
            // remove devider line and pack size label
            
            [self.dividerLine removeFromSuperview];
            [self.packSizeLabel removeFromSuperview];
        }

        
        
        [self setHeightAllField:titleLbl :titleLbl.text];
        [self setHeightAllField:descriptionLbl :descriptionLbl.text];
        [self setHeightAllField:mainDescLbl :mainDescLbl.text];
        [self setAllfieldYAxis];
        
    }
    else{
        NSLog(@"NO Display Field Found");
    }
}
-(void)setHeightAllField :(UILabel *)lbl :(NSString *)lblText
{
    CGSize maximumLabelSize = CGSizeMake(lbl.frame.size.width, FLT_MAX);
    
    CGSize expectedLabelSize = [lblText sizeWithFont:lbl.font constrainedToSize:maximumLabelSize lineBreakMode:lbl.lineBreakMode];
    
    //adjust the label the the new height.
    CGRect newFrame = lbl.frame;
    newFrame.size.height = expectedLabelSize.height;
    lbl.frame = newFrame;
}

-(void)setAllfieldYAxis
{
    titleLbl.frame = CGRectMake(titleLbl.frame.origin.x, titleLbl.frame.origin.y, titleLbl.frame.size.width, titleLbl.frame.size.height);
    
    descriptionLbl.frame = CGRectMake(descriptionLbl.frame.origin.x, titleLbl.frame.origin.y + titleLbl.frame.size.height+2, descriptionLbl.frame.size.width, descriptionLbl.frame.size.height);
    
    mainDescLbl.frame = CGRectMake(mainDescLbl.frame.origin.x,descriptionLbl.frame.origin.y +descriptionLbl.frame.size.height+2, mainDescLbl.frame.size.width, mainDescLbl.frame.size.height);
    
    
    
    float widthIs =
 [self.priceLabel.text
  boundingRectWithSize:self.priceLabel.frame.size
  options:NSStringDrawingUsesLineFragmentOrigin
  attributes:@{ NSFontAttributeName:self.priceLabel.font }
  context:nil]
   .size.width;
    
    priceLabel.frame = CGRectMake(priceLabel.frame.origin.x,mainDescLbl.frame.origin.y + mainDescLbl.frame.size.height+5, widthIs, priceLabel.frame.size.height);
    
    dividerLine.frame = CGRectMake(priceLabel.frame.origin.x + widthIs + 5,priceLabel.frame.origin.y, 1, dividerLine.frame.size.height);

    packSizeLabel.frame = CGRectMake(dividerLine.frame.origin.x + 6 ,mainDescLbl.frame.origin.y + mainDescLbl.frame.size.height+5, packSizeLabel.frame.size.width, packSizeLabel.frame.size.height);
    
    
    valueTxtFld.frame = CGRectMake(valueTxtFld.frame.origin.x, priceLabel.frame.origin.y-3, valueTxtFld.frame.size.width, valueTxtFld.frame.size.height);
    
    measurementLbl.frame = CGRectMake(measurementLbl.frame.origin.x, valueTxtFld.frame.origin.y+3, measurementLbl.frame.size.width, measurementLbl.frame.size.height);
    
    cancelButton.frame = CGRectMake(cancelButton.frame.origin.x, descriptionLbl.frame.origin.y, cancelButton.frame.size.width, cancelButton.frame.size.width);
    
    
   float createOrderDynamicCellHeight =titleLbl.frame.size.height+descriptionLbl.frame.size.height+mainDescLbl.frame.size.height+priceLabel.frame.size.height+20;
    self.mainView.frame =CGRectMake(self.mainView.frame.origin.x, self.mainView.frame.origin.y, self.mainView.frame.size.width, createOrderDynamicCellHeight);
    

}


-(void)setCancelButtonHandler{
    NSLog(@"%ld",self.cancelButton.tag);
    [self.delegate buttonDelegate:self.cancelButton.tag];

}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
  
    [self.delegate textFieldDelegate:textField];
    
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
   
     [self.delegate textFieldValue:textField :self.cancelButton.tag];
    return  [textField resignFirstResponder];

}
- (void)textFieldDidChange:(UITextField *)textField {
    NSLog(@"text changed: %@", textField.text);
    [self.delegate textFieldValue:textField :self.cancelButton.tag];
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    MXTextField *quantityField = (MXTextField *) textField;
    
    if ([packSizeFeatureVerticals containsObject:quantityField.elementId]) {
           [self packSizeMethodCall:quantityField.attachedData :quantityField.text];
       }
       else
       {
           // do nothing
           // return pack size flag true for other verticals
           
           [self.delegate returnPackSizeFlag:true];
           
       }
    [self endEditing:YES];
       
}
-(void)packSizeMethodCall :(NSString *)packSizeString :(NSString *) quantityValuveString
{
    int packSizeInt = [packSizeString intValue];
    int quantityValuveInt = [quantityValuveString intValue];
    if (quantityValuveInt == 0) {
        // do nothing
        self.valueTxtFld.text =  @"";
        [self.delegate returnPackSizeFlag:true];
    }
    else
    {
        if (quantityValuveInt >= packSizeInt) {
            if (packSizeInt == 1) {
                 // do nothing
                 [self.delegate returnPackSizeFlag:true];
             }
             else
             {
                 float theFloat = (float)quantityValuveInt / (float)packSizeInt;
                 int rounded = round(theFloat);
                 int finalQuantityValue  = packSizeInt * rounded;
                 if (quantityValuveInt == finalQuantityValue) {
                     // do nothing
                      [self.delegate returnPackSizeFlag:true];
                 }
                 else
                 {
                     // show alert
                     [self alertViewMethod:[NSString stringWithFormat:@"%d",finalQuantityValue]];
                      [self.delegate returnPackSizeFlag:false];
            
                     
                 }
             }
        }
        
        else
        {
             [self alertViewMethod:[NSString stringWithFormat:@"%d",packSizeInt]];
             [self.delegate returnPackSizeFlag:false];
        }
    }
 

}

-(void)alertViewMethod :(NSString *) quantityValue
{
         // show alert
         UIAlertController *alertController = [UIAlertController alertControllerWithTitle:self.titleLbl.text message:@"Your Order Quantity is rounded off according to pack size." preferredStyle:UIAlertControllerStyleAlert
                                     ];
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault
                                                                        handler:^(UIAlertAction * action)
                                                                      {
                                                                      [self.delegate returnPackSizeFlag:true];
                                                                      }];
                  [alertController addAction:defaultAction];
          
                   UIViewController* root = [[[[UIApplication sharedApplication]windows]objectAtIndex:0] rootViewController];
                          UIViewController *assignViewController = nil;
                          
                          if ([root isKindOfClass:[SWRevealViewController class]]) {
                                      SWRevealViewController *reveal = (SWRevealViewController*)root;
                                      UINavigationController *check =(UINavigationController*)reveal.frontViewController;
                                      NSArray* viewsList = check.viewControllers;
                                      UIViewController *checkView = (UIViewController *) [viewsList objectAtIndex:viewsList.count - 1];
                              assignViewController = checkView;
                          }
                          else
                          {
                              assignViewController = root;
                          }
                         
                          [assignViewController presentViewController:alertController animated:YES completion:nil];
         
         
         dispatch_async(dispatch_get_main_queue(), ^{
             self.valueTxtFld.text = quantityValue;
             [self.delegate textFieldValue:self.valueTxtFld :self.cancelButton.tag];
         });

         
     }


@end
