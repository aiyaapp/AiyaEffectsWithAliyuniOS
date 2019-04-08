//
//  AliyunEffectTimeFilterView.h
//  qusdk
//
//  Created by Vienta on 2018/2/26.
//  Copyright © 2018年 Alibaba Group Holding Limited. All rights reserved.
//  时间特效View

#import <UIKit/UIKit.h>

@protocol AliyunEffectTimeFilterDelegate <NSObject>

- (void)didSelectNone;
- (void)didSelectMomentSlow;
- (void)didSelectWholeSlow;
- (void)didSelectMomentFast;
- (void)didSelectWholeFast;
- (void)didSelectRepeat;//反复
- (void)didSelectInvert;//倒放

@end

typedef enum : NSUInteger {
    TimeFilterButtonTypeMoment = 0, //某刻
    TimeFilterButtonTypeWhole, //全程
} TimeFilterButtonType;

@interface AliyunEffectTimeFilterView : UIView

@property (nonatomic, assign) TimeFilterButtonType type;
@property (nonatomic, weak) id<AliyunEffectTimeFilterDelegate> delegate;

- (void)reset;

@end
