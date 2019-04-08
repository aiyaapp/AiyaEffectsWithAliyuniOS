//
//  QURecordParamViewController.m
//  AliyunVideo
//
//  Created by dangshuai on 17/3/6.
//  Copyright (C) 2010-2017 Alibaba Group Holding Limited. All rights reserved.
//

#import "AliyunRecordParamViewController.h"
#import "AliyunRecordParamTableViewCell.h"
#import "AVC_ShortVideo_Config.h"
#import <AssetsLibrary/AssetsLibrary.h>
#if SDK_VERSION == SDK_VERSION_BASE
#import <AliyunVideoSDK/AliyunVideoSDK.h>
#else
#import "AliyunVideoRecordParam.h"
#import "AliyunMediaConfig.h"
#import "AliyunMediator.h"
#import "AliyunVideoUIConfig.h"
#import "AliyunVideoBase.h"
#import "AliyunVideoCropParam.h"
#endif


@interface AliyunRecordParamViewController ()<UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;

#if SDK_VERSION == SDK_VERSION_CUSTOM
@property (nonatomic, strong) AliyunMediaConfig *quVideo;
#else
@property (nonatomic, strong) AliyunVideoRecordParam *quVideo;
#endif

@property (nonatomic, assign) CGFloat videoOutputWidth;
@property (nonatomic, assign) CGFloat videoOutputRatio;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *chineseHeightConstraint;
@property (assign, nonatomic) BOOL isPhotoToRecord;
@property (assign, nonatomic) BOOL isUnActive;
@end

@implementation AliyunRecordParamViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        
#if (SDK_VERSION == SDK_VERSION_BASE || SDK_VERSION == SDK_VERSION_STANDARD)
        [self setupSDKBaseVersionUI];
#else
        [self setupSDKUI];
#endif
    }
    return self;
}
#if (SDK_VERSION == SDK_VERSION_BASE || SDK_VERSION == SDK_VERSION_STANDARD)
- (void)setupSDKBaseVersionUI {
    AliyunVideoUIConfig *config = [[AliyunVideoUIConfig alloc] init];
    
    config.backgroundColor = RGBToColor(35, 42, 66);
    config.timelineBackgroundCollor = RGBToColor(35, 42, 66);
    config.timelineDeleteColor = [UIColor redColor];
    config.timelineTintColor = RGBToColor(239, 75, 129);
    config.durationLabelTextColor = [UIColor redColor];
    config.cutTopLineColor = [UIColor redColor];
    config.cutBottomLineColor = [UIColor redColor];
    config.noneFilterText = @"无滤镜";
    config.hiddenDurationLabel = NO;
    config.hiddenFlashButton = NO;
    config.hiddenBeautyButton = NO;
    config.hiddenCameraButton = NO;
    config.hiddenImportButton = NO;
    config.hiddenDeleteButton = NO;
    config.hiddenFinishButton = NO;
    config.recordOnePart = NO;
    config.filterArray = @[@"炽黄",@"粉桃",@"海蓝",@"红润",@"灰白",@"经典",@"麦茶",@"浓烈",@"柔柔",@"闪耀",@"鲜果",@"雪梨",@"阳光",@"优雅",@"朝阳",@"波普",@"光圈",@"海盐",@"黑白",@"胶片",@"焦黄",@"蓝调",@"迷糊",@"思念",@"素描",@"鱼眼",@"马赛克",@"模糊"];
    config.imageBundleName = @"QPSDK";
    config.filterBundleName = @"FilterResource";
    config.recordType = AliyunVideoRecordTypeCombination;
    config.showCameraButton = YES;
    
    [[AliyunVideoBase shared] registerWithAliyunIConfig:config];
}
#else
- (void)setupSDKUI {
    
    AliyunIConfig *config = [[AliyunIConfig alloc] init];
    
    config.backgroundColor = RGBToColor(35, 42, 66);
    config.timelineBackgroundCollor = RGBToColor(35, 42, 66);
    config.timelineDeleteColor = [UIColor redColor];
    config.timelineTintColor = RGBToColor(239, 75, 129);
    config.durationLabelTextColor = [UIColor redColor];
    config.hiddenDurationLabel = NO;
    config.hiddenFlashButton = NO;
    config.hiddenBeautyButton = NO;
    config.hiddenCameraButton = NO;
    config.hiddenImportButton = NO;
    config.hiddenDeleteButton = NO;
    config.hiddenFinishButton = NO;
    config.recordOnePart = NO;
    config.filterArray = @[@"filter/炽黄",@"filter/粉桃",@"filter/海蓝",@"filter/红润",@"filter/灰白",@"filter/经典",@"filter/麦茶",@"filter/浓烈",@"filter/柔柔",@"filter/闪耀",@"filter/鲜果",@"filter/雪梨",@"filter/阳光",@"filter/优雅",@"filter/朝阳",@"filter/波普",@"filter/光圈",@"filter/海盐",@"filter/黑白",@"filter/胶片",@"filter/焦黄",@"filter/蓝调",@"filter/迷糊",@"filter/思念",@"filter/素描",@"filter/鱼眼",@"filter/马赛克",@"filter/模糊"];
    config.imageBundleName = @"QPSDK";
    config.recordType = AliyunIRecordActionTypeCombination;
    config.filterBundleName = nil;
    config.showCameraButton = YES;
    
    [AliyunIConfig setConfig:config];
}

