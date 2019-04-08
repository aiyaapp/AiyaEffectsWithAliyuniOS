//
//  AlivcDefine.m
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2018/5/9.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import "AlivcDefine.h"
#import "AlivcProfile.h"
#import "AlivcUserInfoManager.h"
#import "MBProgressHUD+AlivcHelper.h"



NSString * AlivcAppServer_UrlPreString = @"http://live-appserver-sig.alivecdn.com"; // 新加坡
NSString * AlivcAppServer_AppID = @"sg-37nisbt8"; // 新加坡

NSString *const AlivcAppServer_StsAccessKey = @"com.alivc.sts.stsAccessKey";
NSString *const AlivcAppServer_StsSecretKey = @"com.alivc.sts.stsSecretKey";
NSString *const AlivcAppServer_StsSecurityToken = @"com.alivc.sts.stsSecurityToken";
NSString *const AlivcAppServer_StsExpiredTime = @"com.alivc.sts.stsExpiredTime";

NSString *const AlivcAppServer_Mode = @"com.alivc.app.mode";

@implementation AlivcDefine

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        int mode = [[[NSUserDefaults standardUserDefaults] objectForKey:AlivcAppServer_Mode] intValue];
        [AlivcDefine AlivcAppServerSetTestEnvMode:mode]; // 默认是新加坡环境
    });
}

+ (void) AlivcAppServerSetTestEnvMode:(int)mode {
    
    if(mode == 0) { // 新加坡
        AlivcAppServer_UrlPreString = @"http://live-appserver-sig.alivecdn.com";
        AlivcAppServer_AppID = @"sg-becvqlqr";
    }else if(mode == 1) { //上海
        AlivcAppServer_UrlPreString = @"http://live-appserver-sh.alivecdn.com";
        AlivcAppServer_AppID = @"sh-hrjbxns6";
    }
    
    // 记录环境
    [[NSUserDefaults standardUserDefaults] setObject:@(mode) forKey:AlivcAppServer_Mode];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //更换用户
    AlivcProfile *profile = [AlivcProfile shareInstance];
    [AlivcUserInfoManager randomAUserSuccess:^(AlivcLiveUser *liveUser) {
        profile.userId = liveUser.userId;
        profile.avatarUrlString = liveUser.avatarUrlString;
        profile.nickname = liveUser.nickname;
    } failure:^(NSString * _Nonnull errDes) {
        
    }];
    
}

+ (int)mode{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:AlivcAppServer_Mode] intValue];
}

@end

