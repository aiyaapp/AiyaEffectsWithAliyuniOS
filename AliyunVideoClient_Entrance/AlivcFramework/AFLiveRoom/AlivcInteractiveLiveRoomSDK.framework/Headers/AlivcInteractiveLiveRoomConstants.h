//
//  AlivcInteractiveLiveRoomConstants.h
//  AlivcInteractiveLiveRoomSDK
//
//  Created by OjisanC on 2018/5/17.
//  Copyright © 2018年 Aliyun. All rights reserved.
//

#ifndef AlivcInteractiveLiveRoomConstants_h
#define AlivcInteractiveLiveRoomConstants_h

typedef NS_ENUM(NSInteger, AlivcInteractiveLiveRoomLogLevel){
    
    AlivcInteractiveLiveRoomLogLevelDebug = 0,    /**< Debug */
    AlivcInteractiveLiveRoomLogLevelInfo  = 1,    /**< Info */
    AlivcInteractiveLiveRoomLogLevelWarn  = 2,    /**< Warnning */
    AlivcInteractiveLiveRoomLogLevelError = 3,    /**< Error */
};

typedef NS_ENUM(NSInteger,AlivcInteractiveLiveRoomLogMode) {
    AlivcInteractiveLiveRoomLogModePrint = 1 << 0,         /**< print */
    AlivcInteractiveLiveRoomLogModeLocalFile = 1 << 1,     /**< print to local file */
};


#endif /* AlivcLiveRoomConstants_h */
