//
//  AliyunMediator.m
//  AliyunVideo
//
//  Created by Worthy on 2017/5/4.
//  Copyright © 2017年 Alibaba Group Holding Limited. All rights reserved.
//

#import "AliyunMediator.h"
#import "AliyunConfigureViewController.h"

NSString *const AliyunShortVideoModuleString_VideoShooting = @"AliyunShortVideoModuleString_VideoShooting";
NSString *const AliyunShortVideoModuleString_VideoEdit = @"AliyunShortVideoModuleString_VideoEdit";
NSString *const AliyunShortVideoModuleString_VideoClip = @"AliyunShortVideoModuleString_VideoClip";
NSString *const AliyunShortVideoModuleString_MagicCamera = @"AliyunShortVideoModuleString_MagicCamera";

@implementation AliyunMediator

+ (instancetype)shared {
    static AliyunMediator *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[AliyunMediator alloc] init];
    });
    return instance;
}

- (void)pushWithModuleString:(NSString *)moduleString nav:(UINavigationController *)nav{
    if ([moduleString isEqualToString:AliyunShortVideoModuleString_VideoShooting]) {
        UIViewController *vc = [self recordModule];
        [nav pushViewController:vc animated:YES];
        return;
    }
    if ([moduleString isEqualToString:AliyunShortVideoModuleString_VideoEdit]) {
        AliyunConfigureViewController *vc = [[AliyunConfigureViewController alloc] init];
        vc.isClipConfig = NO;
        [nav pushViewController:vc animated:YES];
        return;
    }
    if ([moduleString isEqualToString:AliyunShortVideoModuleString_VideoClip]) {
        AliyunConfigureViewController *vc = [[AliyunConfigureViewController alloc] init];
        vc.isClipConfig = YES;
        [nav pushViewController:vc animated:YES];
        return;
    }
    if ([moduleString isEqualToString:AliyunShortVideoModuleString_MagicCamera]) {
        UIViewController *vc = [self magicCameraModule];
        [nav pushViewController:vc animated:YES];
        return;
    }
}

#pragma mark - module

- (UIViewController *)recordModule {
    Class c = NSClassFromString(@"AliyunRecordParamViewController");
    UIViewController *vc = (UIViewController *)[[c alloc] init];
    return vc;
}


- (UIViewController *)magicCameraModule {
    Class c = NSClassFromString(@"AliyunMagicCameraViewController");
    UIViewController *vc = (UIViewController *)[[c alloc] init];
    return vc;
}

- (UIViewController *)editModule {
    Class c = NSClassFromString(@"AliyunCompositionViewController");
    UIViewController *vc = (UIViewController *)[[c alloc] init];
    return vc;
}

- (UIViewController *)cropModule {
    Class c = NSClassFromString(@"AliyunPhotoViewController");
    UIViewController *vc = (UIViewController *)[[c alloc] init];
    return vc;
}

-(UIViewController *)liveModule {
    return nil;
}

-(UIViewController *)uiComponentModule {
    Class c = NSClassFromString(@"AliyunComponentViewController");
    UIViewController *vc = (UIViewController *)[[c alloc] init];
    return vc;
}

#pragma mark - vc

- (UIViewController *)recordViewController {
    Class c = NSClassFromString(@"AliyunRecordViewController");
    UIViewController *vc = (UIViewController *)[[c alloc] init];
    return vc;
}

- (UIViewController *)compositionViewController {
    Class c = NSClassFromString(@"AliyunCompositionViewController");
    UIViewController *vc = (UIViewController *)[[c alloc] init];
    return vc;
}

- (UIViewController *)editViewController {
    Class c = NSClassFromString(@"AliyunEditViewController");
    UIViewController *vc = (UIViewController *)[[c alloc] init];
    return vc;
}

- (UIViewController *)cropViewController {
    Class c = NSClassFromString(@"AliyunCropViewController");
    UIViewController *vc = (UIViewController *)[[c alloc] init];
    return vc;
}

- (UIViewController *)configureViewController {
    Class c = NSClassFromString(@"AliyunConfigureViewController");
    UIViewController *vc = (UIViewController *)[[c alloc] init];
    return vc;
}

- (UIViewController *)photoViewController {
    Class c = NSClassFromString(@"AliyunPhotoViewController");
    UIViewController *vc = (UIViewController *)[[c alloc] init];
    return vc;
}

@end
