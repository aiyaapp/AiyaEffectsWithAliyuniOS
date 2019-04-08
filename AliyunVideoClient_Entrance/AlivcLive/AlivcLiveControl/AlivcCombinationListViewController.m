//
//  AlivcCombinationListViewController.m
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2018/4/23.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import "AlivcCombinationListViewController.h"
#import "NSString+AlivcHelper.h"
#import "AlivcLivePlayRoom.h"
#import "AlivcVideoListManager.h"
#import "AlivcVideoItemCollectionViewCell.h"
#import "AlivcLivePlayViewController.h"
#import "MBProgressHUD+AlivcHelper.h"
#import "AlivcLiveRoomView.h"
#import "AlivcProfile.h"
#import "AlivcKickoutView.h"
#import "AlivcLiveRoomManager.h"
#import "AlivcUserInfoManager.h"
#import <AlivcInteractiveLiveRoomSDK/AlivcInteractiveLiveRoomSDK.h>

#if __has_include(<AlivcUtilsSDK/AlivcIMManager.h>)
#import <AlivcUtilsSDK/AlivcIMManager.h>
#else
#import "AlivcIMManager.h"
#endif

#import "AlivcDefine.h"
/**
 组合的列表的选项

 - AlivcCombinationItemShortVideo: 短视频
 - AlivcCombinationItemLive: 直播
 - AlivcCombinationItemPalyback: 回放
 */
typedef NS_ENUM(NSInteger,AlivcCombinationItemType){
    AlivcCombinationItemTypeShortVideo = 1 << 0,
    AlivcCombinationItemTypeLive = 1 << 1,
    AlivcCombinationItemTypePalyback = 1 << 2,
};

typedef NS_ENUM(NSInteger, AlivcAuthorizationStatus) {
    AlivcAuthorizationStatusAuthorized,
    AlivcAuthorizationStatusVideoDenied,
    AlivcAuthorizationStatusAudioDenied,
    AlivcAuthorizationStatusNoAuthorized
};

static NSInteger kCombinationValue = 0b110; //默认值是3个选项齐全
static NSString *AlivcTest_RoomId_Key = @"AlivcTest_RoomId_Key";

@interface AlivcCombinationListViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate,UIAlertViewDelegate>

/**
 顶部的容器视图
 */
@property (nonatomic, strong) UIView *topView;

/**
 顶部的按钮数组
 */
@property (nonatomic, strong) NSMutableArray <UIButton *>*buttons;

/**
 内容视图
 */
@property (nonatomic, strong) UIScrollView *containScrollView;

/**
 直播列表
 */
@property (nonatomic, strong) NSMutableArray <AlivcLivePlayRoom *>*liveList;

/**
 视图列表
 */
@property (nonatomic, strong) NSArray <UICollectionView *>*collectionViewList;

/**
 开直播的按钮
 */
@property (nonatomic, strong) UIButton *startLiveButton;

/**
 选择下方的蓝色线图
 */
@property (nonatomic, strong) UIView *selectedLineView;

@property (nonatomic, strong) AlivcVideoListManager *listManager;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, assign) BOOL requesting;
@property (nonatomic, assign) BOOL notHasMore;

@end

@implementation AlivcCombinationListViewController

+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 提前获取sts
        AlivcProfile *profile = [AlivcProfile shareInstance];
        NSString *userId = profile.userId;
        if (!userId) {
            //生成用户
            [AlivcUserInfoManager randomAUserSuccess:^(AlivcLiveUser *liveUser) {
                profile.userId = liveUser.userId;
                profile.avatarUrlString = liveUser.avatarUrlString;
                profile.nickname = liveUser.nickname;
                [AlivcLiveRoomManager stsWithAppUid:liveUser.userId success:NULL failure:NULL];
            } failure:^(NSString * _Nonnull errDes) {
                
            }];
        }else{
            [AlivcLiveRoomManager stsWithAppUid:profile.userId success:NULL failure:NULL];
        }
    });
}

#pragma mark - System Method
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setEnv];
    // Do any additional setup after loading the view.
    _listManager = [[AlivcVideoListManager alloc]init];
    _requesting = NO;
    [self configBaseData];
    [self configBaseUI];
    [AlivcLiveTime createInstance];
}

- (void)setEnv{
    // 设置IM的环境
    int mode = [[[NSUserDefaults standardUserDefaults] objectForKey:AlivcAppServer_Mode] intValue];
    [AlivcIMManager AlivcIMSetTestEnvMode:mode];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = false;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = true;
}



