//
//  AlivcChatRoomView.m
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2018/4/24.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import "AlivcLiveRoomView.h"
#import "AlivcControlView.h"
#import "AlivcMessageInputView.h"
#import "AlivcMessageListView.h"
#import "AlivcUserEnterView.h"
#import "AlivcMessage.h"
#import "AlivcHostPreSelectLiveQualityView.h"
#import "AlivcUserInfoListView.h"
#import "AlivcOperateUserView.h"
#import "AlivcRoomInfoView.h"

#import "XTLoveHeartView.h"
#import "AlivcUIConfig.h"
#import "AlivcLiveUser.h"
#import "AlivcUserInfoManager.h"

#import "MBProgressHUD+AlivcHelper.h"
#import "NSString+AlivcHelper.h"
#import "UIColor+AlivcHelper.h"

#import "AliyunReachability.h"

#import <AlivcLibFace/AlivcLibFaceManager.h>
#import <ALivcLibBeauty/AlivcLibBeautyManager.h>

#import "AlivcLikeBox.h"
#import "AlivcKickoutView.h"
#import "AlivcProfile.h"
#import "AlivcStringConvertTool.h"
#import "AlivcLiveRoomManager.h"

#import "AlivcLiveBeautifySettingsViewController.h"
#import "NSString+AlivcHelper.h"

#if __has_include(<AlivcInteractiveWidgetSDK/AlivcInteractiveWidgetSDK.h>)
#import <AlivcInteractiveWidgetSDK/AlivcInteractiveWidgetSDK.h>
#else
#import "AlivcInteractiveWidgetSDK.h"
#endif

#if __has_include(<AlivcInteractiveLiveRoomSDK/AlivcInteractiveLiveRoomSDK.h>)
#import <AlivcInteractiveLiveRoomSDK/AlivcInteractiveLiveRoomSDK.h>
#else
#import "AlivcInteractiveLiveRoomSDK.h"
#endif

#if __has_include(<AlivcUtilsSDK/AlivcLiveTime.h>)
#import <AlivcUtilsSDK/AlivcLiveTime.h>
#else
#import "AlivcLiveTime.h"
#endif


//"Iii5c3Es","LTAIKV1BwUcdSvK9","6kYp5oe3ntbHiNNqedhgaHhtiKDkgw"

static long kLIKE_COUNT = 0;
static NSInteger const kKickOutDuration = 60 * 15; // 踢出时间

@interface AlivcLiveRoomView()<
AlivcInteractiveLiveRoomAuthDelegate,
AlivcLiveRoomNotifyDelegate,
AlivcLiveRoomPlayerNotifyDelegate,
AlivcLiveRoomPusherNotifyDelegate,
AlivcLiveRoomNetworkNotifyDelegate,
AlivcInteractiveLiveRoomErrorDelegate,
AlivcLivePusherCustomFilterDelegate,
AlivcLivePusherCustomDetectorDelegate,
AlivcInteractiveNotifyDelegate,
UIGestureRecognizerDelegate,
AlivcUserInfoListViewDelegate,
AlivcOperateUserViewDelegate,
AlivcControlViewDelegate,
AlivcMessageInputViewDelegate,
AlivcLiveBeautifySettingsViewControllerDelegate,
AlivcHostPreSelectLiveQualityViewDelegate,
AlivcMessageListViewDelegate,
AlivcRoomInfoViewDelegate,
UIAlertViewDelegate>

@property (nonatomic, strong) AliyunReachability *reachability;       //网络监听

#pragma mark - UI

/**
 房间信息视图
 */
@property (nonatomic, strong) AlivcRoomInfoView *roomInfoView;

/**
 播放视图本身
 */
@property (nonatomic, strong) UIView *playView;

/**
 除了主播之外的其他mic的播放器
 */
@property (nonatomic, strong) UIView *subPlayView;

/**
 用户列表视图
 */
@property (nonatomic, strong) AlivcUserInfoListView *userListView;

/**
 美颜参数调整视图
 */
@property (nonatomic, strong) AlivcLiveBeautifySettingsViewController *beautifySettingController;

/**
 消息列表视图
 */
@property (nonatomic, strong) AlivcMessageListView *messageListView;

/**
 消息输入视图
 */
@property (nonatomic, strong) AlivcMessageInputView *messageInputView;

/**
 观众进入
 */
@property (nonatomic, strong) AlivcUserEnterView *enterView;

/**
 底部的控制视图 - 总的按钮集合
 */
@property (nonatomic, strong) AlivcControlView *controlView;

/**
 主播预览视图 - 开始播放后直接移除
 */
@property (nonatomic, strong) UIView *hostPreView;

/**
 主播操作用户的视图
 */
@property (nonatomic, strong) AlivcOperateUserView *operateView;

/**
 开始直播按钮
 */
@property (nonatomic, strong) UIButton *startLiveButton;

/**
 流清晰度选择面板
 */
@property (nonatomic, strong) AlivcHostPreSelectLiveQualityView *selectView;

#pragma mark - Other
/**
 角色
 */
@property (nonatomic, assign) AlivcLiveRoleType role;

/**
 直播间
 */
@property (nonatomic, strong) AlivcInteractiveLiveRoom *liveRoom;

/**
 主播信息
 */
@property (nonatomic, strong) AlivcLiveUser *hostUser;

/**
 直播间的配置信息 - 界面上的摄像头等
 */
@property (nonatomic, strong) AlivcInteractiveLiveRoomConfig *roomConfig;

/**
 直播间的配置信息 - 底层属性，播放参数
 */
@property (nonatomic, strong) AlivcLiveRoomInfo *roomInfo;

/**
 AppServer的roomInfo
 */
@property (nonatomic, strong) AlivcLivePlayRoom *appRoomInfo;

/**
 观众或者主播的用户信息
 */
@property (nonatomic, strong) AlivcUser *userInfo;

/**
 暂存的评论消息
 */
@property (nonatomic, strong) NSString *tempMessage;

/**
 暂存的消息类型
 */
@property (nonatomic, assign) AlivcMessageType tempMessageType;

/**
 摄像头是否前置
 */
@property (nonatomic, assign) BOOL cameraIsPreposition;

/**
 sts token
 */
@property (nonatomic, strong) AlivcSts *stsToken;

@property (nonatomic, copy) NSString *roomId;

@property (nonatomic, assign) BOOL enterRoomFail;

@property (nonatomic, strong) NSMutableSet <NSString *> *kickoutUids;

@end

@implementation AlivcLiveRoomView

- (NSMutableSet<NSString *> *)kickoutUids{
    if(!_kickoutUids){
        _kickoutUids = [[NSMutableSet alloc] init];
    }
    return _kickoutUids;
}

#pragma mark - getter
//- (NSMutableArray<AlivcLiveUser *> *)liveUserList{
//    if (!_liveUserList) {
//        _liveUserList = [[NSMutableArray alloc] init];
//    }
//    return _liveUserList;
//}

- (AlivcRoomInfoView *)roomInfoView{
    if (!_roomInfoView) {
        _roomInfoView = [[AlivcRoomInfoView alloc]initWithHost:_hostUser];
        _roomInfoView.delegate = self;
    }
    return _roomInfoView;
}

- (AlivcUserInfoListView *)userListView{
    if (!_userListView) {
        _userListView = [[AlivcUserInfoListView alloc]initWithArray:NULL];
        _userListView.delegate = self;
    }
    return _userListView;
}

- (UIView *)playView{
    if (!_playView) {
        _playView = [[UIView alloc] init];
        _playView.backgroundColor = [UIColor clearColor];
        _playView.frame = [self getFullScreenFrame];
        if (self.role != AlivcLiveRoleHost) {
            UIImageView *bg = [[UIImageView alloc] initWithFrame:_playView.bounds];
            bg.backgroundColor = [UIColor whiteColor];
            bg.image = [UIImage imageNamed:@"alivcReources.bundle/background_push"];
            [_playView addSubview:bg];
        }
    }
    return _playView;
}

- (UIView *)subPlayView{
    if (!_subPlayView) {
        _subPlayView = [[UIView alloc] init];
        _subPlayView.frame = [self getSmallPlayRect];
    }
    return _subPlayView;
}

- (UIView *)hostPreView{
    if (!_hostPreView) {
        _hostPreView = [[UIView alloc] init];
        _hostPreView.backgroundColor = [UIColor clearColor];
        _hostPreView.frame = [self getFullScreenFrame];
    }
    return _hostPreView;
}

- (AlivcMessageListView *)messageListView{
    if (!_messageListView) {
        _messageListView = [[AlivcMessageListView alloc]init];
        _messageListView.delegate = self;
    }
    return _messageListView;
}

- (AlivcUserEnterView *)enterView{
    if (_enterView == nil) {
        _enterView = [[AlivcUserEnterView alloc] init];
    }
    return _enterView;
}


- (AlivcMessageInputView *)messageInputView{
    if (!_messageInputView) {
        _messageInputView = [[AlivcMessageInputView alloc]init];
        _messageInputView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height+50);
        _messageInputView.hidden = YES;
        _messageInputView.delegate = self;
    }
    return _messageInputView;
}

- (AlivcControlView *)controlView{
    if (!_controlView) {
        _controlView = [[AlivcControlView alloc]initWithRole:_role];
        _controlView.delegate = self;
    }
    return _controlView;
}

