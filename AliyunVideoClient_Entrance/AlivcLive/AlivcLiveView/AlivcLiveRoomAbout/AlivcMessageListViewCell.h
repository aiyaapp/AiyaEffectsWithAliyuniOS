//
//  AlivcMessageListViewCell.h
//  AliyunVideoClient_Entrance
//
//  Created by jiangsongwen on 2018/5/29.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlivcMessageListViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, copy) NSAttributedString *msgString;
@end
