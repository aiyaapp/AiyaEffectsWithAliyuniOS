//
//  AlivcLiveTime.h
//  AlivcInteractiveLiveRoomSDK
//
//  Created by OjisanC on 2018/6/11.
//

#import <Foundation/Foundation.h>

@interface AlivcLiveTime : NSObject

+ (void)createInstance ;

+ (void)destoryInstance ;

+ (NSUInteger)getUTCTime;

+ (NSString *)getUTCTime:(NSUInteger)duration; //当前UTC 时间 + duration秒

+ (NSDate *)getUTCTimeFromString:(NSString *)utc;

@end
