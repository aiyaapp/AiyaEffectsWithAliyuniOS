//
//  AlivcRoomConfig.h
//  AlivcLiveRoomSDK
//
//  Created by OjisanC on 2018/5/17.
//  Copyright © 2018年 Aliyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AlivcLiveRoomConstants.h"

@interface AlivcRoomConfig : NSObject

@property(nonatomic, assign) int reportLikeInterval;

@property(nonatomic, assign) AlivcLiveRoomPlayUrlType playUrlType;

@end