#pragma mark - getter

- (UIView *)topView{
    if (!_topView) {
        _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    }
    return _topView;
}

- (NSMutableArray <UIButton *>*)buttons{
    if (!_buttons) {
        _buttons = [[NSMutableArray alloc]init];
    }
    return _buttons;
}

- (UIButton *)cancelButton{
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:@"avcClose"];
    [cancelButton setBackgroundImage:image forState:UIControlStateNormal];
    [cancelButton setBackgroundImage:image forState:UIControlStateSelected];
    cancelButton.frame = CGRectMake(0, 22, image.size.width, image.size.height);
    [cancelButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    return cancelButton;
}

- (UIScrollView *)containScrollView{
    if (!_containScrollView) {
        _containScrollView = [[UIScrollView alloc]init];
        _containScrollView.frame = CGRectMake(0, CGRectGetMaxY(self.topView.frame), ScreenWidth, ScreenHeight - CGRectGetMaxY(self.topView.frame) - 64);
        _containScrollView.pagingEnabled = true;
        _containScrollView.delegate = self;
    }
    return _containScrollView;
}

- (UIButton *)startLiveButton{
    if (!_startLiveButton) {
        _startLiveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _startLiveButton.frame = CGRectMake(0, 0, 60, 60);
        [_startLiveButton addTarget:self action:@selector(startLiveButtonTouched) forControlEvents:UIControlEventTouchUpInside];
//        [_startLiveButton setTitle:@"开直播" forState:UIControlStateNormal];
        [_startLiveButton setImage:[UIImage imageNamed:@"startLive"] forState:UIControlStateNormal];
//        [_startLiveButton setBackgroundColor:[UIColor blueColor]];
    }
    return _startLiveButton;
}

- (UIView *)selectedLineView{
    if (!_selectedLineView) {
        _selectedLineView = [[UIView alloc]init];
        _selectedLineView.frame = CGRectMake(0, 0, ScreenWidth / 10, 2);
        _selectedLineView.backgroundColor = [AlivcUIConfig shared].kAVCThemeColor;
    }
    return _selectedLineView;
}


#pragma mark - Custom Method

- (void)onClickRightButton:(UIButton *)sender{
    NSString *preRoomId = [[NSUserDefaults standardUserDefaults]objectForKey:AlivcTest_RoomId_Key];

    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"请输入对应主播的房间ID" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    if (preRoomId) {
        [alertView textFieldAtIndex:0].text = preRoomId;
    }
    [alertView show];
}

- (void)configBaseUI{
    [self.view addSubview:self.topView];
    self.title = [@"Interactive Stream" localString];

#if DEBUG
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 100)];
    [rightButton addTarget:self action:@selector(onClickRightButton:) forControlEvents:UIControlEventTouchDownRepeat];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = item;
#endif
    
    NSMutableArray *shouldAddViews = [[NSMutableArray alloc]init];
    NSMutableArray *addItems = [[NSMutableArray alloc]init];
    
    for (NSInteger i = 0; i < 3; i++) {
        NSInteger itemValue = 1 << i;
        BOOL shouldAdd = kCombinationValue & itemValue;
        if (shouldAdd) {
            NSString *itemString = [NSString stringWithFormat:@"%ld",(long)itemValue];
            [addItems addObject:itemString];
        }
    }
    //添加视图
    [self.topView addSubview:self.selectedLineView];
    [self.view addSubview:self.containScrollView];
    self.containScrollView.contentSize = CGSizeMake(ScreenWidth * addItems.count, self.containScrollView.frame.size.height);
    
    for (NSInteger i = 0; i < addItems.count; i++) {
        NSString *itemString = addItems[i];
        NSInteger itemValue = [itemString integerValue];
        AlivcCombinationItemType itemType = (AlivcCombinationItemType )itemValue;
        UIButton *itemButton = [self creatButtonWithType:itemType];
        itemButton.center = CGPointMake(ScreenWidth / addItems.count * (i + 0.5), self.topView.frame.size.height / 2);
        [self.topView addSubview:itemButton];
        
        [self.buttons addObject:itemButton];
        if (itemType == AlivcCombinationItemTypeLive) {
            itemButton.selected = true;
            self.selectedLineView.center = CGPointMake(itemButton.center.x, self.topView.frame.size.height - 1);
        }
        
        UICollectionView *itemView = [self creatCollectionViewWithType:itemType];
        itemView.backgroundColor = [UIColor clearColor];
        [self.containScrollView addSubview:itemView];
        itemView.center = CGPointMake((i + 0.5) * ScreenWidth, self.containScrollView.frame.size.height / 2);
        [shouldAddViews addObject:itemView];
    }
    
    self.collectionViewList = (NSArray *)shouldAddViews;
    
    //悬浮一个开直播的按钮
    [self.view addSubview:self.startLiveButton];
    self.startLiveButton.center = CGPointMake(ScreenWidth / 2, ScreenHeight - 136);
    
    //默认值
    [self setUIWithType:AlivcCombinationItemTypeLive];
}