#endif
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
#if SDK_VERSION != SDK_VERSION_BASE
    [AliyunIConfig config].hiddenImportButton = NO;
#endif
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setupParamData];
    [_tableView reloadData];
    self.heightConstraint.constant = SafeTop;
    self.chineseHeightConstraint.constant = SafeTop;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenKeyboard:)];
    [self.tableView addGestureRecognizer:tapGesture];
    
#if SDK_VERSION == SDK_VERSION_CUSTOM
    _quVideo = [[AliyunMediaConfig alloc] init];
    _quVideo.outputSize = CGSizeMake(540, 720);
    _quVideo.minDuration = 2;
    _quVideo.maxDuration = 30;
#else
    _quVideo = [[AliyunVideoRecordParam alloc] init];
    _quVideo.ratio = AliyunVideoVideoRatio3To4;
    _quVideo.size = AliyunVideoVideoSize540P;
    _quVideo.minDuration = 2;
    _quVideo.maxDuration = 30;
    _quVideo.position = AliyunCameraPositionFront;
    _quVideo.beautifyStatus = YES;
    _quVideo.beautifyValue = 100;
    _quVideo.torchMode = AliyunCameraTorchModeOff;
    _quVideo.outputPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/record_save.mp4"];

#endif
    
    self.videoOutputRatio = 0.75;
    self.videoOutputWidth = 540;

}

- (void)hiddenKeyboard:(id)sender {
    [self.view endEditing:YES];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(SDK_VERSION == SDK_VERSION_BASE){
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
    }
}
- (void)appWillResignActive:(id)sender{
    self.isUnActive = YES;
}
- (void)appDidBecomeActive:(id)sender{
    self.isUnActive = NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
// 支持设备自动旋转
- (BOOL)shouldAutorotate
{
    return YES;
}

// 支持竖屏显示
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AliyunRecordParamCellModel *model = _dataArray[indexPath.row];
    if (model) {
        NSString *identifier = model.reuseId;
        AliyunRecordParamTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[AliyunRecordParamTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        [cell configureCellModel:model];
        return cell;
    }
    return nil;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth / 2 - 50, 0, 100, 44)];
    [button setTitle:@"启动录制" forState:0];
    [button addTarget:self action:@selector(toRecordView) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = RGBToColor(240, 84, 135);
    [view addSubview:button];
    return view;
}

