//  消息输入视图
//  AlivcMessageInputView.h
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2018/4/24.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AlivcMessageInputView;

@protocol AlivcMessageInputViewDelegate <NSObject>

- (void)messageInputView:(AlivcMessageInputView *)view sendMessage:(NSString *)message;

@end

@interface AlivcMessageInputView : UIView

@property (nonatomic, strong) UITextView *textView;

@property (weak, nonatomic) id <AlivcMessageInputViewDelegate> delegate;

@end
