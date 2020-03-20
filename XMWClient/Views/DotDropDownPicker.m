//
//  DotDropDownPicker.m
//  QCMSProject
//
//  Created by Ashish Tiwari on 06/07/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//

#import "DotDropDownPicker.h"
#import "MXBarButton.h"

@implementation DotDropDownPicker

@synthesize attachedData;
@synthesize elementId;
@synthesize dropDownList;
@synthesize dropDownListKey;
@synthesize selectedPickerValue;
@synthesize selectedPickerKey;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
      
    return self;
}



#pragma mark UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	return [dropDownList objectAtIndex:row];
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	if([[dropDownList objectAtIndex:row] isEqualToString:@"<Search>"])
	{
        
		// call another method and write similar code as in search button pressed.
		//[self performSelector:@selector() withObject:nil];
	}
	/*else if([dropDownList objectAtIndex:row] == nil || [[dropDownList objectAtIndex:row] isEqualToString:@"None"])
	{
		selectedPickerValue = @"None";
		selectedPickerKey = @"";
	}*/
	else
    {
        selectedPickerValue = [dropDownList objectAtIndex:row];
		selectedPickerKey = [dropDownListKey objectAtIndex:row];
     
       
    }
}

#pragma mark UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return [dropDownList count];
}

//- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
//{
//    UILabel *pickerLabel = (UILabel *)view;
//    CGRect frame = CGRectMake(0,0,265,40);
//    pickerLabel = [[UILabel alloc] initWithFrame:frame];
//    [pickerLabel setTextAlignment:UITextAlignmentLeft];
//    [pickerLabel setBackgroundColor:[UIColor clearColor]];
//    [pickerLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
//    [pickerLabel setNumberOfLines:0];
//    [pickerLabel setText:[dropDownList objectAtIndex:row]];
//    return pickerLabel;
//}

@end
