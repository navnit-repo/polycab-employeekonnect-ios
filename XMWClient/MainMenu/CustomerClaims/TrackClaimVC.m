//
//  TrackClaimVC.m
//  XMWClient
//
//  Created by dotvikios on 10/07/18.
//  Copyright © 2018 dotvik. All rights reserved.
//

#import "TrackClaimVC.h"
#import "Records.h"

@interface TrackClaimVC ()

@end

@implementation TrackClaimVC
{
    Records * records;
    int cellHeight;
    NSMutableDictionary *trackRecords;
}
@synthesize trackButton;
@synthesize trackClaimArray;
@synthesize claimType,claimSubType,reason,comment,status;
@synthesize haderView;
@synthesize claimNoDisplay;
@synthesize claimNo;
@synthesize claimTypeLbl,claimSubTypeLbl,reasonLbl,statusLbl,commentsLbl;
@synthesize scroll;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSLog(@"itemRows %@",trackClaimArray);
    NSLog(@"%@ %@ %@ %@ %@",claimType,claimSubType,reason,comment,status);

    
    [self.navigationItem setHidesBackButton:YES animated:YES];
    claimNoDisplay.text = claimNo;
    self.navigationItem.titleView = haderView;
    
    self.claimTypeLbl.text = claimType;
    self.claimSubTypeLbl.text = claimSubType;
    self.reasonLbl.text = reason;
    self.commentsLbl.text = comment;
    self.statusLbl.text = status;
    
    
    cellHeight = 285;
    
    trackRecords = [[NSMutableDictionary alloc ]init];
    [trackRecords setObject:trackClaimArray forKey:@"itemObj"];

    [self recordsLoad];
    
    
}

-(void)recordsLoad{
    long int viewCartHeight = 0;
    int cellConut =0;

       NSArray* itemObj = [trackRecords objectForKey:@"itemObj"];
       viewCartHeight = viewCartHeight + [itemObj count];
       for ( int i=0 ; i < itemObj.count; i++) {

        records = [Records createInstance:cellConut*290];


        [records configure:[itemObj objectAtIndex:i]];

        records.frame= CGRectMake(0, 128+(cellConut*cellHeight), 320,285);

        [scroll addSubview:records];
        cellConut = cellConut+1;

    }
    [scroll setContentSize:CGSizeMake(320 , (viewCartHeight *290)+128)];
  
}
- (IBAction)backButton:(id)sender {
[self.navigationController popViewControllerAnimated:YES];

}


@end