- (instancetype)initWithRole:(AlivcLiveRoleType)role roomId:(NSString *)roomId userInfo:(AlivcUser *)userInfo roomconfig:(AlivcInteractiveLiveRoomConfig *)roomConfig{
    self = [super init];
    if (self) {
        _role = role;
        _userInfo = userInfo;
        _roomConfig = roomConfig;
        
        //网络状态判定
        _reachability = [AliyunReachability reachabilityForInternetConnection];
        [_reachability startNotifier];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(reachabilityChanged)
                                                     name:AliyunPVReachabilityChangedNotification
                                                   object:nil];
        
        self.stsToken = [[AlivcSts alloc]init];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        self.stsToken.accessKey = [[NSUserDefaults standardUserDefaults]objectForKey:AlivcAppServer_StsAccessKey];
        self.stsToken.secretKey = [[NSUserDefaults standardUserDefaults]objectForKey:AlivcAppServer_StsSecretKey];
        self.stsToken.securityToken = [[NSUserDefaults standardUserDefaults]objectForKey:AlivcAppServer_StsSecurityToken];
        self.stsToken.expireTime = [[NSUserDefaults standardUserDefaults]objectForKey:AlivcAppServer_StsExpiredTime];
        
        self.roomId = roomId;
        self.frame = [UIScreen mainScreen].bounds;
        
        [self configBaseUI];
        [self configLiveRoom];
        [self addNotification];
        [self addGesture];
        
        self.cameraIsPreposition = true;
        if(role == AlivcLiveRoleHost){
            self.hostUser = [AlivcProfile shareInstance];
            [self refreshUIWithHost:self.hostUser];
        }
        
        __weak typeof(self)weakSelf = self;
        [AlivcLiveRoomManager roomInfoDetailWithRoomId:roomId success:^(AlivcLivePlayRoom *room) {
            __strong typeof(weakSelf)strongSelf = weakSelf;
            if (!strongSelf) return;
            
            strongSelf.appRoomInfo = room;
            strongSelf.hostUser = room.host;
            [strongSelf refreshUIWithHost:strongSelf.hostUser];
            
            // 过滤主播，最多显示30个
            __block NSUInteger maxCount = 0;
            NSMutableArray <AlivcLiveUser *>*audienceArr = [[NSMutableArray alloc] init];
            [room.audienceList enumerateObjectsUsingBlock:^(AlivcLiveUser * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if(![obj.userId isEqualToString:strongSelf.hostUser.userId]){
                    [audienceArr addObject:obj];
                    maxCount++;
                }
                if(maxCount >= 30){
                    *stop = YES;
                }
            }];
            
            [strongSelf refreshUIWithAudiences:audienceArr];
            [strongSelf.roomInfoView updateViewAudienceCount:strongSelf.appRoomInfo.viewCount];
            
        } failure:^(NSString *errString) {
            
        }];
        
        [self onCopyRoomId];
    }
    return self;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    NSLog(@"dealloc: liveRoomView");
}


- (void)destroy{
    _liveRoom = nil;
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


#pragma mark - Custom Method

/**
 初始化房间等SDK相关的东西
 */
- (void)configLiveRoom{
    
    self.liveRoom = [[AlivcInteractiveLiveRoom alloc] initWithAppId:AlivcAppServer_AppID config:_roomConfig];
    
    [self.liveRoom setRoomNotifyDelegate:self];
    [self.liveRoom setPlayerNotifyDelegate:self];
    [self.liveRoom setAuthDelegate:self];
    [self.liveRoom setInteractiveNotifyDelegate:self];
    [self.liveRoom setInteractiveLiveRoomErrorDelegate:self];
    [self.liveRoom setNetworkNotifyDelegate:self];
    if(_role == AlivcLiveRoleHost){
        [self.liveRoom setPusherNotifyDelegate:self];
        [self.liveRoom setCustomFilterDelegate:self];
        [self.liveRoom setCustomDetectorDelegate:self];
    }
    
    NSUInteger currentTime = [AlivcLiveTime getUTCTime];
    NSUInteger expireTime = self.stsToken.expireTime ? [[AlivcLiveTime getUTCTimeFromString:self.stsToken.expireTime] timeIntervalSince1970] : 0;
    NSTimeInterval interval = expireTime - currentTime;
    if(interval <= 60){ // 小于60s的时候，就重新刷新
        
        __weak typeof(self)weakSelf = self;
        [AlivcLiveRoomManager stsWithAppUid:self.userInfo.userId success:^(AlivcSts *sts) {
            __strong typeof(weakSelf)strongSelf = weakSelf;
            if (!strongSelf) return;
            strongSelf.stsToken = sts;
            [strongSelf.liveRoom login:strongSelf.stsToken];
            [strongSelf liveRoomPrepare];
        } failure:^(NSString *errString) {
            
        }];
    }else{
        [self.liveRoom login:self.stsToken];
        [self liveRoomPrepare];
    }
}

- (void)liveRoomPrepare{
    if(self.role == AlivcLiveRoleHost) {
        
        //设置主播view
        [self.liveRoom setLocalView:self.playView];
        
        //开始预览
        [self.liveRoom startPreview:^(AlivcLiveError *error) {
            
        }];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //设置默认美颜
            AlivcBeautyParams *params = [self getBeautyParamsOfLevel:[self getBeautyLevel]];
            [self.liveRoom setBeautyParams:params];
        });
        
    }else {
        AlivcLiveRole *role = [[AlivcLiveRole alloc]initWithType:self.role];
        //进入房间
        __weak typeof(self)weakSelf = self;
        [self.liveRoom enter:self.roomId user:self.userInfo role:role completion:^(AlivcLiveError *error, AlivcLiveRoomInfo *liveRoomInfo){
            
            __strong typeof(weakSelf)strongSelf = weakSelf;
            if (!strongSelf) return;
            if(error && error.errorCode != ALIVC_RETURN_SUCCESS) {
                [strongSelf onAlivcInteractiveLiveRoomErrorCode:error.errorCode errorDetail:error.errorDescription];
                return;
            }
            // appSever 加入房间
            [AlivcLiveRoomManager joinRoomWithRoomId:strongSelf.roomId
                                              hostId:liveRoomInfo.anchorAppUid
                                            audience:strongSelf.userInfo.userId success:^{
                                                __strong typeof(weakSelf)strongSelf = weakSelf;
                                                [AlivcLiveRoomManager joinRoomNotificationWithRoomID:strongSelf.roomId userId:strongSelf.userInfo.userId success:^{
                                                    
                                                } failure:^(NSString *errString) {
                                                    
                                                }];
                                                
                                            } failure:^(NSString *errString) {
                                                
                                            }];
            
            strongSelf.roomInfo = liveRoomInfo;
            NSString *anchorAppUid = liveRoomInfo.anchorAppUid;
            
            // 用户观看主播的流
            if(anchorAppUid){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [strongSelf.liveRoom setRemoteView:strongSelf.playView micAppUid:anchorAppUid];
                });
            }
            
            // 此时最多只显示另外一路流
            [liveRoomInfo.playInfosDic enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, AlivcPlayInfo * _Nonnull obj, BOOL * _Nonnull stop) {
                
                if(![key isEqualToString:anchorAppUid]){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [strongSelf.liveRoom setRemoteView:strongSelf.subPlayView micAppUid:key];
                        [strongSelf addSubview:strongSelf.subPlayView];
                    });
                    *stop = YES;
                }
            }];
        }];
        
        [self.liveRoom getLikeCount:^(AlivcLiveError *error, NSUInteger count) {
            __strong typeof(weakSelf)strongSelf = weakSelf;
            if (!strongSelf) return;
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf.roomInfoView updateLikeCount:count];
            });
        }];
    }
}

/**
 适配UI
 */
- (void)configBaseUI{
    
    if (self.role == AlivcLiveRoleHost) {
        [self configHostPreView];
    }else{
        [self creatBaseUI];
    }
}


-(UIView *)gradientMaskView{
    UIView *maskView = [[UIView alloc] init];
    maskView.frame = self.bounds;
    
    // 上下蒙版
    CGFloat height = 64;
    CAGradientLayer *topLayer = [[CAGradientLayer alloc] init];
    topLayer.colors = @[(id)[UIColor colorWithHexString:@"#000000" alpha:0].CGColor,
                        (id)[UIColor colorWithHexString:@"#000000" alpha:0.6].CGColor];
    topLayer.frame = CGRectMake(0, 0, self.hostPreView.bounds.size.width, height);
    topLayer.startPoint = CGPointMake(0.5, 1);
    topLayer.endPoint = CGPointMake(0.5, 0);
    [maskView.layer addSublayer:topLayer];
    
    
    CAGradientLayer *bottomLayer = [[CAGradientLayer alloc] init];
    bottomLayer.colors = @[(id)[UIColor colorWithHexString:@"#000000" alpha:0].CGColor,
                           (id)[UIColor colorWithHexString:@"#000000" alpha:0.6].CGColor];
    bottomLayer.frame = CGRectMake(0, self.hostPreView.bounds.size.height - height, ScreenWidth, height);
    bottomLayer.startPoint = CGPointMake(0.5, 0);
    bottomLayer.endPoint = CGPointMake(0.5, 1);
    [maskView.layer addSublayer:bottomLayer];
    return maskView;
}

/**
 适配主播端的预览视图
 */
- (void)configHostPreView{
    
    [self addSubview:self.hostPreView];
    
    [self.hostPreView addSubview:self.playView];
    
    [self.hostPreView addSubview:[self gradientMaskView]];
    
    //返回按钮
    CGFloat cy = 42 + (IPHONEX ? 24 : 0);
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backImage = [UIImage imageNamed:@"avcBackIcon"];
    backButton.frame = CGRectMake(0, 0, backImage.size.width, backImage.size.height);
    [backButton setBackgroundImage:backImage forState:UIControlStateNormal];
    [self.hostPreView addSubview:backButton];
    backButton.center = CGPointMake(26, cy);
    [backButton addTarget:self action:@selector(closeButtonTouched) forControlEvents:UIControlEventTouchUpInside];
    
    
    //美颜相关
    AlivcControlView *controlView = [[AlivcControlView alloc]initWithPreWhenRoleIsHost:true];
    controlView.delegate = self;
    [self.hostPreView addSubview:controlView];
    controlView.center = CGPointMake(ScreenWidth - controlView.frame.size.width / 2, cy);
}


/**
 开始推流成功后或者开始播放成功后开始做的一些事情 去创建UI，查询数据 正式进入界面
 */
