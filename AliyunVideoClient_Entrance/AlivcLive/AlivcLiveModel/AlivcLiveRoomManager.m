//  
//  AlivcChatRoomManager.m
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2018/4/24.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import "AlivcLiveRoomManager.h"
#import "AlivcAppServer.h"
#import "AlivcDefine.h"

@implementation AlivcLiveRoomManager

+ (void)stsWithAppUid:(NSString *)appUid success:(void (^)(AlivcSts *sts))success failure:(void(^)(NSString *errString))failure{
    
    
    NSString *urlString = [AlivcAppServer_UrlPreString stringByAppendingString:@"/appserver/newsts"];
    NSDictionary *params = @{@"id":appUid?:@""};
    [AlivcAppServer postWithUrlString:urlString parameters:params completionHandler:^(NSString * _Nullable errString, NSDictionary * _Nullable resultDic) {
        
        if (errString) {
            if (failure) {
                failure(errString);
            }
            NSLog(@"%@ %@ error:%@", urlString, params, errString);
        }else{
            
            AlivcSts *sts = nil;
            NSDictionary *dic = resultDic[@"data"];
            if ([dic isKindOfClass:[NSDictionary class]]) {
                dic = dic[@"SecurityTokenInfo"];
                if ([dic isKindOfClass:[NSDictionary class]]) {
                    sts = [[AlivcSts alloc] init];
                    sts.accessKey = dic[@"AccessKeyId"];
                    sts.secretKey = dic[@"AccessKeySecret"];
                    sts.securityToken = dic[@"SecurityToken"];
                    sts.expireTime = dic[@"Expiration"];
                    
                    // 存储
                    [[NSUserDefaults standardUserDefaults] setObject:sts.accessKey forKey:AlivcAppServer_StsAccessKey];
                    [[NSUserDefaults standardUserDefaults] setObject:sts.secretKey forKey:AlivcAppServer_StsSecretKey];
                    [[NSUserDefaults standardUserDefaults] setObject:sts.securityToken forKey:AlivcAppServer_StsSecurityToken];
                    [[NSUserDefaults standardUserDefaults] setObject:sts.expireTime forKey:AlivcAppServer_StsExpiredTime];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
            }
            
            if (sts) {
                if (success) {
                    success(sts);
                }
                NSLog(@"%@ %@ success", urlString, params);
            }else{
                if (failure) {
                    failure(@"sts is nil");
                }
                NSLog(@"%@ %@ error:sts is nil", urlString, params);
            }
        }
    }];
    
}

+ (void)createRoomWithUserId:(NSString *)userId roomTitle:(NSString *)title success:(void (^)(AlivcLivePlayRoom *room))success failure:(void(^)(NSString *errString))failure{
    
    NSString *urlString = [AlivcAppServer_UrlPreString stringByAppendingString:@"/appserver/createroom"];
    NSDictionary *parameters = @{
                                 @"user_id":userId?:@"",
                                 @"room_title":title?:@""
                                 };
    [AlivcAppServer postWithUrlString:urlString parameters:parameters completionHandler:^(NSString * _Nullable errString, NSDictionary * _Nullable resultDic) {
        
        if (errString) {
            if (failure) {
                failure(errString);
            }
            NSLog(@"%@ %@ error:%@", urlString, parameters, errString);
        }else{
            [AlivcAppServer judgmentResultDic:resultDic success:^(id  _Nonnull dataObject) {
                
                AlivcLivePlayRoom *room = [[AlivcLivePlayRoom alloc] initWithDic:dataObject];
                if (success) {
                    success(room);
                }
                NSLog(@"%@ %@ sucess", urlString, parameters);
            } doFailure:^(NSString * errStr) {
                if (failure) {
                    failure(errStr);
                }
                NSLog(@"%@ %@ error:%@", urlString, parameters, errStr);
            }];
        }
    }];
}

+ (void)joinRoomWithRoomId:(NSString *)roomId hostId:(NSString *)hostId audience:(NSString *)audienceId success:(void(^)(void))success failure:(void(^)(NSString *errString))failure{
    
    NSString *urlString = [AlivcAppServer_UrlPreString stringByAppendingString:@"/appserver/joinroom"];
    NSDictionary *parameters = @{
                                 @"room_id":roomId?:@"",
                                 @"streamer_id":hostId?:@"",
                                 @"viewer_id":audienceId?:@""
                                 };
    [AlivcAppServer postWithUrlString:urlString parameters:parameters completionHandler:^(NSString * _Nullable errString, NSDictionary * _Nullable resultDic) {
        
        if (errString) {
            if (failure) {
                failure(errString);
            }
            NSLog(@"%@ %@ error:%@", urlString, parameters, errString);
        }else{
            [AlivcAppServer judgmentResultDic:resultDic success:^(id  _Nonnull dataObject) {
                if (success) {
                    success();
                }
                NSLog(@"%@ %@ sucess", urlString, parameters);
            } doFailure:^(NSString * errStr) {
                if (failure) {
                    failure(errStr);
                }
                NSLog(@"%@ %@ error:%@", urlString, parameters, errStr);
            }];
        }
    }];
}

+ (void)leaveRoomWithRoomId:(NSString *)roomId userId:(NSString *)userId success:(void (^)(void))success failure:(void (^)(NSString *))failure{
    
    NSString *urlString = [AlivcAppServer_UrlPreString stringByAppendingString:@"/appserver/leaveroom"];
    NSDictionary *parameters = @{
                                 @"room_id":roomId?:@"",
                                 @"user_id":userId?:@""
                                 };
    [AlivcAppServer postWithUrlString:urlString parameters:parameters completionHandler:^(NSString * _Nullable errString, NSDictionary * _Nullable resultDic) {
        
        if (errString) {
            if (failure) {
                failure(errString);
            }
            NSLog(@"%@ %@ error:%@", urlString, parameters, errString);
        }else{
            [AlivcAppServer judgmentResultDic:resultDic success:^(id  _Nonnull dataObject) {
                if (success) {
                    success();
                }
                NSLog(@"%@ %@ sucess", urlString, parameters);
            } doFailure:^(NSString * errStr) {
                if (failure) {
                    failure(errStr);
                }
                NSLog(@"%@ %@ error:%@", urlString, parameters, errStr);
            }];
        }
    }];
}

+ (void)roomInfoDetailWithRoomId:(NSString *)roomId success:(void (^)(AlivcLivePlayRoom *room))success failure:(void(^)(NSString *errString))failure{
    
    NSString *urlString = [AlivcAppServer_UrlPreString stringByAppendingString:@"/appserver/getroomdetail"];
    NSDictionary *parameters = @{
                                 @"room_id":roomId?:@""
                                 };
    [AlivcAppServer postWithUrlString:urlString parameters:parameters completionHandler:^(NSString * _Nullable errString, NSDictionary * _Nullable resultDic) {
        
        if (errString) {
            if (failure) {
                failure(errString);
            }
            NSLog(@"%@ %@ error:%@", urlString, parameters, errString);
        }else{
            [AlivcAppServer judgmentResultDic:resultDic success:^(id  _Nonnull dataObject) {
                
                NSMutableDictionary *dic = [[dataObject objectForKey:@"room_info"] mutableCopy];
                NSDictionary *streamerInfo = [dataObject objectForKey:@"streamer_info"];
                
                [dic setObject:[streamerInfo objectForKey:@"user_id"] ?:@"" forKey:@"streamer_id"];
                [dic setObject:[streamerInfo objectForKey:@"nick_name"] ?:@"" forKey:@"streamer_name"];
                [dic setObject:[streamerInfo objectForKey:@"avatar"] ?:@"" forKey:@"streamer_avater"];
                
                AlivcLivePlayRoom *room = [[AlivcLivePlayRoom alloc] initWithDic:dic];
                if (success) {
                    success(room);
                }
                NSLog(@"%@ %@ sucess", urlString, parameters);
            } doFailure:^(NSString * errStr) {
                if (failure) {
                    failure(errStr);
                }
                NSLog(@"%@ %@ error:%@", urlString, parameters, errStr);
            }];
        }
    }];
}

+ (void)joinRoomNotificationWithRoomID:(NSString *)roomId userId:(NSString *)userId success:(void (^)(void))success failure:(void(^)(NSString *errString))failure{
    
    NSString *urlString = @"/appserver/notification";
    NSString *allUrlString = [NSString stringWithFormat:@"%@%@",AlivcAppServer_UrlPreString,urlString];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:@"e_enter_room" forKey:@"event_id"];
    [parameters setObject:roomId?:@"" forKey:@"room_id"];
    [parameters setObject:userId?:@"" forKey:@"user_id"];

    [AlivcAppServer postWithUrlString:allUrlString parameters:parameters completionHandler:^(NSString * _Nullable errString, NSDictionary * _Nullable resultDic) {
        if (errString) {
            if (failure) {
                failure(errString);
            }
            NSLog(@"%@ %@ error:%@", urlString, parameters, errString);
        }else{
            [AlivcAppServer judgmentResultDic:resultDic success:^(id dataObject) {
                if (success) {
                    success();
                }
                NSLog(@"%@ %@ sucess", urlString, parameters);
            } doFailure:^(NSString * errStr) {
                if (failure) {
                    failure(errStr);
                }
                NSLog(@"%@ %@ error:%@", urlString, parameters, errStr);
            }];
        }
    }];
}

