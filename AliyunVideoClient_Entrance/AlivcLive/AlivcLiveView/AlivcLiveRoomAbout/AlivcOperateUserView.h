//
//  AlivcOperateUserView.h
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2018/5/3.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,AlivcOperateUserType){
    AlivcOperateUserTypeSilent = 0,
    AlivcOperateUserTypeKickout,
    AlivcOperateUserTypeBlacklist
};

@class AlivcOperateUserView;
@class AlivcLiveUser;

@protocol AlivcOperateUserViewDelegate <NSObject>

- (void)operateUserView:(AlivcOperateUserView *)view user:(AlivcLiveUser *)user operateType:(AlivcOperateUserType)operateType;

- (void)cancelOperateUserView:(AlivcOperateUserView *)view;

@end

@interface AlivcOperateUserView : UIView

@property (weak, nonatomic) IBOutlet UIButton *forbidButton;
@property (weak, nonatomic) IBOutlet UIButton *kickoutButton;
@property (weak, nonatomic) IBOutlet UIButton *blackListButton;

@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *idLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarView;
@property (weak, nonatomic) IBOutlet UIView *buttomView;

@property (weak, nonatomic) IBOutlet UIButton *removeBtn;

- (instancetype)initWithUser:(AlivcLiveUser *)user;

- (void)showInView:(UIView *)view;

- (void)dismiss;

@property (nonatomic, weak) id <AlivcOperateUserViewDelegate> delegate;

@end
