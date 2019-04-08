//
//  AlivcUserEnterView.m
//  AliyunVideoClient_Entrance
//
//  Created by jiangsongwen on 2018/6/2.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import "AlivcUserEnterView.h"
#import "UIColor+AlivcHelper.h"
#import "NSString+AlivcHelper.h"
@class AlivcEnterSubview;
@interface AlivcUserEnterView ()<CAAnimationDelegate>
@property(nonatomic,strong)CAEmitterLayer *ringLayer;
@property (nonatomic, strong)UIView *moveView;
@property (nonatomic, strong)AlivcEnterSubview *enterView;
@property (nonatomic, strong)UIView *floatStarView;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic, strong)NSMutableArray *bossArray;
@property (nonatomic, assign)BOOL animationPlaying;
@property (nonatomic, strong) UILabel *nameLabel;
@end
@implementation AlivcUserEnterView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _bossArray = [NSMutableArray new];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//
//            [self welcomeBossEnterLiveRoom:@"杜磊思"];
//            [self welcomeBossEnterLiveRoom:@"杜磊思"];
//            [self welcomeBossEnterLiveRoom:@"杜磊思"];
//        });
        
    }
    return self;
}

-(CAAnimationGroup *)moveTime_One:(float)time X:(NSNumber *)x moveTime_Two:(float)time_two twoX:(NSNumber *)twoX threeTime:(float)threeTime X_end:(NSNumber *)x_end{
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    animation.toValue=x;
    animation.duration=time;
    animation.removedOnCompletion=NO;
    animation.fillMode=kCAFillModeForwards;
    
    CABasicAnimation *animation2=[CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    animation2.toValue=twoX;
    animation2.duration=time_two;
    animation2.beginTime = animation.duration;
    animation2.removedOnCompletion=NO;
    animation2.fillMode=kCAFillModeForwards;
    
    CABasicAnimation *animation3=[CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    animation3.toValue=x_end;
    animation3.duration=threeTime;
    animation3.beginTime = animation2.duration;
    animation3.removedOnCompletion=NO;
    animation3.fillMode=kCAFillModeForwards;
    
    CAAnimationGroup *animGroup = [CAAnimationGroup animation];
    animGroup.animations = @[animation,animation2,animation3];
    animGroup.duration = time+time_two+threeTime;
    animGroup.fillMode = kCAFillModeForwards;
    animGroup.removedOnCompletion = NO;
    return animGroup;
}

- (void)bossEnter:(NSDictionary *)dic{
    NSString *userName = dic[@"name"];
    [self.enterView removeFromSuperview];
    [self.layer removeAllAnimations];
    NSString *desc = [NSString stringWithFormat:@" %@",[@"Enter Stream Room" lowercaseString]];
    
    self.moveView = [[UIView alloc] initWithFrame:CGRectMake(self.bounds.size.width, 0, 428/2, self.bounds.size.height)];
    self.moveView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.moveView];
    self.enterView = [[AlivcEnterSubview alloc] initWithFrame:CGRectMake(0, 0, self.moveView.frame.size.width, self.bounds.size.height)];
    self.enterView.alpha = 0.8;
    [self.moveView addSubview:self.enterView];
    self.floatStarView = [[UIView alloc] initWithFrame:self.enterView.bounds];
    self.floatStarView.backgroundColor = [UIColor clearColor];
    self.floatStarView.userInteractionEnabled = NO;
    self.ringLayer.emitterPosition = CGPointMake(self.floatStarView.frame.size.width-20, self.floatStarView.frame.size.height/2.0);
    [self.floatStarView.layer addSublayer:self.ringLayer];
    [self.moveView addSubview:self.floatStarView];
    self.animationPlaying = YES;
    [self.moveView.layer addAnimation:[self moveTime_One:0.3 X:[NSNumber numberWithInteger:-[UIScreen mainScreen].bounds.size.width+10] moveTime_Two:2 twoX:[NSNumber numberWithInteger:-[UIScreen mainScreen].bounds.size.width] threeTime:0.3 X_end:[NSNumber numberWithInteger:-[UIScreen mainScreen].bounds.size.width*4]] forKey:@"moveX"];
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.moveView.frame.size.width, self.frame.size.height)];
    self.nameLabel.textColor = [UIColor whiteColor];
    self.nameLabel.textAlignment = NSTextAlignmentLeft;
    self.nameLabel.font = [UIFont systemFontOfSize:13];
    self.nameLabel.text = [NSString stringWithFormat:@"%@%@",userName,desc];
    [self.moveView addSubview:self.nameLabel];
}

- (void)welcomeBossEnterLiveRoom:(NSString *)name{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:name,@"name", nil];
    [self.bossArray addObject:dic];
    [self startTimer];
}


- (void)startTimer{
    if (self.timer==nil) {
        [self addMsg];
        
        self.timer = [NSTimer timerWithTimeInterval:2.7  target:self selector:@selector(addMsg) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}

- (void)addMsg{
    if (self.bossArray.count>0) {
        [self bossEnter:self.bossArray.firstObject];
        [self.bossArray removeObjectAtIndex:0];
        
    }else{
        [self stopTimer];
        [self.enterView removeFromSuperview];
    }
}
- (void)stopTimer{
    [self.timer invalidate];
    self.timer = nil;
}

@end

@interface AlivcEnterSubview ()

@end
@implementation AlivcEnterSubview
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = self.bounds;
        gradient.colors = [NSArray arrayWithObjects:
                           (id)[UIColor colorWithHexString:@"#00c1de" alpha:1].CGColor,
                           (id)[UIColor colorWithHexString:@"#00c1de" alpha:0].CGColor, nil];
        gradient.startPoint = CGPointMake(0, 0);
        gradient.endPoint = CGPointMake(1.0, 0);
        [self.layer addSublayer:gradient];
    }
    return self;
}

@end

