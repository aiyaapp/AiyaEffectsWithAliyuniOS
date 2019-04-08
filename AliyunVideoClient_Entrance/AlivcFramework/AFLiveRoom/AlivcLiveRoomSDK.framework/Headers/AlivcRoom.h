//
//  AlivcRoom.h
//  AlivcLiveRoomSDK
//
//  Created by OjisanC on 2018/5/17.
//  Copyright © 2018年 Aliyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlivcRoomConfig.h"
#import "AlivcRoomInfo.h"
#import "AlivcPlayInfo.h"
#import "AlivcPushInfo.h"
#import "AlivcLiveRoomConstants.h"
#import "AlivcLiveRole.h"
#import "AlivcUser.h"

#if __has_include(<AlivcUtilsSDK/AlivcUtilsSDK.h>)
#import <AlivcUtilsSDK/AlivcUtilsSDK.h>
#else
#import "AlivcUtilsSDK.h"
#endif

@protocol AlivcRoomDelegate;

@interface AlivcRoom : NSObject

@property (weak, nonatomic) id<AlivcRoomDelegate> delegate;

@property(nonatomic, strong)AlivcRoomInfo *roomInfo;

- (instancetype)initWithAppId:(NSString *)appId config:(AlivcRoomConfig*)roomConfig;

- (void)login:(AlivcSts *)sts;

- (void)logout;

- (void)refreshSts:(AlivcSts *)sts;

#pragma mark room
- (void)enter:(NSString *)roomId user:(AlivcUser *)user role:(AlivcLiveRole *)role completion:(void (^)(AlivcLiveError *error, AlivcRoomInfo *roomInfo))completion;

- (void)quit:(void (^)(AlivcLiveError *error))completion;

- (void)upMic:(void (^)(AlivcLiveError *error))completion;

- (void)downMic:(void (^)(AlivcLiveError *error))completion;

- (void)kickout:(NSString *)appUid reson:(NSString *)reason expireTime:(NSString *)expireTime completion:(void (^)(AlivcLiveError *error))completion;

- (void)cancelKickout:(NSString *)appUid completion:(void (^)(AlivcLiveError *error))completion;

- (void)forbidPushStream:(NSString *)userData expireTime:(NSString *)expireTime completion:(void (^)(AlivcLiveError *error))completion;

- (void)allowPushStreamWithCompletion:(void (^)(AlivcLiveError *error))completion;

- (void)getPlayInfo:(NSString *)roomId completion:(void (^)(AlivcLiveError *error, AlivcPlayInfo *playInfo))completion;

- (void)getPushInfo:(NSString *)roomId completion:(void (^)(AlivcLiveError *error, AlivcPushInfo *pushInfo))completion;

- (void)requestImToken:(void (^)(AlivcLiveError *error, AlivcToken *token))completion;

@end
