//
//  JSONStructureConstant.cpp
//  demo
//
//  Created by Ashish Tiwari on 20/05/13.
//
//

#import <Foundation/Foundation.h>
#import "JSONStructureConstant.h"

NSString *const JsonStrucConst_TRUE = @"1";
NSString *const JsonStrucConst_FALSE = @"0";

// dotForm
NSString *const JsonStrucConst_DOT_FORMS = @"DOT_FORMS";
NSString *const JsonStrucConst_FORM_ID = @"formId";
NSString *const JsonStrucConst_SCREEN_DESC = @"screenDesc";
NSString *const JsonStrucConst_SCREEN_NAME = @"screenName";
NSString *const JsonStrucConst_SCREEN_HEADER = @"screenHeader";
NSString *const JsonStrucConst_SCREEN_MENU_CONFIG = @"screenMenuConfig";
NSString *const JsonStrucConst_FORM_TYPE = @"formType";
NSString *const JsonStrucConst_FORM_SUB_TYPE = @"formSubType";
NSString *const JsonStrucConst_ADAPTER_TYPE = @"adapterType";
NSString *const JsonStrucConst_SUBMIT_ADAPTER_ID = @"submitAdapterId";
NSString *const JsonStrucConst_VIEW_ADAPTER_ID = @"viewAdapterId";
NSString *const JsonStrucConst_FORM_ELEMENT = @"formElement";
NSString *const JsonStrucConst_FORM = @"form";

NSString *const JsonStrucConst_ELEMENTS = @"ELEMENTS";

// dotFormElement
NSString *const JsonStrucConst_ELEMENT_ID = @"elementId";
NSString *const JsonStrucConst_ELEMENT_POSITION = @"elementPosition";
NSString *const JsonStrucConst_DESCRIPTION = @"description";
NSString *const JsonStrucConst_DISPLAY_TEXT = @"displayText";
NSString *const JsonStrucConst_OPTIONAL = @"optional";
NSString *const JsonStrucConst_DATA_TYPE = @"dataType";
NSString *const JsonStrucConst_LENGTH = @"length";
NSString *const JsonStrucConst_DEFAULT_VAL = @"default";
NSString *const JsonStrucConst_IS_ELEMENT_DISPLAY = @"isElementDisplay";
NSString *const JsonStrucConst_ELEMENT_TYPE = @"elementType";
NSString *const JsonStrucConst_IS_HISTORY_CACHE = @"isHistoryCache";
NSString *const JsonStrucConst_IS_ELEMENT_DEPEND_ON_OTHER = @"isElementDependOnOther";
NSString *const JsonStrucConst_DEPENDED_ELEMENT_NAME = @"dependedElementName";
NSString *const JsonStrucConst_DEPENDED_ELEMENT_VALUE = @"dependedElementValue";
NSString *const JsonStrucConst_VALUE_SET_ELEMENT_NAME = @"valueSetElementName";
NSString *const JsonStrucConst_FORMAT = @"format";
NSString *const JsonStrucConst_ELEMENT_STYLE = @"elementStyle";
NSString *const JsonStrucConst_MASTER_VALUE_MAPPING = @"masterValueMapping";
NSString *const JsonStrucConst_COLUMN_CONFIG = @"columnConfig";
NSString *const JsonStrucConst_EXTENDED_PROPERTY = @"extendedProperty";
NSString *const JsonStrucConst_IS_USE_FORWARD = @"isUseForward";
NSString *const JsonStrucConst_EVENT_DETAIL = @"eventDetail";
NSString *const JsonStrucConst_READ_ONLY = @"readonly";
NSString *const JsonStrucConst_ENABLE_ALL = @"enableAll";


// Constant for Report Definition other then Form Element and Definition
NSString *const JsonStrucConst_PLACE = @"place";
NSString *const JsonStrucConst_VALUE_DEPEND_ON = @"valueDependOn";
NSString *const JsonStrucConst_REPORT_ID = @"reportId";
NSString *const JsonStrucConst_REPORT_TYPE = @"reportType";
NSString *const JsonStrucConst_REPORT_PLACES = @"reportPlaces";
NSString *const JsonStrucConst_IS_DRILL_DOWN = @"isDrilldown";
NSString *const JsonStrucConst_DRILLDOWN_DETAIL = @"drilldownDetail";
NSString *const JsonStrucConst_REPORT_ELEMENT = @"reportElement";
NSString *const JsonStrucConst_REPORT = @"report";
NSString *const JsonStrucConst_DOT_REPORTS = @"DOT_REPORTS";