- (void)configBaseData{
    _pageIndex = 1;
    if (_requesting) return;
    _requesting = YES;
    _notHasMore = NO;
    __weak typeof(self) ws = self;
    [_listManager getLivePageIndex:_pageIndex pageSize:10 ListSucess:^(NSArray<AlivcLivePlayRoom *> *liveList) {
        if (!liveList.lastObject.more) {
            ws.notHasMore = YES;
        }
        ws.liveList = [NSMutableArray arrayWithArray:liveList];
        ws.requesting = NO;
        UICollectionView *collectionView = [ws collectionViewWithType:AlivcCombinationItemTypeLive];
        [collectionView reloadData];
    } failure:^(NSString *errorString) {
        ws.requesting = NO;
    }];
}
- (void)loadMoreRoomListData{
    if (_requesting || _notHasMore) return;
    _requesting = YES;
    _pageIndex ++;
    __weak typeof(self) ws = self;
    [_listManager getLivePageIndex:_pageIndex pageSize:10 ListSucess:^(NSArray<AlivcLivePlayRoom *> *liveList) {
        if (!liveList.lastObject.more) {
            ws.notHasMore = YES;
        }
        [ws.liveList addObjectsFromArray:liveList];
        ws.requesting = NO;
        UICollectionView *collectionView = [ws collectionViewWithType:AlivcCombinationItemTypeLive];
        [collectionView reloadData];
    } failure:^(NSString *errorString) {
        ws.requesting = NO;
    }];
}

- (NSString *)descriptionStringWithCombinationItem:(AlivcCombinationItemType )itemType{
    switch (itemType) {
        case AlivcCombinationItemTypeShortVideo:
            return [@"小视频" localString];
            break;
        case AlivcCombinationItemTypeLive:
            return [@"Live" localString];
            break;
        case AlivcCombinationItemTypePalyback:
            return [@"Playback" localString];
        default:
            break;
    }
    return @"";
}

