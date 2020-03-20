//
//  ChatRoom.m
//  Path Map
//
//  Created by Yatharth Singh on 11/05/16.
//  Copyright © 2016 Yatharth Singh. All rights reserved.
//

#import "ChatRoomVC.h"

extern BOOL ChatBoxPushNotifiactionFlag;
extern BOOL ChatRoomPushNotifiactionFlag;

@interface ChatRoomVC()

@end

@implementation ChatRoomVC

{
    NSMutableArray* chat;
    NSString* userId;
}
@synthesize userDict,isFromStr;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Initialize the root of our Firebase namespace.
    chat=[[NSMutableArray alloc]init];

    self.chatTextview.delegate=self;
  
    
    self.message1BtnOutlet.titleLabel.lineBreakMode=NSLineBreakByWordWrapping;
    self.message2BtnOutlet.titleLabel.lineBreakMode=NSLineBreakByWordWrapping;
    self.message3BtnOutlet.titleLabel.lineBreakMode=NSLineBreakByWordWrapping;
    
    
    self.mainTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 55,320,413) style:UITableViewStylePlain];
    self.mainTable.backgroundColor = [UIColor clearColor];
    
    self.mainTable.dataSource = self;
    self.mainTable.delegate = self;
    
    [self.mainTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];

    [self.view addSubview:self.mainTable];
    [self.view bringSubviewToFront:self.hintview];
    
    [self setUserData];
//    [self getChatHistory];
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setUserData
{
    if([isFromStr isEqualToString:@"MessageScreen"])
    {
        self.targetName.text=[self.userDict objectForKey:@"user_name"];
        
    }
    else
    {
        //from myconnections screen
        self.targetName.text=[NSString stringWithFormat:@"%@ %@",[self.userDict objectForKey:@"first_name"],[self.userDict objectForKey:@"last_name"]];
        
    }
    
    self.targetImage.layer.cornerRadius = 12.5;
    self.targetImage.clipsToBounds = YES;
    
}
#pragma mark-Tableview Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

        return chat.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

        static NSString* cellIdentifier = @"messagingCell";
        PTSMessagingCell * cell = (PTSMessagingCell*) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        
        
        
        if (cell == nil) {
            cell = [[PTSMessagingCell alloc] initMessagingCellWithReuseIdentifier:cellIdentifier];
        }
        
        [self configureCell:cell atIndexPath:indexPath];
    
        return cell;
 
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    CGSize messageSize;
    if(chat.count>0)
    {
        NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
        dict=[chat objectAtIndex:indexPath.row];
        NSString *message= [dict objectForKey:@"message"];
        if(message!=nil)
        {
            messageSize = [PTSMessagingCell messageSize:message];
            return messageSize.height + 2*[PTSMessagingCell textMarginVertical] + 40.0f;
        }
    }
    
    return messageSize.height + 2*[PTSMessagingCell textMarginVertical] + 40.0f;
    
}

-(void)configureCell:(id)cell atIndexPath:(NSIndexPath *)indexPath {
    
    PTSMessagingCell* ccell = (PTSMessagingCell*)cell;
    //ccell.backgroundColor = [UIColor clearColor];
    
   
    NSDictionary *dict=[chat objectAtIndex:indexPath.row];
    NSString *senderId=[dict objectForKey:@"source_id"];
    
    
    NSString *time=[dict objectForKey:@"message_date_time"];

    if([senderId isEqualToString:userId]) {
        ccell.sent = YES;
        
        ccell.timeLabel.text = time;
        ccell.messageLabel.text = [dict objectForKey:@"message"];
    }
    else {
        ccell.sent = NO;
        if([isFromStr isEqualToString:@"MessageScreen"])
        {
        }
        else
        {
        }
        ccell.timeLabel.text = time;
        ccell.messageLabel.text = [dict objectForKey:@"message"];
    }
}

-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
}

#pragma mark -TextviewDelegate Methods
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{

    if([_chatTextview.text isEqualToString:@"Type Your Message...."])
    {
        _chatTextview.text=@"";
        _chatTextview.textColor=[UIColor colorWithRed:(131/255.0) green:(131/255.0) blue:(131/255.0) alpha:1.0];
    }
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{

    if([_chatTextview.text isEqualToString:@""])
    {
        _chatTextview.text=@"Type Your Message....";
        _chatTextview.textColor=[UIColor colorWithRed:(131/255.0) green:(131/255.0) blue:(131/255.0) alpha:1.0];
    }
    [textView resignFirstResponder];
    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return YES;
}

- (IBAction)sendBtnClickHandler:(id)sender {
    //[self.view endEditing:YES];
    if((![_chatTextview.text  isEqual: @""])&&(![_chatTextview.text  isEqual: @"Type Your Message...."]))
    {

        
         NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
        [dict setObject:@"chat" forKey:@"opcode"];
         [dict setObject:@"connectionrequest" forKey:@"type"];
//         [dict setObject:userId forKey:@"source_uid"];
//        if([isFromStr isEqualToString:@"MessageScreen"])
//        {
//             [dict setObject:[self.userDict objectForKey:@"target"] forKey:@"target_uid"];
//        }
//        else
//        {
//             [dict setObject:[self.userDict objectForKey:@"user_id"] forKey:@"target_uid"];
//        }
        
        [dict setObject:self.chatTextview.text forKey:@"sent_message"];
        
//        [self sendMessage:dict];

        _chatTextview.text=@"";
        
    }
}

- (IBAction)reportAbussiveBtnHandler:(id)sender
{
    
}
-(NSString *)currentTime:(NSDate *)time
{
    //Get current time
    //NSDate* now = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *dateComponents = [gregorian components:(NSCalendarUnitHour  | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:time];
    NSInteger hour = [dateComponents hour];
    NSString *am_OR_pm=@"AM";
    
    if (hour>12)
    {
        hour=hour%12;
        
        am_OR_pm = @"PM";
    }
    
    NSInteger minute = [dateComponents minute];
    //NSInteger second = [dateComponents second];
    
    NSLog(@"Current Time  %@",[NSString stringWithFormat:@"%02ld:%02ld",  (long)hour, (long)minute]);
    
    return [NSString stringWithFormat:@"%02ld:%02ld %@",  (long)hour, (long)minute,am_OR_pm];
}
-(NSString *)currentTimeInMilis
{
    long currentTime = (long)(NSTimeInterval)([[NSDate date] timeIntervalSince1970]);
    
    return [NSString stringWithFormat:@"%02ld",currentTime];
    
}

- (IBAction)backBtnHandler:(id)sender {
    ChatRoomPushNotifiactionFlag = NO;
    ChatBoxPushNotifiactionFlag = NO;
    
    if([chat count])
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {

    }
}

- (IBAction)message1ClickHandler:(id)sender {
    self.chatTextview.text=[sender titleLabel].text;
}

- (IBAction)message2ClickHandler:(id)sender {
    self.chatTextview.text=[sender titleLabel].text;
}

- (IBAction)message3ClickHandler:(id)sender {
    self.chatTextview.text=[sender titleLabel].text;
}
@end


