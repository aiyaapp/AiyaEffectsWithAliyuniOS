//
//  AlivcLogConfig.h
//  AlivcLog
//
//  Created by OjisanC on 2018/5/20.
//  Copyright © 2018年 Aliyun. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,AlivcLogLevel) {
    AlivcLogLevelDebug = 0,    /**< 调试 */
    AlivcLogLevelInfo  = 1,    /**< 信息 */
    AlivcLogLevelWarn  = 2,    /**< 警告 */
    AlivcLogLevelError = 3,    /**< 错误 */
};

typedef NS_OPTIONS(NSUInteger,AlivcLogMode) {
   // AlivcLogModeAll     = 0,                 /**< 全部 */
    AlivcLogModeLocalPrint = 1 << 0,         /**< 本地打印 */
    AlivcLogModeLocalFile = 1 << 1,          /**< 本地文件打印 */
    AlivcLogModeUploadFileToServer = 1 << 2, /**< 上传日志文件到服务器 */
};

@interface AlivcLogConfig : NSObject

/**
 日志模式， 默认 AlivcLogModeLocalPrint
 */
@property (nonatomic, assign)AlivcLogMode mode;

/**
 日志等级， 默认 AlivcLogLevelDebug
 */
@property (nonatomic, assign)AlivcLogLevel level;

//上传日志和上传日志文件时需要用到以下属性
/**
 host address
 */
@property (nonatomic, copy)NSString *host;

/**
 project name
 */
@property (nonatomic, copy)NSString *projectName;

/**
 log store name
 */
@property (nonatomic, copy)NSString *logStore;

/**
 session id
 */
@property (nonatomic, copy)NSString *sessionId;

/**
 uuid
 */
@property (nonatomic, copy)NSString *uuid;

@end
