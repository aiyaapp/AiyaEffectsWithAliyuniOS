//  列表管理类，提供接口获取本地内存列表及从服务器更新列表
//  AlivcVideoListMgr.m
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2018/4/23.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import "AlivcVideoListManager.h"
#import "AlivcLivePlayRoom.h"
#import "AlivcAppServer.h"
#import "AlivcDefine.h"

@implementation AlivcVideoListManager

- (void)getLivePageIndex:(NSInteger )pageIndex pageSize:(NSInteger)pageSize ListSucess:(void (^)(NSArray<AlivcLivePlayRoom *> *))sucess failure:(void (^)(NSString *))failure{
//    NSMutableArray *test = [[NSMutableArray alloc]init];
//    for (int i = 0; i < 1; i++) {
//        AlivcLivePlayRoom *mediaInfo = [[AlivcLivePlayRoom alloc]init];
//        [test addObject:mediaInfo];
//    }
//
//    sucess(test);
//    return;
    //appserver
    NSString *urlString = @"/appserver/getroomlist";
    NSString *allUrlString = [NSString stringWithFormat:@"%@%@",AlivcAppServer_UrlPreString,urlString];
    [AlivcAppServer postWithUrlString:allUrlString parameters:@{@"page_index":@(pageIndex),@"page_size":@(pageSize)} completionHandler:^(NSString * _Nullable errString, NSDictionary * _Nullable resultDic) {
        if (errString) {
            failure(errString);
        }else{
            [AlivcAppServer judgmentResultDic:resultDic success:^(id dataObject) {
                NSDictionary *dataDic = (NSDictionary *)dataObject;
                NSArray *roomsDic = dataDic[@"rooms"];
                BOOL more = [dataDic[@"more"] boolValue];
                NSMutableArray *roomsArray = [[NSMutableArray alloc]init];
                for (NSDictionary *dic in roomsDic) {
                    AlivcLivePlayRoom *roomInfo = [[AlivcLivePlayRoom alloc]initWithDic:dic];
                    roomInfo.more = more;
                    [roomsArray addObject:roomInfo];
                }
                NSArray *resultArray = (NSArray *)roomsArray;
                sucess(resultArray);
            } doFailure:failure];
            
        }
    }];
//    [AlivcAppServer getWithUrlString:allUrlString completionHandler:^(NSString * _Nullable errString, NSDictionary * _Nullable resultDic) {
//
//
//    }];
}

- (void)getVodListSucess:(void (^)(NSArray<AlivcLivePlayRoom *> *))sucess failure:(void (^)(NSString *))failure{
    
}

- (void)getLivePlaybackListSucess:(void (^)(NSArray<AlivcLivePlayRoom *> *))sucess failure:(void (^)(NSString *))failure{
    
}

@end
