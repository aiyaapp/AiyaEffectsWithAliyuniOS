//
//  AlivcInteractiveLiveRoomErrorDelegate.h
//  AlivcInteractiveLiveRoomSDK
//
//  Created by OjisanC on 2018/6/2.
//

#import <Foundation/Foundation.h>

@protocol AlivcInteractiveLiveRoomErrorDelegate <NSObject>

@optional
- (void)onAlivcInteractiveLiveRoomErrorCode:(NSInteger)errorCode errorDetail:(NSString *)errorDetail;

@end
