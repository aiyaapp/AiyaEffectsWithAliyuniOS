//
//  AlivcLiveRoomNotifyDelegate.h
//  AlivcLiveRoomSDK
//
//  Created by OjisanC on 2018/5/18.
//  Copyright © 2018年 Aliyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AlivcLiveRole;

@protocol AlivcLiveRoomNotifyDelegate <NSObject>

@optional

/*主播流变更（有流）消息*/
- (void)onAlivcRoomBroadcastStart;

/*主播流变更（无流）消息*/
- (void)onAlivcRoomBroadcastStop;

/*用户进入房间消息*/
- (void)onAlivcRoomUserLogin:(NSString *)userId userData:(NSDictionary *)userData;

/*用户退出房间消息*/
- (void)onAlivcRoomUserLogout:(NSString *)userId userData:(NSDictionary *)userData;

/*麦列表变更（新增的麦序）*/
- (void)onAlivcRoomUpMic:(NSString *)userId;

/*麦列表变更（移除的麦序）*/
- (void)onAlivcRoomDownMic:(NSString *)userId;

/*用户被踢出房间下行消息*/
- (void)onAlivcRoomKickOutUserId:(NSString *)userId;

///*用户被解除踢出房间下行消息*/
//- (void)onAlivcRoomCancelKickOutUserId:(NSString *)userId;

/*禁播下行消息*/
- (void)onAlivcRoomForbidPushStream:(NSString *)userData;

///*禁播解除下行消息*/
//- (void)onAlivcRoomAllowPushStream;

@end
