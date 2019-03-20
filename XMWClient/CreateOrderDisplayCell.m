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
@synthesize titleLbl,descriptionLbl,cancelButton,valueTxtFld,measurementLbl,priceLabel,mainDescLbl;


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
        self.cancelButton.tintColor = [UIColor blackColor];
        [self.cancelButton addTarget:self action:@selector(setCancelButtonHandler) forControlEvents:UIControlEventTouchUpInside];
        
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
    
    priceLabel.frame = CGRectMake(priceLabel.frame.origin.x,mainDescLbl.frame.origin.y + mainDescLbl.frame.size.height+5, priceLabel.frame.size.width, priceLabel.frame.size.height);
    
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
@end
