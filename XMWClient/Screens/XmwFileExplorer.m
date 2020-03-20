//
//  XmwFileExplorer.m
//  QCMSProject
//
//  Created by Pradeep Singh on 3/27/14.
//  Copyright (c) 2014 dotvik. All rights reserved.
//

#import "XmwFileExplorer.h"
#import "Styles.h"

@interface XmwFileExplorer ()
{
    NSString *docsDir;
    NSMutableArray* directoryStack;
    //NSArray *directoryFiles;
     NSMutableArray *directoryFiles;
    
    UITableView* directoryView;
    UIDocumentInteractionController* documentInteractionController;
}
@property UIDocumentInteractionController* documentInteractionController;


@end

@implementation XmwFileExplorer

@synthesize documentInteractionController;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
   
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    directoryStack = [[NSMutableArray alloc] init];
    
    // current document directory
    NSArray *dirPaths;
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    
    [directoryStack addObject:docsDir];
    [self refreshCurrentDirectoryView];
    
    NSLog(@"XmwFileExplorer: Document Directory = %@ ", docsDir);
    
    
    directoryView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    directoryView.delegate = self;
    directoryView.dataSource = self;
    
    [self.view addSubview:directoryView];
    
    [self drawHeaderItem];
    
}
-(void) drawHeaderItem
{
    
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(backHandler:)];
    backButton.tintColor = [Styles barButtonTextColor];
    [self.navigationItem setLeftBarButtonItem:backButton];
    
    [self drawTitle: @"File Explorer"];

}
- (void) backHandler : (id) sender {
    
    if([directoryStack count] > 1) {
        [directoryStack removeObjectAtIndex:[directoryStack count] -1];
        [self refreshCurrentDirectoryView];
    } else {
        [ [self navigationController]  popViewControllerAnimated:YES];
    }
}

-(void) drawTitle:(NSString *)headerStr
{
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIColor whiteColor],NSForegroundColorAttributeName,
                                    [UIColor whiteColor],NSBackgroundColorAttributeName,nil];
    
    self.navigationController.navigationBar.titleTextAttributes = textAttributes;
    // self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    
    UILabel*  titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 40)];
    titleLabel.text = @"File Explorer";
    titleLabel.textColor = [Styles headerTextColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    [self.navigationItem setTitleView: titleLabel];
    
}


-(void) refreshCurrentDirectoryView
{
    if([directoryStack count] >0) {
        NSString* currentDir = [directoryStack objectAtIndex:([directoryStack count] -1)];
        directoryFiles = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:currentDir error:nil];
        NSLog(@"%@", directoryFiles);
        [directoryView reloadData];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma - mark table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *file = [directoryFiles objectAtIndex:indexPath.row];
    NSString *path = [self pathForFile:file];
    
    if(![self fileIsDirectory:file]) {
        NSURL *URL = [NSURL fileURLWithPath:path];
    
        if (URL) {
        // Initialize Document Interaction Controller
            self.documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:URL];
        
        // Configure Document Interaction Controller
            [self.documentInteractionController setDelegate:self];
        
        // Preview PDF
            [self.documentInteractionController presentPreviewAnimated:YES];
        }
    } else {
        [directoryStack addObject:path];
        [self refreshCurrentDirectoryView];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 40.0;
    
}

