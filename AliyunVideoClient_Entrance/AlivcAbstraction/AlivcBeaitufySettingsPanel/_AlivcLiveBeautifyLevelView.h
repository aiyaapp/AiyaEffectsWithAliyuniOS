//
//  _AlivcLiveBeautifyLevelView.h
//  BeautifySettingsPanel
//
//  Created by 汪潇翔 on 2018/5/29.
//  Copyright © 2018 汪潇翔. All rights reserved.
//

#import <UIKit/UIKit.h>

@class _AlivcLiveBeautifyNavigationView,_AlivcLiveBeautifyLevelView;

@protocol _AlivcLiveBeautifyLevelViewDelegate <NSObject>
- (void)levelView:(_AlivcLiveBeautifyLevelView *)levelView didChangeLevel:(NSInteger)level;
@end

@interface _AlivcLiveBeautifyLevelView : UIView

@property (nonatomic, readonly) _AlivcLiveBeautifyNavigationView *navigationView;

@property (nonatomic, assign) NSInteger level;

@property (nonatomic, weak) id<_AlivcLiveBeautifyLevelViewDelegate> delegate;

@end
