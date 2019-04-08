//
//  AliyunEffectTimeView.m
//  qusdk
//
//  Created by Worthy on 2018/2/12.
//  Copyright © 2018年 Alibaba Group Holding Limited. All rights reserved.
//

#import "AliyunEffectTimeView.h"
#import "AliyunEffectFilterCell.h"
#import "AVC_ShortVideo_Config.h"
@implementation AliyunEffectTimeView
{
    UICollectionView *_collectionView;
    UIButton *_cancelButton;
    UIButton *_revokeButton;
    UIButton *_filterButton;
    UIButton *_animtionFilterButton;
    UIView *_indicator;
    NSMutableArray *_dataArray;
    NSInteger _effectType;
    NSInteger _selectIndex;
    UIButton *_selectButton;
    NSTimer *_schedule;
    NSIndexPath *preIdxPath;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBToColor(27, 33, 51);
        _dataArray = [[NSMutableArray alloc] init];
        _selectIndex = -1;
        [self addSubViews];
        [self insertDataArray];
    }
    return self;
}

- (void)addSubViews {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(50, 70);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 102) collectionViewLayout:layout];
    _collectionView.backgroundColor = RGBToColor(35, 42, 66);
    _collectionView.showsHorizontalScrollIndicator = NO;
    [_collectionView registerNib:[UINib nibWithNibName:@"AliyunEffectFilterCell" bundle:nil] forCellWithReuseIdentifier:@"AliyunEffectFilterCell"];
    [_collectionView registerNib:[UINib nibWithNibName:@"AliyunEffectFilterCell" bundle:nil] forCellWithReuseIdentifier:@"AliyunEffectFilterFuncCell"];
    _collectionView.dataSource = (id<UICollectionViewDataSource>)self;
    _collectionView.delegate = (id<UICollectionViewDelegate>)self;
    [self addSubview:_collectionView];
    UILongPressGestureRecognizer *longPressGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [_collectionView addGestureRecognizer:longPressGes];
    CGFloat height = 34;
    
    
    _filterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _filterButton.bounds = CGRectMake(0, 0, 60, height);
    _filterButton.center = CGPointMake(CGRectGetMidX(self.bounds) - 35, CGRectGetHeight(self.bounds) - height/2);
    [_filterButton setTitle:@"某刻" forState:UIControlStateNormal];
    [_filterButton addTarget:self action:@selector(filterButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_filterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [_filterButton setTitleColor:rgba(110, 118, 139, 1) forState:UIControlStateNormal];
    [self addSubview:_filterButton];
    _selectButton = _filterButton;
    _selectButton.selected = YES;
    
    _animtionFilterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _animtionFilterButton.bounds = CGRectMake(0, 0, 60, height);
    _animtionFilterButton.center = CGPointMake(CGRectGetMidX(self.bounds) + 35, CGRectGetHeight(self.bounds) - height/2);
    [_animtionFilterButton setTitle:@"全程" forState:UIControlStateNormal];
    [_animtionFilterButton addTarget:self action:@selector(animtionFilterButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_animtionFilterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [_animtionFilterButton setTitleColor:rgba(110, 118, 139, 1) forState:UIControlStateNormal];
    [self addSubview:_animtionFilterButton];
    
    _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelButton.bounds = CGRectMake(0, 0 , height, height);
    _cancelButton.center = CGPointMake(height / 2 + 10, CGRectGetHeight(self.bounds) - height/2);
    [_cancelButton setImage:[AliyunImage imageNamed:@"cancel"] forState:0];
    [_cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_cancelButton];
    
    _revokeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _revokeButton.bounds = CGRectMake(0, 0 , height, height);
    _revokeButton.center = CGPointMake(ScreenWidth - height / 2 - 10, CGRectGetHeight(self.bounds) - height/2);
    [_revokeButton setImage:[AliyunImage imageNamed:@"revoke"] forState:0];
    [_revokeButton addTarget:self action:@selector(revokeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    _revokeButton.hidden = YES;
    [self addSubview:_revokeButton];
    
    _indicator = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 3)];
    _indicator.center = CGPointMake(_filterButton.center.x, _filterButton.center.y + height / 2);
    _indicator.backgroundColor = rgba(239,75,129,1);
    [self addSubview:_indicator];
}

- (void)touchEnd {
    NSLog(@"~~~ges1:end");
    if (_schedule) {
        if (_delegate) {
            [_delegate timeViewDidEndLongPress];
        }
        [_schedule invalidate];
        _schedule = nil;
    }
}

- (void)longPress:(UILongPressGestureRecognizer *)ges {
    if (_effectType != 7) {
        return;
    }
    
    CGPoint location = [ges locationInView:_collectionView];
    NSIndexPath *idxPath = [_collectionView indexPathForItemAtPoint:location];
    
    if (idxPath == NULL) {
        [self touchEnd];
        return;
    }
    if (idxPath.row == 0) {
        //        [self touchEnd];
        return;
    }
    
    if  (preIdxPath.row != idxPath.row) {
        [self touchEnd];
    }
    
    switch (ges.state) {
        case UIGestureRecognizerStateBegan: {
            NSLog(@"~~~ges:began");
            preIdxPath = idxPath;
            
            AliyunEffectTimeInfo *currentTime = _dataArray[idxPath.row];
            
            if (_delegate) {
                [_delegate timeViewDidBeganLongPressEffect:currentTime];
            }
            [_schedule invalidate];
            _schedule = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(touchProgress) userInfo:nil repeats:YES];
            [_schedule fire];
        }
            break;
        case UIGestureRecognizerStateEnded:
            NSLog(@"~~~ges:ended");
            [self touchEnd];
            break;
        case UIGestureRecognizerStateChanged:
            //            NSLog(@"~~~ges:changed");
            break;
        case UIGestureRecognizerStateCancelled:
            NSLog(@"~~~ges:cancel");
            break;
        case UIGestureRecognizerStateFailed:
            NSLog(@"~~~ges:failed");
            break;
        case UIGestureRecognizerStatePossible:
            NSLog(@"~~~ges:possible");
            break;
        default:
            NSLog(@"~~~ges:default");
            break;
    }
}

- (void)touchProgress {
    if (_delegate) {
        [_delegate timeViewDidTouchingProgress];
    }
}

- (void)filterButtonClick {
    _selectButton.selected = NO;
    _selectButton = _filterButton;
    _selectButton.selected = YES;
    [UIView animateWithDuration:0.24 animations:^{
        _indicator.center = CGPointMake(_filterButton.center.x, _filterButton.center.y + 34 / 2);
    }];
}

- (void)animtionFilterButtonClick {
    _selectButton.selected = NO;
    _selectButton = _animtionFilterButton;
    _selectButton.selected = YES;
    
    [UIView animateWithDuration:0.24 animations:^{
        _indicator.center = CGPointMake(_animtionFilterButton.center.x, _animtionFilterButton.center.y + 34 / 2);
    }];
}

- (void)filterAction {
    
}

- (void)revokeButtonClick {
    if (_delegate) {
        [_delegate timeViewDidRevokeButtonClick];
    }
}

- (void)insertDataArray {
    AliyunEffectInfo *effctOrigin = [[AliyunEffectInfo alloc] init];
    effctOrigin = [[AliyunEffectInfo alloc] init];
    effctOrigin.name = @"无";
    effctOrigin.eid = -1;
    effctOrigin.effectType = 3;
    effctOrigin.icon = @"QPSDK.bundle/MV_none";
    effctOrigin.resourcePath = nil;
    [_dataArray addObject:effctOrigin];
    
    AliyunEffectInfo *effctFast = [[AliyunEffectInfo alloc] init];
    effctFast.name = @"快速";
    effctFast.eid = 0;
    effctFast.effectType = 3;
    effctFast.icon = @"QPSDK.bundle/mv_more";
    [_dataArray addObject:effctFast];
    
    AliyunEffectInfo *effctSlow = [[AliyunEffectInfo alloc] init];
    effctSlow.name = @"慢速";
    effctSlow.eid = 0;
    effctSlow.effectType = 3;
    effctSlow.icon = @"QPSDK.bundle/mv_more";
    [_dataArray addObject:effctSlow];
    
    AliyunEffectInfo *effctInvert = [[AliyunEffectInfo alloc] init];
    effctInvert.name = @"倒放";
    effctInvert.eid = 0;
    effctInvert.effectType = 3;
    effctInvert.icon = @"QPSDK.bundle/mv_more";
    [_dataArray addObject:effctInvert];
 
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    AliyunEffectFilterCell *cell = [[AliyunEffectFilterCell alloc] init];
    
    if (_effectType == 7) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AliyunEffectFilterCell" forIndexPath:indexPath];
    } else {
        if (indexPath.row == 0 || indexPath.row == _dataArray.count - 1) {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AliyunEffectFilterFuncCell" forIndexPath:indexPath];
        } else {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AliyunEffectFilterCell" forIndexPath:indexPath];
        }
    }
    
    AliyunEffectInfo *effectInfo = _dataArray[indexPath.row];
    [cell cellModel:effectInfo];
    if (_effectType != 7) {
        if (indexPath.row == _selectIndex) {
            [cell setSelected:YES];
        }
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_effectType != 7) {
        AliyunEffectFilterCell *lastSelectCell = (AliyunEffectFilterCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:_selectIndex inSection:0]];
        [lastSelectCell setSelected:NO];
    }
    
    AliyunEffectTimeInfo *currentEffect = _dataArray[indexPath.row];
    
    [_delegate timeViewDidSelectEffect:(AliyunEffectTimeInfo *)currentEffect];
        
    
}

- (void)cancelButtonClick {
    [_delegate timeViewCancelButtonClick];
}
@end