+ (void)leaveRoomNotificationWithRoomID:(NSString *)roomId userId:(NSString *)userId success:(void (^)(void))success failure:(void(^)(NSString *errString))failure{
    
    NSString *urlString = @"/appserver/notification";
    NSString *allUrlString = [NSString stringWithFormat:@"%@%@",AlivcAppServer_UrlPreString,urlString];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:@"e_leave_room" forKey:@"event_id"];
    [parameters setObject:roomId?:@"" forKey:@"room_id"];
    [parameters setObject:userId?:@"" forKey:@"user_id"];
    
    [AlivcAppServer postWithUrlString:allUrlString parameters:parameters completionHandler:^(NSString * _Nullable errString, NSDictionary * _Nullable resultDic) {
        if (errString) {
            if (failure) {
                failure(errString);
            }
            NSLog(@"%@ %@ error:%@", urlString, parameters, errString);
        }else{
            [AlivcAppServer judgmentResultDic:resultDic success:^(id dataObject) {
                if (success) {
                    success();
                }
                NSLog(@"%@ %@ sucess", urlString, parameters);
            } doFailure:^(NSString * errStr) {
                if (failure) {
                    failure(errStr);
                }
                NSLog(@"%@ %@ error:%@", urlString, parameters, errStr);
            }];
        }
    }];
}

