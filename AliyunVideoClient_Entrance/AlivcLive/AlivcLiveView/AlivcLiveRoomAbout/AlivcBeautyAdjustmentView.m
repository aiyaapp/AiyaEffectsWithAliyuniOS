//
//  AlivcBeautyAdjustmentView.m
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2018/4/24.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import "AlivcBeautyAdjustmentView.h"
#import <AlivcInteractiveLiveRoomSDK/AlivcInteractiveLiveRoomSDK.h>
@interface AlivcBeautyAdjustmentView()

@property (nonatomic, strong) NSMutableArray *sliderArray;

@end


@implementation AlivcBeautyAdjustmentView

- (instancetype)init{
    self = [super init];
    if (self) {
        //
        [self configBaseUI];
    }
    return self;
}


- (void)configBaseUI{
    
    self.sliderArray = [[NSMutableArray alloc]init];
    
    CGFloat retractX = 7;
    
    CGFloat sliderCount = 7;
    
    CGFloat height = [UIScreen mainScreen].bounds.size.height * 0.5;
    
    self.frame = CGRectMake(8, ScreenHeight - height - 60, ScreenWidth - 8 * 2, height);

    
    self.backgroundColor = AlivcRGBA(1, 1, 1, 0.3);
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 10;
    
    UIButton *beautyButton = [self setupButtonWithFrame:(CGRectMake(0, 100, 100, 50))
                                            normalTitle:NSLocalizedString(@"beauty_on", nil)
                                            selectTitle:NSLocalizedString(@"beauty_off", nil)
                                                 action:@selector(beautyButtonAction:)];
    
    [beautyButton setSelected:YES];
    [self addSubview:beautyButton];
    [beautyButton setSelected:true];
    
    
    CGFloat labelX = CGRectGetMaxX(beautyButton.frame) + retractX;
    CGFloat labelWidth = 46;
    CGFloat sliderX = CGRectGetMaxX(beautyButton.frame) + labelWidth + retractX * 2;
    CGFloat sliderWidth = CGRectGetWidth(self.frame) - sliderX - retractX;
    CGFloat adjustHeight = (CGRectGetHeight(self.frame) - retractX * (sliderCount - 1)) / sliderCount                                                                                                                                                                               ;
    
    
    NSArray *labelNameArray = @[NSLocalizedString(@"beauty_skin_smooth", nil),NSLocalizedString(@"beauty_white", nil),NSLocalizedString(@"beauty_ruddy", nil),NSLocalizedString(@"beauty_cheekpink", nil),NSLocalizedString(@"beauty_thinface", nil),NSLocalizedString(@"beauty_shortenface", nil),NSLocalizedString(@"beauty_bigeye", nil)];
    NSArray *sliderActionArray = @[@"buffingValueChange:",@"whiteValueChange:", @"ruddyValueChange:",@"cheekPinkValueChange:",@"thinfaceValueChange:",@"shortenfaceValueChange:",@"bigeyeValueChange:"];
    
 
    
    
    for (int index = 0; index < sliderCount; index++) {
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(labelX, retractX * (index + 1) + adjustHeight * index, labelWidth, adjustHeight);
        label.font = [UIFont systemFontOfSize:14.f];
        label.text = labelNameArray[index];
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.numberOfLines = 0;
        label.textColor = [UIColor whiteColor];
        [self addSubview:label];
        
        UISlider *slider = [[UISlider alloc] init];
        slider.frame = CGRectMake(sliderX, retractX * (index + 1) + adjustHeight * index, sliderWidth, adjustHeight);
        [slider addTarget:self action:NSSelectorFromString(sliderActionArray[index]) forControlEvents:(UIControlEventValueChanged)];
        slider.maximumValue = 100;
        slider.minimumValue = 0;
        slider.value = 25;
        slider.tag = index;
        [self addSubview:slider];
        [self.sliderArray addObject:slider];
    }
}

- (UIButton *)setupButtonWithFrame:(CGRect)rect normalTitle:(NSString *)normal selectTitle:(NSString *)select action:(SEL)action {
    
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    button.frame = rect;
    [button addTarget:self action:action forControlEvents:(UIControlEventTouchUpInside)];
    [button setTitle:normal forState:(UIControlStateNormal)];
    [button setTitle:select forState:(UIControlStateSelected)];
    [button setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    button.titleLabel.font = [UIFont systemFontOfSize:13.f];
    button.backgroundColor = [UIColor whiteColor];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = rect.size.height / 5;
    return button;
}

- (void)setOriginValueWithParams:(AlivcBeautyParams *)params{
    for (int index = 0; index < self.sliderArray.count; index ++) {
        UISlider *slider = self.sliderArray[index];
        switch (index) {
            case 0:
                slider.value = params.beautyBuffing;
                break;
            case 1:
                slider.value = params.beautyWhite;
                break;
            case 2:
                slider.value = params.beautyRuddy;
                break;
            case 3:
                slider.value = params.beautyCheekPink;
                break;
            case 4:
                slider.value = params.beautySlimFace;
                break;
            case 5:
                slider.value = params.beautyShortenFace;
                break;
            case 6:
                slider.value = params.beautyBigEye;
                break;
                
            default:
                break;
        }
    }
}

#pragma mark - Delegate

- (void)beautyButtonAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if ([self.delegate respondsToSelector:@selector(publisherOnClickedBeautyButton:)]) {
        [self.delegate publisherOnClickedBeautyButton:sender.selected];
    }
}


- (void)buffingValueChange:(UISlider *)slider {
    
    if ([self.delegate respondsToSelector:@selector(publisherSliderBeautyBuffingValueChanged:)]) {
        [self.delegate publisherSliderBeautyBuffingValueChanged:(int)slider.value];
    }
}

- (void)whiteValueChange:(UISlider *)slider {
    
    if ([self.delegate respondsToSelector:@selector(publisherSliderBeautyWhiteValueChanged:)]) {
        [self.delegate publisherSliderBeautyWhiteValueChanged:(int)slider.value];
    }
}



- (void)ruddyValueChange:(UISlider *)slider {
    
    if ([self.delegate respondsToSelector:@selector(publisherSliderBeautyRubbyValueChanged:)]) {
        [self.delegate publisherSliderBeautyRubbyValueChanged:(int)slider.value];
    }
}

- (void)cheekPinkValueChange:(UISlider *)slider {
    
    if ([self.delegate respondsToSelector:@selector(publisherSliderBeautyCheekPinkValueChanged:)]) {
        [self.delegate publisherSliderBeautyCheekPinkValueChanged:(int)slider.value];
    }
}

- (void)thinfaceValueChange:(UISlider *)slider {
    
    if ([self.delegate respondsToSelector:@selector(publisherSliderBeautyThinFaceValueChanged:)]) {
        [self.delegate publisherSliderBeautyThinFaceValueChanged:(int)slider.value];
    }
}

- (void)shortenfaceValueChange:(UISlider *)slider {
    
    if ([self.delegate respondsToSelector:@selector(publisherSliderBeautyShortenFaceValueChanged:)]) {
        [self.delegate publisherSliderBeautyShortenFaceValueChanged:(int)slider.value];
    }
}

- (void)bigeyeValueChange:(UISlider *)slider {
    
    if ([self.delegate respondsToSelector:@selector(publisherSliderBeautyBigEyeValueChanged:)]) {
        [self.delegate publisherSliderBeautyBigEyeValueChanged:(int)slider.value];
    }
}

@end