# pragma - mark tableview datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(directoryFiles !=nil) {
        return  [directoryFiles count];
    } else {
        return 0;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell:%d", indexPath.row];
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    if (cell!=nil) {

    //static NSString *CellIdentifier = @"Cell";
    
   // UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
   // if (cell == nil) {
        //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        //cell.textLabel.font = [UIFont systemFontOfSize:16.0];
    
    
    NSString *file = [directoryFiles objectAtIndex:indexPath.row];
    NSString *path = [self pathForFile:file];
    BOOL isdir = [self fileIsDirectory:file];
    [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isdir];
    
  //  cell.textLabel.text = file;
  //  cell.textLabel.textColor = isdir ? [UIColor blueColor] : [UIColor darkTextColor];
    cell.accessoryType = isdir ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
    
    
    
    UIView *containerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 40)];
    containerView.backgroundColor = [UIColor clearColor];
    UILabel *textLable = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, self.view.bounds.size.width-50, 40)];
    textLable.backgroundColor = [UIColor clearColor];
    textLable.font =  [UIFont systemFontOfSize:16.0];
    textLable.textAlignment = NSTextAlignmentLeft;
    textLable.textColor = isdir ? [UIColor blueColor] : [UIColor darkTextColor];
    textLable.text = [self displayableFileName :file];
    
    UIButton *removeRowButton  = [UIButton buttonWithType:UIButtonTypeCustom];
        NSRange rangePdf =  [file rangeOfString:@".pdf"];
        NSRange rangeDoc = [file rangeOfString:@".doc"];
        NSRange rangeDocx = [file rangeOfString:@".docx"];
        NSRange rangeXls = [file rangeOfString:@".xls"];
        
        if(rangePdf.length>0)
        {
            
            [removeRowButton setFrame:CGRectMake(self.view.bounds.size.width-40, 5, 30, 30)];
            [removeRowButton setBackgroundImage:[UIImage imageNamed:@"minus_normal"] forState:UIControlStateNormal];
            [removeRowButton addTarget:self action:@selector(removeRowHandler:) forControlEvents:UIControlEventTouchUpInside];
            removeRowButton.tag = indexPath.row;
            [containerView addSubview:removeRowButton];
            
        }
        else if(rangeDoc.length >0)
        {
            [removeRowButton setFrame:CGRectMake(self.view.bounds.size.width-40, 5, 30, 30)];
            [removeRowButton setBackgroundImage:[UIImage imageNamed:@"minus_normal"] forState:UIControlStateNormal];
            [removeRowButton addTarget:self action:@selector(removeRowHandler:) forControlEvents:UIControlEventTouchUpInside];
            removeRowButton.tag = indexPath.row;
            [containerView addSubview:removeRowButton];
        }
        else if(rangeDocx.length >0)
        {
            [removeRowButton setFrame:CGRectMake(self.view.bounds.size.width-40, 5, 30, 30)];
            [removeRowButton setBackgroundImage:[UIImage imageNamed:@"minus_normal"] forState:UIControlStateNormal];
            [removeRowButton addTarget:self action:@selector(removeRowHandler:) forControlEvents:UIControlEventTouchUpInside];
            removeRowButton.tag = indexPath.row;
            [containerView addSubview:removeRowButton];
        }
        else if(rangeXls.length >0)
        {
            [removeRowButton setFrame:CGRectMake(self.view.bounds.size.width-40, 5, 30, 30)];
            [removeRowButton setBackgroundImage:[UIImage imageNamed:@"minus_normal"] forState:UIControlStateNormal];
            [removeRowButton addTarget:self action:@selector(removeRowHandler:) forControlEvents:UIControlEventTouchUpInside];
            removeRowButton.tag = indexPath.row;
            [containerView addSubview:removeRowButton];
        }
        
    
    [containerView addSubview:textLable];
    [cell addSubview:containerView];

    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    
    return 1;
}

-(NSString*) displayableFileName:(NSString*) filename
{
    NSRange tempRange = [filename rangeOfString:@"FileName=Admin%2fForms%2f"];
    if(tempRange.length>0) {
        NSString* actualName = [filename substringFromIndex:tempRange.location + tempRange.length];
        return [actualName stringByReplacingOccurrencesOfString:@"%20" withString:@" "];
    } else {
        return [filename stringByReplacingOccurrencesOfString:@"%20" withString:@" "];
    }
}

#pragma mark - UIDocumentInteractionControllerDelegate

- (UIViewController *) documentInteractionControllerViewControllerForPreview: (UIDocumentInteractionController *) controller {
    return self;
}


#pragma mark - General File functions

- (NSString *)pathForFile:(NSString *)file {
    
    NSString* basePathDir = [directoryStack objectAtIndex:([directoryStack count] -1)];
    return [ basePathDir stringByAppendingPathComponent:file];
}

- (BOOL)fileIsDirectory:(NSString *)file {
    BOOL isdir = NO;
    NSString *path = [self pathForFile:file];
    [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isdir];
    return isdir;
}

-(void) createFolder:(NSString*) name
{
    
    
}
-(IBAction)removeRowHandler:(id)sender
{
    UIButton *button = sender;
    int rowNumber = button.tag;
    
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Are you sure you want to delete this file?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK" , nil];
    myAlertView.tag = rowNumber;
    [myAlertView show];
    
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    int selectedRowNo = alertView.tag;
    
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"OK"])
    {
        UITableView *tv = (UITableView *)directoryView;
        
        NSString *fileName = [directoryFiles objectAtIndex:selectedRowNo];
        
        [directoryFiles removeObjectAtIndex:selectedRowNo];
        
       // NSArray *deleteIndexPaths = [NSArray arrayWithObjects:[NSIndexPath indexPathForRow:selectedRowNo inSection:0],nil];
         [tv reloadData];
       // [tv deleteRowsAtIndexPaths:deleteIndexPaths withRowAnimation:UITableViewRowAnimationFade];
        
        [self removeFile:fileName];
        
    }
    else if([title isEqualToString:@"Cancel"])
    {
        
    }
    
    
    
}

- (void)removeFile:(NSString *)fileName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *filePath = [documentsPath stringByAppendingPathComponent:fileName];
    NSError *error;
    BOOL success = [fileManager removeItemAtPath:filePath error:&error];
    if (success) {
         NSLog(@"file Deleted Successfully");
    }
    else
    {
        NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
    }
}


@end
