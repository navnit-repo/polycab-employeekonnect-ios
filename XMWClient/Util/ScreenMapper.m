//
//  ScreenMapper.m
//  QCMSProject
//
//  Created by Pradeep Singh on 9/3/17.
//  Copyright © 2017 dotvik. All rights reserved.
//

#import "ScreenMapper.h"
#import "ClientVariable.h"
#import "DVAppDelegate.h"

@implementation ScreenMapper


#pragma mark - custom report VCs

+(void) registerCustomReportVC
{
    ClientVariable* clientVariables = [ClientVariable getInstance : [DVAppDelegate currentModuleContext] ];
      // for My Details
      [clientVariables registerReportVCClass:@"MyDetailsVC" forId:@"DOT_REPORT_MYDETAIL"];
      
      [clientVariables registerReportVCClass:@"BalanceConfirmationVC" forId:@"DOT_REPORT_BALANCE_CONFIRMATION"];
      
       // for Dispatch Details
      [clientVariables registerReportVCClass:@"DispatchDetailsVC" forId:@"DOT_REPORT_DISPATCH_DETAILS_DW"];
      
      // for Payment Outstanding
      [clientVariables registerReportVCClass:@"PaymentOutstandingReportView" forId:@"DOT_REPORT_PAYMENT_OUTSTANDING"];
      
    // for WideReportVC
      [clientVariables registerReportVCClass:@"WideReportVC" forId:@"DOT_REPORT_EMPLOYEE_PORTAL_ORDERS"];
      
      // for WideReportVC drilldown
      [clientVariables registerReportVCClass:@"WideReportVC" forId:@"DOT_REPORT_EMPLOYEE_PORTAL_ORDERS_DD_MOBILE"];
      
      // for WideReportVC
      [clientVariables registerReportVCClass:@"WideReportVC" forId:@"BU_HEAD_SALES_ORDER_PENDENCY"];
      
      // for WideReportVC
      [clientVariables registerReportVCClass:@"WideReportVC" forId:@"DOT_REPORT_SALES_ORDER_PENDENCY_DW"];
      
      
      // for Credit Notes
      [clientVariables registerReportVCClass:@"CreditNotesVC" forId:@"DOT_REPORT_CREDIT_NOTES"];
    
    

}

#pragma mark - custom form VCs

+(void) registerCustomFormVC
{
    ClientVariable* clientVariables = [ClientVariable getInstance : [DVAppDelegate currentModuleContext] ];
        // for My Manage Sub User
      [clientVariables registerFormVCClass:@"ManageSubUserVC" forId:@"DOT_FORM_Create_Sub_User"];
        
        // for FeedBack
      // [clientVariables registerFormVCClass:@"FeedBackVC" forId:@"DOT_FORM_FEEDBACK"];
       
        // for Feedback Form Customer
       [clientVariables registerFormVCClass:@"FeedbackFormCustomerVC" forId:@"DOT_FORM_FEEDBACK_FROM_CUSTOMER"];
        
        // for Create Order
        [clientVariables registerFormVCClass:@"EmployeeCreateOrderVC" forId:@"DOT_FORM_3"];
        
        // for SPA Create Order
        [clientVariables registerFormVCClass:@"EmployeeCreateOrderVC" forId:@"DOT_FORM_4"];
        
       
      // for BusinessVerticalVC
      [clientVariables registerFormVCClass:@"BusinessVerticalVC" forId:@"DOT_REPORT_5_BUSINESS_VERTICAL_SALES_REPORT"];
       
        
    // for RMAVC
    [clientVariables registerFormVCClass:@"RMAVC" forId:@"DOT_FORM_REQUEST_FOR_RETURN_MATERIAL"];
        
     
    // for sales comparisons control
    /*
    [clientVariables registerFormVCClass:@"SalesComparisonVC" forId:@"DOT_REPORT_5_SALES_COMPARISON"];
    [clientVariables registerFormVCClass:@"EmployeeSalesFormVC" forId:@"DOT_FORM_LEVEL_SALES_NATIONAL_WISE"];
    [clientVariables registerFormVCClass:@"EmployeeSalesFormVC" forId:@"DOT_FORM_LEVEL_BU_NATIONAL_WISE"];
    [clientVariables registerFormVCClass:@"EmployeeSalesFormVC" forId:@"DOT_FORM_BU_SALES_REGION_WISE"];
    [clientVariables registerFormVCClass:@"EmployeeSalesFormVC" forId:@"DOT_FORM_BU_REGION_SALES_STATE_WISE"];
    [clientVariables registerFormVCClass:@"EmployeeSalesFormVC" forId:@"DOT_FORM_BU_SALES_CUSTOMER_WISE"];
    [clientVariables registerFormVCClass:@"EmployeeSalesFormVC" forId:@"DOT_FORM_CUSTOMER_WISE_SALES"];
     */
    
    [clientVariables registerFormVCClass:@"GrowthIndicatorFormVC" forId:@"DOT_REPORT_5_SALES_COMPARISON"];
    [clientVariables registerFormVCClass:@"GrowthIndicatorFormVC" forId:@"DOT_FORM_LEVEL_SALES_NATIONAL_WISE"];
    [clientVariables registerFormVCClass:@"GrowthIndicatorFormVC" forId:@"DOT_FORM_LEVEL_BU_NATIONAL_WISE"];
    [clientVariables registerFormVCClass:@"GrowthIndicatorFormVC" forId:@"DOT_FORM_BU_SALES_REGION_WISE"];
    [clientVariables registerFormVCClass:@"GrowthIndicatorFormVC" forId:@"DOT_FORM_BU_REGION_SALES_STATE_WISE"];
    [clientVariables registerFormVCClass:@"GrowthIndicatorFormVC" forId:@"DOT_FORM_BU_SALES_CUSTOMER_WISE"];
    [clientVariables registerFormVCClass:@"GrowthIndicatorFormVC" forId:@"DOT_FORM_CUSTOMER_WISE_SALES"];

     [clientVariables registerFormVCClass:@"TSIFormVC" forId:@"DOT_FORM_CREDIT_NOTES"];

}


@end