//Constant for the ClientMasterDetail
NSString *const JsonStrucConst_USER_MODULE = @"USER_MODULE";
NSString *const JsonStrucConst_MODULE_UPDATE_DETAIL = @"MODULE_UPDATE_DETAIL";
NSString *const JsonStrucConst_MASTER_DATA_REFRESH = @"MASTER_DATA_REFRESH";
NSString *const JsonStrucConst_MASTER_DATA = @"MASTER_DATA";
NSString *const JsonStrucConst_DOT_CLIENT_XML_DATA = @"DOT_CLIENT_XML_DATA";
NSString *const JsonStrucConst_DOT_FORM_DATA = @"DOT_FORM_DATA";
NSString *const JsonStrucConst_DOT_REPORT_DATA = @"DOT_REPORT_DATA";
NSString *const JsonStrucConst_CLIENT_MASTER_DETAIL = @"CLIENT_MASTER_DETAIL";

//Login Structure Property Constant
NSString *const JsonStrucConst_USER_NAME = @"USER_NAME";
NSString *const JsonStrucConst_PASSWORD = @"PASSWORD";
NSString *const JsonStrucConst_MODULE_ID = @"MODULE_ID";
NSString *const JsonStrucConst_LANGUAGE = @"LANGUAGE";
NSString *const JsonStrucConst_ROLE_XML_CACHE_DATE = @"ROLE_XML_CACHE_DATE";
NSString *const JsonStrucConst_DEVICE_INFO_MAP = @"DEVICE_INFO_MAP";
NSString *const JsonStrucConst_AUTH_TOKEN =@"JWT_OAUTH_TOKEN";

//Menu Detail Constant
NSString *const JsonStrucConst_USER_LOGIN_STATUS = @"USER_LOGIN_STATUS";
NSString *const JsonStrucConst_USER_LOGIN_MSG = @"USER_LOGIN_MSG";
NSString *const JsonStrucConst_PASS_STATE = @"PASS_STATE";
NSString *const JsonStrucConst_PASS_STATE_MSG = @"PASS_STATE_MSG";
NSString *const JsonStrucConst_MAX_DOC_NO = @"MAX_DOC_NO";
NSString *const JsonStrucConst_SERVER_DATE_TIME = @"SERVER_DATE_TIME";
NSString *const JsonStrucConst_MENU_DETAIL = @"MENU_DETAIL";
NSString *const JsonStrucConst_USER_DASHBOARD_DATA = @"USER_DASHBOARD_DATA";


//Dot Form post Constant
NSString *const JsonStrucConst_DOC_ID = @"DOC_ID";
NSString *const JsonStrucConst_DOC_DESC = @"DOC_DESC";
NSString *const JsonStrucConst_ADAPTER_ID = @"ADAPTER_ID";
NSString *const JsonStrucConst_REPORT_CACHE_REFRESH = @"REPORT_CACHE_REFRESH";
NSString *const JsonStrucConst_POST_DATA = @"POST_DATA";
NSString *const JsonStrucConst_DISPLAY_DATA = @"DISPLAY_DATA";

//DocPost Response
NSString *const JsonStrucConst_TRACKER_NO = @"TRACKER_NO";
NSString *const JsonStrucConst_SUBMIT_MESSAGE = @"SUBMIT_MESSAGE";
NSString *const JsonStrucConst_SUBMIT_STATUS = @"SUBMIT_STATUS";
NSString *const JsonStrucConst_SUBMIT_DATA = @"SUBMIT_RESPONSE_DATA";

// Report Post Response Constant
NSString *const JsonStrucConst_VIEW_REPORT_ID = @"VIEW_REPORT_ID";
NSString *const JsonStrucConst_HEADER_DATA = @"HEADER_DATA";
NSString *const JsonStrucConst_TABLE_DATA = @"TABLE_DATA";
NSString *const JsonStrucConst_SUB_HEADER_DATA = @"SUB_HEADER_DATA";
NSString *const JsonStrucConst_FOOTER_DATA = @"FOOTER_DATA";

///DocFormPost Off line Processing Object
NSString *const JsonStrucConst_STATUS_CLIENT_SUBMIT = @"STATUS_CLIENT_SUBMIT";
NSString *const JsonStrucConst_STATUS_SERVER_SUBMIT = @"STATUS_SERVER_SUBMIT";
NSString *const JsonStrucConst_RECORD_STATUS = @"RECORD_STATUS";
NSString *const JsonStrucConst_DOC_SUBMIT_DATE = @"DOC_SUBMIT_DATE";
NSString *const JsonStrucConst_FORM_POST_RESPONSE = @"FORM_POST_RESPONSE";
NSString *const JsonStrucConst_SERVER_RESPONSE_ID_ON_FIRST_SINK = @"SERVER_RESPONSE_ID_ON_FIRST_SINK";
NSString *const JsonStrucConst_DOT_FORM_POST_OBJ = @"DOT_FORM_POST_OBJ";




