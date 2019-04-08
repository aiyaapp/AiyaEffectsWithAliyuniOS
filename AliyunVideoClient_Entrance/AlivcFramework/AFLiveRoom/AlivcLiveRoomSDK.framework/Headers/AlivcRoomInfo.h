//
//  AlivcRoomInfo.h
//  AlivcLiveRoomSDK
//
//  Created by Charming04 on 2018/5/21.
//  Copyright © 2018年 Aliyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlivcPushInfo.h"
#import "AlivcPlayInfo.h"
#import "AlivcRoomConfig.h"

/**
 房间管控状态
 - AlivcRoomInfoRoomControlStatusAllow: 允许直播
 - AlivcRoomInfoRoomControlStatusForbid: 禁止播放
 */
typedef NS_ENUM(NSInteger, AlivcRoomInfoRoomControlStatus) {
    AlivcRoomInfoRoomControlStatusAllow = 0,
    AlivcRoomInfoRoomControlStatusForbid
};

typedef NS_ENUM(NSInteger, AlivcRoomInfoRoomStatus) {
    AlivcRoomInfoRoomStatusClose = 0,
    AlivcRoomInfoRoomStatusOn,
    AlivcRoomInfoRoomStatusnterrupt
};

typedef NS_ENUM(NSInteger, AlivcRoomInfoUserStatus) {
    AlivcRoomInfoUserStatusNormal = 0,
    AlivcRoomInfoUserStatusKickedOut
};

@interface AlivcRoomInfo : NSObject

@property(nonatomic, strong) NSString *appId;
@property(nonatomic, strong) NSString *roomId;

@property(nonatomic, strong) NSString *requestId;
@property(nonatomic, assign) int status;
@property(nonatomic, strong) NSString *clientId;
@property(nonatomic, strong) NSString *tokenId;
@property(nonatomic, strong) NSString *tokenExpireTime;
@property(nonatomic, assign) AlivcRoomInfoRoomControlStatus roomControlStatus;
@property(nonatomic, assign) AlivcRoomInfoRoomStatus roomStatus;
@property(nonatomic, assign) AlivcRoomInfoUserStatus userStatus;
@property(nonatomic, strong) NSString *anchorAppUid;

@property(nonatomic, strong) NSMutableDictionary <NSString *, AlivcPlayInfo *> *playInfosDic;// 麦列表
@property(nonatomic, strong) AlivcPushInfo *pushInfo;

- (instancetype)initWithDic:(NSDictionary *)dic config:(AlivcRoomConfig *)config;

@end