- (void)creatBaseUI{
    
    if (self.role == AlivcLiveRoleHost) {
        [self.hostPreView removeFromSuperview];
    }
    
    CGFloat cx = 0;
    CGFloat cy = 0;
    
    [self addSubview:self.playView];
    
    [self addSubview:[self gradientMaskView]];
    
    //退出房间的按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *closeImage = [UIImage imageNamed:@"avcClose"];
    button.frame = CGRectMake(ScreenWidth - 8 - closeImage.size.width , 38  + (IPHONEX ? 24 : 0), closeImage.size.width, closeImage.size.height);
    [button setBackgroundImage:closeImage forState:UIControlStateNormal];
    [button setBackgroundImage:closeImage forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(closeButtonTouched) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    [self bringSubviewToFront:button];
    
    //主播基本信息展示
    [self addSubview:self.roomInfoView];
    CGFloat originY = button.center.y - self.roomInfoView.avatarContainView.frame.size.height / 2;
    CGRect hostFrame = self.roomInfoView.frame;
    hostFrame.origin = CGPointMake(8, originY);
    self.roomInfoView.frame = hostFrame;
    
    //roomID
    if (self.roomId) {
        UILabel *roomIdLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 20, 24)];
        roomIdLabel.text = [NSString stringWithFormat:@"ID:%@",self.roomId];
        roomIdLabel.font = [UIFont systemFontOfSize:13];
        [roomIdLabel sizeToFit];
        CGRect rect = roomIdLabel.frame;
        rect.size.height = 24;
        roomIdLabel.frame = rect;
        CGFloat cx = ScreenWidth - 8 - roomIdLabel.frame.size.width / 2;
        CGFloat cy = CGRectGetMidY(self.roomInfoView.likeCountContainView.frame) + (IPHONEX ? 24 : 0) + 5;
        roomIdLabel.center = CGPointMake(cx, cy);
        [self addSubview:roomIdLabel];
        [roomIdLabel setTextColor:[UIColor lightGrayColor]];
    }
    
    //用户列表视图
    [self addSubview:self.userListView];
    self.userListView.center = CGPointMake(ScreenWidth - button.frame.size.width - 10 - self.userListView.frame.size.width / 2, button.center.y);
    
    CGFloat width = CGRectGetMinX(button.frame) - CGRectGetMaxX(self.roomInfoView.frame) - 16;
    CGRect rect = self.userListView.frame;
    rect.size.width = width;
    rect.origin.x = CGRectGetMaxX(self.roomInfoView.frame) + 8;
    self.userListView.frame = rect;
    
    //底部控制视图
    [self addSubview:self.controlView];
    cx = self.frame.size.width / 2;
    cy = self.frame.size.height - self.controlView.frame.size.height / 2 - (IPHONEX ? 34 : 0);
    self.controlView.center = CGPointMake(cx, cy);
    
    //消息列表视图
    [self addSubview:self.messageListView];
    cx = self.messageListView.frame.size.width/ 2;
    cy = self.frame.size.height - self.controlView.frame.size.height - self.messageListView.frame.size.height / 2;
    self.messageListView.center = CGPointMake(cx, cy - (IPHONEX ? 34 : 0));
    
    [self addSubview:self.enterView];
    self.enterView.frame = CGRectMake(self.messageListView.frame.origin.x, self.messageListView.frame.origin.y-28, self.frame.size.width, 28);
}

- (void)onCopyRoomId{
    // 将userId复制到剪切板
#if DEBUG
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = self.roomId;
    });
#endif
}

/**
 刷新主播视图
 
 @param host 主播
 */
- (void)refreshUIWithHost:(AlivcLiveUser *)host{
    [self.roomInfoView refreshUIWithHost:host];
}

/**
 刷新观众列表视图
 
 @param audiences 观众列表
 */
- (void)refreshUIWithAudiences:(NSArray <AlivcLiveUser *>*)audiences{
    [self.userListView refreshUIWithArray:audiences];
}

/**
 添加手势
 */
- (void)addGesture{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
}

/**
 添加通知
 */
- (void)addNotification{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [self addBackgroundNotifications];
}


/**
 获取全面的屏幕尺寸
 
 @return 全面的屏幕尺寸
 */
- (CGRect)getFullScreenFrame {
    
    CGRect frame = self.bounds;
    return frame;
}

- (CGRect)getSmallPlayRect{
    CGRect frame = self.bounds;
    CGFloat width = frame.size.width;
    CGFloat heigth = frame.size.height;
    frame.size.width *= 0.35;
    frame.size.height *= 0.35;
    frame.origin.x = width - frame.size.width - 10;
    frame.origin.y = heigth - frame.size.height - 100;
    return frame;
}


/**
 展示错误信息
 
 @param errCode 错误码
 */
- (void)showErrorMessageWithErrorCode:(int)errCode{
    NSString *errDes = [NSString stringWithFormat:@"error:%ld",(long)errCode];
    [MBProgressHUD showMessage:errDes inView:self];
}
//
///**
// 模拟用户列表
//
// @return 用户列表
// */
//- (NSArray <AlivcLiveUser *>*)simulationUser{
//    NSMutableArray *userArray = [[NSMutableArray alloc]init];
//    for (int i = 0; i < 10; i++) {
//        AlivcLiveUser *user = [[AlivcLiveUser alloc]init];
//        if (i % 2 == 0) {
//            user.avatar = [UIImage imageNamed:@"test_avator_boy"];
//        }else{
//            user.avatar = [UIImage imageNamed:@"test_avator_girl"];
//        }
//        user.nickname = [NSString stringWithFormat:@"模拟账号%ld",(long)i];
//        [userArray addObject:user];
//    }
//    return (NSArray *)userArray;
//
//}


/**
 根据userId返回user，如果没有，那么返回为空
 
 @param userId 用户id
 @return 返回对应用户id的自定义模型
 */
- (AlivcLiveUser *__nullable)findLiveUaserWithID:(NSString *)userId{
    if ([self.hostUser.userId isEqualToString:userId] ) {
        return self.hostUser;
    }
    for (AlivcLiveUser *user in self.userListView.userArray) {
        if ([user.userId isEqualToString:userId]) {
            return user;
        }
    }
    AlivcLiveUser *user = [[AlivcLiveUser alloc] init];
    user.userId = userId;
    return user;
}

/**
 新观众进来处理
 1.更新数据
 2.更新界面
 3.消息处理
 
 @param newUser 新进来的观众
 */
- (void)handleWhenEnterANewUser:(AlivcLiveUser *)newUser{
    
    __block BOOL isUpdateNume = YES;
    __weak typeof(self)ws = self;
    [self.userListView.userArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[AlivcLiveUser class]]) {
            AlivcLiveUser *tempUser = obj;
            if ([tempUser.userId isEqualToString:newUser.userId] ) {
                [ws.userListView kickoutAUser:tempUser];
                isUpdateNume = NO;
                *stop = YES;
            }
        }
    }];
    
    //更新人数
    if (isUpdateNume) {
        self.appRoomInfo.viewCount += 1;
    }
    [self.roomInfoView updateViewAudienceCount:self.appRoomInfo.viewCount];
    
    //更新观众列表
    [self.userListView insertAUser:newUser];
    
    //更新一条消息
    [self updateAMessageWithUser:newUser type:AlivcMessageTypeLogin commentString:nil];
}

/**
 观众离开
 1.更新数据
 2.更新界面
 3.消息处理
 @param aUser 离开的观众
 @param isKickout 是否被踢掉的
 */
- (void)handleWhenLeavedAUser:(AlivcLiveUser *)aUser isKickout:(BOOL)isKickout{
    //更新人数
    if (self.appRoomInfo.viewCount < 0) {
        self.appRoomInfo.viewCount = 0;
    }else{
        self.appRoomInfo.viewCount--;
    }
    
    [self.roomInfoView updateViewAudienceCount:self.appRoomInfo.viewCount];
    
    //更新观众列表
    [self.userListView kickoutAUser:aUser];
    
    //更新一条消息
    if (isKickout) {
        [self updateAMessageWithUser:aUser type:AlivcMessageTypeKickout commentString:nil];
    } else {
        [self updateAMessageWithUser:aUser type:AlivcMessageTypeLogout commentString:nil];
    }
}

- (void)handleWhenAUserLeaved:(NSString *)userId isKickout:(BOOL)isKickout{
    
    if(!userId) return;
    
    if (![NSThread currentThread].isMainThread) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self handleWhenAUserLeaved:userId isKickout:isKickout];
        });
        return;
    }
    
    if(isKickout){
        [self.kickoutUids addObject:userId];
        [self performSelector:@selector(removeKickoutUserId:) withObject:userId afterDelay:kKickOutDuration];
    }
    
    __block AlivcLiveUser *liveUser = nil;
    [self.userListView.userArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[AlivcLiveUser class]]) {
            AlivcLiveUser *tempUser = obj;
            if ([tempUser.userId isEqualToString:userId]) {
                liveUser = tempUser;
                *stop = YES;
            }
        }
    }];
    
    if (!liveUser) {
        __weak typeof(self)weakSelf = self;
        [AlivcUserInfoManager getUserInfoWithIds:userId success:^(NSArray<AlivcLiveUser *> * _Nonnull liveUsers) {
            if (liveUsers.count) {
                __strong typeof(weakSelf)strongSelf = weakSelf;
                AlivcLiveUser *user = [liveUsers firstObject];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [strongSelf handleWhenLeavedAUser:user isKickout:isKickout];
                });
            }
        } failure:^(NSString * _Nonnull errDes) {
            dispatch_async(dispatch_get_main_queue(), ^{
                __strong typeof(weakSelf)strongSelf = weakSelf;
                [MBProgressHUD showMessage:errDes inView:strongSelf];
            });
        }];
    }else{
        [self handleWhenLeavedAUser:liveUser isKickout:isKickout];
    }
}

