//
//  AppConst.h
//  WOEC
//
//  Created by Tuannq on 5/2/17.
//  Copyright © 2017 Tuannq. All rights reserved.
//

#ifndef AppConst_h
#define AppConst_h


typedef NS_ENUM(NSInteger, SegmentState) {
    
    SegmentStateAll = 0,
    SegmentStateSend,
    SegmentStateReceive,
};

typedef NS_ENUM(NSInteger, SearchState) {
    
    SearchStateNormal = 0,
    SearchStateEdit,
    SearchStateAdd,
};

// Detect device
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE6 ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && MAX([UIScreen mainScreen].bounds.size.height,[UIScreen mainScreen].bounds.size.width) == 667)
#define IS_IPHONE5 ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && MAX([UIScreen mainScreen].bounds.size.height,[UIScreen mainScreen].bounds.size.width) == 568)
#define IS_IPHONE4 ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && MAX([UIScreen mainScreen].bounds.size.height,[UIScreen mainScreen].bounds.size.width) == 480)
#define IS_IPHONE6PLUS ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && MAX([UIScreen mainScreen].bounds.size.height,[UIScreen mainScreen].bounds.size.width) == 736)

#define SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)


static NSString * const PROFILEDATA_NAME = @"ProfileData.dat";
static NSString * const IS_OPENED_APP = @"isOpenedApp";

static NSString * const MSG_DOES_NOT_HAVE_ACCESS_CAMERA = @"This app does not have access to your camera. You can enable access in Privacy Settings.";
static NSString * const BUTTON_CANCEL =  @"Cancel";
static NSString * const BUTTON_OK =  @"OK";
static NSString * const BUTTON_GO =  @"Go";
static NSString * const BUTTON_ADVANCE =  @"Advance";
static NSString * const BUTTON_SIMPLE =  @"Simple";
static NSString * const MSG_NOT_SUPPORT_DEVICE =  @"Reader not supported by the current device";
static NSString * const MSG_ERROR_UNKNOWN =  @"Unknown";
static NSString * const MSG_BLANK = @"";
static NSString * const MSG_LOADING = @"Loading...";
static NSString * const MSG_ERROR_NETWORK = @"Unable to connect. Try later";
static NSString * const BUTTON_DONE =  @"Done";
static NSString * const MSG_PHOTO_ALBUM_RESULT = @"%@ Photos";
static NSString * const TITLE_ONE_ITEM_SELECTED = @"%@ item selected";
static NSString * const TITLE_MORE_ITEM_SELECTED = @"%@ items selected";
static NSString * const MSG_ERROR_STATEMENT_QUERY = @"Can't execute query";
static NSString * const MSG_ERROR_PASSCODE_FAIL_TOO_MUCH = @"False password too much. Application will logout";
static NSString * const MSG_ERROR_TEXTFIELD_EMPTY = @"%@ not empty";
static NSString * const MSG_SUCCESS = @"Update success";
static NSString * const MSG_ERROR_UPDATE_FAIL = @"Can't Update";
static NSString * const MSG_CONFIRM_DELETE = @"Do you want delete ???";
static NSString * const MSG_CONFIRM_LOGOUT = @"Do you want logout ???";

static NSString * const kViewControllerPin = @"kViewControllerPin";
static NSString * const kNotifUpdateAmout = @"updateAmout";

static NSString * const MSG_CAN_OPEN_SETING =  @"It looks like your privacy settings are preventing us from accessing your camera. You can fix this by doing the following:\n\n1. Touch the Go button below to open the Settings app.\n\n2. Touch Privacy.\n\n3. Turn the Camera on.\n\n4. Open this app and try again.";
static NSString * const MSG_CAN_NOT_OPEN_SETING =  @"It looks like your privacy settings are preventing us from accessing your camera. You can fix this by doing the following:\n\n1. Close this app.\n\n2. Open the Settings app.\n\n3. Scroll to the bottom and select this app in the list.\n\n4. Touch Privacy.\n\n5. Turn the Camera on.\n\n6. Open this app and try again.";

static NSString * const kVC_TimelineTableViewCell = @"TimelineTableViewCell";
static NSString * const kIdentifier_timelineTableViewCell = @"timelineTableViewCell";

static NSString * const kVC_ContactTableViewCell = @"ContactTableViewCell";
static NSString * const kIdentifier_contactTableViewCell = @"contactTableViewCell";


#define SERVER_PATH @"http://119.81.117.21:3000/api/"
#define URL_GET_BALANCE (SERVER_PATH @"wallet_get_balance?u=%@&p=%@")
#define URL_GET_TRANSFERS (SERVER_PATH @"wallet_get_transfers?u=%@&p=%@")
#define URL_GET_ADDRESS (SERVER_PATH @"wallet_get_address?u=%@&p=%@")
#define URL_LOGIN (@"http://119.81.117.21:3000/login")
#define URL_SEND (@"http://119.81.117.21:3000/send")
#define URL_UPDATE_USER (@"http://119.81.117.21:3000/update_user")

#define COOKIE_HEADER (@"Cookie")



#define HTTP_REQUEST_TIME_OUT 60
#endif /* AppConst_h */
