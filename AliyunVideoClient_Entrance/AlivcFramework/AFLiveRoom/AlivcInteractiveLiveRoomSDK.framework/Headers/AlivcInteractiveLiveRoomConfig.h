//
//  AlivcInteractiveLiveRoomConfig.h
//  AlivcInteractiveLiveRoomSDK
//
//  Created by Charming04 on 2018/5/20.
//  Copyright © 2018年 Aliyun. All rights reserved.
//

#import <Foundation/Foundation.h>

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

@interface AlivcInteractiveLiveRoomConfig : NSObject

@property(nonatomic, strong, readonly) AlivcLiveRoomConfig *liveRoomConfig;
@property(nonatomic, strong, readonly) AlivcInteractiveWidgetConfig *widgetConfig;


@property(nonatomic, assign) BOOL beautyOn;
@property(nonatomic, assign) AlivcBeautyMode beautyMode;
@property(nonatomic, assign) AlivcLivePushResolution resolution;
@property(nonatomic, strong) UIImage *pauseImg;

@end
