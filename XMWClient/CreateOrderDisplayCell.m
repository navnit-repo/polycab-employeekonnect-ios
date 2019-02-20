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
@implementation CreateOrderDisplayCell
@synthesize titleLbl,descriptionLbl,cancelButton,valueTxtFld;

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
    
    
    UIToolbar *keyboardDoneButtonView = [[UIToolbar alloc] init];
    [keyboardDoneButtonView sizeToFit];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStyleBordered target:self
                                                                  action:@selector(doneClicked:)];
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:doneButton, nil]];
    valueTxtFld.inputAccessoryView = keyboardDoneButtonView;
    
    
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
        NSUInteger length = array.count;
        NSString *isCodeStr =[array objectAtIndex:length-1];
        
        if ([verticalName isEqualToString:@"Cables"]) {
            if ([isCodeStr isEqualToString:@"NA"] || isCodeStr ==nil || [isCodeStr isKindOfClass:[NSNull class]]) {
                self.titleLbl.text = [array objectAtIndex:0];
            }
            else{
                self.titleLbl.text = [[[[[array objectAtIndex:0] stringByAppendingString:@" "] stringByAppendingString:@"/"] stringByAppendingString:@" "] stringByAppendingString:[array objectAtIndex:length-1]];
            }
        }
        else
        {
            self.titleLbl.text = [array objectAtIndex:0];
        }
        
        
        self.valueTxtFld.text = quntyValue;
        
        self.measurementLbl.text = [array objectAtIndex:3];
        self.descriptionLbl.text = [[[[[[[[[[[[[array objectAtIndex:1]stringByAppendingString:@" "]stringByAppendingString:[array objectAtIndex:2]]stringByAppendingString:@" "]stringByAppendingString:[array objectAtIndex:3]]stringByAppendingString:@" "]stringByAppendingString:[array objectAtIndex:4]]stringByAppendingString:@" "]stringByAppendingString:[array objectAtIndex:5]]stringByAppendingString:@" "]stringByAppendingString:[array objectAtIndex:6]]stringByAppendingString:@" "]stringByAppendingString:[array objectAtIndex:7]];
        
        
        self.priceLabel.text =[NSString stringWithFormat:@"Price: %@",[array objectAtIndex:length-3]];
        self.mainDescLbl.text =[array objectAtIndex:length-2];
        self.cancelButton.tag = buttonTag;
        [self.cancelButton setImage:[UIImage imageNamed:@"crossicon.png"] forState:UIControlStateNormal];
        self.cancelButton.tintColor = [UIColor blackColor];
        [self.cancelButton addTarget:self action:@selector(setCancelButtonHandler) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    else{
        NSLog(@"NO Display Field Found");
    }
}

//- (void)configure:(NSArray *)array :(long)buttonTag :(NSString *)verticalName
//{
//    if (array!=nil) {
//        [self autoLayout];
//        self.valueTxtFld.delegate = self;
//        NSLog(@"Display Field :%@",array);
//        NSUInteger length = array.count;
//        NSString *isCodeStr =[array objectAtIndex:length-1];
//
//        if ([verticalName isEqualToString:@"Cables"]) {
//            if ([isCodeStr isEqualToString:@"NA"] || isCodeStr ==nil || [isCodeStr isKindOfClass:[NSNull class]]) {
//                self.titleLbl.text = [array objectAtIndex:0];
//            }
//            else{
//                self.titleLbl.text = [[[[[array objectAtIndex:0] stringByAppendingString:@" "] stringByAppendingString:@"/"] stringByAppendingString:@" "] stringByAppendingString:[array objectAtIndex:length-1]];
//            }
//        }
//        else
//        {
//            self.titleLbl.text = [array objectAtIndex:0];
//        }
//
//
//        self.measurementLbl.text = [array objectAtIndex:3];
//        self.descriptionLbl.text = [[[[[[[[[[[[[array objectAtIndex:1]stringByAppendingString:@" "]stringByAppendingString:[array objectAtIndex:2]]stringByAppendingString:@" "]stringByAppendingString:[array objectAtIndex:3]]stringByAppendingString:@" "]stringByAppendingString:[array objectAtIndex:4]]stringByAppendingString:@" "]stringByAppendingString:[array objectAtIndex:5]]stringByAppendingString:@" "]stringByAppendingString:[array objectAtIndex:6]]stringByAppendingString:@" "]stringByAppendingString:[array objectAtIndex:7]];
//
//
//        self.priceLabel.text =[NSString stringWithFormat:@"Price: %@",[array objectAtIndex:length-3]];
//        self.mainDescLbl.text =[array objectAtIndex:length-2];
//        self.cancelButton.tag = buttonTag;
//        [self.cancelButton setImage:[UIImage imageNamed:@"crossicon.png"] forState:UIControlStateNormal];
//        self.cancelButton.tintColor = [UIColor blackColor];
//        [self.cancelButton addTarget:self action:@selector(setCancelButtonHandler) forControlEvents:UIControlEventTouchUpInside];
//
//
//    }
//    else{
//        NSLog(@"NO Display Field Found");
//    }
//}


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
@end
