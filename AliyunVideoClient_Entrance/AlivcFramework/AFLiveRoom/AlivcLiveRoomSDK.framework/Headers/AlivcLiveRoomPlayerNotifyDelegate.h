//
//  AlivcLiveRoomPlayerNotifyDelegate.h
//  AlivcLiveRoomSDK
//
//  Created by OjisanC on 2018/5/18.
//  Copyright © 2018年 Aliyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AlivcLiveRoomPlayerNotifyDelegate <NSObject>

@optional
- (void)onAlivcPlayerStarted;

- (void)onAlivcPlayerStopped;

- (void)onAlivcPlayerFinished;

@end

