//
//  AlivcLiveBeautifySettingsViewController.h
//  AliyunVideoClient_Entrance
//
//  Created by 汪潇翔 on 2018/5/29.
//  Copyright © 2018 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AlivcLiveBeautifySettingsViewController;

@protocol AlivcLiveBeautifySettingsViewControllerDelegate <NSObject>

- (void)settingsViewController:(AlivcLiveBeautifySettingsViewController *)viewController didChangeLevel:(NSInteger)level;

- (void)settingsViewController:(AlivcLiveBeautifySettingsViewController *)viewController didChangeValue:(NSDictionary *)info;

@end

@interface AlivcLiveBeautifySettingsViewController : UIViewController

+ (instancetype)settingsViewControllerWithLevel:(NSInteger)level detailItems:(NSArray<NSDictionary *> *)detailItems;

- (void)updateDetailItems:(NSArray<NSDictionary *> *)detailItems;

@property (nonatomic, weak) id<AlivcLiveBeautifySettingsViewControllerDelegate> delegate;
@property (nonatomic, copy) dispatch_block_t dispearCompletion;
@end
