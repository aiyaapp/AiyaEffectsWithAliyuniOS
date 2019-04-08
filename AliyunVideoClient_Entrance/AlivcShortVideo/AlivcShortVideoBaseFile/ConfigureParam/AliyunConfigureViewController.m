//
//  QUConfigureViewController.m
//  AliyunVideo
//
//  Created by dangshuai on 17/1/12.
//  Copyright (C) 2010-2017 Alibaba Group Holding Limited. All rights reserved.
//

#import "AliyunConfigureViewController.h"
#import "AVC_ShortVideo_Config.h"

#import <AssetsLibrary/AssetsLibrary.h>
#if SDK_VERSION == SDK_VERSION_BASE
#import <AliyunVideoSDK/AliyunVideoSDK.h>
#else
#import "AliyunMediaConfig.h"
#import "AliyunMediator.h"
#import "AliyunVideoBase.h"
#import "AliyunVideoUIConfig.h"
#import "AliyunVideoCropParam.h"

#endif

@interface AliyunConfigureViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textFieldFPS;
@property (weak, nonatomic) IBOutlet UITextField *textFieldGOP;
@property (weak, nonatomic) IBOutlet UITextField *textFieldBitrate;

@property (weak, nonatomic) IBOutlet UISlider *bpsSilder;
@property (weak, nonatomic) IBOutlet UISlider *sizeSlider;
@property (weak, nonatomic) IBOutlet UISlider *ratioSlider;
@property (weak, nonatomic) IBOutlet UILabel *labelVideoSize;
@property (weak, nonatomic) IBOutlet UILabel *ratioLabel;
@property (weak, nonatomic) IBOutlet UILabel *videoQualityLabel;
@property (weak, nonatomic) IBOutlet UIView *roundViewCut;
@property (weak, nonatomic) IBOutlet UIView *roundViewFill;
@property (weak, nonatomic) IBOutlet UISwitch *encodeSwitch;


@property (weak, nonatomic) IBOutlet UISwitch *cropSwitch;

@property (nonatomic, strong) CALayer *fillLayer;

@property (nonatomic, strong) NSArray *qualities;
@property (nonatomic, strong) AliyunMediaConfig *mediaInfo;

@property (nonatomic, assign) CGFloat videoOutputRatio;
@property (nonatomic, assign) CGFloat videoOutputWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *chineseHeightConstraint;

@end

@implementation AliyunConfigureViewController
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
    if (IPHONEX) {
        self.heightConstraint.constant = 88;
        self.chineseHeightConstraint.constant = 88;
    }else{
        self.heightConstraint.constant = 64;
        self.chineseHeightConstraint.constant = 64;
    }
    _roundViewCut.layer.cornerRadius = 9;
    _roundViewCut.layer.masksToBounds = YES;
    _roundViewFill.layer.cornerRadius = 9;
    _roundViewFill.layer.masksToBounds = YES;
    
    [_textFieldFPS setValue:RGBToColor(110, 118, 139) forKeyPath:@"_placeholderLabel.textColor"];
    [_textFieldGOP setValue:RGBToColor(110, 118, 139) forKeyPath:@"_placeholderLabel.textColor"];
    
    _sizeSlider.minimumTrackTintColor = RGBToColor(240, 84, 135);
    [_sizeSlider setThumbTintColor:RGBToColor(240, 84, 135)];
    
    _bpsSilder.minimumTrackTintColor = RGBToColor(240, 84, 135);
    [_bpsSilder setThumbTintColor:RGBToColor(240, 84, 135)];
    _bpsSilder.value = 0.25;
    
    _ratioSlider.minimumTrackTintColor = RGBToColor(240, 84, 135);
    [_ratioSlider setThumbTintColor:RGBToColor(240, 84, 135)];
    _ratioSlider.value = 0.6;
    
    
    _mediaInfo = [[AliyunMediaConfig alloc] init];
    _mediaInfo.minDuration = 2.0;
    _mediaInfo.maxDuration = 10.0*60;
    _mediaInfo.fps = 25;
    _mediaInfo.gop = 5;
    _mediaInfo.videoQuality = 1;
    _mediaInfo.outputSize = CGSizeMake(540, 720);
    _mediaInfo.cutMode = AliyunMediaCutModeScaleAspectFill;
    _mediaInfo.videoOnly = NO;
    _mediaInfo.backgroundColor = [UIColor blackColor];
    _qualities = @[@"极高",@"高",@"中",@"低",@"较低",@"极低"];
    
    self.videoOutputRatio = 0.75;
    self.videoOutputWidth = 540;

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.textFieldFPS resignFirstResponder];
    [self.textFieldGOP resignFirstResponder];
    [self.textFieldBitrate resignFirstResponder];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (_mediaInfo.cutMode == AliyunMediaCutModeScaleAspectFill) {
        self.fillLayer.position = _roundViewFill.center;
    } else {
        self.fillLayer.position = _roundViewCut.center;
    }
}

- (IBAction)textFieldFPSEndEdit:(id)sender {
    _mediaInfo.fps = [_textFieldFPS.text intValue];
}
- (IBAction)textFieldGOPEndEdit:(id)sender {
    _mediaInfo.gop = [_textFieldGOP.text intValue];
}

- (IBAction)textFieldBitrateEndEdit:(id)sender {
        _mediaInfo.bitrate = [_textFieldBitrate.text intValue];
}


