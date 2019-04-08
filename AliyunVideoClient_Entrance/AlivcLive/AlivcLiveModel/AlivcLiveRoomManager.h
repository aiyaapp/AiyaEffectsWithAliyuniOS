//  互动直播信息管理类，通过该类来管理直播信息 播放管理:后台进行通信，通知后台进入房间、退出房间、点赞事件 直播管理类:后台进行通信，拉取直播地址、通知后台退出直播
//  AlivcChatRoomManager.h
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2018/4/24.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AlivcLivePlayRoom.h"
#import "AlivcLiveUser.h"
#import <AlivcInteractiveLiveRoomSDK/AlivcInteractiveLiveRoomSDK.h>

@interface AlivcLiveRoomManager : NSObject

+ (void)stsWithAppUid:(NSString *)appUid success:(void (^)(AlivcSts *sts))success failure:(void(^)(NSString *errString))failure;

/**
 创建房间

 @param userId 主播uid
 @param title 开播提示
 @param success 成功
 @param failure 失败
 */
+ (void)createRoomWithUserId:(NSString *)userId roomTitle:(NSString *)title success:(void (^)(AlivcLivePlayRoom *room))success failure:(void(^)(NSString *errString))failure;

/**
 获取roomInfoDetail
 
 @param roomId 房间id
 @param success 成功
 @param failure 失败
 */
+ (void)roomInfoDetailWithRoomId:(NSString *)roomId success:(void (^)(AlivcLivePlayRoom *room))success failure:(void(^)(NSString *errString))failure;

/**
 加入房间

 @param roomId 房间id
 @param hostId 主播id
 @param audienceId 观众id
 @param success 成功
 @param failure 失败
 */
+ (void)joinRoomWithRoomId:(NSString *)roomId hostId:(NSString *)hostId audience:(NSString *)audienceId success:(void(^)(void))success failure:(void(^)(NSString *errString))failure;

/**
 用户离开房间

 @param roomId 房间id
 @param userId 用户id
 @param success 成功
 @param failure 失败
 */
+ (void)leaveRoomWithRoomId:(NSString *)roomId userId:(NSString *)userId success:(void (^)(void))success failure:(void(^)(NSString *errString))failure;

/**
 用户离开房间

 @param roomId 房间id
 @param userId userId
 */
+ (void)joinRoomNotificationWithRoomID:(NSString *)roomId userId:(NSString *)userId success:(void (^)(void))success failure:(void(^)(NSString *errString))failure;


/**
 主播开始播放

 @param roomId 房间id
 @param userId userId
 @param success 成功
 @param failure 失败
 */
+ (void)startStreamingWithRoomID:(NSString *)roomId userId:(NSString *)userId success:(void (^)(void))success failure:(void(^)(NSString *errString))failure;

/**
 主播结束直播

 @param roomId 房间id
 @param userId userId
 @param success 成功
 @param failure 失败
 */
+ (void)endStreamingWithRoomID:(NSString *)roomId userId:(NSString *)userId success:(void (^)(void))success failure:(void(^)(NSString *errString))failure;

/**
 用户加入房间

 @param roomId 房间id
 @param userId userId
 */
+ (void)leaveRoomNotificationWithRoomID:(NSString *)roomId userId:(NSString *)userId success:(void (^)(void))success failure:(void(^)(NSString *errString))failure;


/**
 用户想通过APPServer绑定由SDK创建的房间

 @param userId 用户ID
 @param roomId 房间ID
 @param pushUrlString 推流地址
 @param playFlv flv播放地址
 @param playHls hls播放地址
 @param playRtmp rtmp播放地址
 @param success 成功
 @param failure 失败
 */
+ (void)bindRoomWithUserId:(NSString *)userId roomId:(NSString *)roomId pushUrl:(NSString *)pushUrlString playFlv:(NSString *)playFlv palyHls:(NSString *)playHls playRtmp:(NSString *)playRtmp success:(void(^)(void))success failure:(void(^)(NSString *errString))failure;
@end
