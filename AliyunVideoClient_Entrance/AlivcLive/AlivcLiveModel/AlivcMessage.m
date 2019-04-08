//
//  AlivcMessage.m
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2018/4/25.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import "AlivcMessage.h"
#import "AlivcLiveUser.h"
#import "AlivcUserInfoManager.h"
#import "UIColor+AlivcHelper.h"
#import <AlivcInteractiveLiveRoomSDK/AlivcInteractiveLiveRoomSDK.h>
#import "NSString+AlivcHelper.h"
@interface AlivcMessage()

@property (nonatomic, strong) NSString *commentString;

@property (nonatomic, strong) NSString *nickname;

@end

@implementation AlivcMessage


- (instancetype)initWithUser:(AlivcLiveUser *)user type:(AlivcMessageType)type commentString:(NSString *)commentString{
    self = [super init];
    if (self) {
        _user = user;
        _messageType = type;
        _commentString = commentString;
        _nickname = user.nickname;
        _userId = user.userId;
    }
    return self;
}

//- (instancetype)initWitUserId:(NSString *)userId nickname:(NSString *)name content:(NSString *)content type:(AlivcMessageType)type{
//    if (self) {
//        _userId = userId;
//        _nickname = name;
//        _messageType = type;
//        _commentString = content;
//    }
//    return self;
//}


- (NSAttributedString *)showText{
//    NSDictionary *blackDic = @{NSForegroundColorAttributeName:[UIColor groupTableViewBackgroundColor]};
//    NSDictionary *grayDic = @{NSForegroundColorAttributeName:[UIColor grayColor]};
//    switch (self.messageType) {
//        case AlivcMessageTypeSystem:{
//            NSMutableAttributedString *maString = [[NSMutableAttributedString alloc]initWithString:self.messageString];
//            [maString setAttributes:blackDic range:NSMakeRange(0, self.messageString.length)];
//            return maString;
//        }
//
//            break;
//        case AlivcMessageTypeComment:{
//            if (self.userName) {
//                NSString *preString = [self.userName stringByAppendingString:@":"];
//                NSString *allString = [preString stringByAppendingString:self.messageString];
//                NSMutableAttributedString *maString = [[NSMutableAttributedString alloc]initWithString:allString];
//                [maString setAttributes:blackDic range:NSMakeRange(0, preString.length)];
//                [maString setAttributes:grayDic range:NSMakeRange(preString.length, self.messageString.length)];
//                return maString;
//            }
//        }
//            break;
//        default:
//            break;
//    }
//    return [[NSMutableAttributedString alloc]initWithString:self.messageString];
    NSString *messageString = @"";
    NSAttributedString *msgAttString;
    switch (self.messageType) {
        case AlivcMessageTypeForbidSendMsg:
            messageString = [NSString stringWithFormat:@"%@被主播禁言",self.nickname];
            msgAttString = [self getAttributedStringWithFirstStr:[NSString stringWithFormat:@"%@ ",self.nickname] andSize:13 andColor:[UIColor colorWithHexString:@"#62ffcf" alpha:1] WithSecondStr:@"被主播禁言" andSecondSize:14 andSecondColor:[UIColor colorWithHexString:@"#ff4062"]];
            break;
        case AlivcMessageTypeAllowSendMsg:
            messageString = [NSString stringWithFormat:@"%@被解除了禁言",self.nickname];
            msgAttString = [self getAttributedStringWithFirstStr:[NSString stringWithFormat:@"%@ ",self.nickname] andSize:13 andColor:[UIColor colorWithHexString:@"#62ffcf" alpha:1] WithSecondStr:@"被解除了禁言" andSecondSize:14 andSecondColor:[UIColor colorWithHexString:@"#fbde38"]];
            break;
        case AlivcMessageTypeForbidAllSendMsg:
            messageString = @"主播禁言了所有人";
            msgAttString = [self getAttributedStringWithFirstStr:@"广播 " andSize:13 andColor:[UIColor colorWithHexString:@"#62ffcf" alpha:1] WithSecondStr:messageString andSecondSize:14 andSecondColor:[UIColor colorWithHexString:@"#fbde38"]];
            break;
        case AlivcMessageTypeAllowAllSendMsg:
            messageString = @"主播对所有人解除了禁言";
            msgAttString = [self getAttributedStringWithFirstStr:@"广播 " andSize:13 andColor:[UIColor colorWithHexString:@"#62ffcf" alpha:1] WithSecondStr:messageString andSecondSize:14 andSecondColor:[UIColor colorWithHexString:@"#fbde38"]];
            break;
        case AlivcMessageTypeGift:
            messageString = [NSString stringWithFormat:@"%@送了一个礼物",self.nickname];
            msgAttString = [self getAttributedStringWithFirstStr:[NSString stringWithFormat:@"%@ ",self.nickname] andSize:13 andColor:[UIColor colorWithHexString:@"#62ffcf" alpha:1] WithSecondStr:@"送了一个礼物" andSecondSize:14 andSecondColor:[UIColor colorWithHexString:@"#fbde38"]];
            break;
        case AlivcMessageTypeChat:
            if (self.commentString) {
                messageString = [NSString stringWithFormat:@"%@: %@",self.nickname,self.commentString];
                msgAttString = [self getAttributedStringWithFirstStr:[NSString stringWithFormat:@"%@: ",self.nickname] andSize:13 andColor:[UIColor colorWithHexString:@"#62ffcf" alpha:1] WithSecondStr:self.commentString andSecondSize:14 andSecondColor:[UIColor colorWithHexString:@"#ffffff"]];
            }else{
                messageString = [NSString stringWithFormat:@"%@: %@",self.nickname,@"error:message is null"];
            }
            
            break;
        case AlivcMessageTypeKickout:
            messageString = [NSString stringWithFormat:@"%@%@",self.user.nickname,[@"user_has_been_remove" localString]];
            msgAttString = [self getAttributedStringWithFirstStr:[NSString stringWithFormat:@"%@ ",self.nickname] andSize:13 andColor:[UIColor colorWithHexString:@"#62ffcf" alpha:1] WithSecondStr:[@"user_has_been_remove" localString] andSecondSize:14 andSecondColor:[UIColor colorWithHexString:@"#fbde38"]];
            break;
        case AlivcMessageTypeLogin:
            messageString = [NSString stringWithFormat:@"%@%@",self.nickname,[@"user_enter" localString]];
            msgAttString = [self getAttributedStringWithFirstStr:[NSString stringWithFormat:@"%@ ",self.nickname] andSize:13 andColor:[UIColor colorWithHexString:@"#62ffcf" alpha:1] WithSecondStr:[@"user_enter" localString] andSecondSize:14 andSecondColor:[UIColor colorWithHexString:@"#fbde38"]];
            break;
        case AlivcMessageTypeLogout:
            messageString = [NSString stringWithFormat:@"%@%@",self.nickname,[@"user_leave" localString]];
            msgAttString = [self getAttributedStringWithFirstStr:[NSString stringWithFormat:@"%@ ",self.nickname] andSize:13 andColor:[UIColor colorWithHexString:@"#62ffcf" alpha:1] WithSecondStr:[@"user_leave" localString] andSecondSize:14 andSecondColor:[UIColor colorWithHexString:@"#fbde38"]];
            break;
        case AlivcMessageTypeLike:
            messageString = [NSString stringWithFormat:@"%@给主播点了个赞",self.nickname];
            msgAttString = [self getAttributedStringWithFirstStr:[NSString stringWithFormat:@"%@ ",self.nickname] andSize:13 andColor:[UIColor colorWithHexString:@"#62ffcf" alpha:1] WithSecondStr:@"给主播点了个赞" andSecondSize:14 andSecondColor:[UIColor colorWithHexString:@"#fbde38"]];
            break;
        default:
            break;
    }
    
    return msgAttString;
}

