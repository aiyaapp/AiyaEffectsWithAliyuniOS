//
//  AlivcPlayerDelegate.h
//  AlivcLiveRoomSDK
//
//  Created by OjisanC on 2018/5/19.
//  Copyright © 2018年 Aliyun. All rights reserved.
//


#import <Foundation/Foundation.h>

@class AlivcPlayer;

@protocol AlivcPlayerDelegate <NSObject>

@optional

- (void)onAlivcPlayerStarted:(AlivcPlayer *)player;

- (void)onAlivcPlayerStopped:(AlivcPlayer *)player;

- (void)onAlivcPlayerFinished:(AlivcPlayer *)player;

- (void)onAlivcPlayerError:(AlivcPlayer *)player errorCode:(NSInteger)errorCode;

@end
