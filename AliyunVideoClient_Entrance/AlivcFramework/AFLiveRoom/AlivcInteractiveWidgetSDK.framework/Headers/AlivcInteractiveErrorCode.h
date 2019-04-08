//
//  AlivcInteractiveErrorCode.h
//  AlivcLiveRoomSDK
//
//  Created by OjisanC on 2018/5/19.
//  Copyright © 2018年 Aliyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 AlivcInteractiveErrorCode

 - ALIVC_INTERACTIVE_ERROR_INVALID_STATE: INVALID_STATE
 - ALIVC_INTERACTIVE_ERROR_INVALID_PARAM: INVALID_PARAM
 - ALIVC_INTERACTIVE_ERROR_UNKNOWN: UNKNOWN
 - ALIVC_INTERACTIVE_ERROR_RETURN_FAILED: RETURN_FAILED
 - ALIVC_INTERACTIVE_RETURN_SUCCESS: SUCCESS
 */
typedef NS_ENUM(NSInteger,AlivcInteractiveErrorCode) {
    ALIVC_INTERACTIVE_ERROR_INVALID_STATE                       = -4 , //参数非法，请检查输入参数
    ALIVC_INTERACTIVE_ERROR_INVALID_PARAM                       = -3 , //参数非法，请检查输入参数
    ALIVC_INTERACTIVE_ERROR_UNKNOWN                             = -2 , //参数非法，请检查输入参数
    ALIVC_INTERACTIVE_ERROR_RETURN_FAILED                       = -1 , //参数非法，请检查输入参数
    ALIVC_INTERACTIVE_RETURN_SUCCESS                            = 0, //无错误

};
