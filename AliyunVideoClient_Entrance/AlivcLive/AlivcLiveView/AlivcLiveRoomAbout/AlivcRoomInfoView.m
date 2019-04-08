//
//  AlivcRoomInfoView.m
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2018/5/3.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import "AlivcRoomInfoView.h"
#import "AlivcLiveUser.h"
#import "UIImageView+WebCache.h"

@interface AlivcRoomInfoView()





@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;

@property (weak, nonatomic) IBOutlet UILabel *viewAudienceCountLabel;

@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;

@property (nonatomic, strong) AlivcLiveUser *hostUser;

@property (nonatomic, assign) NSInteger likeCount;

@end

@implementation AlivcRoomInfoView

- (instancetype)initWithHost:(AlivcLiveUser *)host{
    self = [[NSBundle mainBundle]loadNibNamed:@"AlivcRoomInfoView" owner:self options:nil].firstObject;
    if (self) {
        self.frame = CGRectMake(0, 0, 135, 74);
        _hostUser = host;
        [self configBaseUI];
    }
    return self;
}

- (void)configBaseUI{
    self.avatarImageView.image = self.hostUser.avatar;
    self.nicknameLabel.text = self.hostUser.nickname;
    
    [self updateViewAudienceCount:0];
    [self updateLikeCount:0];
}

- (void)refreshUIWithHost:(AlivcLiveUser *)host{
    _hostUser = host;
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:self.hostUser.avatarUrlString ?:@"" ] placeholderImage:[UIImage imageNamed:@"test_avator_boy"]];
    self.nicknameLabel.text = self.hostUser.nickname;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    self.avatarContainView.layer.cornerRadius = self.avatarContainView.frame.size.height / 2;
    self.avatarContainView.clipsToBounds = true;
    
    self.likeCountContainView.layer.cornerRadius = self.likeCountContainView.frame.size.height / 2;
    self.likeCountContainView.clipsToBounds = true;
    
    self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.size.height / 2;
    self.avatarImageView.clipsToBounds = true;
}

- (void)updateLikeCount:(NSInteger)count{
    self.likeCount = count;
    self.likeCountLabel.text = [NSString stringWithFormat:@"%ld",(long)count];
}

- (void)increasedLikeCount:(NSInteger)count{
    self.likeCount += count;
    self.likeCountLabel.text = [NSString stringWithFormat:@"%ld",(long)self.likeCount];
}

- (void)updateViewAudienceCount:(NSInteger)count{
    if(count < 0) count = 0; //防止count小于0
    if(count >= 10000){
        CGFloat wan = (CGFloat)count / 10000;
        self.viewAudienceCountLabel.text = [NSString stringWithFormat:@"%.1f万",wan];
    }else{
        self.viewAudienceCountLabel.text = [NSString stringWithFormat:@"%ld",(long)count];
    }
    
}
- (IBAction)touched:(id)sender {
    if ([self.delegate respondsToSelector:@selector(roomInfoView:hostTouched:)]) {
        [self.delegate roomInfoView:self hostTouched:self.hostUser];
    }
}


@end
