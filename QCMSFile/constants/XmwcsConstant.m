//
//  XmwcsConstant.cpp
//  QCMSProject
//
//  Created by Ashish Tiwari on 20/05/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "XmwcsConstant.h"

// #define CONFIG_PROD
// #define CONFIG_QA
// #define CONFIG_DEV


NSString *const XmwcsConst_APP_MODULE_ESS = @"xess";
NSString *const XmwcsConst_APP_MODULE_SALES = @"xsales";
NSString *const XmwcsConst_APP_MODULE_WORKFLOW = @"xwf";


int const XmwcsConst_SORT_AS_INTEGER =  1;
int const XmwcsConst_SORT_AS_STRING =  2;


//forgot password at login screen
NSString *const  XmwcsConst_FORGOT_PWD_USER_ID = @"USER_ID";
NSString *const  XmwcsConst_FORGOT_PWD_MODULE_ID = @"MODULE_ID";

NSString* XmwcsConst_SERVICE_UPDATE_DROPDOWM_URL_NOTIFY_CONTEXT=@"https://pconnect.polycab.com:443/xmwpolycab/store";
NSString* XmwcsConst_SERVICE_URL = @"https://pconnect.polycab.com:443/xmwpolycab/feed";
NSString* XmwcsConst_SERVICE_URL_NOTIFY_CONTEXT = @"https://pconnect.polycab.com:443/xmwpolycab/nms";
NSString* XmwcsConst_PRODUCT_TREE_SERVICE_URL = @"https://pconnect.polycab.com:443/xmwpolycab/productsearch";
NSString* XmwcsConst_SERVICE_URL_APP_CONTROL = @"https://pconnect.polycab.com:443/xmwpolycab/appControl";
NSString* XmwcsConst_SERVICE_URL_DEAL_STORE = @"https://pconnect.polycab.com:443/xmwpolycab/deal/home.html";

NSString* XmwcsConst_OPCODE_URL  = @"https://pconnect.polycab.com:443/xmwpolycab/jsonservice";
NSString* XmwcsConst_FILE_UPLOAD_URL  = @"https://pconnect.polycab.com:443/xmwpolycab/xmwfileupload";
NSString* XmwcsConst_DEALER_OPCODE_URL = @"https://pconnect.polycab.com:443/pcdealer/jsonservice";


NSString* const XmwcsConst_DEMO_USER = @"testuser";
NSString* const XmwcsConst_DEMO_USER_MAPPED = @"111152";
NSString* XmwcsConst_CHAT_URL =@"https://pconnect.polycab.com:443/";

#ifdef CONFIG_PROD

NSString* const XmwcsConst_SERVICE_URL_PROD = @"https://pconnect.polycab.com:443/xmwpolycab/feed";
NSString* const XmwcsConst_SERVICE_URL_NOTIFY_CONTEXT_PROD = @"https://pconnect.polycab.com:443/xmwpolycab/nms";
NSString* const XmwcsConst_PRODUCT_TREE_SERVICE_URL_PROD = @"https://pconnect.polycab.com:443/xmwpolycab/productsearch";
NSString* const XmwcsConst_SERVICE_URL_APP_CONTROL_PROD = @"https://pconnect.polycab.com:443/xmwpolycab/appControl";
NSString* const XmwcsConst_SERVICE_URL_DEAL_STORE_PROD = @"https://pconnect.polycab.com:443/xmwpolycab/deal/home.html";
NSString* const XmwcsConst_SERVICE_URL_OPCODE_SERVICE_PROD = @"https://pconnect.polycab.com:443/xmwpolycab/jsonservice";
NSString *const XmwcsConst_SERVICE_URL_FILE_UPLOAD_SERVICE_PROD= @"https://pconnect.polycab.com:443/xmwpolycab/xmwfileupload";
NSString *const XmwcsConst_SERVICE_URL_CHAT_SERVICE_PROD =@"https://pconnect.polycab.com:443/";
NSString* const XmwcsConst_DEALER_OPCODE_URL_PROD = @"https://pconnect.polycab.com:443/pcdealer/jsonservice";




// DEMO or QA is same

NSString* const XmwcsConst_SERVICE_URL_DEMO = @"http://polycab.dotvik.com:8080/xmwpolycab/feed";
NSString* const XmwcsConst_SERVICE_URL_NOTIFY_CONTEXT_DEMO = @"http://polycab.dotvik.com:8080/xmwpolycab/nms";
NSString* const XmwcsConst_PRODUCT_TREE_SERVICE_URL_DEMO = @"http://polycab.dotvik.com:8080/xmwpolycab/productsearch";
NSString* const XmwcsConst_SERVICE_URL_APP_CONTROL_DEMO = @"http://polycab.dotvik.com:8080/xmwpolycab/appControl";
NSString* const XmwcsConst_SERVICE_URL_DEAL_STORE_DEMO = @"http://polycab.dotvik.com:8080/xmwpolycab/deal/home.html";
NSString* const XmwcsConst_SERVICE_URL_OPCODE_SERVICE_DEMO = @"http://polycab.dotvik.com:8080/xmwpolycab/jsonservice";
NSString *const XmwcsConst_SERVICE_URL_FILE_UPLOAD_SERVICE_DEMO= @"http://polycab.dotvik.com:8080/xmwpolycab/xmwfileupload";
NSString *const XmwcsConst_SERVICE_URL_CHAT_SERVICE_DEMO =@"http://polycab.dotvik.com:8080/";
NSString* const XmwcsConst_DEALER_OPCODE_URL_DEMO = @"http://polycab.dotvik.com:8080/pcdealer/jsonservice";


