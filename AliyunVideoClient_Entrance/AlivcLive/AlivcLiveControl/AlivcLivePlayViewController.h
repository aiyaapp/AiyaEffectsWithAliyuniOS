//  直播间的视图控制器
//  AlivcLivePlayViewController.h
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2018/4/24.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import "AlivcBaseViewController.h"
#import "AlivcDefine.h"
#import <AlivcInteractiveLiveRoomSDK/AlivcInteractiveLiveRoom.h>

@class AlivcUser;
@class AlivcInteractiveLiveRoomConfig;

@interface AlivcLivePlayViewController : AlivcBaseViewController

@property(nonatomic, copy) void(^showedCompletion)(NSString *errorStr);
@property (nonatomic, copy)void(^showBeKickOut)(void);

/**
 角色
 */
@property (nonatomic, assign) AlivcLiveRoleType role;

/**
 用户信息
 */
@property (nonatomic, strong) AlivcUser *userInfo;

/**
 界面上的摄像头参数等，目前是默认的，不排除后期服务端保存每个主播开播的偏好设置 - 所有在这里暴露出来
 */
@property (nonatomic, strong) AlivcInteractiveLiveRoomConfig *roomConfig;

/**
房间id
 */
@property (nonatomic, strong) NSString *roomId;

@end
