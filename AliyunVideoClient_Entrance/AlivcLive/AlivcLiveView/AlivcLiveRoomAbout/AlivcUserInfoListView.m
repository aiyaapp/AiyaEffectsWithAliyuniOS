//
//  AlivcUserInfoListView.m
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2018/4/24.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import "AlivcUserInfoListView.h"
#import "AlivcLiveUser.h"
#import "UIButton+WebCache.h"

static NSInteger maxCount = 30;

@interface AlivcUserInfoListView()

@property (nonatomic, strong) NSMutableArray <AlivcLiveUser *>*userArray;

@property (nonatomic, strong) UIScrollView *scrollerView;

@property (nonatomic, strong) NSMutableArray <UIButton *>*buttonArray;
@end


@implementation AlivcUserInfoListView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithArray:(NSArray<AlivcLiveUser *> *)userArray{
    self = [super init];
    if (self) {
        //
        if(userArray){
            _userArray = [[NSMutableArray alloc]initWithArray:userArray];
        }else{
            _userArray = [[NSMutableArray alloc]init];
        }
        
        _buttonArray = [[NSMutableArray alloc]init];
        [self configBaseUI];
    }
    return self;
}

/**
 scrollerView,ButtonList
 */
- (void)configBaseUI{
    self.frame = CGRectMake(0, 0, ScreenWidth * 0.51 - 10, 30);
    self.scrollerView = [[UIScrollView alloc]init];
    self.scrollerView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.scrollerView.showsHorizontalScrollIndicator = false;
    [self addSubview:self.scrollerView];
    [self refreshUI];
}


/**
 根据数据源刷新界面，增加或者减少用户按钮
 */
- (void)refreshUI{
    for (UIButton *button in self.buttonArray) {
        [button removeFromSuperview];
    }
    [self.buttonArray removeAllObjects];
    
    CGFloat iWidth = self.frame.size.height;
    CGFloat device = 8;
    self.scrollerView.contentSize = CGSizeMake((iWidth + device) * self.userArray.count, iWidth);
    
    for (AlivcLiveUser *user in self.userArray) {
        NSInteger index = [self.userArray indexOfObject:user];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = index;
        button.frame = CGRectMake(0, 0, iWidth, iWidth);
        button.layer.cornerRadius = iWidth / 2;
        button.clipsToBounds = true;
        [button addTarget:self action:@selector(buttonTouched:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollerView addSubview:button];
        button.center = CGPointMake((index + 0.5) * iWidth + index * device, iWidth / 2);
        
        [button sd_setImageWithURL:[NSURL URLWithString:user.avatarUrlString ?:@ ""] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"test_avator_boy"]];
        [button sd_setImageWithURL:[NSURL URLWithString:user.avatarUrlString ?:@ ""] forState:UIControlStateSelected placeholderImage:[UIImage imageNamed:@"test_avator_boy"]];

        [self.buttonArray addObject:button];
    }
}

- (void)refreshUIWithArray:(NSArray<AlivcLiveUser *> *)userArray{
    self.userArray = [[NSMutableArray alloc]initWithArray:userArray];
    [self refreshUI];
}

- (BOOL)insertAUser:(AlivcLiveUser *)aUser{
    if (self.userArray.count > maxCount - 1) {
        return false;
    }
    
    [self.userArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[AlivcLiveUser class]]) {
            AlivcLiveUser *tempUser = obj;
            if ([tempUser.userId isEqualToString:aUser.userId] ) {
                [self.userArray removeObject:tempUser];
                *stop = YES;
            }
        }
        
    }];
    
    [self.userArray insertObject:aUser atIndex:0];
    [self refreshUI];
    return true;
}

- (BOOL)kickoutAUser:(AlivcLiveUser *)aUser{
    BOOL haveFind = false;
    for (AlivcLiveUser *itemUser in self.userArray) {
        if (itemUser.userId != nil && [itemUser.userId isEqualToString:aUser.userId]) {
            haveFind = true;
            [self.userArray removeObject:itemUser];
            [self refreshUI];
            return true;
        }
    }
    return haveFind;
}

- (void)buttonTouched:(UIButton *)button{
    if ([self.delegate respondsToSelector:@selector(userInfoListView:touchUpInSideWith:)]) {
        if (button.tag < self.userArray.count) {
            AlivcLiveUser *user = self.userArray[button.tag];
            [self.delegate userInfoListView:self touchUpInSideWith:user];
        }
    }
}
@end
