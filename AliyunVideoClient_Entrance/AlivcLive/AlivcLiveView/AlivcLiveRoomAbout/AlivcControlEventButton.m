//
//  AlivcControlEventButton.m
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2018/4/24.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import "AlivcControlEventButton.h"
#import "UIColor+AlivcHelper.h"

@interface AlivcControlEventButton ()
@property (nonatomic, assign) BOOL lightClose;
@property (nonatomic, assign) BOOL micClose;
@end

@implementation AlivcControlEventButton

- (instancetype)initWithEvent:(AlivcLiveControlEvent )event isAnchor:(BOOL)isAnchor{
    self = [super init];
    if (self) {
        _event = event;
        if (isAnchor) {
            UIImage *image = [[self class] imageWithEvent:event isActhor:isAnchor];
            CGFloat width = 49;
            self.frame = CGRectMake(0, 0, width, width);
            [self setImage:image forState:UIControlStateNormal];
            self.contentMode = UIViewContentModeScaleAspectFit;
//            self.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
            if (event == AlivcLiveControlEventMicrophone) {
                [self setImage:[UIImage imageNamed:@"AlivcIconMicrophoneClose"] forState:UIControlStateSelected];
            }
            if (event == AlivcLiveControlEventLight) {
                [self setImage:[UIImage imageNamed:@"AlivcIconLight"] forState:UIControlStateSelected];
            }
        }else{
            UIImage *image = [[self class] imageWithEvent:event isActhor:isAnchor];
            CGFloat width = 49;
            self.frame = CGRectMake(0, 0, width, width);
            //        [self setBackgroundImage:image forState:UIControlStateNormal];
            [self setImage:image forState:UIControlStateNormal];
            self.contentMode = UIViewContentModeScaleAspectFit;
            if (event == AlivcLiveControlEventMessage) {
                [self setTitle:NSLocalizedString(@"Let's Chat", nil) forState:UIControlStateNormal];
                self.titleLabel.font = [UIFont systemFontOfSize:14];
                self.titleLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
                self.titleLabel.textAlignment = NSTextAlignmentLeft;
                self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                self.frame = CGRectMake(10, 0, 90, width);
            }else if (event == AlivcLiveControlEventLike){
//                self.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
            }
        }
    }
    return self;
}

+ (UIImage *)imageWithEvent:(AlivcLiveControlEvent )event isActhor:(BOOL)isActhor{
    switch (event) {
        case AlivcLiveControlEventMessage:
            if (isActhor) {
                return [UIImage imageNamed:@"AlivcIconMessage"];
            }else{
                return nil;
            }
            break;
        case AlivcLiveControlEventBeauty:
            return [UIImage imageNamed:@"AlivcIconBeauty"];
            break;
        case AlivcLiveControlEventMusic:
            return [UIImage imageNamed:@"AlivcIconMusic"];
            break;
        case AlivcLiveControlEventMicrophone:
            return [UIImage imageNamed:@"AlivcIconMicrophoneOpen"];
            break;
        case AlivcLiveControlEventLight:
            return [UIImage imageNamed:@"AlivcIconLightClose"];
            break;
        case AlivcLiveControlEventCamera:
            return [UIImage imageNamed:@"AlivcIconCamera"];
            break;
        case AlivcLiveControlEventLike:
            return [UIImage imageNamed:@"alivc_room_like"];
            break;
        default:
            break;
    }
    return [UIImage imageNamed:@"avcClose"];
}
@end