// DEV is same on QA but port is different
NSString* const XmwcsConst_SERVICE_URL_DEV = @"http://polycab.dotvik.com:8080/xmwpolycab/feed";
NSString* const XmwcsConst_SERVICE_URL_NOTIFY_CONTEXT_DEV = @"http://polycab.dotvik.com:8080/xmwpolycab/nms";
NSString* const XmwcsConst_PRODUCT_TREE_SERVICE_URL_DEV = @"http://polycab.dotvik.com:8080/xmwpolycab/productsearch";
NSString* const XmwcsConst_SERVICE_URL_APP_CONTROL_DEV = @"http://polycab.dotvik.com:8080/xmwpolycab/appControl";
NSString* const XmwcsConst_SERVICE_URL_DEAL_STORE_DEV = @"http://polycab.dotvik.com:8080/xmwpolycab/deal/home.html";
NSString* const XmwcsConst_SERVICE_URL_OPCODE_SERVICE_DEV = @"http://polycab.dotvik.com:8080/xmwpolycab/jsonservice";
NSString *const XmwcsConst_SERVICE_URL_FILE_UPLOAD_SERVICE_DEV= @"http://polycab.dotvik.com:8080/xmwpolycab/xmwfileupload";
NSString *const XmwcsConst_SERVICE_URL_CHAT_SERVICE_DEV =@"http://polycab.dotvik.com:8080/";
NSString* const XmwcsConst_DEALER_OPCODE_URL_DEV = @"http://polycab.dotvik.com:8080/pcdealer/jsonservice";


#else

// For connects to QA server
NSString* const XmwcsConst_SERVICE_URL_PROD = @"http://polycab.dotvik.com:8080/xmwpolycab/feed";
NSString* const XmwcsConst_SERVICE_URL_NOTIFY_CONTEXT_PROD = @"http://polycab.dotvik.com:8080/xmwpolycab/nms";
NSString* const XmwcsConst_PRODUCT_TREE_SERVICE_URL_PROD = @"http://polycab.dotvik.com:8080/xmwpolycab/productsearch";
NSString* const XmwcsConst_SERVICE_URL_APP_CONTROL_PROD = @"http://polycab.dotvik.com:8080/xmwpolycab/appControl";
NSString* const XmwcsConst_SERVICE_URL_DEAL_STORE_PROD = @"http://polycab.dotvik.com:8080/xmwpolycab/deal/home.html";
NSString* const XmwcsConst_SERVICE_URL_OPCODE_SERVICE_PROD =  @"http://polycab.dotvik.com:8080/xmwpolycab/jsonservice";
NSString *const XmwcsConst_SERVICE_URL_FILE_UPLOAD_SERVICE_PROD= @"http://polycab.dotvik.com:8080/xmwpolycab/xmwfileupload";
NSString *const XmwcsConst_SERVICE_URL_CHAT_SERVICE_PROD = @"http://polycab.dotvik.com:8080/";
NSString* const XmwcsConst_DEALER_OPCODE_URL_PROD = @"http://polycab.dotvik.com:8080/pcdealer/jsonservice";


////check
//NSString*  XmwcsConst_OPCODE_URL  = @"http://polycab.dotvik.com:8080/pcdealer/jsonservice";
//NSString*  XmwcsConst_FILE_UPLOAD_URL  = @"http://pconnect.polycab.com:8080/pcdealer/xmwfileupload";


// For connects to QA server
NSString* const XmwcsConst_SERVICE_URL_DEMO = @"http://polycab.dotvik.com:8080/xmwpolycab/feed";
NSString* const XmwcsConst_SERVICE_URL_NOTIFY_CONTEXT_DEMO = @"http://polycab.dotvik.com:8080/xmwpolycab/nms";
NSString* const XmwcsConst_PRODUCT_TREE_SERVICE_URL_DEMO = @"http://polycab.dotvik.com:8080/xmwpolycab/productsearch";
NSString* const XmwcsConst_SERVICE_URL_APP_CONTROL_DEMO = @"http://polycab.dotvik.com:8080/xmwpolycab/appControl";
NSString* const XmwcsConst_SERVICE_URL_DEAL_STORE_DEMO = @"http://polycab.dotvik.com:8080/xmwpolycab/deal/home.html";
NSString* const XmwcsConst_SERVICE_URL_OPCODE_SERVICE_DEMO = @"http://polycab.dotvik.com:8080/xmwpolycab/jsonservice";
NSString *const XmwcsConst_SERVICE_URL_FILE_UPLOAD_SERVICE_DEMO= @"http://polycab.dotvik.com:8080/xmwpolycab/xmwfileupload";
NSString *const XmwcsConst_SERVICE_URL_CHAT_SERVICE_DEMO =@"http://polycab.dotvik.com:8080/";
NSString* const XmwcsConst_DEALER_OPCODE_URL_DEMO = @"http://polycab.dotvik.com:8080/pcdealer/jsonservice";


// For connects to DEV server
NSString* const XmwcsConst_SERVICE_URL_DEV = @"http://polycab.dotvik.com:8080/xmwpolycab/feed";
NSString* const XmwcsConst_SERVICE_URL_NOTIFY_CONTEXT_DEV = @"http://polycab.dotvik.com:8080/xmwpolycab/nms";
NSString* const XmwcsConst_PRODUCT_TREE_SERVICE_URL_DEV = @"http://polycab.dotvik.com:8080/xmwpolycab/productsearch";
NSString* const XmwcsConst_SERVICE_URL_APP_CONTROL_DEV = @"http://polycab.dotvik.com:8080/xmwpolycab/appControl";
NSString* const XmwcsConst_SERVICE_URL_DEAL_STORE_DEV = @"http://polycab.dotvik.com:8080/xmwpolycab/deal/home.html";
NSString* const XmwcsConst_SERVICE_URL_OPCODE_SERVICE_DEV = @"http://polycab.dotvik.com:8080/xmwpolycab/jsonservice";
NSString *const XmwcsConst_SERVICE_URL_FILE_UPLOAD_SERVICE_DEV= @"http://polycab.dotvik.com:8080/xmwpolycab/xmwfileupload";
NSString *const XmwcsConst_SERVICE_URL_CHAT_SERVICE_DEV =@"http://polycab.dotvik.com:8080/";
NSString* const XmwcsConst_DEALER_OPCODE_URL_DEV = @"http://polycab.dotvik.com:8080/pcdealer/jsonservice";

