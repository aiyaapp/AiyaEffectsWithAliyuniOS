//
//  AliyunEffectTimeFilterView.m
//  qusdk
//
//  Created by Vienta on 2018/2/26.
//  Copyright © 2018年 Alibaba Group Holding Limited. All rights reserved.
//

#import "AliyunEffectTimeFilterView.h"

@implementation AliyunEffectTimeFilterView
{
    UIButton *_momentButton;
    UIButton *_wholeButton;
    UIButton *_noneButton;
    UILabel *_noneLabel;
    UIButton *_slowButton;
    UILabel *_slowLabel;
    UIButton *_fastButton;
    UILabel *_fastLabel;
    UIButton *_backRunButton;
    UILabel *_backRunLabel;
    UIButton *_repeatButton;
    UILabel *_repeatLabel;
    UIButton *_effectSelectButton;
    UIButton *_typeSelectButton;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = RGBToColor(27, 33, 51);
        [self addSubViews];
    }
    return self;
}

- (void)addSubViews {
    _noneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _slowButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _fastButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _repeatButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _backRunButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    NSArray *buttons = @[_noneButton, _slowButton, _fastButton, _repeatButton, _backRunButton];
    NSArray *buttonNormalImages = @[@"QPSDK.bundle/time_filter_none_normal.png",
                                     @"QPSDK.bundle/time_filter_slow_normal.png",
                                     @"QPSDK.bundle/time_filter_fast_normal.png",
                                     @"QPSDK.bundle/time_filter_repeat_normal.png",
                                     @"QPSDK.bundle/time_filter_backrun_normal.png"];
    
    NSArray *buttonSelectImages = @[@"QPSDK.bundle/time_filter_none_select.png",
                                     @"QPSDK.bundle/time_filter_slow_select.png",
                                     @"QPSDK.bundle/time_filter_fast_select.png",
                                     @"QPSDK.bundle/time_filter_repeat_select.png",
                                     @"QPSDK.bundle/time_filter_backrun_select.png"];
    
    NSArray *buttonActions = @[@"noneButtonClicked:",
                               @"slowButtonClicked:",
                               @"fastButtonClicked:",
                               @"repeatButtonClicked:",
                               @"backrunButtonClicked:"];
    
    float dlt = (ScreenWidth - 40 - 40 * 4) / 3;
    float centerX[] = {40.0, 80.0 + dlt, 120.0 + 2 * dlt, 160.0 + 3 * dlt, 160.0 + 3 * dlt};
    float centerY = 44;
    
    for (int i = 0; i < [buttons count]; i++) {
        UIButton *btn = buttons[i];
        btn.bounds = CGRectMake(0, 0, 40, 40);
        btn.center = CGPointMake(centerX[i], centerY);
        [btn setImage:[UIImage imageNamed:buttonNormalImages[i]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:buttonSelectImages[i]] forState:UIControlStateSelected];
        
        SEL action = NSSelectorFromString(buttonActions[i]);
        [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
    
    _noneLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
    _slowLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
    _fastLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
    _repeatLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
    _backRunLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
    float labelCenterY = 76;
    
    NSArray *labels = @[_noneLabel, _slowLabel, _fastLabel, _repeatLabel, _backRunLabel];
    NSArray *labelTitles = @[@"无", @"慢速", @"快速", @"反复", @"倒放"];
    for (int i = 0; i < [labels count]; i++) {
        UILabel *label = labels[i];
        label.center = CGPointMake(centerX[i], labelCenterY);
        [label setText:labelTitles[i]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setTextColor:[UIColor whiteColor]];
        [label setFont:[UIFont systemFontOfSize:12]];
        [self addSubview:label];
    }
    
    CGFloat height = 34;
    _momentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _momentButton.bounds = CGRectMake(0, 0, 60, height);
    _momentButton.center = CGPointMake(CGRectGetMidX(self.bounds) - 35, CGRectGetHeight(self.bounds) - height/2);
    [_momentButton setTitle:@"某刻" forState:UIControlStateNormal];
    [_momentButton addTarget:self action:@selector(momentButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_momentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [_momentButton setTitleColor:rgba(110, 118, 139, 1) forState:UIControlStateNormal];
    [self addSubview:_momentButton];
    
    _wholeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _wholeButton.bounds = CGRectMake(0, 0, 60, height);
    _wholeButton.center = CGPointMake(CGRectGetMidX(self.bounds) + 35, CGRectGetHeight(self.bounds) - height/2);
    [_wholeButton setTitle:@"全程" forState:UIControlStateNormal];
    [_wholeButton addTarget:self action:@selector(wholeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_wholeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [_wholeButton setTitleColor:rgba(110, 118, 139, 1) forState:UIControlStateNormal];
    [self addSubview:_wholeButton];
    
    self.type = TimeFilterButtonTypeMoment;
    [self typeButtonSelected:_momentButton];
}

- (void)setType:(TimeFilterButtonType)type
{
    _type = type;
    if (_type == TimeFilterButtonTypeWhole) {
        _backRunButton.hidden = _backRunLabel.hidden = NO;
        _repeatButton.hidden = _repeatLabel.hidden = YES;
    } else {
        _backRunButton.hidden = _backRunLabel.hidden = YES;
        _repeatButton.hidden = _repeatLabel.hidden = NO;
    }
}

- (void)momentButtonClick:(id)sender
{
    self.type = TimeFilterButtonTypeMoment;
    [self typeButtonSelected:sender];
    _effectSelectButton.selected = NO;
}

- (void)wholeButtonClick:(id)sender
{
    self.type = TimeFilterButtonTypeWhole;
    [self typeButtonSelected:sender];
    _effectSelectButton.selected = NO;
}

- (void)noneButtonClicked:(id)sender
{
    [_delegate didSelectNone];
    [self buttonSelected:sender];
}

- (void)slowButtonClicked:(id)sender
{
    [self buttonSelected:sender];
    if (_type == TimeFilterButtonTypeWhole) {
        [_delegate didSelectWholeSlow];
    } else {
        [_delegate didSelectMomentSlow];
    }
}

- (void)fastButtonClicked:(id)sender
{
    [self buttonSelected:sender];
    if (_type == TimeFilterButtonTypeWhole) {
        [_delegate didSelectWholeFast];
    } else {
        [_delegate didSelectMomentFast];
    }
}

- (void)repeatButtonClicked:(id)sender
{
    [self buttonSelected:sender];
    [_delegate didSelectRepeat];
}

- (void)backrunButtonClicked:(id)sender
{
    [self buttonSelected:sender];
    [_delegate didSelectInvert];
}

- (void)buttonSelected:(UIButton *)button {
    _effectSelectButton.selected = NO;
    _effectSelectButton = button;
    _effectSelectButton.selected = YES;
}

- (void)typeButtonSelected:(UIButton *)button {
    _typeSelectButton.selected = NO;
    _typeSelectButton = button;
    _typeSelectButton.selected = YES;
}

- (void)reset {
    _effectSelectButton.selected = NO;
}

@end
