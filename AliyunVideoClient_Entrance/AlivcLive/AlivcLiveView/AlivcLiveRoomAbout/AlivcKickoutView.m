//
//  AlivcKickoutView.m
//  AliyunVideoClient_Entrance
//
//  Created by jiangsongwen on 2018/5/31.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import "AlivcKickoutView.h"
#import "UIColor+AlivcHelper.h"
#import "NSString+AlivcHelper.h"
@interface AlivcKickoutView ()
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIButton *okBtn;
@property (nonatomic, strong) UIView *blackView;
@end

@implementation AlivcKickoutView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:CGRectMake(0, 0, 300, 356/2)];
    self.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2-64);
    if (self) {
        [self addSubview:self.icon];
        [self addSubview:self.messageLabel];
        [self addSubview:self.okBtn];
        self.backgroundColor = [UIColor colorWithHexString:@"#373d41"];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 5;
    }
    return self;
}

- (UIImageView *)icon{
    if (_icon == nil) {
        _icon = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width/2-20, 20, 40, 40)];
//        _icon.backgroundColor = [UIColor redColor];
        _icon.image = [UIImage imageNamed:@"avcPromptWarning"];
    }
    return _icon;
}

- (UILabel *)messageLabel{
    if (_messageLabel == nil) {
        _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, self.icon.frame.origin.y+self.icon.frame.size.height+12, self.frame.size.width-24, 40)];
        _messageLabel.text = [@"You have been removed from the room by the caster" localString];
        _messageLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
        _messageLabel.font = [UIFont systemFontOfSize:16];
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.numberOfLines = 0;
    }
    return _messageLabel;
}

- (UIButton *)okBtn{
    if (_okBtn == nil) {
        _okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_okBtn setFrame:CGRectMake(0, self.frame.size.height-44, self.frame.size.width, 44)];
        [_okBtn setTitle:[@"OK" localString] forState:UIControlStateNormal];
        [_okBtn setTitleColor:[UIColor colorWithHexString:@"#00c1de"] forState:UIControlStateNormal];
        _okBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_okBtn addTarget:self action:@selector(ok) forControlEvents:UIControlEventTouchUpInside];
        CALayer *line = [CALayer layer];
        [line setFrame:CGRectMake(0, 0, _okBtn.frame.size.width, 0.5)];
        [line setBackgroundColor:[UIColor colorWithHexString:@"#979797"].CGColor];
        [_okBtn.layer addSublayer:line];
    }
    return _okBtn;
}

- (UIView *)blackView{
    if (_blackView == nil) {
        _blackView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _blackView.backgroundColor = [UIColor colorWithHexString:@"0X000000" alpha:0.5];
    }
    return _blackView;
}

- (void)ok{
    [self.blackView removeFromSuperview];
    [self removeFromSuperview];
}

- (void)showInView:(UIView *)view{
    [view addSubview:self.blackView];
    [view addSubview:self];
}


@end