#endif


NSString *const XmwcsConst_HAVELLS_TRAVELLER_URL = @"http://polycab.dotvik.com/servlet/traveler";
NSString *const  XmwcsConst_MKONNECT_FAQ_URL = @"http://polycab.dotvik.com:8080/xmwpolycab/faq.html";



//for the CALL NAME
NSString *const XmwcsConst_CALL_NAME_FOR_LOGIN = @"FOR_LOGIN";
NSString *const XmwcsConst_CALL_NAME_FOR_SUBMIT = @"FOR_SUBMIT";
NSString *const XmwcsConst_CALL_NAME_FOR_REPORT = @"FOR_REPORT";
NSString *const XmwcsConst_CALL_NAME_FOR_SEARCH = @"FOR_SEARCH";
NSString *const XmwcsConst_CALL_NAME_FOR_CHANGE_PASSWORD = @"FOR_CHANGE_PASSWORD";
NSString *const XmwcsConst_CALL_NAME_FOR_FORGOT_PASSWORD = @"FOR_FORGOT_PASSWORD";
NSString *const XmwcsConst_CALL_NAME_FOR_UPDATE_APP_VERSION = @"FOR_UPDATE_APP_VERSION";
NSString *const XmwcsConst_CALL_NAME_FOR_NOTIFY_DEVICE_REGISTER = @"FOR_NOTIFY_DEVICE_REGISTER";
NSString *const XmwcsConst_CALL_NAME_FOR_FETCH_NOTIFICATION_LIST = @"FOR_FETCH_NOTIFICATION_LIST";
NSString *const XmwcsConst_CALL_NAME_FOR_NOTIFY_DEVICE_DEREGISTER = @"FOR_NOTIFY_DEVICE_DEREGISTER";
NSString *const XmwcsConst_CALL_NAME_FOR_NOTIFY_PUSH_SEND_RES = @"FOR_NOTIFY_PUSH_SEND_RES";
NSString *const XmwcsConst_CALL_NAME_FOR_NOTIFY_PUSH_SEND = @"FOR_NOTIFY_PUSH_SEND";
NSString *const XmwcsConst_CALL_NAME_FOR_COMMON_REQUEST = @"FOR_COMMON_REQUEST";

NSString *const XmwcsConst_CALL_NAME_FOR_VIEW_EDIT = @"VIEW_EDIT";


//Component Type
NSString *const XmwcsConst_DE_COMPONENT_SUGGESTIVE_SEARCH_FIELD = @"SUGGESTIVE_SEARCH_FIELD" ;
NSString *const XmwcsConst_DE_COMPONENT_TEXTFIELD = @"TEXTFIELD";
NSString *const XmwcsConst_DE_COMPONENT_TEXTAREA = @"TEXTAREA";
NSString *const XmwcsConst_DE_COMPONENT_DISABLED_TEXTFIELD = @"DISABLED_TEXTFIELD";
NSString *const XmwcsConst_DE_COMPONENT_LABEL = @"LABEL";
NSString *const XmwcsConst_DE_COMPONENT_DROPDOWN = @"DROPDOWN";
NSString *const XmwcsConst_DE_COMPONENT_EDITABLE_DROPDOWN = @"EDITABLE_DROPDOWN";
NSString *const XmwcsConst_DE_COMPONENT_BUTTON = @"BUTTON";
NSString *const XmwcsConst_DE_COMPONENT_CHECKBOX = @"CHECKBOX";
NSString *const XmwcsConst_DE_COMPONENT_RADIO_GROUP = @"RADIO_GROUP";
NSString *const XmwcsConst_DE_COMPONENT_DATE_FIELD = @"DATE_FIELD";
NSString *const XmwcsConst_DE_COMPONENT_TIME_FIELD = @"TIME_FIELD";
NSString *const XmwcsConst_DE_COMPONENT_CONTACT_FIELD = @"CONTACT_FIELD";
NSString *const XmwcsConst_DE_COMPONENT_EMAIL_FIELD = @"EMAIL_FIELD";
NSString *const XmwcsConst_DE_COMPONENT_SUBHEADER_GROUP = @"SUBHEADER_GROUP";
NSString *const XmwcsConst_DE_COMPONENT_PHONE_NO_FIELD = @"PHONE_NO_FIELD";
NSString *const XmwcsConst_DE_COMPONENT_SEARCH_FIELD = @"SEARCH_FIELD";
NSString *const XmwcsConst_DE_COMPONENT_CHECKBOX_GROUP = @"CHECKBOX_GROUP";
NSString *const XmwcsConst_DE_COMPONENT_TEXTFIELD_PASSWORD = @"TEXTFIELD_PASSWORD";
NSString *const XmwcsConst_DE_COMPONENT_SUB_HEADER = @"SUB_HEADER";
NSString *const XmwcsConst_DE_COMPONENT_MULTI_SELECT = @"MULTI_SELECT";
NSString *const XmwcsConst_DE_COMPONENT_MULTI_SELECT_SEARCH = @"MULTI_SELECT_SEARCH";
NSString *const XmwcsConst_DE_COMPONENT_EDIT_SEARCH_FIELD = @"EDIT_SEARCH_FIELD";
NSString *const XmwcsConst_DE_COMPONENT_BARCODE_SCAN_FIELD = @"BARCODE_SCAN_FIELD";
NSString *const XmwcsConst_DE_COMPONENT_ATTACHMENT_BUTTON = @"FILE_ATTACHMENT";


