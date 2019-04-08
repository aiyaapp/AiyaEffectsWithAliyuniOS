//
//  AlivcLiveRoomConfig.h
//  AlivcLiveRoomSDK
//
//  Created by OjisanC on 2018/5/18.
//  Copyright © 2018年 Aliyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AlivcRoomConfig.h"
#import "AlivcPlayerConfig.h"
#import "AlivcPusherConfig.h"
#import "AlivcLiveRoomConstants.h"

@interface AlivcLiveRoomConfig : NSObject

@property(nonatomic, strong, readonly) AlivcRoomConfig *roomConfig;
@property(nonatomic, strong, readonly) AlivcPlayerConfig *playerConfig;
@property(nonatomic, strong, readonly) AlivcPusherConfig *pusherConfig;

@property(nonatomic, assign) AlivcLiveRoomPlayUrlType playUrlType;

@property (nonatomic, assign)NSUInteger notifyIntervalBeforeExpired;

@property(nonatomic, assign) BOOL beautyOn;
@property(nonatomic, assign) AlivcBeautyMode beautyMode;
@property(nonatomic, assign) AlivcLivePushResolution resolution;
@property(nonatomic, strong) UIImage *pauseImg;

@end