- (void)setupParamData {
    
        AliyunRecordParamCellModel *cellModel0 = [[AliyunRecordParamCellModel alloc] init];
        cellModel0.title = @"码率";
        cellModel0.placeHolder = @"";
        cellModel0.reuseId = @"cellInput";
        cellModel0.valueBlock = ^(int value){
            _quVideo.bitrate = value;
        };

    
    AliyunRecordParamCellModel *cellModel1 = [[AliyunRecordParamCellModel alloc] init];
    cellModel1.title = @"最小时长";
    cellModel1.placeHolder = @"最小时长大于0，默认值2s";
    cellModel1.reuseId = @"cellInput";
    cellModel1.valueBlock = ^(int value){
        _quVideo.minDuration = value;
    };
    
    AliyunRecordParamCellModel *cellModel2 = [[AliyunRecordParamCellModel alloc] init];
    cellModel2.title = @"最大时长";
    cellModel2.placeHolder = @"建议不超过300S，默认值30s";
    cellModel2.reuseId = @"cellInput";
    cellModel2.valueBlock = ^(int value){
        _quVideo.maxDuration = value;
    };
    
    AliyunRecordParamCellModel *cellModel3 = [[AliyunRecordParamCellModel alloc] init];
    cellModel3.title = @"关键帧间隔";
    cellModel3.placeHolder = @"建议1-300，默认5";
    cellModel3.reuseId = @"cellInput";
    cellModel3.valueBlock = ^(int value) {
        _quVideo.gop = value;
    };
    
    AliyunRecordParamCellModel *cellModel4 = [[AliyunRecordParamCellModel alloc] init];
    cellModel4.title = @"视频质量";
    cellModel4.placeHolder = @"高";
    cellModel4.reuseId = @"cellSilder";
    cellModel4.defaultValue = 0.25;
    cellModel4.valueBlock = ^(int value){
        _quVideo.videoQuality = value;
    };
    
    AliyunRecordParamCellModel *cellModel5 = [[AliyunRecordParamCellModel alloc] init];
    cellModel5.title = @"视频比例";
    cellModel5.placeHolder = @"3:4";
    cellModel5.reuseId = @"cellSilder";
    cellModel5.defaultValue = 0.6;
    cellModel5.ratioBack = ^(CGFloat videoRatio){
        self.videoOutputRatio = videoRatio;
    };
    
    AliyunRecordParamCellModel *cellModel6 = [[AliyunRecordParamCellModel alloc] init];
    cellModel6.title = @"分辨率";
    cellModel6.placeHolder = @"540P";
    cellModel6.reuseId = @"cellSilder";
    cellModel6.defaultValue = 0.75;
    cellModel6.sizeBlock = ^(CGFloat videoWidth){
        self.videoOutputWidth = videoWidth;
    };
    
    
    _dataArray = @[cellModel0,cellModel1,cellModel2,cellModel3,cellModel4,cellModel5,cellModel6];
}

// 根据调节结果更新videoSize
#if SDK_VERSION == SDK_VERSION_CUSTOM
- (void)updatevideoOutputVideoSize {
    
    CGFloat width = self.videoOutputWidth;
    CGFloat height = ceilf(self.videoOutputWidth / self.videoOutputRatio); // 视频的videoSize需为整偶数
    _quVideo.outputSize = CGSizeMake(width, height);
    NSLog(@"videoSize:w:%f  h:%f", _quVideo.outputSize.width, _quVideo.outputSize.height);
}
#endif

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view resignFirstResponder];
}