NSString *const XmwcsConst_DE_COMPONENT_LOCATION = @"LOCATION";
NSString *const XmwcsConst_DE_COMPONENT_CAMERA_IMAGE = @"CAMERA_IMAGE";
NSString *const XmwcsConst_DE_COMPONENT_CAMERA_VIDEO = @"CAMERA_VIDEO";



//dot Form Type
NSString *const XmwcsConst_DF_FORM_TYPE_SIMPLE = @"SIMPLE";
NSString *const XmwcsConst_DF_FORM_TYPE_ADD_ROW = @"ADD_ROW";
NSString *const XmwcsConst_DF_FORM_TYPE_BUTTON = @"BUTTON";
NSString *const XmwcsConst_DF_FORM_TYPE_SIMPLEADDROW = @"SIMPLEADDROW";
NSString *const XmwcsConst_DF_FORM_TYPE_SIMPLEADDROW_SAMEFORM = @"SIMPLEADDROW_SAMEFORM";

NSString *const XmwcsConst_DF_FORM_TYPE_ABOUT_US = @"ABOUT_US";
NSString *const XmwcsConst_DF_FORM_TYPE_FAQ = @"FAQ";
NSString *const XmwcsConst_DF_FORM_TYPE_OTHER = @"OTHER";
NSString *const XmwcsConst_DF_FORM_TYPE_CHANGE_PASSWORD = @"CHANGE_PASSWORD";
NSString *const XmwcsConst_DF_FORM_TYPE_FILE_EXPLORER = @"LOCAL_FILE_EXPLORER";
NSString *const XmwcsConst_DF_FORM_TYPE_NOTIFICATION = @"LOCAL_NOTIFICATION";
NSString *const XmwcsConst_DF_FORM_TYPE_POINTS = @"LOCAL_POINTS";


//boolean Value
NSString *const XmwcsConst_BOOLEAN_VALUE_TRUE = @"TRUE";
NSString *const XmwcsConst_BOOLEAN_VALUE_FALSE = @"FALSE";

//Dropdown Value Pattern
NSString *const XmwcsConst_DE_DD_VALUE_PTRN_CODE = @"CODE";
NSString *const XmwcsConst_DE_DD_VALUE_PTRN_NAME = @"NAME";
NSString *const XmwcsConst_DE_DD_VALUE_PTRN_CODE_NAME = @"CODE_NAME";
NSString *const XmwcsConst_DE_DD_VALUE_PTRN_NAME_CODE = @"NAME_CODE";

//Time Field Value Pattern
NSString *const XmwcsConst_DE_TIME_VALUE_PTRN_12HRS = @"12HRS";
NSString *const XmwcsConst_DE_TIME_VALUE_PTRN_24HRS = @"24HRS";

//Button Data Type
NSString *const XmwcsConst_DE_BUTTON_DATA_TYPE_ADD_ROW = @"ADD_ROW";
NSString *const XmwcsConst_DE_BUTTON_DATA_TYPE_FORM_SUBMIT = @"FORM_SUBMIT";
NSString *const XmwcsConst_DE_BUTTON_DATA_TYPE_CANCEL = @"CANCEL";
NSString *const XmwcsConst_DE_BUTTON_DATA_TYPE_VIEW_REPORT = @"VIEW_REPORT";
NSString *const XmwcsConst_DE_BUTTON_DATA_TYPE_CALCULATE = @"CALCULATE";
NSString *const XmwcsConst_DE_BUTTON_DATA_TYPE_NEXT = @"NEXT";
NSString *const XmwcsConst_DE_BUTTON_DATA_TYPE_SUBFORM = @"SUBFORM";
NSString *const XmwcsConst_DE_BUTTON_DATA_TYPE_SEARCH = @"SEARCH";
//Text Data Type
NSString *const XmwcsConst_DE_TEXTFIELD_DATA_TYPE_CHAR = @"CHAR";
NSString *const XmwcsConst_DE_TEXTFIELD_DATA_TYPE_NUMERIC = @"NUMERIC";
NSString *const XmwcsConst_DE_TEXTFIELD_DATA_TYPE_AMOUNT = @"AMOUNT";
NSString *const XmwcsConst_DE_TEXTFIELD_DATA_TYPE_FLOAT = @"FLOAT";
NSString *const XmwcsConst_DE_TEXTFIELD_DATA_TYPE_PHONE = @"PHONE";
NSString *const XmwcsConst_DE_LABEL_PREVIOUS_SCREEN = @"PREVIOUS_SCREEN";


NSString *const XmwcsConst_DE_SEARCH_GROUP = @"SEARCH_GROUP";


//Dot Element Date Fromat as
NSString *const XmwcsConst_DE_DATE_FORMAT_dd_MM_yyyy = @"dd/MM/yyyy";
NSString *const XmwcsConst_DE_DATE_FORMAT_yyyy_MM_dd = @"yyyy/MM/dd";


//Dot Element Date View as
NSString *const XmwcsConst_DE_DATE_VIEW_IN_NATIVE = @"NATIVE";
NSString *const XmwcsConst_DE_DATE_VIEW_IN_CALENDAR = @"CALENDAR";

//Dot Report type
NSString *const XmwcsConst_REPORT_TYPE_SIMPLE = @"SIMPLE";
NSString *const XmwcsConst_REPORT_TYPE_SIMPLE_LINK = @"SIMPLE_LINK";
NSString *const XmwcsConst_REPORT_TYPE_LEGEND = @"LEGEND";
NSString *const XmwcsConst_REPORT_TYPE_OTHER = @"OTHER";

