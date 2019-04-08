//
//  AlivcLiveRoomConstants.h
//  AlivcLiveRoomSDK
//
//  Created by OjisanC on 2018/5/17.
//  Copyright © 2018年 Aliyun. All rights reserved.
//

#ifndef AlivcLiveRoomConstants_h
#define AlivcLiveRoomConstants_h

typedef NS_ENUM(NSInteger,AlivcLiveRoomType) {
    AlivcLiveRoomTypeChat = 0,
    AlivcLiveRoomTypePush = 1,
    AlivcLiveRoomTypeLive = 2,
};

typedef NS_ENUM(NSInteger,AlivcLiveRoomPlayUrlType) {
    AlivcLiveRoomPlayUrlTypeHlsUd = 0,
    AlivcLiveRoomPlayUrlTypeFlvUd,
    AlivcLiveRoomPlayUrlTypeHlsHd,
    AlivcLiveRoomPlayUrlTypeFlvHd,
    AlivcLiveRoomPlayUrlTypeHlsOd,
    AlivcLiveRoomPlayUrlTypeFlvOd,
    AlivcLiveRoomPlayUrlTypeHlsSd,
    AlivcLiveRoomPlayUrlTypeFlvSd,
};




#endif /* AlivcLiveRoomConstants_h */
