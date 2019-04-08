//
//  AlivcLiveRoomPusherErrorDelegate.h
//  AlivcLiveRoomSDK
//
//  Created by OjisanC on 2018/5/18.
//  Copyright © 2018年 Aliyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AlivcLiveRoomPusherErrorDelegate <NSObject>

@optional
- (void)onAlivcPusherErrorCode:(NSInteger)errorCode errorDetail:(NSInteger)errorDetail;

@end
