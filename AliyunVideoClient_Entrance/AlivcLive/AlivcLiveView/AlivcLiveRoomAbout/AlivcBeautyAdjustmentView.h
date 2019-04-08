//  美颜调整视图
//  AlivcBeautyAdjustmentView.h
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2018/4/24.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AlivcBeautyParams;

@protocol AlivcBeautyAdjustmentViewDelegate <NSObject>

- (void)publisherOnClickedBeautyButton:(BOOL)beautyOn;

- (void)publisherSliderBeautyWhiteValueChanged:(int)value;

- (void)publisherSliderBeautyBuffingValueChanged:(int)value;

- (void)publisherSliderBeautyRubbyValueChanged:(int)value;

- (void)publisherSliderBeautyCheekPinkValueChanged:(int)value;

- (void)publisherSliderBeautyThinFaceValueChanged:(int)value;

- (void)publisherSliderBeautyShortenFaceValueChanged:(int)value;

- (void)publisherSliderBeautyBigEyeValueChanged:(int)value;

@end

@interface AlivcBeautyAdjustmentView : UIView

@property (nonatomic, weak) id <AlivcBeautyAdjustmentViewDelegate> delegate;

- (void)setOriginValueWithParams:(AlivcBeautyParams *)params;

@end
