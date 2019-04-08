//
//  AlivcVideoItemCollectionViewCell.m
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2018/4/23.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import "AlivcVideoItemCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "UIColor+AlivcHelper.h"
#import "AlivcLiveUserCountTool.h"
@interface AlivcVideoItemCollectionViewCell ()
@property (nonatomic, strong) CAGradientLayer *gradient;
@end

@implementation AlivcVideoItemCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.coverImageView.contentMode = UIViewContentModeScaleToFill;

}

- (void)setData:(AlivcLivePlayRoom *)data{
    _data = data;
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:data.coverUrlString] placeholderImage:[UIImage imageNamed:@"AlivcHostAvatar"]];
    self.nameLabel.text = data.hostName;
    self.userCountLabel.text = [NSString stringWithFormat:@"%@",[AlivcLiveUserCountTool shortNumberCount:data.viewCount]];
    [self.userCountLabel sizeToFit];
    [self.coverImageView.layer addSublayer:self.gradient];

}

- (void)prepareForReuse{
    [super prepareForReuse];
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:_data.coverUrlString] placeholderImage:[UIImage imageNamed:@"AlivcHostAvatar"]];
}

- (CAGradientLayer *)gradient{
    if (_gradient == nil) {
        _gradient = [CAGradientLayer layer];
        _gradient.frame = CGRectMake(0, self.bounds.size.height-50, self.bounds.size.width, 50);
        _gradient.colors = [NSArray arrayWithObjects:
                           (id)[UIColor colorWithHexString:@"#000000" alpha:0].CGColor,
                           (id)[UIColor colorWithHexString:@"#000000" alpha:1].CGColor, nil];
        _gradient.startPoint = CGPointMake(0.5, 0);
        _gradient.endPoint = CGPointMake(0.5, 1);
    }
    return _gradient;
}
@end
