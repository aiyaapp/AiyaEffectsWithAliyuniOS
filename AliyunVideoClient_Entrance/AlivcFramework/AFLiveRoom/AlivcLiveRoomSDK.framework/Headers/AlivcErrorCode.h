//
//  AlivcErrorCode.h
//  AlivcLiveRoomSDK
//
//  Created by OjisanC on 2018/5/19.
//  Copyright © 2018年 Aliyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,AlivcErrorCode) {
    
    ALIVC_ERROR_INVALID_STATE                       = -4 ,      //参数非法，请检查输入参数
    ALIVC_ERROR_INVALID_PARAM                       = -3 ,      //参数非法，请检查输入参数
    ALIVC_ERROR_UNKNOWN                             = -2 ,      //参数非法，请检查输入参数
    ALIVC_ERROR_RETURN_FAILED                       = -1 ,      //参数非法，请检查输入参数
    ALIVC_RETURN_SUCCESS                            = 0,        //无错误

//Alivc Player Error Codes 4000 - 4999
    ALIVC_ERROR_AUTH_EXPIRED                          = 4002,     //鉴权过期，请重新获取新的鉴权信息
    ALIVC_ERROR_INVALID_INPUTFILE                     = 4003,     //无效的输入文件，请检查视频源和路径
    ALIVC_ERROR_NO_INPUTFILE                          = 4004,     //没有设置视频源或视频地址不存在
    ALIVC_ERROR_READ_DATA_FAILED                      = 4005,     //读取视频源失败
    ALIVC_ERROR_LOADING_TIMEOUT                       = 4008,     //视频加载超时，请检查网络状况
    ALIVC_ERROR_REQUEST_DATA_ERROR                    = 4009,     //请求数据错误
    ALIVC_ERROR_VIDEO_FORMAT_UNSUPORTED               = 4011,     //视频格式不支持
    ALIVC_ERROR_PLAYAUTH_PARSE_FAILED                 = 4012,     //playAuth解析失败
    ALIVC_ERROR_DECODE_FAILED                         = 4013,     //视频解码失败
    ALIVC_ERROR_NO_SUPPORT_CODEC                      = 4019,     //视频编码格式不支持
    ALIVC_ERROR_UNKNOWN_ERROR                         = 4400,     //未知错误
    ALIVC_ERROR_REQUEST_ERROR                         = 4500,     //服务端请求错误
    ALIVC_ERROR_DATA_ERROR                            = 4501,     //服务器返回数据错误
    ALIVC_ERROR_QEQUEST_SAAS_SERVER_ERROR             = 4502,     //请求saas服务器错误
    ALIVC_ERROR_QEQUEST_MTS_SERVER_ERROR              = 4503,     //请求mts服务器错误
    ALIVC_ERROR_SERVER_INVALID_PARAM                 = 4504,      //服务器返回参数无效，请检查XX参数
    ALIVC_ERROR_ILLEGALSTATUS                         = 4521,     //非法的播放器状态，当前状态是xx
    ALIVC_ERROR_NO_VIEW                               = 4022,     //没有设置显示窗口，请先设置播放视图
    ALIVC_ERROR_NO_MEMORY                             = 4023,     //内存不足
    //ALIVC_ERROR_FUNCTION_DENIED                       = 4024,     //系统权限被拒绝或没有经过授权
    ALIVC_ERROR_DOWNLOAD_NO_NETWORK                   = 4101,     //视频下载时连接不到服务器
    ALIVC_ERROR_DOWNLOAD_NETWORK_TIMEOUT              = 4102,     //视频下载时网络超时
    ALIVC_ERROR_DOWNLOAD_QEQUEST_SAAS_SERVER_ERROR    = 4103,     //请求saas服务器错误
    ALIVC_ERROR_DOWNLOAD_QEQUEST_MTS_SERVER_ERROR     = 4104,     //请求mts服务器错误
    ALIVC_ERROR_DOWNLOAD_SERVER_INVALID_PARAM         = 4105,     //服务器返回参数无效，请检查XX参数
    ALIVC_ERROR_DOWNLOAD_INVALID_INPUTFILE            = 4106,     //视频下载流无效或地址过期
    ALIVC_ERROR_DOWNLOAD_NO_ENCRYPT_FILE              = 4107,     //未找到加密文件，请从控制台下载加密文件并集成
    ALIVC_ERROR_DONWNLOAD_GET_KEY                     = 4108,     //获取秘钥失败，请检查秘钥文件
    ALIVC_ERROR_DOWNLOAD_INVALID_URL                  = 4109,     //下载地址无效
    ALIVC_ERROR_DONWLOAD_NO_SPACE                     = 4110,     //磁盘空间不够
    ALIVC_ERROR_DOWNLOAD_INVALID_SAVE_PATH            = 4111,     //视频文件保存路径不存在，请重新设置
    ALIVC_ERROR_DOWNLOAD_NO_PERMISSION                = 4112,     //当前视频不可下载
    ALIVC_ERROR_DOWNLOAD_MODE_CHANGED                 = 4113,     //下载模式改变无法继续下载
    ALIVC_ERROR_DOWNLOAD_ALREADY_ADDED                = 4114,     //当前视频已经添加到下载项，请避免重复添加
    ALIVC_ERROR_DOWNLOAD_NO_MATCH                     = 4115,     //未找到合适的下载项，请先添加
    
//Alivc Pusher Error Codes 5001 - 5999
    
    ALIVC_ERROR_PUSHER_CONNECT_FAIL                    = 5010,     //推流地址连接失败
    ALIVC_ERROR_PUSHER_SEND_DATA_TIMEOUT               = 5011,     //发送数据超时
    ALIVC_ERROR_PUSHER_RECONNECT_FAIL                  = 5012,     //重连失败
    ALIVC_ERROR_PUSHER_AUTH_EXPIRED                    = 5013,     //鉴权过期
    
    ALIVC_ERROR_PUSHER_SYSTEM_ERROR                    = 5100,     //系统错误
    
    ALIVC_ERROR_PUSHER_INTERNAL_ERROR                   = 5200,     //SDK内部错误
    
//Alivc Room Error Codes 6001 - 6999
    
    ALIVC_ERROR_ROOM_IM_TOKEN_REQUEST_ERROR             = 6001,     //IM token request error
    ALIVC_ERROR_ROOM_IM_TOKEN_EXPIRED_ERROR             = 6002,     //IM token expired

} ;


//typedef NSInteger AlivcPusherErrorCode;