- (NSArray<NSDictionary *> *)beautyDetailItems{
    AlivcBeautyParamsLevel level = [self getBeautyLevel];
    AlivcBeautyParams *params = [self getBeautyParamsOfLevel:level];
    AlivcBeautyParams *defaultParams = [AlivcBeautyParams defaultBeautyParamsWithLevel:level];
    
    NSArray<NSDictionary *> *detailItems =
    @[
      @{
          @"title":[@"Skin Polishing" localString],
          @"identifier":@"0",
          @"icon_name":@"ic_buffing",
          @"value":@(params.beautyBuffing),
          @"originalValue":@(defaultParams.beautyBuffing),
          @"minimumValue":@(0),
          @"maximumValue":@(100),
          },
      @{
          @"title":[@"Skin Whitening" localString],
          @"identifier":@"1",
          @"icon_name":@"ic_beauty_white",
          @"value":@(params.beautyWhite),
          @"originalValue":@(defaultParams.beautyWhite),
          @"minimumValue":@(0),
          @"maximumValue":@(100)
          },
      @{
          @"title":[@"Skin Shining" localString],
          @"identifier":@"2",
          @"icon_name":@"ic_Ruddy",
          @"value":@(params.beautyRuddy),
          @"originalValue":@(defaultParams.beautyRuddy),
          @"minimumValue":@(0),
          @"maximumValue":@(100)
          },
      @{
          @"title":[@"Chin Reducing" localString],
          @"identifier":@"3",
          @"icon_name":@"ic_shorface",
          @"value":@(params.beautyShortenFace),
          @"originalValue":@(defaultParams.beautyShortenFace),
          @"minimumValue":@(0),
          @"maximumValue":@(100)
          },
      @{
          @"title":[@"Eye Widening" localString],
          @"identifier":@"4",
          @"icon_name":@"ic_bigeye",
          @"value":@(params.beautyBigEye),
          @"originalValue":@(defaultParams.beautyBigEye),
          @"minimumValue":@(0),
          @"maximumValue":@(100)
          },
      @{
          @"title":[@"Face Slimming" localString],
          @"identifier":@"5",
          @"icon_name":@"ic_slimface",
          @"value":@(params.beautySlimFace),
          @"originalValue":@(defaultParams.beautySlimFace),
          @"minimumValue":@(0),
          @"maximumValue":@(100)
          },
      @{
          @"title":[@"beauty_cheekpink" localString],
          @"identifier":@"6",
          @"icon_name":@"ic_face_red",
          @"value":@(params.beautyRuddy),
          @"originalValue":@(defaultParams.beautyRuddy),
          @"minimumValue":@(0),
          @"maximumValue":@(100)
          }
      ];
    return detailItems;
}

- (void)showBeautifySettingPanel{
    if(!self.beautifySettingController){
        
        AlivcBeautyParamsLevel level = [self getBeautyLevel];
        NSArray<NSDictionary *> *detailItems = [self beautyDetailItems];
        self.beautifySettingController = [AlivcLiveBeautifySettingsViewController settingsViewControllerWithLevel:level detailItems:detailItems];
        __weak typeof(self)weakSelf = self;
        [self.beautifySettingController setDispearCompletion:^{
            __strong typeof(weakSelf)strongSelf = weakSelf;
            strongSelf.startLiveButton.hidden = NO;
            strongSelf.selectView.hidden = NO;
        }];
        self.beautifySettingController.delegate = self;
    }
    self.startLiveButton.hidden = YES;
    self.selectView.hidden = YES;
    [[self viewController] presentViewController:self.beautifySettingController animated:YES completion:nil];
}


/**
 更新一条消息
 
 @param type 消息类型
 @param userId 用户id
 @param commentString 消息体本身
 */
- (AlivcLiveUser *)updateMessageWithType:(AlivcMessageType)type userId:(NSString *)userId commentString:(NSString *__nullable)commentString{
    AlivcLiveUser *user = [self findLiveUaserWithID:userId];
    [self updateAMessageWithUser:user type:type commentString:commentString];
    return user;
}


/**
 主播下播，观众离开直播间，不管sdk返回什么样的值，都得退出，不能因为sdk的异常让用户或者主播无法退出房间
 
 @param isKickout 是否被踢出的
 */
- (void)leaveRoomIsKickout:(BOOL)isKickout{
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self]; // 取消所有perFormSelector
    
    [_reachability stopNotifier];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AliyunPVReachabilityChangedNotification object:nil];
    
    __weak typeof(self)weakSelf = self;
    [self.liveRoom quit:^(AlivcLiveError *error) {
        
        __strong typeof(weakSelf)strongSelf = weakSelf;
        if (!strongSelf) return;
        
        if (strongSelf.enterRoomFail == NO) {// 进房间失败后，不用调用leave
            // App server 观众离开房间
            [AlivcLiveRoomManager leaveRoomWithRoomId:strongSelf.roomId userId:strongSelf.userInfo.userId success:^{
                
                __strong typeof(weakSelf)strongSelf = weakSelf;
                if(strongSelf.role == AlivcLiveRoleAudience){
                    if (!isKickout) { // 如果不是踢出的话，则发送通知
                        [AlivcLiveRoomManager leaveRoomNotificationWithRoomID:strongSelf.roomId userId:strongSelf.userInfo.userId success:^{
                            
                        } failure:^(NSString *errString) {
                            
                        }];
                    }
                }
            } failure:^(NSString *errString) {
                
            }];
            
            if(strongSelf.role == AlivcLiveRoleHost){
                // 主播退出房间
                [AlivcLiveRoomManager endStreamingWithRoomID:strongSelf.roomId
                                                      userId:strongSelf.roomInfo.anchorAppUid
                                                     success:^{
                                                         
                                                     } failure:^(NSString *errString) {
                                                         
                                                     }];
            }
        }
        [strongSelf.liveRoom logout];
    }];
    
    
    if ([self.delegate respondsToSelector:@selector(haveleavedRoomView:isBeKickouted:)]) {
        [self.delegate haveleavedRoomView:self isBeKickouted:isKickout];
    }
}

/**
 返回当前的时间
 
 @return 当前的时间字符串
 */
+ (NSString *)currentDateString{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"HH:mm:ss.SSS";
    NSString *dateString = [formatter stringFromDate:date];
    return dateString;
}

- (AlivcBeautyParamsLevel)getBeautyLevel{
    
    NSString *beautyLevel = [[NSUserDefaults standardUserDefaults] objectForKey:@"beautyLevel"];
    if(beautyLevel){
        AlivcBeautyParamsLevel level = [[[NSUserDefaults standardUserDefaults] objectForKey:@"beautyLevel"] integerValue];
        return level;
    }
    return [AlivcBeautyParams defaultBeautyLevel];
}

- (void)saveBeautyLevel:(AlivcBeautyParamsLevel)level{
    
    [[NSUserDefaults standardUserDefaults] setObject:@(level).stringValue forKey:@"beautyLevel"];
}

- (void)saveParam:(NSInteger)count identifer:(NSString *)identifer level:(AlivcBeautyParamsLevel)level{
    
    if ([identifer isEqualToString:@"0"]) {
        
        [[NSUserDefaults standardUserDefaults]setObject:@(count).stringValue forKey:[@"beautyBuffing" stringByAppendingString:@(level).stringValue]];
        
    }else if ([identifer isEqualToString:@"1"]) {
        
        [[NSUserDefaults standardUserDefaults]setObject:@(count).stringValue forKey:[@"beautyWhite" stringByAppendingString:@(level).stringValue]];
    }else if ([identifer isEqualToString:@"2"]) {
        
        [[NSUserDefaults standardUserDefaults]setObject:@(count).stringValue forKey:[@"beautyRuddy" stringByAppendingString:@(level).stringValue]];
    }else if ([identifer isEqualToString:@"3"]) {
        
        [[NSUserDefaults standardUserDefaults]setObject:@(count).stringValue forKey:[@"beautyShortenFace" stringByAppendingString:@(level).stringValue]];
    }else if ([identifer isEqualToString:@"4"]) {
        
        [[NSUserDefaults standardUserDefaults]setObject:@(count).stringValue forKey:[@"beautyBigEye" stringByAppendingString:@(level).stringValue]];
    }else if ([identifer isEqualToString:@"5"]) {
        
        [[NSUserDefaults standardUserDefaults]setObject:@(count).stringValue forKey:[@"beautySlimFace" stringByAppendingString:@(level).stringValue]];
    }else if ([identifer isEqualToString:@"6"]){
        
        [[NSUserDefaults standardUserDefaults]setObject:@(count).stringValue forKey:[@"beautyCheekPink" stringByAppendingString:@(level).stringValue]];
    }
}

- (void)saveBeautyParams:(AlivcBeautyParams *)beautyParams level:(AlivcBeautyParamsLevel)level{
    
    NSString *beautyWhite = [NSString stringWithFormat:@"%ld",(long)beautyParams.beautyWhite];
    [[NSUserDefaults standardUserDefaults]setObject:beautyWhite forKey:[@"beautyWhite" stringByAppendingString:@(level).stringValue]];
    
    NSString *beautyBuffing = [NSString stringWithFormat:@"%ld",(long)beautyParams.beautyBuffing];
    [[NSUserDefaults standardUserDefaults]setObject:beautyBuffing forKey:[@"beautyBuffing" stringByAppendingString:@(level).stringValue]];
    
    NSString *beautyRuddy = [NSString stringWithFormat:@"%ld",(long)beautyParams.beautyRuddy];
    [[NSUserDefaults standardUserDefaults]setObject:beautyRuddy forKey:[@"beautyRuddy" stringByAppendingString:@(level).stringValue]];
    
    NSString *beautySlimFace = [NSString stringWithFormat:@"%ld",(long)beautyParams.beautySlimFace];
    [[NSUserDefaults standardUserDefaults]setObject:beautySlimFace forKey:[@"beautySlimFace" stringByAppendingString:@(level).stringValue]];
    
    NSString *beautyShortenFace = [NSString stringWithFormat:@"%ld",(long)beautyParams.beautyShortenFace];
    [[NSUserDefaults standardUserDefaults]setObject:beautyShortenFace forKey:[@"beautyShortenFace" stringByAppendingString:@(level).stringValue]];
    
    NSString *beautyBigEye = [NSString stringWithFormat:@"%ld",(long)beautyParams.beautyBigEye];
    [[NSUserDefaults standardUserDefaults]setObject:beautyBigEye forKey:[@"beautyBigEye" stringByAppendingString:@(level).stringValue]];
    
    NSString *beautyCheekPink = [NSString stringWithFormat:@"%ld",(long)beautyParams.beautyCheekPink];
    [[NSUserDefaults standardUserDefaults]setObject:beautyCheekPink forKey:[@"beautyCheekPink" stringByAppendingString:@(level).stringValue]];
}

