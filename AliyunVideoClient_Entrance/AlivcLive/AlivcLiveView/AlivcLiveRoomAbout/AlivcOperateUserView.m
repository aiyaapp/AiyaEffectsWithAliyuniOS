//
//  AlivcOperateUserView.m
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2018/5/3.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import "AlivcOperateUserView.h"
#import "AlivcLiveUser.h"
#import "UIImageView+WebCache.h"
#import "NSString+AlivcHelper.h"
@interface AlivcOperateUserView()

@property (nonatomic, strong) AlivcLiveUser *user;
@property (weak, nonatomic) IBOutlet UIView *middleView;
@end

@implementation AlivcOperateUserView

//
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    self.avatarView.layer.cornerRadius = self.avatarView.frame.size.width / 2;
    self.avatarView.clipsToBounds = true;
}


- (IBAction)romoveBtn:(id)sender {
}

- (instancetype)initWithUser:(AlivcLiveUser *)user{
    self = [[NSBundle mainBundle]loadNibNamed:@"AlivcOperateUserView" owner:self options:nil].firstObject;
    if (self) {
        //
        _user = user;
        _avatarView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer* tapGes =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onPressAvater:)];
        tapGes.numberOfTapsRequired =2;
        tapGes.numberOfTouchesRequired =1;
        [_avatarView addGestureRecognizer:tapGes];

        [self configBaseUI];
    }
    return self;
}

- (void)onPressAvater:(UILongPressGestureRecognizer *)gesture{
    // 将userId复制到剪切板
#if DEBUG
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = self.user.userId;
    });
#endif
}

- (void)configBaseUI{
    self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    [self.avatarView sd_setImageWithURL:[NSURL URLWithString:self.user.avatarUrlString ?:@""] placeholderImage:[UIImage imageNamed:@"test_avator_boy"]];
    self.nickNameLabel.text = self.user.nickname;
    if (self.user.userId) {
        self.idLabel.text = [NSString stringWithFormat:@"ID:%@",self.user.userId];
    }else{
        self.idLabel.text = @"ID Null";
    }

    
    [self.forbidButton setTitle:[@"Mute" localString] forState:UIControlStateNormal];
    [self.forbidButton setTitle:[@"Lift the ban" localString] forState:UIControlStateSelected];
    self.forbidButton.selected = self.user.forbided;
    
    [self.kickoutButton setTitle:[@"Remove User" localString] forState:UIControlStateNormal];
    [self.kickoutButton setTitle:[@"解除踢出" localString] forState:UIControlStateSelected];
    self.kickoutButton.selected = self.user.kickedout;
    
    [self.blackListButton setTitle:[@"Blacklist" localString] forState:UIControlStateNormal];
    [self.blackListButton setTitle:[@"Lift Blacklist" localString] forState:UIControlStateSelected];
    self.blackListButton.selected = self.user.blackList;
}

- (IBAction)silentButtonTouched:(id)sender {
    if ([self.delegate respondsToSelector:@selector(operateUserView:user:operateType:)]) {
        [self.delegate operateUserView:self user:self.user operateType:AlivcOperateUserTypeSilent];
    }
}
- (IBAction)kickoutButtonTouched:(id)sender {
    if ([self.delegate respondsToSelector:@selector(operateUserView:user:operateType:)]) {
        [self.delegate operateUserView:self user:self.user operateType:AlivcOperateUserTypeKickout];
    }
}

- (IBAction)blacklistButtonTouched:(id)sender {
    if ([self.delegate respondsToSelector:@selector(operateUserView:user:operateType:)]) {
        [self.delegate operateUserView:self user:self.user operateType:AlivcOperateUserTypeBlacklist];
    }
}

- (IBAction)cancelButtonTouched:(id)sender {
    if ([self.delegate respondsToSelector:@selector(cancelOperateUserView:)]) {
        [self.delegate cancelOperateUserView:self];
    }
}


- (void)showInView:(UIView *)view{
    [view addSubview:self];
    self.center = CGPointMake(view.frame.size.width / 2, view.frame.size.height / 2);
}

- (void)dismiss{
    [self removeFromSuperview];
}

@end