- (IBAction)silderValueChanged:(id)sender {
    UISlider *slider = (UISlider *)sender;
    NSString *str = @"540P";
    if (slider.value < 1/4.0) {
        self.videoOutputWidth = 360;
        str = @"360P";
    } else if (slider.value < 2/4.0) {
        self.videoOutputWidth = 480;
        str = @"480P";
    } else if (slider.value < 3/4.0) {
        self.videoOutputWidth = 540;
        str = @"540P";
    } else {
        self.videoOutputWidth = 720;
        str = @"720P";
    }
    _labelVideoSize.text = str;
}

- (IBAction)bpsSliderValueChanged:(id)sender {
    UISlider *slider = (UISlider *)sender;
    int value = slider.value * 100;
    _mediaInfo.videoQuality = value / (100 / 5);
//    if ((int)_mediaInfo.videoQuality == 4) _mediaInfo.videoQuality = 3;
    _videoQualityLabel.text = _qualities[_mediaInfo.videoQuality];
}

- (IBAction)ratioSliderValueChanged:(UISlider *)sender {
    
    NSString *ratio = @"3:4";
    if (sender.value < 1/3.0) {
        self.videoOutputRatio = 9.0/16.0;
        ratio = @"9:16";
    } else if (sender.value < 2/3.0) {
        self.videoOutputRatio = 3.0/4.0;
        ratio = @"3:4";
    } else {
        self.videoOutputRatio = 1.0;
        ratio = @"1:1";
    }
    _ratioLabel.text = ratio;
}

- (IBAction)buttonCencelCLick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)buttonNextClick:(id)sender {
    
    [self updatevideoOutputVideoSize];
    if (self.isClipConfig) {
    #if SDK_VERSION != SDK_VERSION_BASE
        [AliyunIConfig config].showCameraButton = YES;
    #endif
        UIViewController *vc = [[AliyunMediator shared] cropModule];
        [vc setValue:_mediaInfo forKey:@"cutInfo"];
        [vc setValue:self forKey:@"delegate"];
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        UIViewController *vc = [[AliyunMediator shared] editModule];
        [vc setValue:_mediaInfo forKey:@"compositionConfig"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (IBAction)buttonCutModeClick:(id)sender {
    self.fillLayer.position = _roundViewCut.center;
    _mediaInfo.cutMode = AliyunMediaCutModeScaleAspectCut;
}

- (IBAction)buttonFillModeClick:(id)sender {
    self.fillLayer.position = _roundViewFill.center;
    _mediaInfo.cutMode = AliyunMediaCutModeScaleAspectFill;
}

-(IBAction)switchEncode:(UISwitch *)sender {
//    _mediaInfo.encodeMode = sender.on;
}

- (IBAction)switchCrop:(UISwitch *)sender {
    _mediaInfo.gpuCrop = sender.on;
}

- (CALayer *)fillLayer {
    if (!_fillLayer) {
        _fillLayer = [CALayer layer];
        _fillLayer.backgroundColor = RGBToColor(240, 84, 135).CGColor;
        _fillLayer.bounds = CGRectMake(0, 0, 8, 8);
        _fillLayer.cornerRadius = 4;
        _fillLayer.masksToBounds = YES;
        [self.view.layer addSublayer:_fillLayer];
    }
    return _fillLayer;
}

// 根据调节结果更新videoSize
- (void)updatevideoOutputVideoSize {
    
    CGFloat width = self.videoOutputWidth;
    CGFloat height = ceilf(self.videoOutputWidth / self.videoOutputRatio); // 视频的videoSize需为整偶数
    _mediaInfo.outputSize = CGSizeMake(width, height);
    NSLog(@"videoSize:w:%f  h:%f", _mediaInfo.outputSize.width, _mediaInfo.outputSize.height);
    
}
#pragma mark - PhotoViewControllerDelgate
- (void)recodBtnClick:(UIViewController *)vc {
#if SDK_VERSION != SDK_VERSION_BASE
    [AliyunIConfig config].hiddenImportButton = YES;
#endif
//    self.isPhotoToRecord = YES;
    UIViewController *recordVC = [[AliyunMediator shared] recordViewController];
    [recordVC setValue:self forKey:@"delegate"];
    [recordVC setValue:[vc valueForKey:@"cutInfo"] forKey:@"quVideo"];
    [recordVC setValue:@(NO) forKey:@"isSkipEditVC"];
    [self.navigationController pushViewController:recordVC animated:YES];
}

- (void)videoBase:(AliyunVideoBase *)base cutCompeleteWithCropViewController:(UIViewController *)cropVC image:(UIImage *)image {
    //裁剪图片
    if (image) {
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    }
}


- (void)cropFinished:(UIViewController *)cropViewController videoPath:(NSString *)videoPath sourcePath:(NSString *)sourcePath {
    
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library writeVideoAtPathToSavedPhotosAlbum:[NSURL fileURLWithPath:videoPath] completionBlock:^(NSURL *assetURL, NSError *error) {
        if (error) {
            NSLog(@"裁剪完成，保存到相册失败");
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"裁剪完成" message:@"已保存到手机相册" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
        });
    }];
}

- (void)cropFinished:(UIViewController *)cropViewController mediaType:(kPhotoMediaType)type photo:(UIImage *)photo videoPath:(NSString *)videoPath {
    if (type == kPhotoMediaTypePhoto) {
        UIImageWriteToSavedPhotosAlbum(photo, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if(error != NULL){
        NSLog(@"裁剪完成，保存到相册失败");
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"裁剪完成" message:@"已保存到手机相册" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    });
}
- (void)backBtnClick:(UIViewController *)vc {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
