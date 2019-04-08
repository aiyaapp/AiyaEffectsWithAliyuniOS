//  消息实体，
//  AlivcMessage.h
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2018/4/25.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AlivcLiveUser;
@class AlivcMsgInfo;

NS_ASSUME_NONNULL_BEGIN
/**
 
 
 - AlivcMessageTypeSystem:
 - AlivcMessageTypeComment:
 */

/**
 消息类型
 */
typedef NS_ENUM(NSInteger,AlivcMessageType) {
    AlivcMessageTypeLogin = 0,
    AlivcMessageTypeLogout,
    AlivcMessageTypeAllowSendMsg,
    AlivcMessageTypeForbidSendMsg,
    AlivcMessageTypeAllowAllSendMsg,
    AlivcMessageTypeForbidAllSendMsg,
    AlivcMessageTypeKickout,
    AlivcMessageTypeChat,
    AlivcMessageTypeGift,
    AlivcMessageTypeLike,
//    AlivcMessageTypeCreatRoom,
//    AlivcMessageTypeDestoryRoom,
//    AlivcMessageTypeEnterRoom,
//    AlivcMessageTypeLeaveRoom,
//    AlivcMessageTypeLogout,
//    AlivcMessageTypeRefreshImToken,
//    AlivcMessageTypeQueryRoomInfo,
//    AlivcMessageTypeServerNotice,
//    AlivcMessageTypeQueryRoomMsgs,
    
};

@interface AlivcMessage : NSObject

- (instancetype)initWithUser:(AlivcLiveUser *__nullable)user type:(AlivcMessageType)type commentString:(NSString *__nullable)commentString;

//- (instancetype)initWitUserId:(NSString *)userId nickname:(NSString *)name content:(NSString *)content type:(AlivcMessageType)type;

//- (instancetype)initWithUserId:(NSString *)userId type:(AlivcMessageType)type commentString:(NSString *__nullable)commentString;

/**
 消息发生的对象
 */
@property (nonatomic, strong, nullable) AlivcLiveUser *user;

/**
 消息发生的对象的id
 */
@property (nonatomic, strong) NSString *userId;

/**
 消息类型
 */
@property (nonatomic, assign) AlivcMessageType messageType;



/**
 无论哪种类型的消息，展示的都是一行字，可以在这里直接获取

 @return 用于展示的文字
 */
- (NSAttributedString *)showText;


/**
 根据sdk返回的消息类和自定义用户生成一条消息

 @param info sdk返回的消息类
 @param user 自定义用户
 @return 一条用户展示的消息
 */
+ (AlivcMessage *__nullable)messageWithInfo:(AlivcMsgInfo *)info user:(AlivcLiveUser *)user;

@end

NS_ASSUME_NONNULL_END