//Dot Report Element Column Type
NSString *const XmwcsConst_DRE_COLUMN_TYPE_SIMPLE  = @"SIMPLE";
NSString *const XmwcsConst_DRE_COLUMN_TYPE_COLOR  = @"COLOR";
NSString *const XmwcsConst_DRE_COLUMN_TYPE_HIDDEN  = @"HIDDEN";
NSString *const XmwcsConst_DRE_COLUMN_TYPE_CLICK  = @"CLICK";
NSString *const XmwcsConst_DRE_COLUMN_TYPE_COLOR_CLICK  = @"COLOR_CLICK";
NSString *const XmwcsConst_DRE_COLUMN_TYPE_EXPAND  = @"EXPAND";
NSString *const XmwcsConst_DRE_COLUMN_TYPE_SPEC_CHAR_IND = @"SPEC_CHAR_IND";
NSString *const XmwcsConst_DRE_COLUMN_TYPE_CURRENT_DATE_TIME  = @"CURRENT_DATE_TIME";
NSString *const XmwcsConst_DRE_COLUMN_TYPE_URL = @"URL";
NSString *const XmwcsConst_DRE_COLUMN_TYPE_LABEL  = @"LABEL";
NSString *const XmwcsConst_DRE_COLUMN_TYPE_CUSTOM_COLUMN  = @"CUSTOM_COLUMN";




//Dot Report Palces
NSString *const XmwcsConst_REPORT_PLACE_HEADER = @"HEADER";
NSString *const XmwcsConst_REPORT_PLACE_FOOTER = @"FOOTER";
NSString *const XmwcsConst_REPORT_PLACE_SUBHEADER = @"SUBHEADER";
NSString *const XmwcsConst_REPORT_PLACE_TABLE = @"TABLE";
NSString *const XmwcsConst_REPORT_PLACE_HEADER$FOOTER = @"HEADER$FOOTER";
NSString *const XmwcsConst_REPORT_PLACE_HEADER$TABLE = @"HEADER$TABLE";
NSString *const XmwcsConst_REPORT_PLACE_TABLE$FOOTER = @"TABLE$FOOTER";
NSString *const XmwcsConst_REPORT_PLACE_HEADER$TABLE$FOOTER = @"HEADER$TABLE$FOOTER";
NSString *const XmwcsConst_REPORT_PLACE_HEADER$SUBHEADER$TABLE$FOOTER = @"HEADER$SUBHEADER$TABLE$FOOTER";
NSString *const XmwcsConst_REPORT_PLACES_HEADER$SUBHEADER$TABLE = @"HEADER$SUBHEADER$TABLE";


//DoC Type
NSString *const XmwcsConst_DOC_TYPE_SUBMIT = @"SUBMIT";
NSString *const XmwcsConst_DOC_TYPE_VIEW = @"VIEW";
NSString *const XmwcsConst_DOC_TYPE_RECENT_REPORT = @"RECENT_REPORT";
NSString *const XmwcsConst_DOC_TYPE_CONTENT_FORM = @"CONTENT_FORM";
NSString *const XmwcsConst_DOC_TYPE_LOGOUT = @"LOGOUT";
NSString *const XmwcsConst_DOC_TYPE_VIEWDIRECT = @"VIEW_DIRECT";
NSString *const XmwcsConst_DOC_TYPE_VIEWDIRECT_EDIT = @"VIEW_DIRECT_EDIT";
NSString *const  XmwcsConst_DOC_TYPE_URL_LAUNCH = @"URL_LAUNCH";
NSString *const  XmwcsConst_DOC_TYPE_EMAIL_LAUNCH = @"EMAIL_LAUNCH";

NSString *const XmwcsConst_DOC_TYPE_VIEW_EDIT  = @"VIEW_EDIT" ;


//For the Dot Report Element Data Type
NSString *const XmwcsConst_DRE_DATA_TYPE_CHAR = @"CHAR";
NSString *const XmwcsConst_DRE_DATA_TYPE_NUMERIC = @"NUMERIC";
NSString *const XmwcsConst_DRE_DATA_TYPE_QUANTITY = @"QUANTITY";
NSString *const XmwcsConst_DRE_DATA_TYPE_AMOUNT = @"AMOUNT";
NSString *const XmwcsConst_DRE_DATA_TYPE_MOBILE = @"MOBILE";
NSString *const XmwcsConst_DRE_DATA_TYPE_EMAIL = @"EMAIL";
//For the menu map constant
NSString *const XmwcsConst_MENU_CONSTANT_FORM_ID = @"FORM_ID";
NSString *const XmwcsConst_MENU_CONSTANT_FORM_TYPE = @"FORM_TYPE";
NSString *const XmwcsConst_MENU_CONSTANT_IS_OPERATION_AVAL = @"IS_OPERATION_AVAL";
NSString *const XmwcsConst_MENU_CONSTANT_OPERATION_DETAIL = @"OPERATION_DETAIL";
NSString *const XmwcsConst_MENU_CONSTANT_OPERATION_NAME = @"OPERATION_NAME";
NSString *const XmwcsConst_MENU_CONSTANT_SEQUENCE = @"SEQUENCE";
NSString *const XmwcsConst_MENU_CONSTANT_MENU_NAME = @"MENU_NAME";
NSString *const XmwcsConst_MENU_CONSTANT_LAST_FORM_ID = @"LAST_FORM_ID";

//For the style movement
NSString *const XmwcsConst_STYLE_LABEL_MULTILINE = @"MULTILINE";
NSString *const XmwcsConst_STYLE_LABEL_TICKER = @"TICKER";
NSString *const XmwcsConst_STYLE_LABEL_NEWLINE = @"NEWLINE";

//For the style Alignment
NSString *const XmwcsConst_STYLE_PREOPERTY_LINE = @"LINE";
NSString *const XmwcsConst_STYLE_PREOPERTY_ALIGNMENT = @"ALIGNMENT";
NSString *const XmwcsConst_STYLE_ALIGNMENT_HECNTER = @"HECNTER";
NSString *const XmwcsConst_STYLE_ALIGNMENT_VCENTER = @"VCENTER";
NSString *const XmwcsConst_STYLE_ALIGNMENT_RIGHT = @"RIGHT";
NSString *const XmwcsConst_STYLE_ALIGNMENT_LEFT = @"LEFT";


