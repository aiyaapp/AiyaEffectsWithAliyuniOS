//
//  AlivcVideoItemCollectionViewCell.h
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2018/4/23.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlivcLivePlayRoom.h"
@interface AlivcVideoItemCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userCountLabel;

@property (nonatomic, strong) AlivcLivePlayRoom *data;
@end
