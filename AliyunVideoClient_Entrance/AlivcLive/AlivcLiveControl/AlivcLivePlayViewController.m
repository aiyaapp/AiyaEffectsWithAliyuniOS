//  
//  AlivcLivePlayViewController.m
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2018/4/24.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import "AlivcLivePlayViewController.h"
#import "AlivcLiveRoomView.h"
#import <AlivcInteractiveLiveRoomSDK/AlivcInteractiveLiveRoomSDK.h>
#import "AlivcKickoutView.h"
#import "AlivcProfile.h"
#import "AlivcLiveRoomManager.h"
#import "MBProgressHUD+AlivcHelper.h"
#import "AlivcUserInfoManager.h"

@interface AlivcLivePlayViewController ()<AlivcLiveRoomViewDelegate>

@property (nonatomic, strong) AlivcLiveRoomView *roomView;

@end

@implementation AlivcLivePlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    AlivcProfile *profile = [AlivcProfile shareInstance];
    NSString *userId = profile.userId;
    if(!userId){
        __weak typeof(self)weakSelf = self;
        [AlivcUserInfoManager randomAUserSuccess:^(AlivcLiveUser *liveUser) {
            __strong typeof(weakSelf)strongSelf = weakSelf;
            if (!strongSelf) return;
            profile.userId = liveUser.userId;
            profile.avatarUrlString = liveUser.avatarUrlString;
            profile.nickname = liveUser.nickname;
            [strongSelf configForLive];
        } failure:^(NSString * _Nonnull errDes) {
            __strong typeof(weakSelf)strongSelf = weakSelf;
            if (!strongSelf) return;
            [MBProgressHUD showMessage:errDes inView:strongSelf.view];
        }];
    }else{
        [self configForLive];
    }
}

- (void)configForLive{
    
    if ([NSThread currentThread].isMainThread == NO) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self configForLive];
        });
        return;
    }
    
    __weak typeof(self)weakSelf = self;
    if (_role == AlivcLiveRoleHost) {
        
        // 主播的房间存到用户信息里面
        NSString *roomId = [AlivcProfile shareInstance].roomId;
        if (roomId) {
            self.roomId = roomId;
            [self prepareForEnterRoom];
            return;
        }
        
        // 如果没有roomId则创建房间
        [AlivcLiveRoomManager createRoomWithUserId:[AlivcProfile shareInstance].userId roomTitle:@"阿里云互动直播SDK" success:^(AlivcLivePlayRoom *room) {
            __strong typeof(weakSelf)strongSelf = weakSelf;
            if (!strongSelf) return;
            strongSelf.roomId = room.roomId;
            [AlivcProfile shareInstance].roomId = room.roomId;
            [strongSelf prepareForEnterRoom];
        } failure:^(NSString *errString) {
            __strong typeof(weakSelf)strongSelf = weakSelf;
            if (!strongSelf) return;
            [strongSelf backWithErrorString:errString];
        }];
    }else{
        [self prepareForEnterRoom];
        [self.view addSubview:self.roomView];
    }
}

- (void)backWithErrorString:(NSString *)errString{
    [self.navigationController popViewControllerAnimated:YES];
    if (self.showedCompletion) {
        self.showedCompletion(errString);
    }
}

- (void)prepareForEnterRoom{
    self.roomView = [[AlivcLiveRoomView alloc]initWithRole:self.role roomId:self.roomId userInfo:self.userInfo roomconfig:self.roomConfig];
    __weak typeof(self)weakSelf = self;
    [self.roomView setCloseCompletion:^(NSString *str) {
        __strong typeof(self)strongSelf = weakSelf;
        if (!strongSelf) return;
        if (strongSelf.showedCompletion) {
            strongSelf.showedCompletion(str);
        }
    }];
    self.roomView.delegate = self;
    [self.view addSubview:self.roomView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.roomView destroy];
}

- (void)dealloc{
    [self.roomView destroy];
}

#pragma mark - AlivcLiveRoomViewDelegate

- (void)haveleavedRoomView:(AlivcLiveRoomView *)roomView isBeKickouted:(BOOL)kickout{
    if (self.role == AlivcLiveRoleHost) {
        if (!kickout) {
            [self.roomView destroy];
        }
    }else{
        [self.roomView destroy];
    }
    if (kickout && self.role == AlivcLiveRoleHost) {
        return;
    }else{
        [self.navigationController popViewControllerAnimated:true];
        if (kickout) {
            if (self.showBeKickOut) {
                self.showBeKickOut();
            }
//            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"你已被主播踢出直播间,请注意言行!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//            [alertView show];
        }
    }
}

#pragma mark - 转屏
- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end
