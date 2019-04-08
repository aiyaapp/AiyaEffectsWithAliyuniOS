//  视频列表实体类
//  AlivcMediaInfo.h
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2018/4/23.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AlivcLiveUser.h"

@interface AlivcLivePlayRoom : NSObject

/**
 房间id
 */
@property (nonatomic, strong, readonly) NSString *roomId;

/**
 房间标题
 */
@property (nonatomic, strong, readonly) NSString *roomTitle;

/**
 封面的图片URL
 */
@property (nonatomic, strong, readonly) NSString *coverUrlString;

/**
 观看人数
 */
@property (nonatomic, assign) NSInteger viewCount;

/**
 主播id
 */
@property (nonatomic, strong, readonly) NSString *hostId;

/**
 主播名称
 */
@property (nonatomic, strong, readonly) NSString *hostName;

/**
 主播头像地址
 */
@property (nonatomic, strong, readonly) NSString *avaterUrl;

/**
 播放的URL
 */
@property (nonatomic, strong, readonly) NSString *play_flv;

/**
 播放的URL
 */
@property (nonatomic, strong, readonly) NSString *play_hls;

/**
 播放的URL
 */
@property (nonatomic, strong, readonly) NSString *play_rtmp;

/**
 主播
 */
@property (nonatomic, strong) AlivcLiveUser *host;

/**
 观众列表
 */
@property (nonatomic, strong) NSMutableArray <AlivcLiveUser *>*audienceList;

@property (nonatomic, assign) BOOL more;
- (instancetype)initWithDic:(NSDictionary *)dic;

/**
 刷新当前房间的信息

 @param dic dic
 */
- (void)refreshWithDic:(NSDictionary *)dic;
@end
