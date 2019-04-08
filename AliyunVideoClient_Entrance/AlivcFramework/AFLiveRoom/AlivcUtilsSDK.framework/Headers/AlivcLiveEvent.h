//
//  AlivcLiveEvent.h
//  AlivcInteractiveLiveRoomSDK
//
//  Created by OjisanC on 2018/6/2.
//

#import <Foundation/Foundation.h>

@interface AlivcLiveEvent : NSObject

@property (nonatomic, copy)NSString *videoUrl;

+ (instancetype)sharedInstance;

- (void)setRoomId:(NSString *)roomId appId:(NSString *)appId;

- (void)sendEventCreateRoom:(BOOL)isSuccess isAllForbid:(BOOL)isAllForbid;

- (void)sendEventEnterRoom:(BOOL)isSuccess role:(int)role isAllForbid:(BOOL)isAllForbid;

// enterduration enter接口返回的时间（毫秒），playDuration播放或者推流的时间（毫秒）
- (void)sendEventEnterRoom:(BOOL)isSuccess role:(int)role isAllForbid:(BOOL)isAllForbid enterDuration:(NSTimeInterval)enterduration playDuration:(NSTimeInterval)playDuration;

- (void)sendEventQuitRoom:(BOOL)isSuccess likeCount:(int)likeCount audienceCount:(int)audienceCount;

- (void)sendEventDestoryRoom;

- (void)sendEventLike;

- (void)sendEventForbidChat:(BOOL)isSuccess duration:(NSUInteger)duration isAll:(BOOL)isAll;

- (void)sendEventKickOut:(BOOL)isSuccess;

- (void)sendEventMessage:(int)type;

- (void)sendEventError:(NSInteger)code details:(NSString *)details;

@end
