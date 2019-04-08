//
//  AlivcLiveRole.h
//  AlivcLiveRoom
//
//  Created by OjisanC on 2018/4/27.
//  Copyright © 2018年 Aliyun. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 AlivcLiveRoleType
 
 - AlivcLiveRoleNone: AlivcLiveRoleNone
 - AlivcLiveRoleHost: AlivcLiveRoleHost
 - AlivcLiveRoleAudience: AlivcLiveRoleAudience
 - AlivcLiveRoleMicLink: AlivcLiveRoleMicLink
 - AlivcLiveRoleAdministrator: AlivcLiveRoleAdministrator
 - AlivcLiveRoleRoomAdministrator: AlivcLiveRoleRoomAdministrator
 */
typedef NS_ENUM(NSInteger,AlivcLiveRoleType) {
    AlivcLiveRoleNone = -1,
    AlivcLiveRoleHost = 0,
    AlivcLiveRoleAudience = 1,
    AlivcLiveRoleMicLink = 2,
    AlivcLiveRoleAdministrator = 3,
    AlivcLiveRoleRoomAdministrator = 4,
} ;

@interface AlivcLiveRole : NSObject

@property (nonatomic, assign) AlivcLiveRoleType type;
@property (nonatomic, copy) NSString *name;

- (instancetype)initWithType:(NSInteger)type;

- (instancetype)initWithName:(NSString *)name;
@end
