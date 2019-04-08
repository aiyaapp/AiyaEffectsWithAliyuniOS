//
//  AlivcMessageInputView.m
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2018/4/24.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import "AlivcMessageInputView.h"
#import "UIColor+AlivcHelper.h"
#import "NSString+AlivcHelper.h"
@interface AlivcMessageInputView()<UITextViewDelegate>
@property (nonatomic, assign) BOOL isUpdateMsg;


@end

@implementation AlivcMessageInputView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init{
    self = [super init];
    if (self) {
        CGFloat height = 35;
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 45);
        self.backgroundColor = [UIColor colorWithHexString:@"#373d41" alpha:0.5];
        CALayer *line = [CALayer layer];
        [line setFrame:CGRectMake(0, 0, self.frame.size.width, 1)];
        line.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:0.5].CGColor;
        [self.layer addSublayer:line];
        //输入框
        _textView = [[UITextView alloc]init];
        _textView.textColor = [UIColor whiteColor];
        _textView.font = [UIFont systemFontOfSize:14];
        _textView.frame = CGRectMake(8, 12.5, [UIScreen mainScreen].bounds.size.width * 0.68, 20);
        _textView.contentInset = UIEdgeInsetsMake(-4.f, 0.f, -8.f, 0.f);
        _textView.backgroundColor = [UIColor clearColor];
        [self addSubview:_textView];
        //发送按钮
        UIButton *sendButton = [[UIButton alloc]init];
        sendButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 75 - 8, 5, 75, height);
        sendButton.backgroundColor = [UIColor colorWithHexString:@"0X00c1de" alpha:1];
        sendButton.layer.masksToBounds = YES;
        sendButton.layer.cornerRadius = 2;
        [sendButton addTarget:self action:@selector(send:) forControlEvents:UIControlEventTouchUpInside];
        [sendButton setTitle:[@"Send" localString] forState:UIControlStateNormal];
        sendButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [self addSubview:sendButton];
    }
    return self;
}



- (void)send:(UIButton *)sender{
    if (self.isUpdateMsg == false) {
        self.isUpdateMsg = true;
        //0.5秒出发一次，多次点击无效；bug：#15183372
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(repeatDelay) object:nil];
        [self performSelector:@selector(repeatDelay) withObject:nil afterDelay:0.5];
        
        if ([self.delegate respondsToSelector:@selector(messageInputView:sendMessage:)]) {
            NSString *mesage = self.textView.text;
            [self.delegate messageInputView:self sendMessage:mesage];
            
            //发送消息后，清空textView信息；bug：#15183418
            self.textView.text = @"";
        }
    }else{
        return;
    }
}



- (void)repeatDelay{
    self.isUpdateMsg = false;
}


@end