//Search Response Constant
NSString *const JsonStrucConst_SEARCH_MESSAGE = @"SEARCH_MESSAGE";
NSString *const JsonStrucConst_SEARCH_HEADER_DETAIL = @"SEARCH_HEADER_DETAIL";
NSString *const JsonStrucConst_SEARCH_DATA_FOR_SUBMIT = @"SEARCH_DATA_FOR_SUBMIT";
NSString *const JsonStrucConst_SEARCH_DATA_FOR_DISPLAY = @"SEARCH_DATA_FOR_DISPLAY";
NSString *const JsonStrucConst_SEARCH_RECORD = @"SEARCH_RECORD";


// APP Update
NSString *const JsonStrucConst_APP_UPDATE_MINOR_VERSION = @"MINOR_VERSION";
NSString *const JsonStrucConst_APP_UPDATE_MAJOR_VERSION = @"MAJOR_VERSION";
NSString *const JsonStrucConst_APP_UPDATE_FORCE = @"FORCE_UPDATE";
NSString *const JsonStrucConst_APP_UPDATE_APP_DOWNLOAD_URL = @"APP_DOWNLOAD_URL";


//For the Register Notification Devices
NSString *const JsonStrucConst_NOTIFY_DEVICE_REGISTER_ID = @"DEVICE_REGISTER_ID";
NSString *const JsonStrucConst_NOTIFY_DEVICE_PORT = @"DEVICE_PORT";
NSString *const JsonStrucConst_NOTIFY_APP_ID = @"APP_ID";
NSString *const JsonStrucConst_NOTIFY_MODULE_ID = @"MODULE_ID";
NSString *const JsonStrucConst_NOTIFY_SESSION_DETAIL = @"SESSION_DETAIL";
NSString *const JsonStrucConst_NOTIFY_USER_ID = @"USER_ID";
NSString *const JsonStrucConst_NOTIFY_IMEI= @"IMEI";
NSString *const JsonStrucConst_NOTIFY_OS= @"OS";

//For the Send Comman Notfication Structure
NSString *const JsonStrucConst_NOTIFY_OPERATION = @"OPERATION";
NSString *const JsonStrucConst_NOTIFY_ID = @"NOTIFY_ID";
NSString *const JsonStrucConst_NOTIFY_IS_REQUIRE_LOGIN = @"IS_REQUIRE_LOGIN";
NSString *const JsonStrucConst_NOTIFY_IS_RESPOND_BACK = @"IS_RESPOND_BACK";
NSString *const JsonStrucConst_NOTIFY_IS_APP_RESTART = @"IS_APP_RESTART";
NSString *const JsonStrucConst_NOTIFY_IS_CONTENT_SEND_AS_BYTES = @"IS_CONTENT_SEND_AS_BYTES";
NSString *const JsonStrucConst_NOTIFY_CONTENT_TYPE = @"NOTIFY_CONTENT_TYPE";
NSString *const JsonStrucConst_NOTIFY_CONTENT_TITLE = @"NOTIFY_CONTENT_TITLE";
NSString *const JsonStrucConst_NOTIFY_CONTENT_MSG = @"NOTIFY_CONTENT_MSG";
NSString *const JsonStrucConst_NOTIFY_CONTENT_URL = @"NOTIFY_CONTENT_URL";
NSString *const JsonStrucConst_NOTIFY_CONTENT_DATA = @"NOTIFY_CONTENT_DATA";
NSString *const JsonStrucConst_NOTIFY_CONTENT_CALL_BACK_DATA = @"NOTIFY_CONTENT_CALL_BACK_DATA";
NSString *const JsonStrucConst_NOTIFY_EXTRA_INFO = @"NOTIFY_EXTRA_INFO";
NSString *const JsonStrucConst_NOTIFY_CREATE_DATE = @"NOTIFY_CREATE_DATE";
NSString *const JsonStrucConst_NOTIFY_LOG_ID = @"NOTIFY_LOG_ID";

//Common Request Send Request
NSString *const JsonStrucConst_COMMON_REQ_REQUEST_ID = @"REQUEST_ID";
NSString *const JsonStrucConst_COMMON_REQ_POST_DATA = @"POST_DATA";
NSString *const JsonStrucConst_COMMON_REQ_EXTRA_DATA = @"EXTRA_DATA";
NSString *const JsonStrucConst_COMMON_REQ_EXTRA_STRING = @"EXTRA_STRING";

NSString *const JsonStrucConst_NOTIFY_CONFIG_ID =@"NOTIFY_CONFIG_ID";