- (AlivcBeautyParams *)getBeautyParamsOfLevel:(AlivcBeautyParamsLevel)level{
    AlivcBeautyParams *parames = [[AlivcBeautyParams alloc]init];
    
    NSString *beautyWhiteStr = [[NSUserDefaults standardUserDefaults]objectForKey:[@"beautyWhite" stringByAppendingString:@(level).stringValue]];
    if (!beautyWhiteStr) { //说明还没有存储过，取默认值
        parames = [AlivcBeautyParams defaultBeautyParamsWithLevel:level];
        [self saveBeautyParams:parames level:level]; // 做一次存储
        return parames;
    }
    
    int beautyWhite= [beautyWhiteStr intValue];
    parames.beautyWhite = beautyWhite;
    
    int beautyBuffing= [[[NSUserDefaults standardUserDefaults]objectForKey:[@"beautyBuffing" stringByAppendingString:@(level).stringValue]]intValue];
    parames.beautyBuffing = beautyBuffing;
    
    int beautyRuddy= [[[NSUserDefaults standardUserDefaults]objectForKey:[@"beautyRuddy" stringByAppendingString:@(level).stringValue]]intValue];
    parames.beautyRuddy = beautyRuddy;
    
    int beautyCheekPink= [[[NSUserDefaults standardUserDefaults]objectForKey:[@"beautyCheekPink" stringByAppendingString:@(level).stringValue]]intValue];
    parames.beautyCheekPink = beautyCheekPink;
    
    int beautySlimFace= [[[NSUserDefaults standardUserDefaults]objectForKey:[@"beautySlimFace" stringByAppendingString:@(level).stringValue]]intValue];
    parames.beautySlimFace = beautySlimFace;
    
    int beautyShortenFace= [[[NSUserDefaults standardUserDefaults]objectForKey:[@"beautyShortenFace" stringByAppendingString:@(level).stringValue]]intValue];
    parames.beautyShortenFace = beautyShortenFace;
    
    int beautyBigEye= [[[NSUserDefaults standardUserDefaults]objectForKey:[@"beautyBigEye" stringByAppendingString:@(level).stringValue]]intValue];
    parames.beautyBigEye = beautyBigEye;
    
    return parames;
}

#pragma mark - Json Content

/**
 生成json字符串
 
 @param userId 用户id
 @param name 名称
 @param content 内容
 @param type 类型
 @return json字符串
 */
- (NSString *)jsonStringWithUserId:(NSString *)userId nickname:(NSString *)name content:(NSString *)content type:(AlivcMessageType)type{
    NSMutableDictionary *jsonDic = [[NSMutableDictionary alloc]init];
    if (userId) {
        [jsonDic setObject:userId forKey:@"userId"];
    }
    if (name) {
        [jsonDic setObject:name forKey:@"sendName"];
    }
    if (content) {
        [jsonDic setObject:content forKey:@"dataContent"];
    }
    NSString *typeString = [NSString stringWithFormat:@"%ld",(long)type];
    if (typeString) {
        [jsonDic setObject:typeString forKey:@"type"];
    }
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDic options:NSJSONWritingPrettyPrinted error:&error];
    if (jsonData) {
        NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        return jsonString;
    }
    return nil;
}

/**
 处理json字符串
 
 @param jsonString josn字符串
 @param sucess 成功
 @param failure 失败
 */
- (void)handleJsonString:(NSString *)jsonString sucess:(void (^)(NSString *userId, NSString *name, NSString *content,AlivcMessageType type))sucess failure:(void (^)(NSString *errString))failure{
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    if (error) {
        failure(error.description);
    }else if([jsonDic isKindOfClass:[NSDictionary class]]){
        NSString *userId = jsonDic[@"userId"];
        NSString *name = jsonDic[@"sendName"];
        NSString *content = jsonDic[@"dataContent"];
        NSString *typeString = jsonDic[@"type"];
        sucess(userId,name,content,typeString.integerValue);
    }else{
        if (failure) {
            failure([@"parsing_error" localString]);
        }
    }
}
#pragma mark - Response

/**
 键盘将会弹起的处理
 
 @param notification notification
 */
- (void)keyboardWillShow:(NSNotification *)notification{
    
    //添加自定义的输入框，调整位置
    NSDictionary *userInfo = notification.userInfo;
    CGRect frame = [userInfo[UIKeyboardFrameEndUserInfoKey]CGRectValue];//键盘的最终位置
    CGFloat cy = frame.origin.y - self.messageInputView.frame.size.height / 2;
    CGFloat cx = [UIScreen mainScreen].bounds.size.width / 2;
    self.messageInputView.hidden = false;
    [UIView animateWithDuration:0.3 animations:^{
        self.messageInputView.center = CGPointMake(cx, cy);
    }];
}

/**
 键盘将要隐藏的处理
 
 @param notification notification
 */
- (void)keyboardWillHide:(NSNotification *)notification{
    _messageInputView.hidden = true;
    [self.messageInputView removeFromSuperview];
    self.messageInputView = nil;
}

/**
 手势处理
 
 @param gesture gesture
 */
- (void)tapGesture:(UITapGestureRecognizer *)gesture{
    
    [self.messageInputView.textView resignFirstResponder];
}


- (UIViewController *)viewController{
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

/**
 开始直播
 */
- (void)startButtonTouched:(UIButton *)sender{
    
    AlivcLiveRole *role = [[AlivcLiveRole alloc]initWithType:self.role];
    
    __weak typeof(self)weakSelf = self;
    [self.liveRoom enter:self.roomId user:self.userInfo role:role completion:^(AlivcLiveError *error, AlivcLiveRoomInfo *liveRoomInfo) {
        
        __strong typeof(weakSelf)strongSelf = weakSelf;
        if(!strongSelf) return;
        if(error && error.errorCode != ALIVC_RETURN_SUCCESS) {
            [strongSelf onAlivcInteractiveLiveRoomErrorCode:error.errorCode errorDetail:error.errorDescription];
            return;
        }
        strongSelf.roomInfo = liveRoomInfo;
        dispatch_async(dispatch_get_main_queue(), ^{
            //查询基本信息
            [MBProgressHUD showMessage:[@"Enter Stream Room" localString] inView:strongSelf];
        });
        NSString *anchorAppUid = liveRoomInfo.anchorAppUid;
        
        // appSever 加入房间
        [AlivcLiveRoomManager joinRoomWithRoomId:strongSelf.roomId
                                          hostId:liveRoomInfo.anchorAppUid
                                        audience:strongSelf.userInfo.userId success:^{
                                            
                                        } failure:^(NSString *errString) {
                                            
                                        }];
        
        // 主播成功开播
        [AlivcLiveRoomManager startStreamingWithRoomID:strongSelf.roomId
                                                userId:liveRoomInfo.anchorAppUid
                                               success:^{
                                                   
                                               } failure:^(NSString *errString) {
                                                   
                                               }];
        
        // 此时最多只显示另外一路流
        [liveRoomInfo.playInfosDic enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, AlivcPlayInfo * _Nonnull obj, BOOL * _Nonnull stop) {
            
            if(![key isEqualToString:anchorAppUid]){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [strongSelf.liveRoom setRemoteView:strongSelf.subPlayView micAppUid:key];
                    [strongSelf addSubview:strongSelf.subPlayView];
                });
                *stop = YES;
            }
        }];
        
    }];
    
    [self.liveRoom getLikeCount:^(AlivcLiveError *error, NSUInteger count) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        if (!strongSelf) return;
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf.roomInfoView updateLikeCount:count];
        });
    }];
}

/**
 离开直播间
 */
- (void)closeButtonTouched{
    [self leaveRoomIsKickout:false];
}



#pragma mark - 退后台停止推流的实现方案

- (void)addBackgroundNotifications {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillResignActive:)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
}


- (void)applicationWillResignActive:(NSNotification *)notification {
    
    if (!self.liveRoom) {
        return;
    }
    [self.liveRoom pause];
}

- (void)applicationDidBecomeActive:(NSNotification *)notification {
    
    if (!self.liveRoom) {
        return;
    }
    [self.liveRoom resume];
}


- (void)publisherOnClickedZoom:(CGFloat)zoom {
    
    if (self.liveRoom) {
        CGFloat max = [self.liveRoom getMaxZoom];
        [self.liveRoom setZoom:MIN(zoom, max)];
    }
}


- (void)publisherOnClickedFocus:(CGPoint)focusPoint {
    
    if (self.liveRoom) {
        [self.liveRoom focusCameraAtPoint:focusPoint needAutoFocus:YES];
    }
}

#pragma mark - System Delegate ------------
#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isKindOfClass:[UIButton class]] || [NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
}

#pragma mark - CustomView Delegate -------------------

#pragma mark - AlivcHostPreSelectLiveQualityViewDelegate
- (void)hostPreSelectLiveQualityView:(AlivcHostPreSelectLiveQualityView *)view haveSelectQuality:(AlivcLiveQuality)quality{
    switch (quality) {
        case AlivcLiveQualityHD:
            
            [self.liveRoom setResolution:AlivcLivePushResolution720P];
            NSLog(@"超清");
            break;
        case AlivcLiveQualitySD:
            [self.liveRoom setResolution:AlivcLivePushResolution720P];
            NSLog(@"高清");
            break;
        case AlivcLiveQualityLD:
            [self.liveRoom setResolution:AlivcLivePushResolution540P];
            NSLog(@"标清");
            break;
        case AlivcLiveQualityFD:
            [self.liveRoom setResolution:AlivcLivePushResolution360P];
            NSLog(@"流畅");
            break;
            
        default:
            break;
    }
}

#pragma mark - AlivcUserInfoListViewDelegate
- (void)userInfoListView:(AlivcUserInfoListView *)view touchUpInSideWith:(AlivcLiveUser *)touchUser{
    [self showOperateViewWithUser:touchUser];
}

#pragma mark - AlivcMessageListViewDelegate

- (void)messageListView:(AlivcMessageListView *)view message:(AlivcMessage *)message touchedWithUserId:(NSString *)userId{
    AlivcLiveUser *user = [self findLiveUaserWithID:userId];
    [self showOperateViewWithUser:user];
}

#pragma mark - AlivcRoomInfoViewDelegate
- (void)roomInfoView:(AlivcRoomInfoView *)view hostTouched:(AlivcLiveUser *)host{
    [self showOperateViewWithUser:host];
}

