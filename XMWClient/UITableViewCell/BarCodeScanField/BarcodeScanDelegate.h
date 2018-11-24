//
//  BarcodeScanDelegate.h
//  QCMSProject
//
//  Created by Pradeep Singh on 4/10/17.
//  Copyright © 2017 dotvik. All rights reserved.
//

#ifndef BarcodeScanDelegate_h
#define BarcodeScanDelegate_h



@protocol BarcodeScanDelegate <NSObject>

-(void) barcodeResult:(NSString*) scanCode forContext:(NSString*) contextId;
-(void) barcodeCancelledForContext:(NSString*) contextId;

@end


#endif /* BarcodeScanDelegate_h */