//Form Opertaions
NSString *const XmwcsConst_DF_FORM_OPERATION_CREATE = @"CREATE";
NSString *const XmwcsConst_DF_FORM_OPERATION_UPDATE = @"UPDATE";
NSString *const XmwcsConst_DF_FORM_OPERATION_DELETE = @"DELETE";
NSString *const XmwcsConst_DF_FORM_OPERATION_LIST = @"LIST";
NSString *const XmwcsConst_DF_FORM_OPERATION_FILTER_LIST = @"FILTER_LIST";
NSString *const XmwcsConst_DF_FORM_OPERATION_FILTER_UPDATE = @"FILTER_UPDATE";
NSString *const XmwcsConst_DF_FORM_OPERATION_FILTER_DELETE = @"FILTER_DELETE";

//Dot Form Extended Property
NSString *const XmwcsConst_DF_EXTENDED_PROPERTY_SUB_GROUP = @"SUB_GROUP";
NSString *const XmwcsConst_DF_EXTENDED_PROPERTY_TABLE_NAME = @"TABLE_NAME";
NSString *const XmwcsConst_DF_EXTENDED_PROPERTY_ADD_ROW_COLUMN = @"ADD_ROW_COLUMN";



//Dot Element Extended Property
NSString *const XmwcsConst_DE_EXTENDED_PROPERTY_SUB_GROUP = @"SUB_GROUP";


//PHONE FIELD Constant
NSString *const XmwcsConst_DE_PHONE_FIRST_NAME = @"FIRST_NAME";
NSString *const XmwcsConst_DE_PHONE_LAST_NAME = @"LAST_NAME";
NSString *const XmwcsConst_DE_PHONE_EMAIL = @"EMAIL";

//Date FIELD Default Constant
NSString *const XmwcsConst_DE_DATE_DEFAULT = @"DEFAULT";
NSString *const XmwcsConst_DE_DATE_LOWER_LIMIT = @"LOWER_LIMIT";
NSString *const XmwcsConst_DE_DATE_UPPER_LIMIT = @"UPPER_LIMIT";
//Add Row Column Config
NSString *const XmwcsConst_DE_COLUMN_NAME = @"NAME";
NSString *const XmwcsConst_DE_COLUMN_LENGTH = @"LENGTH";
NSString *const XmwcsConst_DE_COLUMN_STYLE = @"STYLE";



//Expected value of EventDetail of Form Element
 NSString *const XmwcsConst_DE_EVENT_DETAIL_EVENT_TYPE = @"EVENT_TYPE";
 NSString *const XmwcsConst_DE_EVENT_DETAIL_REFRESH_FIELD = @"REFRESH_FIELD";
 NSString *const XmwcsConst_DE_EVENT_DETAIL_EVENT_ACTION = @"EVENT_ACTION";
 NSString *const XmwcsConst_DE_EVENT_EVENT_LOST_FOCUS = @"LOST_FOCUS";
 NSString *const XmwcsConst_DE_EVENT_EVENT_GOT_FOCUS = @"GOT_FOCUS";
 NSString *const XmwcsConst_DE_EVENT_EVENT_ON_SELECT = @"ON_SELECT";
 NSString *const XmwcsConst_DE_EVENT_EVENT_ON_CLICK = @"ON_CLICK";
 NSString *const XmwcsConst_DE_EVENT_EVENT_ALERT_WINODW = @"ALERT_WINODW";

 NSString *const XmwcsConst_FIELD_TYPE_STRING = @"STRING";
 NSString *const XmwcsConst_FIELD_TYPE_INTEGER = @"INTEGER";
 NSString *const XmwcsConst_FIELD_TYPE_FLOAT = @"FLOAT";

 NSString *const XmwcsConst_FIELD_TYPE_DOT_FORM_FIELD = @"DOT_FORM_FIELD";

 NSString *const XmwcsConst_FIELD_OPERATION_ADDITION = @"ADD";
 NSString *const XmwcsConst_FIELD_OPERATION_SUBSTRACTION = @"SUB";
 NSString *const XmwcsConst_FIELD_OPERATION_MULTIPLICATION = @"MUL";
 NSString *const XmwcsConst_FIELD_OPERATION_DIVISION = @"DIV";

 NSString *const XmwcsConst_FIELD_OPERATION_GREATER_THAN = @"GT";
 NSString *const XmwcsConst_FIELD_OPERATION_GREATER_THAN_EQUAL = @"GTE";
 NSString *const XmwcsConst_FIELD_OPERATION_LESS_THAN = @"LT";
 NSString *const XmwcsConst_FIELD_OPERATION_LESS_THAN_EQUAL = @"LTE";
 NSString *const XmwcsConst_FIELD_OPERATION_EQUAL = @"EQ";
 NSString *const XmwcsConst_FIELD_OPERATION_STRING_CONCAT = @"STRCONCAT";

 NSString *const XmwcsConst_FIELD_OPERATION_RESULT_VALID = @"VALID";
 NSString *const XmwcsConst_FIELD_OPERATION_RESULT_NOT_VALID = @"NOT_VALID";
 NSString *const XmwcsConst_FIELD_OPERATION_RESULT_GT = @"GT";
 NSString *const XmwcsConst_FIELD_OPERATION_RESULT_LESS = @"LESS";
 NSString *const XmwcsConst_FIELD_OPERATION_RESULT_EQUAL = @"EQ";