#pragma mark - AlivcOperateUserViewDelegate
- (void)operateUserView:(AlivcOperateUserView *)view user:(AlivcLiveUser *)user operateType:(AlivcOperateUserType)operateType{
    if (user.userId == nil) {
        [MBProgressHUD showMessage:[@"left_room" localString] inView:self];
        return;
    }else if([self.kickoutUids containsObject:user.userId]){
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD showMessage:[@"kickout_tip" localString] inView:self];
        });
        return;
    }
    
    __weak typeof(self)weakSelf = self;
    switch (operateType) {
        case AlivcOperateUserTypeSilent:
            
            break;
        case AlivcOperateUserTypeKickout:
            
            if (user.kickedout) {
                user.kickedout = NO;
                view.kickoutButton.selected = NO;
                [self.liveRoom cancelKickout:user.userId completion:^(AlivcLiveError *error) {
                    if(error && error.errorCode == ALIVC_RETURN_SUCCESS){
                        [MBProgressHUD showMessage:[@"relive_kickout_success" localString] inView:weakSelf];
                        view.kickoutButton.selected = NO;
                    }else{
                        user.kickedout = YES;
                        view.kickoutButton.selected = YES;
                        [MBProgressHUD showMessage:error.errorDescription inView:weakSelf];
                    }
                }];
            }else{
                user.kickedout = YES;
                view.kickoutButton.selected = YES;
                [self.liveRoom kickout:user.userId userData:[@"inappropriate_words" localString] duration:kKickOutDuration completion:^(AlivcLiveError *error) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if(error && error.errorCode == ALIVC_RETURN_SUCCESS){
                            [MBProgressHUD showMessage:[@"kickout_success" localString] inView:weakSelf];
                            view.kickoutButton.selected = YES;
                            [weakSelf.operateView dismiss];
                            [weakSelf.userListView.userArray enumerateObjectsUsingBlock:^(AlivcLiveUser * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                if ([obj.userId isEqualToString:user.userId]) {
                                    [weakSelf.userListView kickoutAUser:obj];
                                    *stop = YES;
                                }
                            }];
                        }else{
                            user.kickedout = NO;
                            view.kickoutButton.selected = NO;
                            [MBProgressHUD showMessage:error.errorDescription inView:weakSelf];
                        }
                    });
                }];
            }
            break;
        case AlivcOperateUserTypeBlacklist:
            
            break;
            
        default:
            break;
    }
    
}

- (void)cancelOperateUserView:(AlivcOperateUserView *)view{
    [self.operateView dismiss];
}

#pragma mark - AlivcControlViewDelegate

- (void)controlView:(AlivcControlView *)view buttonTouched:(AlivcControlEventButton *)eventButton{
    switch (eventButton.event) {
        case AlivcLiveControlEventMessage:
            [self messageEventHandle];
            break;
        case AlivcLiveControlEventBeauty:
            [self beautyEventHandle];
            break;
        case AlivcLiveControlEventCamera:
            [self cameraEventHandle];
            break;
        case AlivcLiveControlEventLight:
            [self lightEventHandle:eventButton];
            break;
        case AlivcLiveControlEventMicrophone:
            [self microphoneEventHandle:eventButton];
            break;
        case AlivcLiveControlEventMusic:
            [self musicEventHandle];
            break;
        case AlivcLiveControlEventLike:
            [self likeEventHandle];
            break;
    }
}


/**
 消息按钮事件处理
 */
- (void)messageEventHandle{
    
    //弹起键盘
    if (_messageInputView == nil || !_messageInputView.superview) {
        self.messageInputView.hidden = true;
        [self addSubview:self.messageInputView];
    }
    [self.messageInputView.textView becomeFirstResponder];
}

/**
 美颜事件处理
 */
- (void)beautyEventHandle{
    
    [self showBeautifySettingPanel];
    if (self.liveRoom) {
        AlivcBeautyParams *params = [self getBeautyParamsOfLevel:[self getBeautyLevel]];
        [self.liveRoom setBeautyParams:params];
    }
}

/**
 相机事件处理
 */
- (void)cameraEventHandle{
    
    [self.liveRoom switchCamera];
    self.cameraIsPreposition = !self.cameraIsPreposition;
    [self.controlView setLightingEnable:!self.cameraIsPreposition];
}

/**
 闪光灯事件处理
 */
- (void)lightEventHandle:(AlivcControlEventButton *)button{
    if(self.cameraIsPreposition){
        [MBProgressHUD showMessage:[@"Please switch to the rear camera first" localString] inView:self];
    }else{
        button.selected = !button.selected;
        if (button.selected) {
            [self.liveRoom setFlash:true];
            
        }else{
            [self.liveRoom setFlash:false];
        }
    }
    
}

/**
 麦克风事件处理
 */
- (void)microphoneEventHandle:(AlivcControlEventButton *)button{
    button.selected = !button.selected;
    if (button.selected) {
        [self.liveRoom setMute:true];
        [MBProgressHUD showMessage:[@"Microphone Off" localString] inView:self];
    }else{
        [self.liveRoom setMute:false];
        [MBProgressHUD showMessage:[@"Microphone On" localString] inView:self];
    }
}

/**
 音乐事件处理
 */
- (void)musicEventHandle{
    NSLog(@"音乐");
    [MBProgressHUD showMessage:[@"Function is developing" localString] inView:self];
}


/**
 点赞事件处理
 */
static int KONCE_COUNT = 0;
- (void)likeEventHandle{
    
    XTLoveHeartView *heart = [[XTLoveHeartView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    
    [self addSubview:heart];
    CGPoint fountainSource = CGPointMake(self.frame.size.width - 30, self.bounds.size.height - 30 / 2.0 - 10);
    heart.center = fountainSource;
    [heart animateInView:self];
    self.tempMessageType = AlivcMessageTypeLike;
    KONCE_COUNT++;
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(sendLikeWithCount) object:nil];
    [self performSelector:@selector(sendLikeWithCount) withObject:nil afterDelay:1.f];
}

- (void)sendLikeWithCount{
    __weak typeof(self)weakSelf = self;
    NSInteger count = KONCE_COUNT;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self.liveRoom sendLikeWithCount:count completion:^(AlivcLiveError *error) {
            if(error && error.errorCode == ALIVC_RETURN_SUCCESS){
                __strong typeof(weakSelf)strongSelf = weakSelf;
                if (!strongSelf) return;
                kLIKE_COUNT = count;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [strongSelf.roomInfoView increasedLikeCount:count];
                });
            }
        }];
    });
    KONCE_COUNT = 0;
}



#pragma mark - AlivcMessageInputViewDelegate

- (void)messageInputView:(AlivcMessageInputView *)view sendMessage:(NSString *)message{
    NSLog(@"发送消息:%@",message);
    
    NSString *avater = [AlivcProfile shareInstance].avatarUrlString ?:@"";
    NSDictionary *object = @{
                             @"avatar":avater?:@"",
                             @"user_id":[AlivcProfile shareInstance].userId,
                             @"nick_name":[AlivcProfile shareInstance].nickname
                             };
    
    __weak typeof(self)weakSelf = self;
    [self.liveRoom sendChatMessage:message userData:[AlivcStringConvertTool convertToJsonData:object] completion:^(AlivcLiveError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(error.errorDescription){
                [MBProgressHUD showMessage:error.errorDescription inView:weakSelf];
            }
        });
    }];
    self.tempMessage = message;
    self.tempMessageType = AlivcMessageTypeChat;
}
//#pragma mark - AlivcMusicViewDelegate
//
//- (void)musicOnClickPlayButton:(BOOL)isPlay musicPath:(NSString *)musicPath {
//
//    if (self.liveRoom) {
//        if (isPlay) {
//            [self.liveRoom startBGMAsyncWithPath:musicPath];
//        } else {
//            [self.liveRoom stopBGMAsync];
//        }
//    }
//}
//
//- (void)musicOnClickPauseButton:(BOOL)isPause {
//
//    if (self.liveRoom) {
//        if (isPause) {
//            [self.liveRoom pauseBGM];
//        } else {
//            [self.liveRoom resumeBGM];
//        }
//    }
//}
//
//
//- (void)musicOnClickLoopButton:(BOOL)isLoop {
//
//    if (self.liveRoom) {
//        [self.liveRoom setBGMLoop:isLoop?true:false];
//    }
//}
//
//
//- (void)musicOnClickDenoiseButton:(BOOL)isDenoiseOpen {
//
//    if (self.liveRoom) {
//        [self.liveRoom setAudioDenoise:isDenoiseOpen];
//    }
//}
//
//- (void)musicOnClickMuteButton:(BOOL)isMute {
//
//    if (self.liveRoom) {
//        [self.liveRoom setMute:isMute?true:false];
//    }
//}
//
//- (void)musicOnClickEarBackButton:(BOOL)isEarBack {
//
//    if (self.liveRoom) {
//        [self.liveRoom setBGMEarsBack:isEarBack?true:false];
//    }
//}
//
//- (void)musicOnSliderAccompanyValueChanged:(int)value {
//
//    if (self.liveRoom) {
//        [self.liveRoom setBGMVolume:value];
//    }
//}
//
//- (void)musicOnSliderVoiceValueChanged:(int)value {
//
//    if (self.liveRoom) {
//        [self.liveRoom setCaptureVolume:value];
//    }
//}

#pragma mark - AlivcLiveBeautifySettingsViewControllerDelegate

- (void)settingsViewController:(AlivcLiveBeautifySettingsViewController *)viewController didChangeLevel:(NSInteger)level{
    [self saveBeautyLevel:level];
    
    [viewController updateDetailItems:[self beautyDetailItems]];
    
    AlivcBeautyParams *params = [self getBeautyParamsOfLevel:level];
    if (self.liveRoom) {
        [self.liveRoom setBeautyParams:params];
    }
}

- (void)settingsViewController:(AlivcLiveBeautifySettingsViewController *)viewController didChangeValue:(NSDictionary *)info{
    
    [self saveParam:[info[@"value"] integerValue] identifer:info[@"identifier"] level:[self getBeautyLevel]];
    AlivcBeautyParams *params = [self getBeautyParamsOfLevel:[self getBeautyLevel]];
    if (self.liveRoom) {
        [self.liveRoom setBeautyParams:params];
    }
}


