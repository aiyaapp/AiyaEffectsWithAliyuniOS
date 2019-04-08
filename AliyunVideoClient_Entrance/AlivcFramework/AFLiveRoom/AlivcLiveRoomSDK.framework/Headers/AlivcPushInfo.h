//
//  AlivcPushInfo.h
//  AlivcLiveRoomSDK
//
//  Created by Charming04 on 2018/5/20.
//  Copyright © 2018年 Aliyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlivcPushInfo : NSObject

@property(nonatomic, copy) NSString *requestId;
@property(nonatomic, copy) NSString *rtmp;
@property(nonatomic, copy) NSString *expireTime;

- (instancetype)initWithDic:(NSDictionary *)dic;

@end
