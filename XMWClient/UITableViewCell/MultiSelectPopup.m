//
//  MultiSelectPopup.m
//  QCMSProject
//
//  Created by Pradeep Singh on 8/3/15.
//  Copyright (c) 2015 dotvik. All rights reserved.
//

#import "MultiSelectPopup.h"
#import "DVCheckBoxCell.h"


@interface MultiSelectPopup ()
{
    NSMutableDictionary* selectedDict;
}

@end

@implementation MultiSelectPopup

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self) {
        selectedDict = [[NSMutableDictionary alloc] init];

    }
    return self;
}


-(void) setInitialSelectedList:(NSArray*) selectedList
{
    
    for(int i=0; i<[self.allOptions count]; i++) {
        NSString* item = [self.allOptions objectAtIndex:i];
        if([selectedList containsObject:item]) {
            [selectedDict setObject:@"YES" forKey:[NSString stringWithFormat:@"%d", i]];
        }
    }
    
}


+(MultiSelectPopup*) createInstanceWithData:(NSArray*) lineData title:(NSString*) titleText
{
    
    MultiSelectPopup *view = (MultiSelectPopup *)[[[NSBundle mainBundle] loadNibNamed:@"MultiSelectPopup" owner:self options:nil] objectAtIndex:0];
    
    view.tableView.delegate = view;
    view.tableView.dataSource = view;
    view.allOptions = lineData;
    view.title = titleText;
    
    NSInteger popupHeight = 60 + ([view.allOptions count])*30 + 60;
    if(popupHeight > view.frame.size.height) {
        popupHeight = view.frame.size.height - 60 - 60;
    }
    
    view.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - view.frame.size.width)/2,
                            ([UIScreen mainScreen].bounds.size.height - view.frame.size.height)/2, view.frame.size.width, view.frame.size.height);
    // view.backgroundColor = [UIColor whiteColor];
    view.layer.borderWidth = 3.0f;
    
    view.autoresizesSubviews = YES;
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    
    view.popupHolderView.frame = CGRectMake((view.frame.size.width - 280)/2, (view.frame.size.height-popupHeight)/2, 280, popupHeight);
    
    view.popupHolderView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    view.popupHolderView.layer.borderWidth = 3.0f;
    view.popupHolderView.backgroundColor = [UIColor whiteColor];
    view.popupHolderView.autoresizesSubviews = YES;
    view.popupHolderView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    view.tableView.bounces = NO;
    view.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    view.tableView.frame = CGRectMake(0 , 0, 280, popupHeight - 80);
    
    view.layer.cornerRadius = 5.0;
    view.layer.masksToBounds = YES;
    
    
    view.cancelButton.layer.cornerRadius = 4.0;
    view.cancelButton.layer.masksToBounds = YES;
    
    view.okButton.layer.cornerRadius = 4.0;
    view.okButton.layer.masksToBounds = YES;
    
    // [view.tableView registerClass:[DVCheckBoxCell class] forCellReuseIdentifier:@"DVCheckBoxCell"];
    
    [view.tableView registerNib:[UINib nibWithNibName:@"DVCheckBoxCell" bundle:nil]  forCellReuseIdentifier:@"DVCheckBoxCell" ];
    
    
    
    return view;
}





#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.allOptions!=nil && ([self.allOptions count] > 0)) {
        return [self.allOptions count];
    } else {
        return 0;
    }
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30.0f;
}


-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    DVCheckBoxCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DVCheckBoxCell"];
    
    if(cell==nil) {
        cell = [[DVCheckBoxCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"DVCheckBoxCell"];
    }
    
    UILabel* textLabel = (UILabel*)[cell.contentView viewWithTag:101];
    if(textLabel==nil) {
        textLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 0.0f, self.frame.size.width-10, 32.0f)];
        textLabel.font = [UIFont systemFontOfSize:13.0f];
        
        textLabel.tag = 101;
        [cell.contentView addSubview:textLabel];
    }
    cell.checkBoxCellDelegate = self;
    
    return cell;
}



#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.frame.size.width, 43.0f)];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel*   textLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 0.0f, self.tableView.frame.size.width - 20.0f, 43.0f)];
    textLabel.tag = 101;
    
    textLabel.font = [UIFont systemFontOfSize:13.0f];
    textLabel.numberOfLines = 0;
    
    
    if(self.allOptions!=nil && ([self.allOptions count] > 0)) {
        textLabel.text =  self.title;
    }
    [view addSubview:textLabel];
    
    UIView* hLine = [[UIView alloc] initWithFrame:CGRectMake(5.0f, 42.0f, self.tableView.frame.size.width-10, 1.0f)];
    hLine.backgroundColor = [UIColor lightGrayColor];
    [view addSubview:hLine];

    
    return view;
    
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    
}

-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([cell isKindOfClass:[DVCheckBoxCell class]]) {
        DVCheckBoxCell* cbCell = (DVCheckBoxCell*)cell;
         NSString* itemText = [self.allOptions objectAtIndex:indexPath.row];
        
        
        if([selectedDict objectForKey:[NSString stringWithFormat:@"%ld", (long)indexPath.row]]==nil) {
            [cbCell configureCell:(NSString*) itemText checked:NO forIndex:indexPath.row];
        } else {
            [cbCell configureCell:(NSString*) itemText checked:YES forIndex:indexPath.row];
        }
        
    }
}

- (IBAction)handleClose:(id)sender {
    
    [self removeFromSuperview];
}


-(IBAction)okPressed:(id)sender
{
    
    if( (self.multiSelectDelegate!=nil) && [self.multiSelectDelegate respondsToSelector:@selector(selected: items:)]) {
        [self.multiSelectDelegate selected:self items:[NSArray arrayWithArray:selectedDict.allKeys]];
    }
    [self removeFromSuperview];
}


-(IBAction)cancelPressed:(id)sender
{
    [self removeFromSuperview];
}


#pragma mark - DVCheckBoxCellDelegate

-(void) checkBoxSelectedForRowIndex:(NSInteger) rowIndex
{
    NSLog(@"Item selected with index = %ld" , (long)rowIndex);
    [selectedDict setObject:@"YES" forKey:[NSString stringWithFormat:@"%ld", (long)rowIndex]];
}

-(void) checkBoxUnSelectedForRowIndex:(NSInteger) rowIndex
{
    NSLog(@"Item selected with index = %ld" , (long)rowIndex);
    
    [selectedDict removeObjectForKey:[NSString stringWithFormat:@"%ld", (long)rowIndex]];
}


@end
