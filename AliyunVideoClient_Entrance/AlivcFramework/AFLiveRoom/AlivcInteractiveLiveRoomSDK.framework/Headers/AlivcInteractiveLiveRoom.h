//
//  AlivcInteractiveLiveRoom.h
//  AlivcInteractiveLiveRoomSDK
//
//  Created by Charming04 on 2018/5/20.
//  Copyright © 2018年 Aliyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlivcInteractiveLiveRoomConfig.h"
#import "AlivcInteractiveLiveRoomAuthDelegate.h"
#import "AlivcInteractiveLiveRoomErrorDelegate.h"
#import "AlivcInteractiveLiveRoomConstants.h"

#if __has_include(<AlivcUtilsSDK/AlivcUtilsSDK.h>)
#import <AlivcUtilsSDK/AlivcUtilsSDK.h>
#else
#import "AlivcUtilsSDK.h"
#endif

#if __has_include(<AlivcLiveRoomSDK/AlivcLiveRoomSDK.h>)
#import <AlivcLiveRoomSDK/AlivcLiveRoomSDK.h>
#else
#import "AlivcLiveRoomSDK.h"
#endif

#if __has_include(<AlivcInteractiveWidgetSDK/AlivcInteractiveWidgetSDK.h>)
#import <AlivcInteractiveWidgetSDK/AlivcInteractiveWidgetSDK.h>
#else
#import "AlivcInteractiveWidgetSDK.h"
#endif

@interface AlivcInteractiveLiveRoom : NSObject

/**
 auth sts delegate
 */
@property (nonatomic, weak) id<AlivcInteractiveLiveRoomAuthDelegate> authDelegate;

/**
 live room notify delegate
 */
@property (nonatomic, weak) id<AlivcLiveRoomNotifyDelegate> roomNotifyDelegate;

/**
 play notify delegate
 */
@property (nonatomic, weak) id<AlivcLiveRoomPlayerNotifyDelegate> playerNotifyDelegate;

/**
 pusher notify delegate
 */
@property (nonatomic, weak) id<AlivcLiveRoomPusherNotifyDelegate> pusherNotifyDelegate;

/**
 interactive notify delegate
 */
@property (nonatomic, weak) id<AlivcInteractiveNotifyDelegate> interactiveNotifyDelegate;

/**
 network notify delegate
 */
@property (nonatomic, weak) id<AlivcLiveRoomNetworkNotifyDelegate> networkNotifyDelegate;

/**
 interactive live room error delegate
 */
@property (nonatomic, weak) id<AlivcInteractiveLiveRoomErrorDelegate> interactiveLiveRoomErrorDelegate;

/**
 AlivcInteractiveLiveRoom
 
 @param appId business app id
 @param config AlivcInteractiveLiveRoomConfig
 @return AlivcInteractiveLiveRoom
 */
- (instancetype)initWithAppId:(NSString *)appId
                       config:(AlivcInteractiveLiveRoomConfig*)config;

/**
 pause
 */
- (void)pause;

/**
 resume
 */
- (void)resume;

#pragma mark room

/**
 enter room
 
 @param roomId roomId
 @param user AlivcLiveUser
 @param role AlivcLiveRole
 @param completion completionCallback
 */
- (void)enter:(NSString *)roomId
         user:(AlivcUser *)user
         role:(AlivcLiveRole *)role
   completion:(void (^)(AlivcLiveError *error,AlivcLiveRoomInfo *liveRoomInfo))completion;

/**
 quit room
 
 @param completion completionCallback
 */
- (void)quit:(void (^)(AlivcLiveError *error))completion;

/**
 login with sts
 
 @param sts AlivcSts
 */
- (void)login:(AlivcSts *)sts;

/**
 logout
 */
- (void)logout;

/**
 refresh sts
 
 @param sts AlivcSts
 */
- (void)refreshSts:(AlivcSts *)sts;

/**
 kickout user
 
 @param userId user id to be kicked out
 @param userData user data
 @param duration the seconds user being kicked out
 @param completion completionCallback
 */
- (void)kickout:(NSString *)userId
       userData:(NSString *)userData
       duration:(NSUInteger)duration
     completion:(void (^)(AlivcLiveError *error))completion;

