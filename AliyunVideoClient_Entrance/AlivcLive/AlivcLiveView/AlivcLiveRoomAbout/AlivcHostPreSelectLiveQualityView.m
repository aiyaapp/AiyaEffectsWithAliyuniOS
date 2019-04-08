//
//  AlivcHostPreSelectLiveQualityView.m
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2018/5/2.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import "AlivcHostPreSelectLiveQualityView.h"
#import "NSString+AlivcHelper.h"

@interface AlivcHostPreSelectLiveQualityView()

@property (nonatomic, strong) UIButton *HDButton;
@property (nonatomic, strong) UIButton *SDButton;
@property (nonatomic, strong) UIButton *LDButton;
@property (nonatomic, strong) UIButton *FDButton;


/**
 箭头
 */
@property (nonatomic, strong) UIImageView *selecteImageView;
@end

@implementation AlivcHostPreSelectLiveQualityView

- (instancetype)init{
    self = [super init];
    if (self) {
        //
        [self configBaseUI];
        //默认标清。bug：#15179056 /2018/05/15/16.11
        self.selectLiveQuality = AlivcLiveQualityLD;
        [UIView performWithoutAnimation:^{
            [self refshUIStatus];
        }];
    }
    return self;
}

- (void)configBaseUI{
    NSInteger buttonsCount = [self buttonArray].count;
    self.frame = CGRectMake(0, 0,buttonsCount  * 70, 22 + 8 + 8);
    CGFloat iWidth = self.frame.size.width / buttonsCount;
    for (UIButton *button in [self buttonArray]) {
        [self configQualityButton:button];
        [self addSubview:button];
        NSInteger index = [[self buttonArray]indexOfObject:button];
        CGFloat cx = (index + 0.5) * iWidth;
        button.center = CGPointMake(cx, button.frame.size.height / 2);
    }
    //箭头
    [self addSubview:self.selecteImageView];
    
}

- (UIImageView *)selecteImageView{
    if (!_selecteImageView) {
        
        _selecteImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"AlivcUpArrow"]];
    }
    return _selecteImageView;
}

- (UIButton *)HDButton{
    if (!_HDButton) {
        _HDButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _HDButton.tag = 0;
        [_HDButton addTarget:self action:@selector(qualityButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
        
        [_HDButton setTitle:[@"超清" localString] forState:UIControlStateNormal];
        [_HDButton setTitle:[@"超清" localString] forState:UIControlStateSelected];
    }
    return _HDButton;
}

- (UIButton *)SDButton{
    if (!_SDButton) {
        _SDButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _SDButton.tag = 1;
        [_SDButton addTarget:self action:@selector(qualityButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
        [_SDButton setTitle:[@"HD" localString] forState:UIControlStateNormal];
        [_SDButton setTitle:[@"HD" localString] forState:UIControlStateSelected];
    }
    return _SDButton;
}

- (UIButton *)LDButton{
    if (!_LDButton) {
        _LDButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _LDButton.tag = 2;
        [_LDButton addTarget:self action:@selector(qualityButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
        
        [_LDButton setTitle:[@"SD" localString] forState:UIControlStateNormal];
        [_LDButton setTitle:[@"SD" localString] forState:UIControlStateSelected];
    }
    return _LDButton;
}

- (UIButton *)FDButton{
    if (!_FDButton) {
        _FDButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _FDButton.tag = 3;
        [_FDButton addTarget:self action:@selector(qualityButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
        [_FDButton setTitle:[@"Smooth" localString] forState:UIControlStateNormal];
        [_FDButton setTitle:[@"Smooth" localString] forState:UIControlStateSelected];
    }
    return _FDButton;
}

- (void)configQualityButton:(UIButton *)button{
    button.frame = CGRectMake(0, 0, 30, 30);
    [button sizeToFit];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
}

- (void)qualityButtonTouched:(UIButton *)button{
    switch (button.tag) {
        case 0:
            self.selectLiveQuality = AlivcLiveQualityHD;
            break;
        case 1:
            self.selectLiveQuality = AlivcLiveQualitySD;
            break;
        case 2:
            self.selectLiveQuality = AlivcLiveQualityLD;
            break;
        case 3:
            self.selectLiveQuality = AlivcLiveQualityFD;
            break;
            
        default:
            break;
    }
    [self refshUIStatus];
    if ([self.delegate respondsToSelector:@selector(hostPreSelectLiveQualityView:haveSelectQuality:)]) {
        [self.delegate hostPreSelectLiveQualityView:self haveSelectQuality:self.selectLiveQuality];
    }
}

- (void)refshUIStatus{
    for (UIButton *button in [self buttonArray]) {
        button.selected = false;
    }
    switch (self.selectLiveQuality) {
        case AlivcLiveQualityHD:
            [self setButton:_HDButton selected:true];
            break;
        case AlivcLiveQualityFD:
            [self setButton:_FDButton selected:true];
            break;
        case AlivcLiveQualityLD:
            [self setButton:_LDButton selected:true];
            break;
        case AlivcLiveQualitySD:
            [self setButton:_SDButton selected:true];
            break;
            
        default:
            break;
    }
}

- (NSArray <UIButton *>*)buttonArray{
    return @[self.FDButton,self.LDButton,self.SDButton];
}

/**
 设置button的选中状态
 
 @param button button
 @param selected 选中状态
 */
- (void)setButton:(UIButton *)button selected:(BOOL )selected{
    button.selected = true;
    //移动箭头
    CGFloat cx = button.center.x;
    CGFloat cy = CGRectGetMaxY(button.frame) + 10;
    [UIView animateWithDuration:0.3 animations:^{
        _selecteImageView.center = CGPointMake(cx, cy);
    }];
}

@end