#pragma mark - SDK Delegate ----------------------
#pragma mark - AlivcLiveRoomPusherNotifyDelegate

- (void)onAlivcPusherPreviewStarted {
    
    NSLog(@"onAlivcPusherPreviewStarted");
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.roomId) {
            if (self.role == AlivcLiveRoleHost) {
                //开始按钮
                UIButton *startButton = [UIButton buttonWithType:UIButtonTypeCustom];
                self.startLiveButton = startButton;
                startButton.frame = CGRectMake(0.5 * (self.hostPreView.frame.size.width - 180), self.hostPreView.frame.size.height - 44 - 64 - (IPHONEX ? 24 : 0), 180, 44);
                
                UIImage *image = [AlivcLiveRoomView createImageWithColor:[AlivcUIConfig shared].kAVCThemeColor
                                                                    size:CGSizeMake(180, 44)];
                [startButton setBackgroundImage:image forState:UIControlStateNormal];
                [startButton setTitle:[@"Start Streaming" localString] forState:UIControlStateNormal];
                [startButton addTarget:self action:@selector(startButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
                startButton.layer.cornerRadius = 5;
                startButton.titleLabel.font = [UIFont systemFontOfSize:16];
                startButton.clipsToBounds = true;
                [self.hostPreView addSubview:startButton];
                //清晰度
                AlivcHostPreSelectLiveQualityView *selectView = [[AlivcHostPreSelectLiveQualityView alloc]init];
                self.selectView = selectView;
                selectView.delegate = self;
                selectView.center = CGPointMake(self.hostPreView.bounds.size.width * 0.5, self.hostPreView.bounds.size.height - 32 - (IPHONEX ? 34 : 0));
                [self.hostPreView addSubview:selectView];
            }
            
        }
    });
}

- (void)onAlivcPusherPreviewStopped {
    NSLog(@"onAlivcPusherPreviewStopped");
}

- (void)onAlivcPusherFirstFramePreviewed {
    
    NSLog(@"onAlivcPusherFirstFramePreviewed");
    NSLog(@"onAlivcPusherFirstFramePreviewed时间:%@",[AlivcLiveRoomView currentDateString]);
    
}

- (void)onAlivcPusherPushStarted {
    
    NSLog(@"onAlivcPusherPushStarted回调");
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD showMessage:@"观众已经能看到你了哦" inView:self];
        //防止息屏
        [[UIApplication sharedApplication]setIdleTimerDisabled:true];
        [self creatBaseUI];
    });
    
}

- (void)onAlivcPusherPushPauesed {
    
    NSLog(@"onAlivcPusherPushPauesed回调");
}

- (void)onAlivcPusherPushResumed {
    NSLog(@"onAlivcPusherPushResumed回调");
}

- (void)onAlivcPusherPushStopped {
    NSLog(@"onAlivcPusherPushStopped回调");
}

- (NSString *)onAlivcPusherURLAuthenticationAboutToExpire{
    
    NSLog(@"onAlivcPusherURLAuthenticationAboutToExpire回调");
    
    __weak typeof(self)weakSelf = self;
    [AlivcLiveRoomManager stsWithAppUid:self.userInfo.userId success:^(AlivcSts *sts) {
        
        __strong typeof(weakSelf)strongSelf = weakSelf;
        if (!strongSelf) return;
        strongSelf.stsToken = sts;
        [strongSelf.liveRoom  refreshSts:sts];
        
    } failure:^(NSString *errString) {
        
    }];
    return nil;
}

#pragma mark - AlivcLiveRoomNetworkNotifyDelegate

- (void)onAlivcLiveRoomNetworkPoor {
    NSLog(@"onAlivcLiveRoomNetworkPoor回调");
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD showMessage:[@"network_poor" localString] inView:self];
    });
}

- (void)onAlivcLiveRoomConnectRecovery {
    NSLog(@"onAlivcLiveRoomConnectRecovery回调");
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD showMessage:@"reconnect recovery" inView:self];
    });
    
}

- (void)onAlivcLiveRoomReconnectStart {
    NSLog(@"onAlivcLiveRoomReconnectStart回调");
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD showMessage:@"reconnect start" inView:self];
    });
    
}

- (void)onAlivcLiveRoomReconnectSuccess {
    NSLog(@"onAlivcLiveRoomReconnectSuccess回调");
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD showMessage:@"reconnect success" inView:self];
    });
    
}



#pragma mark - AlivcInteractiveNotifyDelegate

//- (void)onAlivcInteractiveForbidChat:(AlivcInteractiveWidget *)widget userId:(NSString *)userId expirationTime:(long )expirationTime {
//
//    __weak typeof(self)ws = self;
//    [AlivcUserInfoManager getUserInfoWithIds:userId success:^(NSArray<AlivcLiveUser *> * _Nonnull liveUsers) {
//        AlivcLiveUser *user = liveUsers.firstObject;
//        AlivcMessage *message = [[AlivcMessage alloc]initWitUserId:user.userId nickname:user.nickname content:@"" type:AlivcMessageTypeForbidSendMsg];
//        [ws.messageListView updateAMessage:message];
//
//    } failure:^(NSString * _Nonnull errDes) {
//
//    }];
//}

//- (void)onAlivcInteractiveAllowChat:(AlivcInteractiveWidget *)widget userId:(NSString *)userId {

//    if ([userId isEqualToString:self.userInfo.userId]) {
//        [MBProgressHUD showMessage:@"您现在可以发言了" inView:self];
//    }
//    __weak typeof(self)ws = self;
//    [AlivcUserInfoManager getUserInfoWithIds:userId success:^(NSArray<AlivcLiveUser *> * _Nonnull liveUsers) {
//        AlivcLiveUser *user = liveUsers.firstObject;
//        AlivcMessage *message = [[AlivcMessage alloc]initWitUserId:user.userId nickname:user.nickname content:@"" type:AlivcMessageTypeAllowSendMsg];
//        [ws.messageListView updateAMessage:message];
//
//    } failure:^(NSString * _Nonnull errDes) {
//
//    }];
//}

//- (void)onNotifyForbidAllSendMessage:(AlivcInteractiveWidget *)widget expirationTime:(long )expirationTime {
//
//}
//
//- (void)onNotifyAllowAllSendMessage:(AlivcInteractiveWidget *)widget {
//
//}

- (void)onAlivcInteractiveChatMsg:(AlivcInteractiveWidget *)widget userId:(NSString *)userId content:(NSString *)content userData:(NSString *)userData {
    
    NSDictionary *dict = [AlivcStringConvertTool dictionaryWithJsonString:[AlivcStringConvertTool textFromBase64String:userData]];
    AlivcLiveUser *user = [[AlivcLiveUser alloc] init];
    user.userId = userId;
    user.nickname = dict[@"nick_name"];
    [self updateAMessageWithUser:user type:AlivcMessageTypeChat commentString:content];
}


- (void)onAlivcInteractiveLikeMsg:(AlivcInteractiveWidget *)widget count:(NSInteger )likeCount {
    
    if (likeCount >= kLIKE_COUNT) {
        likeCount = likeCount -  kLIKE_COUNT;
        kLIKE_COUNT = 0;
    }else{
        kLIKE_COUNT = kLIKE_COUNT - likeCount;
        likeCount = 0;
        return;
    }
    if(likeCount > 0){
        [_roomInfoView increasedLikeCount:likeCount];
        [[AlivcLikeBox sharedManager] addLikeCount:likeCount inView:self];
    }
}


#pragma mark - AlivcLiveRoomNotifyDelegate

/*主播流变更（有流）消息*/
- (void)onAlivcRoomBroadcastStart {
    
    NSLog(@"onAlivcRoomBroadcastStart 直播");
}

/*主播流变更（无流）消息*/
- (void)onAlivcRoomBroadcastStop {
    
    
}

/*用户进入房间消息*/
- (void)onAlivcRoomUserLogin:(NSString *)userId userData:(NSDictionary *)userData{
    
    if ([userId isEqualToString:self.hostUser.userId]) {
        return;
    }
    
    NSDictionary *userInfo = [userData objectForKey:@"user_info"];
    NSString *welcome = [userInfo objectForKey:@"nick_name"];
    [_enterView welcomeBossEnterLiveRoom:welcome];
    AlivcLiveUser *newUser = [[AlivcLiveUser alloc] initWithDic:userInfo];
    
    [self handleWhenEnterANewUser:newUser];
}

/*用户退出房间消息*/
- (void)onAlivcRoomUserLogout:(NSString *)userId userData:(NSDictionary *)userData{
    
    [self handleWhenAUserLeaved:userId isKickout:NO];
}


/*用户上麦消息*/
- (void)onAlivcRoomUpMic:(NSString *)userId {
    // sdk内部会做播放处理
    if ([userId isEqualToString:self.roomInfo.anchorAppUid]) {
        [self.liveRoom setRemoteView:self.playView micAppUid:userId];
        [MBProgressHUD showMessage:[@"host_enter_room" localString] inView:self];
    }else{
        [self.liveRoom setRemoteView:self.subPlayView micAppUid:userId];
        [self addSubview:self.subPlayView];
    }
}


/*用户下麦消息*/
- (void)onAlivcRoomDownMic:(NSString *)userId {
    
    if ([userId isEqualToString:self.roomInfo.anchorAppUid]) {
        
        if (self.closeCompletion) {
            self.closeCompletion([@"host_leave_room" localString]);
        }
        if(![self.userInfo.userId isEqualToString:userId]){//如果当前用户不是主播，则退出房间
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:[@"tips" localString] message:[@"live_ended" localString] delegate:self cancelButtonTitle:nil otherButtonTitles:[@"it_is_ok" localString], nil];
            [alertView show];
        }
        
    }else{
        [self.subPlayView removeFromSuperview];
    }
}


/*用户被踢出房间下行消息*/
- (void)onAlivcRoomKickOutUserId:(NSString *)userId {
    if ([userId isEqualToString:self.userInfo.userId]) {
        [self leaveRoomIsKickout:YES]; //是自己，离开
    }else{
        [self handleWhenAUserLeaved:userId isKickout:YES];
    }
}