- (UIButton *)creatButtonWithType:(AlivcCombinationItemType )type{
    UIButton *button = [[UIButton alloc]init];
    button.frame = CGRectMake(0, 0, 30, 20);
    [button setTitle:[self descriptionStringWithCombinationItem:type] forState:UIControlStateNormal];
    [button setTitle:[self descriptionStringWithCombinationItem:type] forState:UIControlStateSelected];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    button.tag = (NSInteger )type;
    [button sizeToFit];
    [button addTarget:self action:@selector(itemButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (UICollectionView *)creatCollectionViewWithType:(AlivcCombinationItemType )type{
    CGFloat device = 8;
    CGFloat itemWidth = (ScreenWidth - device * 3) / 2;
    CGSize itemSize = CGSizeMake(itemWidth, itemWidth * 1.1);
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = itemSize;
    layout.sectionInset = UIEdgeInsetsMake(5, 0, 5, 0);
    UICollectionView *itemCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.containScrollView.frame.size.width - device * 2, self.containScrollView.frame.size.height) collectionViewLayout:layout];
    itemCollectionView.alwaysBounceVertical = YES;
    itemCollectionView.tag = (NSInteger )type;
    [itemCollectionView registerNib:[UINib nibWithNibName:@"AlivcVideoItemCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"AlivcVideoItemCollectionViewCell"];
    itemCollectionView.dataSource = self;
    itemCollectionView.delegate = self;
    return itemCollectionView;
}

- (UICollectionView *__nullable)collectionViewWithType:(AlivcCombinationItemType )type{
    for (UICollectionView *cView in self.collectionViewList){
        AlivcCombinationItemType cType = (AlivcCombinationItemType )cView.tag;
        if (cType == type) {
            return cView;
        }
    }
    return nil;
}

- (void)setUIWithType:(AlivcCombinationItemType )type{
    if (type == AlivcCombinationItemTypeLive) {
        self.startLiveButton.hidden = false;
    }else{
        self.startLiveButton.hidden = true;
    }
    [self setButtonUIWithType:type];
    [self setScrollerViewWithType:type];
}

/**
 设置按钮的选中状态

 @param type 类型
 */
- (void)setButtonUIWithType:(AlivcCombinationItemType )type{
    
    for (UIButton *ibutton in self.buttons) {
        if (ibutton.tag == (NSInteger)type) {
            ibutton.selected = true;
            [UIView animateWithDuration:0.3 animations:^{
                self.selectedLineView.center = CGPointMake(ibutton.center.x, self.topView.frame.size.height - 1);
            }];
        }else{
            ibutton.selected = false;
        }
    }
}

/**
 设置scrollerView的偏移量

 @param type 类型
 */
- (void)setScrollerViewWithType:(AlivcCombinationItemType )type{
    NSInteger selectedIndex = 0;
    for (UICollectionView *cView in self.collectionViewList) {
        if (cView.tag == (NSInteger)type) {
            selectedIndex = [self.collectionViewList indexOfObject:cView];
            break;
        }
    }
    [self.containScrollView setContentOffset:CGPointMake(ScreenWidth * selectedIndex, 0) animated:true];
}

#pragma mark - default Value
- (AlivcUser *)defaultUser{
    AlivcUser *userInfo = [[AlivcUser alloc]init];
    userInfo.userId = [AlivcProfile shareInstance].userId;
    userInfo.userDesp = [AlivcProfile shareInstance].nickname;
    return userInfo;
}

- (AlivcInteractiveLiveRoomConfig *)defaultRoomConfig{
    AlivcInteractiveLiveRoomConfig *roomConfig = [[AlivcInteractiveLiveRoomConfig alloc]init];
    roomConfig.beautyOn = true;
    roomConfig.beautyMode = AlivcBeautyPressional;
    roomConfig.resolution = AlivcLivePushResolution540P;
//    roomConfig.playUrlType = AlivcLivePlayUrlRtmpHD;
   // roomConfig.reportLikeInterval = 5 * 1000;
    
    roomConfig.pauseImg = [UIImage imageNamed:@"alivcReources.bundle/background_push"];
    return roomConfig;
}

#pragma mark - Response

- (void)itemButtonTouched:(UIButton *)button{
    AlivcCombinationItemType type = (AlivcCombinationItemType )button.tag;
    [self setUIWithType:type];
}

- (void)startLiveButtonTouched{
    
    [AlivcCombinationListViewController videoAndAudioAuthorizationHandel:^(AlivcAuthorizationStatus status) {
        switch (status) {
            case AlivcAuthorizationStatusAuthorized:
            {
                AlivcLivePlayViewController *targetVC = [[AlivcLivePlayViewController alloc]init];
                __weak typeof(self)weakSelf = self;
                [targetVC setShowedCompletion:^(NSString *errorStr) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [MBProgressHUD showMessage:errorStr inView:weakSelf.view];
                    });
                }];
                targetVC.role = AlivcLiveRoleHost;
                targetVC.userInfo = [self defaultUser];
                targetVC.roomConfig = [self defaultRoomConfig];
                [self.navigationController pushViewController:targetVC animated:true];
            }
                break;
            case AlivcAuthorizationStatusAudioDenied:
                [self showAlertViewWithWithTitle:[@"fail_micophone" localString] message:[@"no_auth_micophone" localString]];
                break;
            case AlivcAuthorizationStatusVideoDenied:
                [self showAlertViewWithWithTitle:[@"fail_camera" localString] message:[@"no_auth_camera" localString]];
                break;
            case AlivcAuthorizationStatusNoAuthorized:
                [self showAlertViewWithWithTitle:[@"fail_mic_camera" localString] message:[@"no_auth_mic_camera" localString]];
                break;
            default:
                break;
        }
    }];
}

- (void)showAlertViewWithWithTitle:(NSString *)title message:(NSString *)message{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
}

