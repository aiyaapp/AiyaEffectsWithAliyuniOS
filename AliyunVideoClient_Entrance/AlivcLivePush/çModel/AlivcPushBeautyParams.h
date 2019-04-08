//
//  AlivcPushBeautyParams.h
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2018/6/20.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger,AlivcPushBeautyParamsLevel) {
    AlivcPushBeautyParamsLevel0 = 0,
    AlivcPushBeautyParamsLevel1,
    AlivcPushBeautyParamsLevel2,
    AlivcPushBeautyParamsLevel3,
    AlivcPushBeautyParamsLevel4,
    AlivcPushBeautyParamsLevel5
};

@interface AlivcPushBeautyParams : NSObject
/**
 white
 
 default : 70
 value range : [0,100]
 */
@property (nonatomic, assign) int beautyWhite;

/**
 buffing
 
 default : 40
 value range : [0,100]
 */
@property (nonatomic, assign) int beautyBuffing;

/**
 ruddy
 
 default : 70
 value range : [0,100]
 */
@property (nonatomic, assign) int beautyRuddy;

/**
 pink
 
 default : 15
 value range : [0,100]
 */
@property (nonatomic, assign) int beautyCheekPink;

/**
 slim face
 
 default : 40
 value range : [0,100]
 */
@property (nonatomic, assign) int beautySlimFace;

/**
 shorten face
 
 default : 50
 value range : [0,100]
 */
@property (nonatomic, assign) int beautyShortenFace;

/**
 big eye
 
 default : 30
 value range : [0,100]
 */

@property (nonatomic, assign) int beautyBigEye;

/**
 init
 
 @return AlivcBeautyParams
 */
- (instancetype)init;

/**
 default beauty params
 
 @param level AlivcBeautyParamsLevel
 @return AlivcBeautyParams
 */
+ (AlivcPushBeautyParams *)defaultBeautyParamsWithLevel:(AlivcPushBeautyParamsLevel)level;

/**
 default beauty AlivcBeautyParamsLevel
 
 @return AlivcBeautyParamsLevel
 */
+ (AlivcPushBeautyParamsLevel)defaultBeautyLevel;
@end
