//
//  AlivcMessageListViewCell.m
//  AliyunVideoClient_Entrance
//
//  Created by jiangsongwen on 2018/5/29.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import "AlivcMessageListViewCell.h"
#import "UIColor+AlivcHelper.h"
#import "AlivcStringDrawing.h"
@interface AlivcMessageListViewCell()

@end

@implementation AlivcMessageListViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubview:self.bgImageView];
        [self addSubview:self.messageLabel];
        
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    CGRect rect = [_msgString alivc_boundingRectWithSize:CGSizeMake(self.bounds.size.width, MAXFLOAT)];
    CGFloat w = rect.size.width+10;
    if (w+12>self.bounds.size.width) {
        w = self.bounds.size.width - 12;
    }
    _bgImageView.frame = CGRectMake(12, 2.5, w, self.bounds.size.height-5);
    _messageLabel.frame = CGRectMake(17, 7.5, w-10, self.bounds.size.height-15);
}

- (UIImageView *)bgImageView{
    if (_bgImageView == nil) {
        _bgImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _bgImageView.backgroundColor = [UIColor colorWithHexString:@"0X000000" alpha:0.5];
        _bgImageView.layer.masksToBounds = YES;
        _bgImageView.layer.cornerRadius = 2.5;
    }
    return _bgImageView;
}

- (UILabel *)messageLabel{
    if (_messageLabel == nil) {
        _messageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _messageLabel.textColor = [UIColor whiteColor];
        _messageLabel.font = [UIFont systemFontOfSize:14];
        _messageLabel.numberOfLines = 0;
    }
    return _messageLabel;
}

- (void)setMsgString:(NSAttributedString *)msgString{
    _msgString = msgString;
    _messageLabel.attributedText = _msgString;
}

@end
