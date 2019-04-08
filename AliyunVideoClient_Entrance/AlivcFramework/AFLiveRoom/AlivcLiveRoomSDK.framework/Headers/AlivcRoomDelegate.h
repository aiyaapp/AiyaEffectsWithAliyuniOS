//
//  AlivcRoomDelegate.h
//  AlivcInteractiveLiveRoomSDK
//
//  Created by Charming04 on 2018/5/27.
//

#import <Foundation/Foundation.h>

@class AlivcRoom;
@protocol AlivcRoomDelegate <NSObject>

@optional

/*errorCode*/
- (void)onAlivcRoom:(AlivcRoom *)room errorCode:(NSInteger)errorCode errorDetail:(NSString *)errorDetail;

@end
