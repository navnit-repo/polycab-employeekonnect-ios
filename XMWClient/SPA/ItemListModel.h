//
//  ItemListModel.h
//  polycab
//
//  Created by Shivangi on 25/10/21.
//

#import <Foundation/Foundation.h>

@interface ItemListModel : NSObject

@property (nonatomic, strong) NSNumber *approvedBy;
@property (nonatomic, strong) NSString * approvedDate;
@property (nonatomic, strong) NSString * approverRemark;
@property (nonatomic, strong) NSString * approverRemarks2;
@property (nonatomic, strong) NSString * approverRemarks3;
@property (nonatomic, strong) NSString * approverRemarks4;
@property (nonatomic, strong) NSNumber *authorization_authority;
@property (nonatomic, strong) NSString * createDate;
@property (nonatomic, strong) NSString * customer_name;
@property (nonatomic, strong) NSString * customer_number;
@property (nonatomic, strong) NSString * customer_remarks;
@property (nonatomic, strong) NSString * deletedlines;
@property (nonatomic, strong) NSNumber *delivery_period;
@property (nonatomic, strong) NSString * endCustomerDocumentRef;
@property (nonatomic, strong) NSString * freight_terms;
@property (nonatomic, strong) NSString * latest_version;
@property (nonatomic, strong) NSString * lmeAluminium;
@property (nonatomic, strong) NSString * lmeCopper;
@property (nonatomic, strong) NSNumber *office;
@property (nonatomic, strong) NSString * opportunity;
@property (nonatomic, strong) NSString * orderBarginType;
@property (nonatomic, strong) NSString * orderQuantityLowerThreshold;
@property (nonatomic, strong) NSString * payment_terms;
@property (nonatomic, strong) NSString * reference_no;


@property (nonatomic, strong) NSString *registry_id;
@property (nonatomic, strong) NSString * requirementType;
@property (nonatomic, strong) NSString * revision_in_work;
@property (nonatomic, strong) NSString * shipto;
@property (nonatomic, strong) NSString * showLmeDetails;
@property (nonatomic, strong) NSString * spa_payment_terms;
@property (nonatomic, strong) NSString *spahrefid;
//@property (nonatomic, strong)  * spalines;


//- (instancetype)initWithDictionary: (NSDictionary *) dictionary;

@end
