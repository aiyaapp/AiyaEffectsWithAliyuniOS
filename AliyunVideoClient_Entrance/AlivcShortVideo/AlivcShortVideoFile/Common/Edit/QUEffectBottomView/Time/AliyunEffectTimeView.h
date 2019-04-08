//
//  AliyunEffectTimeView.h
//  qusdk
//
//  Created by Worthy on 2018/2/12.
//  Copyright © 2018年 Alibaba Group Holding Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AliyunEffectTimeInfo.h"
#import "AliyunEffectTimeInfo.h"

@protocol AliyunEffectTimeViewDelegate <NSObject>

- (void)timeViewCancelButtonClick;

- (void)timeViewDidSelectEffect:(AliyunEffectTimeInfo *)timeInfo;

- (void)timeViewDidBeganLongPressEffect:(AliyunEffectTimeInfo *)timeInfo;

- (void)timeViewDidEndLongPress;

- (void)timeViewDidRevokeButtonClick;

- (void)timeViewDidTouchingProgress;

@end

@interface AliyunEffectTimeView : UIView
@property (nonatomic, assign) id<AliyunEffectTimeViewDelegate> delegate;

@property (nonatomic, strong) AliyunEffectInfo *selectedEffect;

@end
