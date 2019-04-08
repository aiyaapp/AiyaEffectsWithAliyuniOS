//
//  AlivcLikeBox.h
//  AliyunVideoClient_Entrance
//
//  Created by jiangsongwen on 2018/5/31.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlivcLikeBox : NSObject
+ (instancetype)sharedManager;

- (void)addLikeCount:(NSInteger )count inView:(UIView *)view;
@end
