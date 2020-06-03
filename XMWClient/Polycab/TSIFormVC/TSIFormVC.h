//
//  TSIFormVC.h
//  XMWClient
//
//  Created by Pradeep Singh on 18/05/20.
//  Copyright © 2020 dotvik. All rights reserved.
//

#import "FormVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface TSIFormVC : FormVC
{
    NSString* codeLOB;
    NSString *registryID;
}


- (void)done:(SelectedListVC *)selectedListVC context:(NSString *)context code:(NSString *)code display:(NSString *)display;

@end

NS_ASSUME_NONNULL_END
