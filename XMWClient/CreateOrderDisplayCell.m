//
//  CreateOrderDisplayCell.m
//  XMWClient
//
//  Created by dotvikios on 21/08/18.
//  Copyright © 2018 dotvik. All rights reserved.
//

#import "CreateOrderDisplayCell.h"
#import "LayoutClass.h"
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
    [LayoutClass textfieldLayout:self.valueTxtFld forFontWeight:UIFontWeightRegular];
    [LayoutClass setLayoutForIPhone6:self.cancelButton];
    [LayoutClass labelLayout:self.measurementLbl forFontWeight:UIFontWeightRegular];
    [LayoutClass labelLayout:self.priceLabel forFontWeight:UIFontWeightBold];
    
    }
- (void)configure:(NSArray *)array :(long)buttonTag{
    
    if (array!=nil) {
        [self autoLayout];
        
        self.valueTxtFld.delegate = self;
        NSLog(@"Display Field :%@",array);
        self.titleLbl.text = [array objectAtIndex:0];
        self.measurementLbl.text = [array objectAtIndex:3];
        self.descriptionLbl.text = [[[[[[[[[[[[[array objectAtIndex:1]stringByAppendingString:@" "]stringByAppendingString:[array objectAtIndex:2]]stringByAppendingString:@" "]stringByAppendingString:[array objectAtIndex:3]]stringByAppendingString:@" "]stringByAppendingString:[array objectAtIndex:4]]stringByAppendingString:@" "]stringByAppendingString:[array objectAtIndex:5]]stringByAppendingString:@" "]stringByAppendingString:[array objectAtIndex:6]]stringByAppendingString:@" "]stringByAppendingString:[array objectAtIndex:7]];
        
        
        if (array.count==10) {
          self.priceLabel.text = [NSString stringWithFormat:@"Price: %@",[array objectAtIndex:9]];
        }
        if (array.count==9) {
        self.priceLabel.text = [NSString stringWithFormat:@"Price: %@",[array objectAtIndex:8]];
        }
        
        self.cancelButton.tag = buttonTag;
    
        [self.cancelButton setImage:[UIImage imageNamed:@"crossicon.png"] forState:UIControlStateNormal];
        self.cancelButton.tintColor = [UIColor blackColor];
        [self.cancelButton addTarget:self action:@selector(setCancelButtonHandler) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    else{
        NSLog(@"NO Display Field Found");
    }
}


-(void)setCancelButtonHandler{
    NSLog(@"%ld",self.cancelButton.tag);
    [self.delegate buttonDelegate:self.cancelButton.tag];

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return  [textField resignFirstResponder];
}
@end