/*禁播下行消息*/
- (void)onAlivcRoomForbidPushStream:(NSString *)userData {
    if (userData) {
        [MBProgressHUD showMessage:userData inView:self];
    }
    [self.liveRoom stopPreview];
}

#pragma mark - AlivcInteractiveLiveRoomErrorDelegate

- (void)onAlivcInteractiveLiveRoomErrorCode:(NSInteger)errorCode errorDetail:(NSString *)errorDetail {
    
    NSString *lowerErroDetail = [errorDetail lowercaseString];
    if ([lowerErroDetail containsString:@"key"] ||
        [lowerErroDetail containsString:@"tokken"] ||
        [lowerErroDetail containsString:@"expired"] ||
        [lowerErroDetail containsString:@"Specified"]) {
        
        __weak typeof(self)weakSelf = self;
        [AlivcLiveRoomManager stsWithAppUid:self.userInfo.userId success:^(AlivcSts *sts) {
            __strong typeof(weakSelf)strongSelf = weakSelf;
            if (!strongSelf) return;
            strongSelf.stsToken = sts;
            [strongSelf.liveRoom  refreshSts:sts];
            
        } failure:^(NSString *errString) {
            
        }];
    }else if([errorDetail isEqualToString:@"The specified UID is not authorized to enter room"] || [errorDetail containsString:@"not authorized to enter"]){
        self.enterRoomFail = YES;
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:[@"tips" localString] message:[@"you_removed" localString] delegate:self cancelButtonTitle:nil otherButtonTitles:[@"it_is_ok" localString], nil];
        [alertView show];
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *err = [NSString stringWithFormat:@"AlivcInteractiveLiveRoom error:%ld %@",(long)errorCode, errorDetail?:@""];
        [MBProgressHUD showMessage:err inView:self];
    });
}


#pragma mark - AlivcLiveRoomPlayerNotifyDelegate

- (void)onAlivcPlayerStarted {
    
    NSLog(@"onPlayerStarted时间:%@",[AlivcLiveRoomView currentDateString]);
    //防止息屏
    [[UIApplication sharedApplication]setIdleTimerDisabled:true];
}


- (void)onAlivcPlayerStopped {
    NSLog(@"onPlayerStopped");
}

- (void)onAlivcPlayerFinished {
    NSLog(@"onAlivcPlayerFinished");
}


#pragma mark - AlivcInteractiveAuthDelegate

- (void)onStsWillBeExpireSoonWithAccessKey:(NSString *)accessKey secretKey:(NSString *)secretKey expireTime:(NSString *)expireTime token:(NSString *)token afterTime:(NSUInteger)time {
    
    __weak typeof(self)weakSelf = self;
    [AlivcLiveRoomManager stsWithAppUid:self.userInfo.userId success:^(AlivcSts *sts) {
        
        __strong typeof(weakSelf)strongSelf = weakSelf;
        if (!strongSelf) return;
        strongSelf.stsToken = sts;
        [strongSelf.liveRoom  refreshSts:sts];
        
    } failure:^(NSString *errString) {
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong typeof(weakSelf)strongSelf = weakSelf;
            if (!strongSelf) return;
            [MBProgressHUD showMessage:@"token Expiring soon" inView:strongSelf];
            NSLog(@"onStsWillBeExpireSoonWithAccessKey");
        });
    }];
}

- (void)onStsExpiredWithAccessKey:(NSString *)accessKey secretKey:(NSString *)secretKey expireTime:(NSString *)expireTime token:(NSString *)token {
    
    __weak typeof(self)weakSelf = self;
    [AlivcLiveRoomManager stsWithAppUid:self.userInfo.userId success:^(AlivcSts *sts) {
        
        __strong typeof(weakSelf)strongSelf = weakSelf;
        if (!strongSelf) return;
        strongSelf.stsToken = sts;
        [strongSelf.liveRoom  refreshSts:sts];
        
    } failure:^(NSString *errString) {
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong typeof(weakSelf)strongSelf = weakSelf;
            if (!strongSelf) return;
            [MBProgressHUD showMessage:@"token expired" inView:strongSelf];
            NSLog(@"onStsExpiredWithAccessKey");
        });
    }];
}


#pragma mark - AlivcLivePusherCustomFilterDelegate
/**
 通知外置滤镜创建回调
 */
- (void)onCreate:(AlivcLivePusher *)pusher context:(void*)context
{
    [[AlivcLibBeautyManager shareManager] create:context];
}

- (void)updateParam:(AlivcLivePusher *)pusher buffing:(float)buffing whiten:(float)whiten pink:(float)pink cheekpink:(float)cheekpink thinface:(float)thinface shortenface:(float)shortenface bigeye:(float)bigeye
{
    [[AlivcLibBeautyManager shareManager] setParam:buffing whiten:whiten pink:pink cheekpink:cheekpink thinface:thinface shortenface:shortenface bigeye:bigeye];
}

- (void)switchOn:(AlivcLivePusher *)pusher on:(bool)on
{
    [[AlivcLibBeautyManager shareManager] switchOn:on];
}
/**
 通知外置滤镜处理回调
 */
- (int)onProcess:(AlivcLivePusher *)pusher texture:(int)texture textureWidth:(int)width textureHeight:(int)height extra:(long)extra
{
    return [[AlivcLibBeautyManager shareManager] process:texture width:width height:height extra:extra];
}
/**
 通知外置滤镜销毁回调
 */
- (void)onDestory:(AlivcLivePusher *)pusher
{
    [[AlivcLibBeautyManager shareManager] destroy];
}

#pragma mark - AlivcLivePusherCustomDetectorDelegate
/**
 通知外置视频检测创建回调
 */
- (void)onCreateDetector:(AlivcLivePusher *)pusher
{
    [[AlivcLibFaceManager shareManager] create];
}
/**
 通知外置视频检测处理回调
 */
- (long)onDetectorProcess:(AlivcLivePusher *)pusher data:(long)data w:(int)w h:(int)h rotation:(int)rotation format:(int)format extra:(long)extra
{
    return [[AlivcLibFaceManager shareManager] process:data width:w height:h rotation:rotation format:format extra:extra];
}

/**
 通知外置视频检测销毁回调
 */
- (void)onDestoryDetector:(AlivcLivePusher *)pusher
{
    [[AlivcLibFaceManager shareManager] destroy];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self leaveRoomIsKickout:NO];
}

#pragma mark - 网络状态改变
- (void)reachabilityChanged{
    if([AliyunReachability reachabilityForInternetConnection].currentReachabilityStatus == AliyunPVNetworkStatusNotReachable){
        [MBProgressHUD showMessage:[@"network_poor" localString] inView:self];
    }
}

#pragma mark - Other
+(UIImage*)createImageWithColor:(UIColor*) color size:(CGSize)size
{
    CGRect rect=CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

- (void)updateAMessageWithUser:(AlivcLiveUser *)user type:(AlivcMessageType)type commentString:(NSString *)commentString{
    
    if(user.userId.length <= 0) return;
    if(user.nickname.length <= 0){
        __weak typeof(self)weakSelf = self;
        [AlivcUserInfoManager getUserInfoWithIds:user.userId success:^(NSArray<AlivcLiveUser *> * _Nonnull liveUsers) {
            __strong typeof(weakSelf)strongSelf = weakSelf;
            if (!strongSelf) return;
            if(liveUsers.count){
                dispatch_async(dispatch_get_main_queue(), ^{
                    AlivcLiveUser *user = [liveUsers firstObject];
                    AlivcMessage *message = [[AlivcMessage alloc] initWithUser:user type:type commentString:commentString];
                    [strongSelf.messageListView updateAMessage:message];
                });
            }
            
        } failure:^(NSString * _Nonnull errDes) {
            
        }];
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            AlivcMessage *message = [[AlivcMessage alloc] initWithUser:user type:type commentString:commentString];
            [self.messageListView updateAMessage:message];
        });
    }
}

- (void)showOperateViewWithUser:(AlivcLiveUser *)user{
    if([NSThread currentThread].isMainThread == NO){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showOperateViewWithUser:user];
        });
        return;
    }
    
    if([self.kickoutUids containsObject:user.userId]){ //已被踢出
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD showMessage:[@"kickout_tip" localString] inView:self];
        });
        return;
    }
    
    __block BOOL isContain = NO;
    [self.userListView.userArray enumerateObjectsUsingBlock:^(AlivcLiveUser * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj.userId isEqualToString:user.userId]){
            isContain = YES;
            *stop = YES;
        }
    }];
    if(isContain == NO && [user.userId isEqualToString:self.hostUser.userId] == NO){
        [MBProgressHUD showMessage:[@"left_room" localString] inView:self];
        return;
    }
    
    if(user.nickname.length <= 0){
        __weak typeof(self)weakSelf = self;
        [AlivcUserInfoManager getUserInfoWithIds:user.userId success:^(NSArray<AlivcLiveUser *> * _Nonnull liveUsers) {
            __strong typeof(weakSelf)strongSelf = weakSelf;
            if (!strongSelf) return;
            if(liveUsers.count){
                dispatch_async(dispatch_get_main_queue(), ^{
                    AlivcLiveUser *user = [liveUsers firstObject];
                    [self _showOperateViewWithUser:user];
                });
            }
            
        } failure:^(NSString * _Nonnull errDes) {
            
        }];
    }else{
        [self _showOperateViewWithUser:user];
    }
}

- (void)_showOperateViewWithUser:(AlivcLiveUser *)user{
    AlivcOperateUserView *operateView = [[AlivcOperateUserView alloc] initWithUser:user];
    if (self.role == AlivcLiveRoleHost && ![user.userId isEqualToString:self.userInfo.userId]) {
        operateView.buttomView.hidden = NO;
    }else{
        operateView.buttomView.hidden = YES;
    }
    operateView.delegate = self;
    self.operateView = operateView;
    [self.operateView showInView:self];
}

- (void)removeKickoutUserId:(NSString *)uid{
    [self.kickoutUids removeObject:uid];
}

@end

