//
//  AlivcLiveBeautifySettingsView.h
//  BeautifySettingsPanel
//
//  Created by 汪潇翔 on 2018/5/29.
//  Copyright © 2018 汪潇翔. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AlivcLiveBeautifySettingsView;

@protocol AlivcLiveBeautifySettingsViewDataSource <NSObject>

- (NSArray<NSDictionary *> *)detailItemsOfSettingsView:(AlivcLiveBeautifySettingsView *)settingsView;

@end

@protocol AlivcLiveBeautifySettingsViewDelegate <NSObject>

- (void)settingsView:(AlivcLiveBeautifySettingsView *)settingsView didChangeLevel:(NSInteger)level;

- (void)settingsView:(AlivcLiveBeautifySettingsView *)settingsView didChangeValue:(NSDictionary *)info;

@end

@interface AlivcLiveBeautifySettingsView : UIView

@property (nonatomic, assign) NSInteger level;

@property (nonatomic, weak) id<AlivcLiveBeautifySettingsViewDataSource> dataSource;

@property (nonatomic, weak) id<AlivcLiveBeautifySettingsViewDelegate> delegate;

@property (nonatomic, strong) NSArray<NSMutableDictionary *> *detailItems;

@end
