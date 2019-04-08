//
//  AlivcLikeBox.m
//  AliyunVideoClient_Entrance
//
//  Created by jiangsongwen on 2018/5/31.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import "AlivcLikeBox.h"
#import "XTLoveHeartView.h"
@interface AlivcLikeBox ()
@property (nonatomic, strong) CADisplayLink *link;
@property (nonatomic, strong) NSMutableArray *likeArray;
@property (nonatomic, weak) UIView *showView;
@property (nonatomic, assign) NSTimeInterval lastLikeTime;

@end

@implementation AlivcLikeBox

- (instancetype)init {
    self = super.init;
    _likeArray = [NSMutableArray new];
    return self;
}

+ (instancetype)sharedManager {
    static AlivcLikeBox *m;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        m = self.new;
    });
    return m;
}

- (void)addLikeCount:(NSInteger )count inView:(UIView *)view{
    _showView = view;
    if (!_link) {
        _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(step:)];
        [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
    _link.paused = NO;
    for (NSUInteger i = 0; i < count; i++) {
        [_likeArray addObject:@(0)];
    }
}

- (void)step:(CADisplayLink *)link {
    if (_likeArray.count > 0 && (link.timestamp - _lastLikeTime > 0.1)) {
        [_likeArray removeLastObject];
        _lastLikeTime = link.timestamp;
        XTLoveHeartView *heart = [[XTLoveHeartView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
        [_showView addSubview:heart];
        CGPoint fountainSource = CGPointMake(_showView.frame.size.width - 30, _showView.bounds.size.height - 30 / 2.0 - 10);
        heart.center = fountainSource;
        [heart animateInView:_showView];
    }
    if (_likeArray.count==0) {
        [_link invalidate];
        _link = nil;
    }
}
@end