int const XmwcsConst_SplashScreen = 0;
int const XmwcsConst_LaunchForm = 1;
int const XmwcsConst_LoginScreen = 2;
int const XmwcsConst_MainMenuScreen = 3;
int const XmwcsConst_EssMenuScreen = 13;
int const XmwcsConst_EssRecentRequestScreen = 14;
int const XmwcsConst_EssRecentDocumentScreen = 15;
int const XmwcsConst_SalesMenuScreen = 23;
int const XmwcsConst_WorkflowLoginScreen = 32;
int const XmwcsConst_WorkflowMainScreen = 31;
int const XmwcsConst_SCREEN_ID_SIMPLE_FORM = 4;
int const XmwcsConst_SCREEN_ID_SEARCH_RESULT = 5;
int const XmwcsConst_SubMenuScreen = 11;


int const XmwcsConst_CommandExit = 1;
int const XmwcsConst_CommandBack = 2;
int const XmwcsConst_CommandAbout = 3;
int const XmwcsConst_CommandCancel = 4;
int const XmwcsConst_CommandLogout = 5;

NSString *const XmwcsConst_CommandTextBack = @"Back";
NSString *const XmwcsConst_CommandTextExit = @"Exit";
NSString *const XmwcsConst_CommandTextCancel = @"Cancel";
NSString *const XmwcsConst_CommandTextLogout = @"Logout";

NSString *const XmwcsConst_LaunchForm_APP_TITLE = @"Enterprise Mobility";
NSString *const XmwcsConst_LaunchForm_LOGIN = @"Login";
NSString *const XmwcsConst_LoginScreen_TITLE = @"Enterprise : Login";
NSString *const XmwcsConst_LoginScreen_USERNAME = @"Username:";
NSString *const XmwcsConst_LoginScreen_PASSWORD = @"Password";
NSString *const XmwcsConst_LoginScreen_SIGN_IN = @"SIGN IN";

NSString *const XmwcsConst_MainMenuScreen_TITLE = @"Main Menu";
NSString *const XmwcsConst_SIMPLESCREEN_TITLE = @"SimpleScreenTitle";

BOOL const XmwcsConst_IS_DEBUG = true;


NSString *const XmwcsConst_IMEI = @"IMEI";
NSString *const XmwcsConst_DEVICE_MODEL = @"DEVICE_MODEL";
NSString *const XmwcsConst_DEVICE_DETAIL = @"DEVICE_DETAIL";

NSString *const XmwcsConst_RECENT_REQ_MAX_DOC_ID = @"MAX_DOC_ID";
NSString *const XmwcsConst_RECENT_REQ_DOC_NAME = @"DOC_NAME";
NSString *const XmwcsConst_RECENT_REQ_STATUS = @"STATUS";
NSString *const XmwcsConst_RECENT_REQ_TRACER_NO = @"TRACER_NO";
NSString *const XmwcsConst_RECENT_REQ_DOC_SUBMIT_DATE = @"DOC_SUBMIT_DATE";
NSString *const XmwcsConst_RECENT_REQ_DOC_SUBMIT_MESSAGE = @"DOC_SUBMIT_MESSAGE";

NSString *const XmwcsConst_RECENT_REQ_FORM_ID = @"DOC_ID";

//For the Property of DrillDown Property
 NSString *const XmwcsConst_REPORT_DD_PROP_ADAPTER_ID = @"ADAPTER_ID";
 NSString *const XmwcsConst_REPORT_DD_PROP_ADAPTER_TYPE = @"ADAPTER_TYPE";
 NSString *const XmwcsConst_REPORT_DD_PROP_CALL_NAME = @"CALL_NAME";
 NSString *const XmwcsConst_REPORT_DD_PROP_MIDDLE_SCR_MSG = @"MIDDLE_SCR_MSG";
 NSString *const XmwcsConst_DD_PROP_NETWORK_FIELD_TABLE = @"NETWORK_FIELD_TABLE";
 NSString *const XmwcsConst_REPORT_DD_PROP_NETWORK_FIELD_HEADER = @"NETWORK_FIELD_HEADER";
 NSString *const XmwcsConst_REPORT_DD_PROP_NETWORK_FIELD_FOOTER = @"NETWORK_FIELD_FOOTER";
 NSString *const XmwcsConst_REPORT_DD_PROP_IS_NETWORK_CALL = @"IS_NETWORK_CALL";
 NSString *const XmwcsConst_REPORT_DD_PROP_IS_DISPLAY_ON_EXPAND = @"IS_DISPLAY_ON_EXPAND";
NSString *const XmwcsConst_REPORT_DD_PROP_URL_FIELD = @"URL_FIELD";
NSString *const XmwcsConst_REPORT_DD_PROP_ACTION = @"ACTION";
NSString *const XmwcsConst_REPORT_DD_PROP_ACTION_TYPE = @"TYPE";
NSString *const XmwcsConst_REPORT_DD_PROP_ACTION_FORM_ID = @"FORM_ID";
NSString *const XmwcsConst_REPORT_DD_PROP_SERVER_CACHE = @"SERVER_CACHE";




//Extended  Poperty Of The Report

 NSString *const XmwcsConst_REPORT_EXTENDED_CLICK_EVENT_ON = @"CLICK_EVENT_ON";
 NSString *const XmwcsConst_REPORT_EXTENDED_LEGEND_COLOR_ON = @"LEGEND_COLOR_ON";
 NSString *const XmwcsConst_REPORT_EXTENDED_LEGEND_NAME_ON = @"LEGEND_NAME_DATA_ON";



// error tags

NSString *const XmwcsConst_MAIN_ERROR_TYPE = @"ERROR_TYPE";
NSString *const XmwcsConst_MAIN_ERROR_SUB_TYPE = @"ERROR_SUB_TYPE";
NSString *const XmwcsConst_MAIN_ERROR_MSG = @"ERROR_MSG";

//Main Exception Type