- (IBAction)buttonBackClick:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)toRecordView {
    [self.view endEditing:YES];
    
#if SDK_VERSION == SDK_VERSION_CUSTOM
    [self updatevideoOutputVideoSize];
#else
    if (self.videoOutputRatio == 0.5625) {
        _quVideo.ratio = AliyunVideoVideoRatio9To16;
    }else if (self.videoOutputRatio == 0.75) {
        _quVideo.ratio = AliyunVideoVideoRatio3To4;
    } else {
        _quVideo.ratio = AliyunVideoVideoRatio1To1;
    }

#endif
    if (_quVideo.maxDuration == 0) {
        _quVideo.maxDuration = 30;
    }
    if (_quVideo.minDuration == 0) {
        _quVideo.minDuration = 2;
    }
    if (_quVideo.maxDuration <= _quVideo.minDuration) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"最大时长不得小于最小时长" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
#if SDK_VERSION == SDK_VERSION_CUSTOM
    UIViewController *recordVC = [[AliyunMediator shared] recordViewController];
    [recordVC setValue:self forKey:@"delegate"];
    [recordVC setValue:_quVideo forKey:@"quVideo"];
    [recordVC setValue:@(YES) forKey:@"isSkipEditVC"];
    [self.navigationController pushViewController:recordVC animated:YES];
#else
    UIViewController *recordViewController = [[AliyunVideoBase shared] createRecordViewControllerWithRecordParam:_quVideo];
    [AliyunVideoBase shared].delegate = (id)self;
    [self.navigationController pushViewController:recordViewController animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
#endif
   
}

#pragma mark - RecordViewControllerDelegate
- (void)exitRecord {
    if (self.isPhotoToRecord) {
        self.isPhotoToRecord = NO;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)recoderFinish:(UIViewController *)vc videopath:(NSString *)videoPath {
    
    if (self.isPhotoToRecord) {
        self.isPhotoToRecord = NO;
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [library writeVideoAtPathToSavedPhotosAlbum:[NSURL fileURLWithPath:videoPath] completionBlock:^(NSURL *assetURL, NSError *error) {
            if (error) {
                NSLog(@"录制完成，保存到相册失败");
                return;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }];
        return;
    }
    UIViewController *editVC = [[AliyunMediator shared] editViewController];
    NSString *outputPath = [[vc valueForKey:@"recorder"] valueForKey:@"taskPath"];
    [editVC setValue:outputPath forKey:@"taskPath"];
    [editVC setValue:[vc valueForKey:@"quVideo"] forKey:@"config"];
   
    if (!_isUnActive) {
        [self.navigationController pushViewController:editVC animated:YES];
    }
    
    
}


- (void)recordViewShowLibrary:(UIViewController *)vc {
#if SDK_VERSION != SDK_VERSION_BASE
    [AliyunIConfig config].showCameraButton = NO;
#endif
    UIViewController *compositionVC = [[AliyunMediator shared] compositionViewController];
    AliyunMediaConfig *mediaConfig = [[AliyunMediaConfig alloc] init];
    mediaConfig.fps = 25;
    mediaConfig.gop = 5;
    mediaConfig.videoQuality = 1;
    mediaConfig.cutMode = AliyunMediaCutModeScaleAspectFill;
    mediaConfig.encodeMode = AliyunEncodeModeHardH264;
    mediaConfig.outputSize = CGSizeMake(540, 720);
    mediaConfig.videoOnly = NO;
    [compositionVC setValue:mediaConfig forKey:@"compositionConfig"];
    [self.navigationController pushViewController:compositionVC animated:YES];
    
}

#pragma mark - AliyunVideoBaseDelegate
#if (SDK_VERSION == SDK_VERSION_BASE || SDK_VERSION == SDK_VERSION_STANDARD)
-(void)videoBaseRecordVideoExit {
    NSLog(@"退出录制");
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)videoBase:(AliyunVideoBase *)base recordCompeleteWithRecordViewController:(UIViewController *)recordVC videoPath:(NSString *)videoPath {
    NSLog(@"录制完成  %@", videoPath);
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library writeVideoAtPathToSavedPhotosAlbum:[NSURL fileURLWithPath:videoPath]
                                completionBlock:^(NSURL *assetURL, NSError *error) {
                                    
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        [recordVC.navigationController popViewControllerAnimated:YES];
                                    });
                                }];
}

- (AliyunVideoCropParam *)videoBaseRecordViewShowLibrary:(UIViewController *)recordVC {
    
    NSLog(@"录制页跳转Library");
    // 可以更新相册页配置
    AliyunVideoCropParam *mediaInfo = [[AliyunVideoCropParam alloc] init];
    mediaInfo.minDuration = 2.0;
    mediaInfo.maxDuration = 10.0*60;
    mediaInfo.fps = 25;
    mediaInfo.gop = 5;
    mediaInfo.videoQuality = 1;
    mediaInfo.size = AliyunVideoVideoSize540P;
    mediaInfo.ratio = AliyunVideoVideoRatio3To4;
    mediaInfo.cutMode = AliyunVideoCutModeScaleAspectFill;
    mediaInfo.outputPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/cut_save.mp4"];
    return mediaInfo;
    
}

// 裁剪
- (void)videoBase:(AliyunVideoBase *)base cutCompeleteWithCropViewController:(UIViewController *)cropVC videoPath:(NSString *)videoPath {
    
    NSLog(@"裁剪完成  %@", videoPath);
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library writeVideoAtPathToSavedPhotosAlbum:[NSURL fileURLWithPath:videoPath]
                                completionBlock:^(NSURL *assetURL, NSError *error) {
                                    
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        [cropVC.navigationController popViewControllerAnimated:YES];
                                    });
                                }];
    
}

- (AliyunVideoRecordParam *)videoBasePhotoViewShowRecord:(UIViewController *)photoVC {
    
    NSLog(@"跳转录制页");
    return nil;
}

- (void)videoBasePhotoExitWithPhotoViewController:(UIViewController *)photoVC {
    
    NSLog(@"退出相册页");
    [photoVC.navigationController popViewControllerAnimated:YES];
}
#endif

@end
