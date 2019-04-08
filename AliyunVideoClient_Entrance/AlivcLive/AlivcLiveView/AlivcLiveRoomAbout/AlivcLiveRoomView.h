//  整体RoomView类，通过这个类来添加各个分层的view，接收view点击的事件监听 包含:commentView，likeview,musicSelectView,controlview,beautyview
//  AlivcChatRoomView.h
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2018/4/24.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlivcDefine.h"
#import <AlivcInteractiveLiveRoomSDK/AlivcInteractiveLiveRoomSDK.h>

@class AlivcLiveRoomView;
@class AlivcInteractiveLiveRoomConfig;
@class AlivcUserInfo;

@protocol AlivcLiveRoomViewDelegate <NSObject>

/**
 已离开直播间

 @param roomView 直播间
 @param kickout true: 点击离开按钮触发 主动离开。false:被主播踢出的
 */
- (void)haveleavedRoomView:(AlivcLiveRoomView *)roomView isBeKickouted:(BOOL)kickout;


@end

@interface AlivcLiveRoomView : UIView

/**
 初始化一个实例对象

 @param role 角色
 @param roomId 房间id
 @param userInfo AlivcUser
 @param roomConfig AlivcInteractiveLiveRoomConfig
 @return AlivcLiveRoomView
 */
- (instancetype)initWithRole:(AlivcLiveRoleType )role roomId:(NSString *)roomId userInfo:(AlivcUser *)userInfo roomconfig:(AlivcInteractiveLiveRoomConfig *)roomConfig;


@property (nonatomic, weak) id <AlivcLiveRoomViewDelegate> delegate;

@property (nonatomic, copy) void(^closeCompletion)(NSString *str);

- (void)destroy;


/**
 当前时间的字符串

 @return 当前时间字符串
 */
+ (NSString *)currentDateString;

@end
