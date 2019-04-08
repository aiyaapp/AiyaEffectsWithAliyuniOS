//
//  AlivcPlayInfo.h
//  AlivcLiveRoomSDK
//
//  Created by Charming04 on 2018/5/20.
//  Copyright © 2018年 Aliyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AlivcRoomConfig.h"

@interface AlivcPlayInfo : NSObject

@property(nonatomic, copy) NSString *requestId;

@property(nonatomic, assign) int micNumber;
@property(nonatomic, assign) int micVersion;
@property(nonatomic, assign) int micStreamStatus;
@property(nonatomic, copy) NSString *micAppUid;
@property(nonatomic, copy) NSString *micStreamName;

@property(nonatomic, copy) NSString *playUrl; // 根据config获取的最终可播放的url地址

- (instancetype)initWithDic:(NSDictionary *)dic config:(AlivcRoomConfig *)config;

@end
