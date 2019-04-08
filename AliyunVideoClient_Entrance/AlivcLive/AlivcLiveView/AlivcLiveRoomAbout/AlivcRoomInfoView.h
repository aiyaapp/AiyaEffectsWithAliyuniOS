//  直播间主播头像和点赞数信息展示view
//  AlivcRoomInfoView.h
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2018/5/3.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AlivcLiveUser;
@class AlivcRoomInfoView;

@protocol AlivcRoomInfoViewDelegate <NSObject>

- (void)roomInfoView:(AlivcRoomInfoView *)view hostTouched:(AlivcLiveUser *)host;

@end



@interface AlivcRoomInfoView : UIView

@property (weak, nonatomic) IBOutlet UIView *avatarContainView;

@property (weak, nonatomic) IBOutlet UIView *likeCountContainView;

- (instancetype)initWithHost:(AlivcLiveUser *)host;

@property (nonatomic, weak) id <AlivcRoomInfoViewDelegate> delegate;

/**
 刷新界面

 @param host 主播信息
 */
- (void)refreshUIWithHost:(AlivcLiveUser *)host;

/**
 更新观看人数

 @param count 观看人数
 */
- (void)updateViewAudienceCount:(NSInteger )count;

/**
 更新点赞数

 @param count 点赞数
 */
- (void)updateLikeCount:(NSInteger)count;

/**
 新增点赞数

 @param count 新增的点赞数
 */
- (void)increasedLikeCount:(NSInteger)count;

@end
