//  评论列表View，负责展示评论数据与消息
//  AlivcCommentListView.h
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2018/4/24.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AlivcMessageListView, AlivcMessage;
@protocol AlivcMessageListViewDelegate <NSObject>

- (void)messageListView:(AlivcMessageListView *)view message:(AlivcMessage *)message touchedWithUserId:(NSString *)userId;
@end

@class AlivcMessage;

@interface AlivcMessageListView : UIView


/**
 视图上更新一条消息

 @param newMessage 消息
 */
- (void)updateAMessage:(AlivcMessage *)newMessage;


/**
 视图上更新多条消息

 @param newMessages 多条消息
 */
- (void)updateMessages:(NSArray <AlivcMessage *>*)newMessages;


@property (nonatomic, weak) id <AlivcMessageListViewDelegate> delegate;

@end
