//
//  Constant.h
//
//  Copyright © 2016. All rights reserved.
//

#ifndef Constant_h
#define Constant_h

typedef enum CALL_STATE {
    CALL_STATE_STARTED,
    CALL_STATE_BUSY,
    CALL_STATE_ENDED,
    CALL_STATE_OFFLINE,
    CALL_STATE_ON_HOLD,
    CALL_STATE_RELEASED,
    CALL_STATE_CONNECTED
}CALL_STATE;

typedef enum CALL_TYPE {
    CALL_TYPE_INCOMING = 1  ,
    CALL_TYPE_OUTGOING      ,
    CALL_TYPE_MISSED
} CALL_TYPE;

typedef enum MSG_TYPE {
    MSG_TYPE_TEXT = 1   ,
    MSG_TYPE_IMAGE      ,
    MSG_TYPE_VIDEO      ,
    MSG_TYPE_AUDIO      ,
    MSG_TYPE_LOCATION
} MSG_TYPE;

typedef enum MSG_STATE {
    MSG_STATE_OFFLINE = 1   ,
    MSG_STATE_SENT          ,
    MSG_STATE_RECEIVED      ,
    MSG_STATE_READ          ,
    MSG_STATE_INBOX
} MSG_STATE;

typedef enum ENTITY_TYPE {
    ENTITY_TYPE_COMPANY = 1     ,
    ENTITY_TYPE_DEPARTMENT      ,
    ENTITY_TYPE_EMPLOYEE        
} ENTITY_TYPE;

typedef enum BTN_STATE {
    BTN_STATE_OFF = 1   ,
    BTN_STATE_ON
} BTN_STATE;

typedef enum RESPONSE_TYPE {
    RESPONSE_TYPE_OK = 1  ,
    RESPONSE_TYPE_LOGIN_FAILURE        ,
    RESPONSE_TYPE_ACCESS_DENIED        ,
    RESPONSE_TYPE_TOKEN_INVALID
} RESPONSE_TYPE;


//--------------------------------------------------//

#pragma mark Database Constants
//constants for database

//--------------------------------------------------//

#pragma mark Request Constants

#define URLlogin            @"https://urlToLogin"
#define URLupload           @"https://urlToUpload"
#define URLgetCompanies     @"https://urlToGetCompanies"

//--------------------------------------------------//

#pragma mark Storyboard Constants

#define segueLoginToCom     @"loginToCompany"
#define segueEmpToCont      @"employeeToContact"
#define segueCompToEmp      @"companyToEmployee"
#define segueDeptToEmp      @"departmentToEmployee"
#define segueContToMsg      @"contactToMessage"
#define segueChatToMsg      @"chatToMessage"
#define segueMsgToImg       @"messageToImages"

#define VCEmployee          @"employeeVC"
#define VCMessage           @"messageVC"
#define VCCallDetail        @"callDetailVC"

//--------------------------------------------------//



#endif

#endif /* Constant_h */
