//
//  FeedbackDropDownVC.m
//  XMWClient
//
//  Created by dotvikios on 05/10/18.
//  Copyright © 2018 dotvik. All rights reserved.
//

#import "FeedbackDropDownVC.h"
#import "LayoutClass.h"


@interface FeedbackDropDownVC ()

@end

@implementation FeedbackDropDownVC
{
    BOOL click;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBar];
    [self autoLayout];
    // Do any additional setup after loading the view from its nib.
}

-(void)setNavigationBar{


    UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc] initWithImage:[UIImage
                                                                            imageNamed:@"back-button"] style:UIBarButtonItemStylePlain target:self action:@selector(cancelHandler:)];
    
    
    
    cancelButton.tintColor = [UIColor whiteColor];
    
    UIBarButtonItem* DoneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(DoneHandler:)];
    
    
    
    DoneButton.tintColor = [UIColor whiteColor];
    
    [self.navigationItem setRightBarButtonItem:DoneButton];
    
    [self.navigationItem setLeftBarButtonItem:cancelButton];
    
    UIImageView *polycabLogo = [[UIImageView alloc] initWithImage:[UIImage  imageNamed:@"polycab_logo"]];
    self.navigationItem.titleView.contentMode = UIViewContentModeCenter;
    self.navigationItem.titleView = polycabLogo;
    
}
-(void)autoLayout{
    [LayoutClass labelLayout:self.constantView1 forFontWeight:UIFontWeightLight];
     [LayoutClass labelLayout:self.constantView4 forFontWeight:UIFontWeightLight];
     [LayoutClass labelLayout:self.constantView7 forFontWeight:UIFontWeightLight];
     [LayoutClass labelLayout:self.constantView10 forFontWeight:UIFontWeightLight];
     [LayoutClass labelLayout:self.constantView13 forFontWeight:UIFontWeightLight];
     [LayoutClass labelLayout:self.constantView16 forFontWeight:UIFontWeightLight];
     [LayoutClass labelLayout:self.constantView19 forFontWeight:UIFontWeightLight];
     [LayoutClass labelLayout:self.constantView22 forFontWeight:UIFontWeightLight];
     [LayoutClass labelLayout:self.constantView25 forFontWeight:UIFontWeightLight];
     [LayoutClass labelLayout:self.constantView28 forFontWeight:UIFontWeightLight];
     [LayoutClass labelLayout:self.constantView31 forFontWeight:UIFontWeightLight];
     [LayoutClass labelLayout:self.constantView34 forFontWeight:UIFontWeightLight];
    
    [LayoutClass setLayoutForIPhone6:self.constantView2];
     [LayoutClass setLayoutForIPhone6:self.constantView5];
     [LayoutClass setLayoutForIPhone6:self.constantView8];
     [LayoutClass setLayoutForIPhone6:self.constantView11];
     [LayoutClass setLayoutForIPhone6:self.constantView14];
     [LayoutClass setLayoutForIPhone6:self.constantView17];
     [LayoutClass setLayoutForIPhone6:self.constantView20];
     [LayoutClass setLayoutForIPhone6:self.constantView23];
     [LayoutClass setLayoutForIPhone6:self.constantView26];
     [LayoutClass setLayoutForIPhone6:self.constantView29];
     [LayoutClass setLayoutForIPhone6:self.constantView32];
     [LayoutClass setLayoutForIPhone6:self.constantView35];
    
    [LayoutClass setLayoutForIPhone6:self.constantView3];
     [LayoutClass setLayoutForIPhone6:self.constantView6];
     [LayoutClass setLayoutForIPhone6:self.constantView9];
     [LayoutClass setLayoutForIPhone6:self.constantView12];
     [LayoutClass setLayoutForIPhone6:self.constantView15];
     [LayoutClass setLayoutForIPhone6:self.constantView18];
     [LayoutClass setLayoutForIPhone6:self.constantView21];
     [LayoutClass setLayoutForIPhone6:self.constantView24];
     [LayoutClass setLayoutForIPhone6:self.constantView27];
     [LayoutClass setLayoutForIPhone6:self.constantView30];
     [LayoutClass setLayoutForIPhone6:self.constantView33];
     [LayoutClass setLayoutForIPhone6:self.constantView36];
    
}
- (void) DoneHandler : (id) sender
{
    NSMutableArray *wire_cable = [[NSMutableArray alloc]init];
    if (self.aerialBunchedButton.tag == 1) {
        [wire_cable addObject:@"Aerial Bunched Cables"];
    }
    if (self.controlCablesButton.tag == 1) {
        [wire_cable addObject:@"Control Cables"];
    }
    if (self.flexibleCablesButton.tag == 1) {
        [wire_cable addObject:@"Flexible Cables"];
    }
    if (self.fireSurvivalCablesButton.tag == 1) {
        [wire_cable addObject:@"Fire Survival Cables"];
    }
    if (self.flexibleWiresButton.tag == 1) {
        [wire_cable addObject:@"Flexible Wires"];
    }
    if (self.hTCablesButton.tag == 1) {
        [wire_cable addObject:@"H.T. Cables"];
    }
    if (self.buildingWiresButton.tag == 1) {
        [wire_cable addObject:@"Building Wires"];
    }
    if (self.instrumentationCablesButton.tag == 1) {
        [wire_cable addObject:@"Instrumentation Cables"];
    }
    if (self.fRLSWiresButton.tag == 1) {
        [wire_cable addObject:@"FRLS Wires"];
    }
    if (self.lANCablesButton.tag == 1) {
        [wire_cable addObject:@"LAN Cables"];
    }
    if (self.powerCablesButton.tag == 1) {
        [wire_cable addObject:@"Power Cables"];
    }
    if (self.submersibleCablesButton.tag == 1) {
        [wire_cable addObject:@"Submersible Cables"];
    }
    
    [ self.delegate doneButton:self :wire_cable];
    
    [ [self navigationController]  popViewControllerAnimated:YES];
    
}

