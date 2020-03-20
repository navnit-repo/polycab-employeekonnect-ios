//
//  DocFormPostOfflineProcessing.h
//  QCMSProject
//
//  Created by Pradeep Singh on 5/21/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../Network/JSONStructure.h"
#import "DotFormPost.h"


@interface DocFormPostOfflineProcessing : NSObject <JSONStructure>
{
@private
    int jsonStructureId;
    
    NSString* statusClientSubmit;//NOT_SUBMIT, NULL,SUBMIT
    NSString* statusServerSubmit;//Status Record is submit on the server -->
    //For the Sink to the server there are some case:==>
    //1. Document is not Sink to the server--->NOT_SINK
    //2. Document is sink to the server in case of sink we have the id of the server table on which it is submitted  ---->SINK
    //3. Document is sink to the server but after submit it is Edited-->SINK_EDIT
    //4. Document is sink to the server but after submit it is Deleted--->SINK_DELETE
    //5. Record is eligiable  for the delete the record
    //,EDIT after the Record post on the server,Delete after the Record post on the server
    NSString* recordStatus;//Is the record is active/delete on the client 1-> Active 0 ->delete
    NSString* docSubmitDate;//Submit document date for the when user is submit the document
    NSString* trackerNumber;//Tracker Number of the submitted document in case of off line version it is created on the mobile Client
    // In Case of the other integration is created from the particular integration type
    NSString* formPostedResponse;
    //Response String After the creation of the document with the tracker number
    NSString* serverResponseIdOnFirstSink;
    DotFormPost* dotFormPostObj;
    //Form Post Object for the data document for which it is created
}

@property NSString* statusClientSubmit;
@property NSString* statusServerSubmit;
@property NSString* recordStatus;
@property NSString* docSubmitDate;
@property NSString* trackerNumber;
@property NSString* formPostedResponse;
@property NSString* serverResponseIdOnFirstSink;
@property DotFormPost* dotFormPostObj;





@end
