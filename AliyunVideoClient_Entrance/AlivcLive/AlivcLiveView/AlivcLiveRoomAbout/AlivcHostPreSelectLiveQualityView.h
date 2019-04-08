//  主播预览视图的选择清晰度
//  AlivcHostPreSelectLiveQualityView.h
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2018/5/2.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 直播质量

 - AVCLiveQualityHD: 超清
 - AVCLiveQualitySD: 高清
 - AVCLiveQualityLD: 标清
 - AVCLiveQualityFD: 流畅
 */
typedef NS_ENUM(NSInteger,AlivcLiveQuality) {
    AlivcLiveQualityHD,
    AlivcLiveQualitySD,
    AlivcLiveQualityLD,
    AlivcLiveQualityFD,
};

@class AlivcHostPreSelectLiveQualityView;

@protocol AlivcHostPreSelectLiveQualityViewDelegate <NSObject>

- (void)hostPreSelectLiveQualityView:(AlivcHostPreSelectLiveQualityView *)view haveSelectQuality:(AlivcLiveQuality)quality;

@end

@interface AlivcHostPreSelectLiveQualityView : UIView
/**
 视频质量
 */
@property (nonatomic,   assign) AlivcLiveQuality selectLiveQuality;

@property (nonatomic, weak) id  <AlivcHostPreSelectLiveQualityViewDelegate> delegate;

@end
