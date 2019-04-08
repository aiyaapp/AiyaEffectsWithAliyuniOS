//  推流顶部的用户信息列表View
//  AlivcUserInfoListView.h
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2018/4/24.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AlivcLiveUser;
@class AlivcUserInfoListView;

@protocol AlivcUserInfoListViewDelegate <NSObject>

- (void)userInfoListView:(AlivcUserInfoListView *)view touchUpInSideWith:(AlivcLiveUser *)touchUser;

@end


@interface AlivcUserInfoListView : UIView

@property(nonatomic, strong, readonly)NSMutableArray <AlivcLiveUser *>*userArray;

/**
  初始化方法
 
 @param userArray 用户列表
 @return 用户列表
 */
- (instancetype)initWithArray:(NSArray <AlivcLiveUser *>*)userArray;

/**
 刷新界面

 @param userArray 用户列表
 */
- (void)refreshUIWithArray:(NSArray <AlivcLiveUser *>*)userArray;

/**
 新用户进来了，在最前面添加一个头像

 @param aUser 新用户
 @return 添加成功与否，已有视图已经超过30个，就失败，没有超过30个，在最前面添加头像视图，成功
 */
- (BOOL)insertAUser:(AlivcLiveUser *)aUser;

/**
 用户被踢出，移除这个用户的头像

 @param aUser 用户
 @return 移除成功与否,注意：这个bool只是代表这个视图移除成功与否，跟真正的踢人成功与否没有任何关系，如果踢的人没有在当前视图中展示，那么一定会返回失败
 */
- (BOOL)kickoutAUser:(AlivcLiveUser *)aUser;

@property (nonatomic, weak) id <AlivcUserInfoListViewDelegate> delegate;

@end
