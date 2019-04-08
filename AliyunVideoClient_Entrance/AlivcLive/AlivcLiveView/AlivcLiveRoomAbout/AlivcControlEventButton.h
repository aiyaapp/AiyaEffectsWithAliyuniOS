//
//  AlivcControlEventButton.h
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2018/4/24.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

// 美颜，相机，闪光灯，gif

/**
 房间底部控制视图的各种按钮的点击事件
 
 - AliceLiveControlEventMessage: 消息点击
 - AliceLiveControlEventBeauty: 美颜点击
 - AliceLiveControlEventCamera: 相机点击
 - AliceLiveControlEventLight: 灯光
 - AliceLiveControlEventMicrophone: 麦克风
 - AliceLiveControlEventMusic: 音乐
 - AliceLiveControlEventLeave: 离开本房间
 - AliceLiveControlEventLike: 点赞
 */
typedef NS_ENUM(NSInteger,AlivcLiveControlEvent) {
    AlivcLiveControlEventMessage = 0,
    AlivcLiveControlEventBeauty,
    AlivcLiveControlEventMusic,
    AlivcLiveControlEventMicrophone,
    AlivcLiveControlEventLight,
    AlivcLiveControlEventCamera,
    AlivcLiveControlEventLike
};

@interface AlivcControlEventButton : UIButton


/**
 Designated init

 @param event 事件定义
 @return 一个button实例
 */
- (instancetype)initWithEvent:(AlivcLiveControlEvent )event isAnchor:(BOOL)isAnchor;

@property (nonatomic, assign, readonly) AlivcLiveControlEvent event;

@end