+ (AlivcMessage *__nullable)messageWithInfo:(AlivcMsgInfo *)info user:(AlivcLiveUser *)user{
    AlivcMessageType type = AlivcMessageTypeChat;
//    NSString *commentString = info.data;
//    //去适配type
//    NSString *typeString = info.event;
//    if ([typeString isEqualToString:AlivcMsgCreateRoom]) {
//        return nil;
//    }
//    if ([typeString isEqualToString:AlivcMsgDestroyRoom]) {
//        return nil;
//    }
//    if ([typeString isEqualToString:AlivcMsgEnterRoom]) {
//        return nil;
//    }
//    if ([typeString isEqualToString:AlivcMsgLeaveRoom]) {
//        return nil;
//    }
//    if ([typeString isEqualToString:AlivcMsgUserLogin]) {
//        type = AlivcMessageTypeLogin;
//    }
//    if ([typeString isEqualToString:AlivcMsgUserLogout]) {
//        return nil;
//    }
//    if ([typeString isEqualToString:AlivcMsgAllowSendMsg]) {
//        type = AlivcMessageTypeAllowSendMsg;
//    }
//    if ([typeString isEqualToString:AlivcMsgForbidSendMsg]) {
//        type = AlivcMessageTypeForbidSendMsg;
//    }
//    if ([typeString isEqualToString:AlivcMsgAllowAllSendMsg]) {
//        type = AlivcMessageTypeAllowAllSendMsg;
//    }
//    if ([typeString isEqualToString:AlivcMsgForbidAllSendMsg]) {
//        type = AlivcMessageTypeForbidAllSendMsg;
//    }
//    if ([typeString isEqualToString:AlivcMsgKickout]) {
//        type = AlivcMessageTypeKickout;
//    }
//    if ([typeString isEqualToString:AlivcMsgRefreshImToken]) {
//        return nil;
//    }
//    if ([typeString isEqualToString:AlivcMsgQueryRoomInfo]) {
//        return nil;
//    }
//    if ([typeString isEqualToString:AlivcMsgNotice]) {
//        return nil;
//    }
//    if ([typeString isEqualToString:AlivcMsgChat]) {
//        type = AlivcMessageTypeChat;
//    }
//    if ([typeString isEqualToString:AlivcMsgGift]) {
//        type = AlivcMessageTypeGift;
//    }
//    if ([typeString isEqualToString:AlivcMsgQueryRoomMsgs]) {
//        return nil;
//    }
//    if ([typeString isEqualToString:AlivcMsgLike]) {
//        type = AlivcMessageTypeLike;
//    }
   
    
//    AlivcMessage *message = [[AlivcMessage alloc]initWithUser:user type:type commentString:commentString];
//    return message;
    
    return nil;
}

- (NSAttributedString *)getAttributedStringWithFirstStr:(NSString *)fristStr andSize:(CGFloat)fristSize andColor:(UIColor *)fristColor WithSecondStr:(NSString *)secondStr andSecondSize:(CGFloat)secondSize andSecondColor:(UIColor *)secondColor{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:fristStr attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fristSize],NSForegroundColorAttributeName:fristColor}];
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowBlurRadius = 1;
    shadow.shadowOffset = CGSizeMake(0, 0);
    shadow.shadowColor = [UIColor colorWithHexString:@"0X000000" alpha:0.5];
    [str appendAttributedString:[[NSAttributedString alloc]initWithString:secondStr attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:secondSize],NSForegroundColorAttributeName:secondColor,NSShadowAttributeName:shadow}]];
    return str;
}
@end