+ (void)startStreamingWithRoomID:(NSString *)roomId userId:(NSString *)userId success:(void (^)(void))success failure:(void(^)(NSString *errString))failure{
    
    NSString *urlString = @"/appserver/startstreaming";
    NSString *allUrlString = [NSString stringWithFormat:@"%@%@",AlivcAppServer_UrlPreString,urlString];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:roomId?:@"" forKey:@"room_id"];
    [parameters setObject:userId?:@"" forKey:@"user_id"];
    
    [AlivcAppServer postWithUrlString:allUrlString parameters:parameters completionHandler:^(NSString * _Nullable errString, NSDictionary * _Nullable resultDic) {
        if (errString) {
            if (failure) {
                failure(errString);
            }
            NSLog(@"%@ %@ error:%@", urlString, parameters, errString);
        }else{
            [AlivcAppServer judgmentResultDic:resultDic success:^(id dataObject) {
                if (success) {
                    success();
                }
                NSLog(@"%@ %@ sucess", urlString, parameters);
            } doFailure:^(NSString * errStr) {
                if (failure) {
                    failure(errStr);
                }
                NSLog(@"%@ %@ error:%@", urlString, parameters, errStr);
            }];
        }
    }];
}

+ (void)endStreamingWithRoomID:(NSString *)roomId userId:(NSString *)userId success:(void (^)(void))success failure:(void(^)(NSString *errString))failure{
    
    NSString *urlString = @"/appserver/endstreaming";
    NSString *allUrlString = [NSString stringWithFormat:@"%@%@",AlivcAppServer_UrlPreString,urlString];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:roomId?:@"" forKey:@"room_id"];
    [parameters setObject:userId?:@"" forKey:@"user_id"];
    
    [AlivcAppServer postWithUrlString:allUrlString parameters:parameters completionHandler:^(NSString * _Nullable errString, NSDictionary * _Nullable resultDic) {
        if (errString) {
            if (failure) {
                failure(errString);
            }
            NSLog(@"%@ %@ error:%@", urlString, parameters, errString);
        }else{
            [AlivcAppServer judgmentResultDic:resultDic success:^(id dataObject) {
                if (success) {
                    success();
                }
                NSLog(@"%@ %@ sucess", urlString, parameters);
            } doFailure:^(NSString * errStr) {
                if (failure) {
                    failure(errStr);
                }
                NSLog(@"%@ %@ error:%@", urlString, parameters, errStr);
            }];
        }
    }];
}

+ (void)bindRoomWithUserId:(NSString *)userId roomId:(NSString *)roomId pushUrl:(NSString *)pushUrlString playFlv:(NSString *)playFlv palyHls:(NSString *)playHls playRtmp:(NSString *)playRtmp success:(void (^)(void))success failure:(void (^)(NSString *))failure{
    
    NSString *urlString = @"/appserver/bindroom";
    NSString *allUrlString = [NSString stringWithFormat:@"%@%@",AlivcAppServer_UrlPreString,urlString];
    NSDictionary *param = @{@"user_id":userId,@"user_id":userId,@"room_id":roomId,@"push_url":pushUrlString,@"play_flv":playFlv,@"play_hls":playHls,@"play_rtmp":playRtmp};
    [AlivcAppServer postWithUrlString:allUrlString parameters:param completionHandler:^(NSString * _Nullable errString, NSDictionary * _Nullable resultDic) {
        if (errString) {
            if (failure) {
                failure(errString);
            }
            NSLog(@"%@ %@ error:%@", urlString, param, errString);
        }else{
            [AlivcAppServer judgmentResultDic:resultDic success:^(id  _Nonnull dataObject) {
                if (success) {
                    success();
                }
                NSLog(@"%@ %@ sucess", urlString, param);
            } doFailure:^(NSString * errStr) {
                if (failure) {
                    failure(errStr);
                }
                NSLog(@"%@ %@ error:%@", urlString, param, errStr);
            }];
        }
    }];
}
@end
