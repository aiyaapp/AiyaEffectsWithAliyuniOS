//
//  AlivcLiveRoomPusherNotifyDelegate.h
//  AlivcLiveRoomSDK
//
//  Created by OjisanC on 2018/5/18.
//  Copyright © 2018年 Aliyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AlivcLiveRoomPusherNotifyDelegate <NSObject>

@optional

- (void)onAlivcPusherPreviewStarted;

- (void)onAlivcPusherPreviewStopped;

- (void)onAlivcPusherFirstFramePreviewed;

- (void)onAlivcPusherPushStarted;

- (void)onAlivcPusherPushPauesed;

- (void)onAlivcPusherPushResumed;

- (void)onAlivcPusherPushStopped;

- (NSString *)onAlivcPusherURLAuthenticationAboutToExpire;

@end
