//  底部的控制视图
//  AlivcControlView.h
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2018/4/24.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlivcControlEventButton.h"
#import <AlivcInteractiveLiveRoomSDK/AlivcInteractiveLiveRoomSDK.h>

@class AlivcControlView;

@protocol AlivcControlViewDelegate <NSObject>

- (void)controlView:(AlivcControlView *)view buttonTouched:(AlivcControlEventButton *)eventButton;

@end

@interface AlivcControlView : UIView

- (instancetype)initWithRole:(AlivcLiveRoleType )role;

/**
 主播的预览视图与操作视图
 
 @param isPre 是否是预览视图 是：主播的预览视图，否：直播的操作界面 跟initWithRole传主播值生成的实例一样
 @return 实例
 */
- (instancetype)initWithPreWhenRoleIsHost:(BOOL)isPre;

@property (nonatomic, assign, readonly) AlivcLiveRoleType role;

@property (nonatomic, weak) id <AlivcControlViewDelegate> delegate;

- (void)setLightingEnable:(BOOL)enable;

@end
