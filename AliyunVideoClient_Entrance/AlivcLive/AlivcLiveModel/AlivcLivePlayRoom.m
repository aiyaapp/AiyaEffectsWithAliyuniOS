//  视频列表实体类
//  AlivcMediaInfo.m
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2018/4/23.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import "AlivcLivePlayRoom.h"
#import "AlivcDefine.h"

@implementation AlivcLivePlayRoom
@synthesize viewCount = _viewCount;
- (instancetype)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        [self refreshWithDic:dic];
    }
    return self;
}

- (void)refreshWithDic:(NSDictionary *)dic{
    NSString *roomId = dic[@"room_id"];
    if (roomId) {
        _roomId = roomId;
    }
    
    NSString *roomTitle = dic[@"room_title"];
    if (roomTitle) {
        _roomTitle = roomTitle;
    }
    
    NSString *coverUrlString = dic[@"room_screen_shot"];
    if (coverUrlString) {
        if ([coverUrlString containsString:@"http://"] || [coverUrlString containsString:@"https://"]) {
            _coverUrlString = coverUrlString;
        }else{
            _coverUrlString = [AlivcAppServer_UrlPreString stringByAppendingPathComponent:coverUrlString];
        }
    }
    
    NSString *viewCountString = dic[@"room_viewer_count"];
    if (viewCountString) {
        _viewCount = [viewCountString integerValue];
    }else{
        _viewCount = 0;
    }
    
    NSString *hostId = dic[@"streamer_id"];
    if (hostId) {
        _hostId = hostId;
    }
    
    NSString *hostName = dic[@"streamer_name"];
    if (hostName) {
        _hostName = hostName;
    }
    
    NSString *avaterUrl = dic[@"streamer_avater"];
    if (avaterUrl) {
        if ([avaterUrl containsString:@"http://"] || [avaterUrl containsString:@"https://"]) {
            _avaterUrl = avaterUrl;
        }else{
            _avaterUrl = [AlivcAppServer_UrlPreString stringByAppendingPathComponent:avaterUrl];
        }
    }
    
    NSString *play_flv = dic[@"play_flv"];
    if (play_flv) {
        _play_flv = play_flv;
    }
    
    NSString *play_hls = dic[@"play_hls"];
    if (play_hls) {
        _play_hls = play_hls;
    }
    
    NSString *play_rtmp = dic[@"play_rtmp"];
    if (play_rtmp) {
        _play_rtmp = play_rtmp;
    }
    
    _host = [[AlivcLiveUser alloc] init];
    _host.nickname = _hostName;
    _host.userId = _hostId;
    _host.avatarUrlString = _avaterUrl;
    
    NSArray *userListDic = dic[@"room_user_list"];
    if ([userListDic isKindOfClass:[NSArray class]]) {
        NSMutableArray *userList = [[NSMutableArray alloc]init];
        for (NSDictionary *userDic in userListDic) {
            AlivcLiveUser *user = [[AlivcLiveUser alloc]initWithDic:userDic];
            [userList addObject:user];
        }
        self.audienceList = userList;
    }
}

- (NSInteger)viewCount{
    if (_viewCount < 0) {
        _viewCount = 0;
    }
    return _viewCount;
}

- (void)setViewCount:(NSInteger)viewCount{
    if (viewCount < 0) {
        viewCount = 0;
    }
    _viewCount = viewCount;
}

@end