int const XmwcsConst_MAIN_XMW_PLATFORM = 1;
int const XmwcsConst_MAIN_ADAPTER = 2;
int const XmwcsConst_MAIN_CLIENT = 3;


//Exception Sub type

int const XmwcsConst_SUB_CLIENT_JSON_PARSE = 1;
int const XmwcsConst_SUB_CLIENT_SERVICE_UN_AVAILABLE = 2;
int const XmwcsConst_SUB_CLIENT_SESSION_EXPIRE = 3;
int const XmwcsConst_SUB_CLIENT_PASSWORD_RESET = 4;
int const XmwcsConst_SUB_CLIENT_OTHER = 5;


int const XmwcsConst_SUB_XMW_PLATFORM_HIBERNATE = 6;
int const XmwcsConst_SUB_XMW_PLATFORM_OTHER = 7;

int const XmwcsConst_SUB_ADAPTER_CONNECTION_ERROR = 8;
int const XmwcsConst_SUB_ADAPTER_DATA_PARSE_ERROR = 9;
int const XmwcsConst_SUB_ADAPTER_OTHER = 10;

NSString *const XmwcsConst_APP_ID = @"APP_ID";
NSString *const XmwcsConst_APP_VERSION = @"APP_VERSION";
NSString *const XmwcsConst_DEVICE_TYPE = @"DEVICE_TYPE";

NSString *const XmwcsConst_DEVICE_TYPE_ANDROID = @"Android";
NSString *const XmwcsConst_DEVICE_TYPE_WINDOWS_PHONE = @"Windows Phone";
NSString *const XmwcsConst_DEVICE_TYPE_J2ME = @"J2ME";
NSString *const XmwcsConst_DEVICE_TYPE_BB10 = @"BB10";
NSString *const XmwcsConst_DEVICE_TYPE_BB = @"BB";
NSString *const XmwcsConst_DEVICE_TYPE_IPHONE = @"iPhone";
NSString *const XmwcsConst_DEVICE_TYPE_IPAD = @"iPad";
NSString *const XmwcsConst_DEVICE_TYPE_BROWSER = @"Browser";

int const XmwcsConst_NOTIFY_TYPE_OTHERS = 0;
int const XmwcsConst_NOTIFY_TYPE_MSG_WINDOW = 1;
int const XmwcsConst_NOTIFY_TYPE_CONTENT = 2;
int const XmwcsConst_NOTIFY_TYPE_FORM = 3;
int const XmwcsConst_NOTIFY_TYPE_REPORT = 4;
int const XmwcsConst_NOTIFY_TYPE_MENU_MSG = 5;//Total Sales
int const XmwcsConst_NOTIFY_TYPE_MENU_DATA = 6;
int const XmwcsConst_NOTIFY_TYPE_URL_LAUNCH = 7;

//Keychain and AppGroup Identifier
NSString *const XmwcsConst_KEYCHAIN_IDENTIFIER = @"com.polycab.xmw.employee.ent";
NSString *const XmwcsConst_APPGROUP_IDENTIFIER = @"group.com.polycab.xmw.employee.ent";

//Dashboard Card Cell Observer Identifier
NSString *const XmwcsConst_SALESAGGREGATE_CARD_AUTOREFRESH_IDENTIFIER            = @"SALESAGGREGATE_CARD_AUTOREFRESH" ;
NSString *const XmwcsConst_CREDITDETAILS_CARD_AUTOREFRESH_IDENTIFIER             = @"CREDITDETAILS_CARD_AUTOREFRESH" ;
NSString *const XmwcsConst_ORDERPENDENCY_CARD_AUTOREFRESH_IDENTIFIER             = @"ORDERPENDENCY_CARD_AUTOREFRESH" ;
NSString *const XmwcsConst_DASHBOARD_FOREGROUND_AUTOREFRESH_IDENTIFIER           = @"DASHBOARD_FOREGROUND_AUTOREFRESH" ;

NSString *const XmwcsConst_OVERDUE_CARD_AUTOREFRESH_IDENTIFIER                   = @"OVERDUE_CARD_AUTOREFRESH" ;
NSString *const XmwcsConst_NATIONALSALESAGGREGATE_CARD_AUTOREFRESH_IDENTIFIER    = @"NATIONALSALESAGGREGATE_CARD_AUTOREFRESH" ;
NSString *const XmwcsConst_NATIONALSALESAGGREGATEPIE_CARD_AUTOREFRESH_IDENTIFIER = @"NATIONALSALESAGGREGATEPIE_CARD_AUTOREFRESH" ;
NSString *const XmwcsConst_PAYMENTOUTSTANDING_CARD_AUTOREFRESH_IDENTIFIER        = @"PAYMENTOUTSTANDING_CARD_AUTOREFRESH" ;
NSString *const XmwcsConst_OVERDUEPIE_CARD_AUTOREFRESH_IDENTIFIER                = @"OVERDUEPIE_CARD_AUTOREFRESH" ;


//GPS Location Key
NSString *const XmwcsConst_GPS_LOCATION_KEY                   = @"GPS_LOCATION_KEY" ;
NSString *const XmwcsConst_GPS_LOCATION_LATITUDE_KEY          = @"GPS_LOCATION_LATITUDE_KEY" ;
NSString *const XmwcsConst_GPS_LOCATION_LONGITUDE_KEY         = @"GPS_LOCATION_LONGITUDE_KEY" ;
NSString *const XmwcsConst_GPS_LOCATION_GET_CURRENT_TIME_KEY  = @"LOCATION_GET_CURRENT_TIME_KEY" ;
          double XmwcsConst_GPS_LOCATION_GET_DEFAULT_TIME_VARIABLE = 1.0;
NSString *const XmwcsConst_ATTENDANCE_USER_DEFAULT_DICT       = @"ATTENDANCE_USER_DEFAULT_DICT" ;