- (void) cancelHandler : (id) sender
{
    
    
    [ [self navigationController]  popViewControllerAnimated:YES];
    
}

- (IBAction)aerialBunchedCablesButton:(id)sender {
    if (click) {
        self.aerialBunchedView.image = [UIImage imageNamed:@"checkedbox.png"];
        self.aerialBunchedButton.tag = 1;
        click = false;
    }
    else if (click == false) {
        self.aerialBunchedView.image = [UIImage imageNamed:@"checkbox.png"];
        self.aerialBunchedButton.tag = 0;
        click = true;
    }
}
- (IBAction)controlCablesButton:(id)sender {
    if (click) {
        self.controlCablesView.image = [UIImage imageNamed:@"checkedbox.png"];
        self.controlCablesButton.tag = 1;
        click = false;
    }
    else if (click == false) {
        self.controlCablesView.image = [UIImage imageNamed:@"checkbox.png"];
        self.controlCablesButton.tag = 0;
        click = true;
    }
}
- (IBAction)flexibleCablesbutton:(id)sender {
    if (click) {
        self.flexibleCablesView.image = [UIImage imageNamed:@"checkedbox.png"];
        self.flexibleCablesButton.tag = 1;
        
        click = false;
    }
    else if (click == false) {
        self.flexibleCablesView.image = [UIImage imageNamed:@"checkbox.png"];
        self.flexibleCablesButton.tag = 0;
        click = true;
    }
}
- (IBAction)fireSurvivalCablesButton:(id)sender {
    if (click) {
        self.fireSurvivalCablesView.image = [UIImage imageNamed:@"checkedbox.png"];
        self.fireSurvivalCablesButton.tag = 1;
        click = false;
    }
    else if (click == false) {
        self.fireSurvivalCablesView.image = [UIImage imageNamed:@"checkbox.png"];
        self.fireSurvivalCablesButton.tag = 0;
        click = true;
    }
}
- (IBAction)flexibleWiresButton:(id)sender {
    if (click) {
        self.flexibleWiresView.image = [UIImage imageNamed:@"checkedbox.png"];
        self.flexibleWiresButton.tag = 1;
        click = false;
    }
    else if (click == false) {
        self.flexibleWiresView.image = [UIImage imageNamed:@"checkbox.png"];
        self.flexibleWiresButton.tag = 0;
        click = true;
    }
}
- (IBAction)hTCablesButton:(id)sender {
    if (click) {
        self.hTCablesView.image = [UIImage imageNamed:@"checkedbox.png"];
        self.hTCablesButton.tag = 1;
        click = false;
    }
    else if (click == false) {
        self.hTCablesView.image = [UIImage imageNamed:@"checkbox.png"];
        self.hTCablesButton.tag = 0;
        click = true;
    }
}
- (IBAction)buildingWiresButton:(id)sender {
    if (click) {
        self.buildingWiresView.image = [UIImage imageNamed:@"checkedbox.png"];
        self.buildingWiresButton.tag = 1;
        click = false;
    }
    else if (click == false) {
        self.buildingWiresView.image = [UIImage imageNamed:@"checkbox.png"];
        self.buildingWiresButton.tag = 0;
        click = true;
    }
}
- (IBAction)instrumentationCablesButton:(id)sender {
    if (click) {
        self.instrumentationCablesView.image = [UIImage imageNamed:@"checkedbox.png"];
        self.instrumentationCablesButton.tag = 1;
        click = false;
    }
    else if (click == false) {
        self.instrumentationCablesView.image = [UIImage imageNamed:@"checkbox.png"];
        self.instrumentationCablesButton.tag = 0;
        click = true;
    }
}
- (IBAction)fRLSWiresButton:(id)sender {
    if (click) {
        self.fRLSWiresView.image = [UIImage imageNamed:@"checkedbox.png"];
        self.fRLSWiresButton.tag = 1;
        click = false;
    }
    else if (click == false) {
        self.fRLSWiresView.image = [UIImage imageNamed:@"checkbox.png"];
        self.fRLSWiresButton.tag = 0;
        click = true;
    }
}
- (IBAction)lANCablesButton:(id)sender {
    if (click) {
        self.lANCablesView.image = [UIImage imageNamed:@"checkedbox.png"];
        self.lANCablesButton.tag = 1;
        click = false;
    }
    else if (click == false) {
        self.lANCablesView.image = [UIImage imageNamed:@"checkbox.png"];
        self.lANCablesButton.tag = 0;
        click = true;
    }
}
- (IBAction)powerCablesButton:(id)sender {
    if (click) {
        self.powerCablesView.image = [UIImage imageNamed:@"checkedbox.png"];
        self.powerCablesButton.tag = 1;
        click = false;
    }
    else if (click == false) {
        self.powerCablesView.image = [UIImage imageNamed:@"checkbox.png"];
        self.powerCablesButton.tag = 0;
        click = true;
    }
}
- (IBAction)submersibleCablesButton:(id)sender {
    if (click) {
        self.submersibleCablesView.image = [UIImage imageNamed:@"checkedbox.png"];
        self.submersibleCablesButton.tag = 1;
        click = false;
    }
    else if (click == false) {
        self.submersibleCablesView.image = [UIImage imageNamed:@"checkbox.png"];
        self.submersibleCablesButton.tag = 0;
        click = true;
    }
}
@end