- (void)dismiss{
    [self dismissViewControllerAnimated:true completion:nil];
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat width = (ScreenWidth - 8 * 3) / 2;
    return CGSizeMake(width, width * 1.3);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 8;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 8;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    AlivcCombinationItemType type = (AlivcCombinationItemType )collectionView.tag;
    switch (type) {
        case AlivcCombinationItemTypeLive:
            return self.liveList.count;
            break;
            
        default:
            break;
    }
    return 0;
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    AlivcVideoItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AlivcVideoItemCollectionViewCell" forIndexPath:indexPath];
    if (self.liveList.count>0) {
        AlivcLivePlayRoom *room = self.liveList[indexPath.row];
        cell.data = room;
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    AlivcLivePlayRoom *room = self.liveList[indexPath.row];
    NSString *roomID = room.roomId;
    AlivcLivePlayViewController *targetVC = [[AlivcLivePlayViewController alloc]init];
    __weak typeof(self)ws = self;
    targetVC.showBeKickOut = ^{
        AlivcKickoutView *v = [[AlivcKickoutView alloc] init];
        [v showInView:ws.view];

    };
    targetVC.role = AlivcLiveRoleAudience;
    targetVC.roomConfig = [self defaultRoomConfig];
    targetVC.userInfo = [self defaultUser];
    targetVC.roomId = roomID;
    [self.navigationController pushViewController:targetVC animated:true];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView.contentSize.height - scrollView.contentOffset.y < scrollView.frame.size.height-20) {
        NSLog(@"加载更多");
        [self loadMoreRoomListData];
    }
    if (scrollView.contentOffset.y < -20) {
        NSLog(@"下拉刷新");
        [self configBaseData];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self adjustSeletedButtonTypeWithScrollView:scrollView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [self adjustSeletedButtonTypeWithScrollView:scrollView];
}

- (void)adjustSeletedButtonTypeWithScrollView:(UIScrollView *)scrollView{
    CGPoint offset = scrollView.contentOffset;
    NSInteger shang = offset.x / ScreenWidth;
    if (self.buttons.count > shang) {
        UIButton *buton = self.buttons[shang];
        AlivcCombinationItemType type = (AlivcCombinationItemType )buton.tag;
        [self setButtonUIWithType:type];
        [self setUIWithType:type];
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        //确定
        NSLog(@"点击确定的时间:%@",[AlivcLiveRoomView currentDateString]);
        NSString *roomId = [alertView textFieldAtIndex:0].text;
        if (roomId) {
            AlivcLivePlayViewController *targetVC = [[AlivcLivePlayViewController alloc]init];
            __weak typeof(self)weakSelf = self;
            [targetVC setShowedCompletion:^(NSString *errorStr) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [MBProgressHUD showMessage:errorStr inView:weakSelf.view];
                });
            }];
            targetVC.role = AlivcLiveRoleAudience;
            targetVC.roomConfig = [self defaultRoomConfig];
            targetVC.userInfo = [self defaultUser];
            targetVC.roomId = roomId;
            [self.navigationController pushViewController:targetVC animated:true];
            [[NSUserDefaults standardUserDefaults]setObject:roomId forKey:AlivcTest_RoomId_Key];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }else{
            [MBProgressHUD showMessage:@"请输入roomid" inView:self.view];
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

#pragma mark - AVAuthorizationStatus
#pragma mark - Authorization
+(void)videoAndAudioAuthorizationHandel:(void(^)(AlivcAuthorizationStatus status))handel{
    
    // 判断权限
    AVAuthorizationStatus videoStatus = [self videoAVAuthorizationStatus];
    AVAuthorizationStatus audioStatus = [self audioAVAuthorizationStatus];
    __weak typeof(self)weakSelf = self;
    if (videoStatus == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            __strong typeof(weakSelf)strongSelf = weakSelf;
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf videoAndAudioAuthorizationHandel:handel];
            });
        }];
        return;
    }
    if (audioStatus == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
            __strong typeof(weakSelf)strongSelf = weakSelf;
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf videoAndAudioAuthorizationHandel:handel];
            });
        }];
        return;
    }
    
    if (videoStatus == AVAuthorizationStatusDenied && audioStatus == AVAuthorizationStatusDenied) {
        if (handel) {
            handel(AlivcAuthorizationStatusNoAuthorized);
        }
    }else if(videoStatus == AVAuthorizationStatusDenied && audioStatus != AVAuthorizationStatusDenied){
        if (handel) {
            handel(AlivcAuthorizationStatusVideoDenied);
        }
    }else if(videoStatus != AVAuthorizationStatusDenied && audioStatus == AVAuthorizationStatusDenied){
        if (handel) {
            handel(AlivcAuthorizationStatusAudioDenied);
        }
    }else{
        if (handel) {
            handel(AlivcAuthorizationStatusAuthorized);
        }
    }
}

+(AVAuthorizationStatus)videoAVAuthorizationStatus{
    return [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
}

+(AVAuthorizationStatus)audioAVAuthorizationStatus{
    return [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
}

@end
