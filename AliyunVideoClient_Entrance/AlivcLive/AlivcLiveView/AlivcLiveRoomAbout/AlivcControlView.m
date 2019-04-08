//  相机控制View类:控制摄像头的切换，闪光灯的切换等
//  AlivcControlView.m
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2018/4/24.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import "AlivcControlView.h"
#import "UIColor+AlivcHelper.h"
@interface AlivcControlView()
@property (nonatomic, strong) NSArray *buttonArray;
@end

@implementation AlivcControlView

- (instancetype)initWithRole:(AlivcLiveRoleType)role{
    self = [super init];
    if (self) {
        _role = role;
        self.frame = CGRectMake(0, 0, ScreenWidth, 60);
        if (role == AlivcLiveRoleAudience) {
            CALayer *line = [CALayer layer];
            [line setFrame:CGRectMake(0, 0, self.bounds.size.width, 1)];
            [line setBackgroundColor:[UIColor colorWithHexString:@"#ffffff" alpha:0.5].CGColor];
            [self.layer addSublayer:line];
        }
        [self addButtons];
    }
    return self;
}

- (instancetype)initWithPreWhenRoleIsHost:(BOOL)isPre{
    if (isPre) {
        //
        self = [super init];
        self.frame = CGRectMake(0, 0, ScreenWidth * 0.6, 60);
        [self addButtonsWhenHostIsPre];
    }else{
        self = [self initWithRole:AlivcLiveRoleHost];
    }
    return self;
}


/**
 添加主播预览界面控制的按钮
 */
- (void)addButtonsWhenHostIsPre{
    NSArray *buttons = [self buttonsWithAnchorPre];
    self.buttonArray = buttons;
    for (AlivcControlEventButton *button in buttons) {
        [button addTarget:self action:@selector(eventButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    }
    CGFloat iWidth = self.frame.size.width / buttons.count;
    for (AlivcControlEventButton *button in buttons) {
        NSInteger index = [buttons indexOfObject:button];
        CGFloat cx = (index + 0.5) * iWidth;
        CGFloat cy = self.frame.size.height / 2;
        button.center = CGPointMake(cx, cy);
        [self addSubview:button];
    }
}

- (void)addButtons{
    NSArray *buttons = [self buttonsWithRole:self.role];
    self.buttonArray = buttons;
    for (AlivcControlEventButton *button in buttons) {
        [button addTarget:self action:@selector(eventButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    //调整位置
    if (self.role == AlivcLiveRoleHost) {
        CGFloat iWidth = self.frame.size.width / buttons.count;
        for (AlivcControlEventButton *button in buttons) {
            NSInteger index = [buttons indexOfObject:button];
            CGFloat cx = (index + 0.5) * iWidth;
            CGFloat cy = self.frame.size.height / 2;
            button.center = CGPointMake(cx, cy);
            [self addSubview:button];
        }
        
    }else{
//        CGFloat iWidth = self.frame.size.width / 7;
        for (AlivcControlEventButton *button in buttons) {
//            NSInteger index = [buttons indexOfObject:button];
//            if (index > 0) {
//                index = index + 4;
//            }
//            CGFloat cx = (index + 0.5) * iWidth;
            CGFloat cx = 0;
            if (button.event == AlivcLiveControlEventMessage) {
                cx = button.frame.size.width/2+10;
            }else if (button.event == AlivcLiveControlEventLike){
                cx = self.frame.size.width - 30;
            }
            CGFloat cy = self.frame.size.height / 2;
            button.center = CGPointMake(cx, cy);
            [self addSubview:button];
        }
    }
}

- (NSArray <AlivcControlEventButton *>*)buttonsWithRole:(AlivcLiveRoleType )role{
    NSArray *buttons = [NSArray array];
    switch (role) {
        case AlivcLiveRoleHost:
            buttons = [self buttonsWithAnchor];
            break;
        case AlivcLiveRoleAudience:
            buttons = [self buttonsWithAudience];
            break;
            
        default:
            break;
    }
    return buttons;
}


/**
 主播拥有的按钮

 @return 按钮
 */
- (NSArray <AlivcControlEventButton *>*)buttonsWithAnchor{
    NSMutableArray *buttons = [[NSMutableArray alloc]init];
    for (int i = 0; i < 6; i++) {
        AlivcLiveControlEvent event = (AlivcLiveControlEvent )i;
        AlivcControlEventButton *button = [[AlivcControlEventButton alloc] initWithEvent:event isAnchor:YES];
        [buttons addObject:button];
    }
    return (NSArray *)buttons;
}

/**
 主播预览视图拥有的按钮

 @return 按钮
 */
- (NSArray <AlivcControlEventButton *>*)buttonsWithAnchorPre{
    NSMutableArray *buttons = [[NSMutableArray alloc]init];
    
    AlivcControlEventButton *beautyButton = [[AlivcControlEventButton alloc]initWithEvent:AlivcLiveControlEventBeauty isAnchor:YES];
    [buttons addObject:beautyButton];
    
    AlivcControlEventButton *cameraButton = [[AlivcControlEventButton alloc]initWithEvent:AlivcLiveControlEventCamera isAnchor:YES];
    [buttons addObject:cameraButton];
    
    AlivcControlEventButton *lightButton = [[AlivcControlEventButton alloc]initWithEvent:AlivcLiveControlEventLight isAnchor:YES];
    [buttons addObject:lightButton];
    return  (NSArray *)buttons;
}


/**
 观众拥有的按钮

 @return 按钮
 */
- (NSArray <AlivcControlEventButton *>*)buttonsWithAudience{
    NSMutableArray *buttons = [[NSMutableArray alloc]init];
    AlivcControlEventButton *messageButton = [[AlivcControlEventButton alloc]initWithEvent:AlivcLiveControlEventMessage isAnchor:NO];
    [buttons addObject:messageButton];
    AlivcControlEventButton *likeButton = [[AlivcControlEventButton alloc]initWithEvent:AlivcLiveControlEventLike isAnchor:NO];
    [buttons addObject:likeButton];
    return  (NSArray *)buttons;
}

#pragma mark - Response

- (void)eventButtonTouched:(AlivcControlEventButton *)button{
    if ([self.delegate respondsToSelector:@selector(controlView:buttonTouched:)]) {
        [self.delegate controlView:self buttonTouched:button];
    }
}

- (void)setLightingEnable:(BOOL)enable{
    for(AlivcControlEventButton *button in self.buttonArray){
        if (button.event == AlivcLiveControlEventLight) {
            button.enabled = enable;
            break;
        }
    }
}
@end
