//  视频列表管理类,提供接口获取本地内存列表及从服务器更新列表
//  AlivcVideoListMgr.h
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2018/4/23.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AlivcLivePlayRoom;

@interface AlivcVideoListManager : NSObject

- (void)getLivePageIndex:(NSInteger )pageIndex pageSize:(NSInteger)pageSize ListSucess:(void (^)(NSArray<AlivcLivePlayRoom *> *))sucess failure:(void (^)(NSString *))failure;
- (void)getLivePlaybackListSucess:(void (^)(NSArray <AlivcLivePlayRoom *>*playbackList))sucess failure:(void(^)(NSString *errorString))failure;

- (void)getVodListSucess:(void (^)(NSArray <AlivcLivePlayRoom *>*vodList))sucess failure:(void(^)(NSString *errorString))failure;

@end