/**
 cancel Kickout user
 
 @param userId user id to be cancel kickout
 @param completion completionCallback
 */
- (void)cancelKickout:(NSString *)userId
            completion:(void (^)(AlivcLiveError *error))completion;


/**
 liveRoomInfo
 
 @return AlivcLiveRoomInfo
 */
- (AlivcLiveRoomInfo *)liveRoomInfo;

#pragma mark interactive

/**
 send chat message
 
 @param content message content
 @param userData user data
 @param completion completion description
 */
- (void)sendChatMessage:(NSString *)content
               userData:(NSString *)userData
             completion:(void (^)(AlivcLiveError *error))completion;


/**
 get history chat message, the last 20 messages
 
 @param completion completionCallback
 */
- (void)getHistoryChatMessage:(void (^)(AlivcLiveError *error, NSArray <AlivcMessageInfo *> *messageList))completion;


/**
 send like
 
 @param count like count
 @param completion completionCallback
 */
- (void)sendLikeWithCount:(NSInteger )count
               completion:(void (^)(AlivcLiveError *error))completion;

/**
 like count
 
 @param completion completionCallback
 */
- (void)getLikeCount:(void (^)(AlivcLiveError *error, NSUInteger count))completion;


#pragma mark player
/**
 set player view  (must call after enter)
 
 @param remoteView UIView
 @param micAppUid  mic id
 */
- (void)setRemoteView:(UIView *)remoteView
            micAppUid:(NSString *)micAppUid;

#pragma mark push
/**
 previewView must set before call startPreview, and only can set once
 @param localView UIView
 */
- (void)setLocalView:(UIView *)localView;

/**
 start preview
 
 @param completion completionCallback
 */
- (void)startPreview:(void (^)(AlivcLiveError *error))completion;

/**
 stop preview
 */
- (void)stopPreview;

/**
 reconnect push
 
 @param completion completionCallback
 */
- (void)reconnectPush:(void (^)(AlivcLiveError *error))completion;

/**
 Set resolution

 @param resolution AlivcLivePushResolution
 */
- (void)setResolution:(AlivcLivePushResolution)resolution;

#pragma mark beauty
/**
 beautyOn
 
 @param beautyOn default true
 */
- (void)setBeautyOn:(BOOL)beautyOn;

/**
 beautyParams
 
 @param beautyParams AlivcBeautyParams
 */
- (void)setBeautyParams:(AlivcBeautyParams *)beautyParams;

/**
 custom filter delegate
 
 @param delegate AlivcLivePusherCustomFilterDelegate
 */
- (void)setCustomFilterDelegate:(id<AlivcLivePusherCustomFilterDelegate>)delegate;

/**
 custom detector delegate
 
 @param delegate AlivcLivePusherCustomDetectorDelegate
 */
- (void)setCustomDetectorDelegate:(id<AlivcLivePusherCustomDetectorDelegate>)delegate;

#pragma mark camera
/**
 switch camera
 */
- (void)switchCamera;

/**
 autoFocus
 
 @param autoFocus default true
 */
- (void)setAutoFocus:(BOOL)autoFocus;

/**
 focusCamera
 
 @param point CGPoint
 @param autoFocus BOOL
 */
- (void)focusCameraAtPoint:(CGPoint)point needAutoFocus:(BOOL)autoFocus;

/**
 zoom
 
 @param zoom float
 */
- (void)setZoom:(float)zoom;

/**
 max zoom
 
 @return max zoom value
 */
- (float)getMaxZoom;

/**
 current zoom
 
 @return current zoom value
 */
- (float)getCurrentZoom;

/**
 open flash
 
 @param flash BOOL
 */
- (void)setFlash:(BOOL)flash;

#pragma mark sound
/**
 mute switch
 
 @param isMute true:mute push false:nomarl push
 */
- (void)setMute:(BOOL)isMute;

#pragma mark log

/**
 set log level

 @param level AlivcInteractiveLiveRoomLogLevel
 */
- (void)setLogLevel:(AlivcInteractiveLiveRoomLogLevel)level;

/**
 enable log
 */
- (void)enableLog;

/**
 disable log
 */
- (void)disableLog;

@end
