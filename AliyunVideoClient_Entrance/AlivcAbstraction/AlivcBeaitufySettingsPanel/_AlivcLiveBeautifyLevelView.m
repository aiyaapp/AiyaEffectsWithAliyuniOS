//
//  _AlivcLiveBeautifyLevelView.m
//  BeautifySettingsPanel
//
//  Created by 汪潇翔 on 2018/5/29.
//  Copyright © 2018 汪潇翔. All rights reserved.
//

#import "_AlivcLiveBeautifyLevelView.h"
#import "_AlivcLiveBeautifyNavigationView.h"
#import "NSString+AlivcHelper.h"

static const CGFloat AlivcLiveButtonWidth = 45.0f;

@implementation _AlivcLiveBeautifyLevelView {
    _AlivcLiveBeautifyNavigationView *_navigationView;
    NSArray<UIButton *> *_buttons;
    UIView *_buttonsContentView;
    __weak UIButton *_selectedButton;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _level = 0;
        
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        
        UIButton *titleButton = [[UIButton alloc] init];
        [titleButton setImage:[UIImage imageNamed:@"AlivcIconBeauty"] forState:UIControlStateNormal];
        [titleButton setTitle:[NSString stringWithFormat:@"  %@",[@"Face Filter" localString]] forState:UIControlStateNormal];
        titleButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        titleButton.frame = CGRectMake(0, 0, 120, 44);
        
        _navigationView = [_AlivcLiveBeautifyNavigationView navigationViewTitleView:titleButton];
        [self addSubview:_navigationView];
        
        _buttonsContentView = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:_buttonsContentView];
        _buttons  = [self _buttonsWithCount:6];
        
        UIButton *button = _buttons[_level];
        button.selected = YES;
        _selectedButton = button;
    }
    return self;
}

- (NSArray<UIButton *> *)_buttonsWithCount:(NSInteger)count {
    NSMutableArray<UIButton *> *array = [NSMutableArray arrayWithCapacity:count];
    for (NSInteger index = 0; index < count; index++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, AlivcLiveButtonWidth, AlivcLiveButtonWidth);
        button.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2f];
        button.layer.cornerRadius = AlivcLiveButtonWidth * 0.5;
        
        [button setTitle:@(index).stringValue forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"bg_btn_image"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"bg_btn_image_selected"] forState:UIControlStateNormal | UIControlStateSelected];
        
        [button addTarget:self action:@selector(_levelButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [array addObject:button];
        [_buttonsContentView addSubview:button];
    }
    return [array copy];
}

- (_AlivcLiveBeautifyNavigationView *)navigationView {
    return _navigationView;
}

- (void)layoutSubviews {
    _navigationView.frame =
        CGRectMake(0, 0, CGRectGetWidth(self.bounds), 44.f);
    
    _buttonsContentView.frame = CGRectMake(15.f,
                                           CGRectGetMaxY(_navigationView.frame),
                                           CGRectGetWidth(self.bounds) - 15 * 2,
                                           CGRectGetHeight(self.bounds) - CGRectGetMaxY(_navigationView.frame));
    
    CGFloat buttonsContentWidth = CGRectGetWidth(_buttonsContentView.frame);
    CGFloat buttonsContentHeight =  CGRectGetHeight(_buttonsContentView.frame);
    CGFloat buttonsInterval = (buttonsContentWidth - AlivcLiveButtonWidth * _buttons.count) / (_buttons.count - 1);
    CGFloat buttonY = (buttonsContentHeight - AlivcLiveButtonWidth) * 0.5;
    CGFloat buttonX = 0;
    for (UIButton *button in _buttons) {
        CGRect frame = button.frame;
        frame.origin.x = buttonX;
        frame.origin.y = buttonY;
        button.frame = frame;
        buttonX = CGRectGetMaxX(frame) + buttonsInterval;
        
    }
}

- (void)setLevel:(NSInteger)level {
    if (_level != level) {
        _level = level;
        UIButton *button = _buttons[level];
        button.selected = YES;
        _selectedButton.selected = NO;
        _selectedButton = button;
    }
}


- (void)_levelButtonOnClick:(UIButton *)sender {
    if(sender.selected) return;
    sender.selected = YES;
    _selectedButton.selected = NO;
    _selectedButton = sender;
    if (self.delegate && [self.delegate respondsToSelector:@selector(levelView:didChangeLevel:)]) {
        [self.delegate levelView:self didChangeLevel:[_buttons indexOfObject:sender]];
    }
}

@end
