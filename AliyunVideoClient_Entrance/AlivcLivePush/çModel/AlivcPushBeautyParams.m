
//
//  AlivcPushBeautyParams.m
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2018/6/20.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import "AlivcPushBeautyParams.h"

static const int AlivcBeautyWhiteDefault = 70;
static const int AlivcBeautyBuffingDefault = 40;
static const int AlivcBeautyRuddyDefault = 40;
static const int AlivcBeautyCheekPinkDefault = 15;
static const int AlivcBeautyThinFaceDefault = 40;
static const int AlivcBeautyShortenFaceDefault = 50;
static const int AlivcBeautyBigEyeDefault = 30;


@implementation AlivcPushBeautyParams

- (instancetype)init {
    self = [super init];
    if(self) {
        self.beautyWhite = AlivcBeautyWhiteDefault;
        self.beautyBuffing = AlivcBeautyBuffingDefault;
        self.beautyRuddy = AlivcBeautyRuddyDefault;
        self.beautyCheekPink = AlivcBeautyCheekPinkDefault;
        self.beautySlimFace = AlivcBeautyThinFaceDefault;
        self.beautyShortenFace = AlivcBeautyShortenFaceDefault;
        self.beautyBigEye = AlivcBeautyBigEyeDefault;
    }
    return self;
}

+ (AlivcPushBeautyParams *)defaultBeautyParamsWithLevel:(AlivcPushBeautyParamsLevel)level{
    AlivcPushBeautyParams *params = [[AlivcPushBeautyParams alloc] init];
    CGFloat scale = 1;
    if (level == AlivcPushBeautyParamsLevel0) {
        scale = 0;
    }else if(level == AlivcPushBeautyParamsLevel1){
        scale = 0.3;
    }else if(level == AlivcPushBeautyParamsLevel2){
        scale = 0.6;
    }else if(level == AlivcPushBeautyParamsLevel3){
        scale = 1;
    }else if(level == AlivcPushBeautyParamsLevel4){
        scale = 1.2;
    }else if(level == AlivcPushBeautyParamsLevel5){
        scale = 1.5;
    }
    params.beautyWhite = AlivcBeautyWhiteDefault * scale > 100 ? 100 : AlivcBeautyWhiteDefault * scale;
    params.beautyBuffing = AlivcBeautyBuffingDefault * scale > 100 ? 100 : AlivcBeautyBuffingDefault * scale;
    params.beautyRuddy = AlivcBeautyRuddyDefault * scale > 100 ? 100 : AlivcBeautyRuddyDefault * scale;
    params.beautyCheekPink = AlivcBeautyCheekPinkDefault * scale > 100 ? 100 : AlivcBeautyCheekPinkDefault * scale;
    params.beautySlimFace = AlivcBeautyThinFaceDefault * scale > 100 ? 100 : AlivcBeautyThinFaceDefault * scale;
    params.beautyShortenFace = AlivcBeautyShortenFaceDefault * scale > 100 ?  100 : AlivcBeautyShortenFaceDefault * scale;
    params.beautyBigEye = AlivcBeautyBigEyeDefault * scale > 100 ? 100 : AlivcBeautyBigEyeDefault * scale;
    return params;
}

+ (AlivcPushBeautyParamsLevel)defaultBeautyLevel{
    return AlivcPushBeautyParamsLevel4;
}

@end
