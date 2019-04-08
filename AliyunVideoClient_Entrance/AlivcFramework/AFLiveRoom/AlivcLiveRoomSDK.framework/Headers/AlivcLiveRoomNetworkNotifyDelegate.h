//
//  AlivcLiveRoomNetworkNotifyDelegate.h
//  AlivcInteractiveLiveRoomSDK
//
//  Created by OjisanC on 2018/6/5.
//

@protocol AlivcLiveRoomNetworkNotifyDelegate <NSObject>

@optional

- (void)onAlivcLiveRoomNetworkPoor;

- (void)onAlivcLiveRoomConnectRecovery;

- (void)onAlivcLiveRoomReconnectStart;

- (void)onAlivcLiveRoomReconnectSuccess;

@end
