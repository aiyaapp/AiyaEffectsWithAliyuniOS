//  评论列表View，负责展示评论数据
//  AlivcCommentListView.m
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2018/4/24.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import "AlivcMessageListView.h"
#import "AlivcMessage.h"
#import "AlivcStringDrawing.h"
#import "AlivcMessageListViewCell.h"

static  NSString *const AlivcMessageListViewCellReuseidentifier = @"AlivcMessageListViewCell";

@interface AlivcMessageListView()<UITableViewDataSource,UITableViewDelegate>


/**
 展示数据源的tableView
 */
@property (nonatomic, strong) UITableView *tableView;

/**
 展示的数据源
 */
@property (nonatomic, strong) NSMutableArray <AlivcMessage *>*dataArray;

@end

@implementation AlivcMessageListView
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}

- (NSMutableArray <AlivcMessage *>*)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}

- (instancetype)init{
    CGRect defaultFrame = CGRectMake(0, 0, 280, 300);
    return [self initWithFrame:defaultFrame];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self configBaseUI];
    }
    return self;
}


/**
 包含一个tableView,消息进入的时候用户查看状态，默默的添加，不上划，否则自动上划
 */
- (void)configBaseUI{
    
    //tableView
    [self.tableView registerClass:[AlivcMessageListViewCell class] forCellReuseIdentifier:AlivcMessageListViewCellReuseidentifier];
    self.tableView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [self addSubview:self.tableView];
    
}

/**
 更新消息

 @param newMessage 新的消息
 */
- (void)updateAMessage:(AlivcMessage *)newMessage{
    [self.dataArray addObject:newMessage];
    NSIndexPath *addIndexPath = [NSIndexPath indexPathForRow:self.dataArray.count - 1 inSection:0];
    [self updateUIWithNewIndexPaths:@[addIndexPath]];
}


/**
 更新多条消息

 @param newMessages 多条消息
 */
- (void)updateMessages:(NSArray<AlivcMessage *> *)newMessages{
    NSInteger originIndex = self.dataArray.count; //新数据第一个的下标
    [self.dataArray addObjectsFromArray:newMessages];
    NSMutableArray *addNewIndexPaths = [[NSMutableArray alloc]init];
    for (int index = 0; index < newMessages.count; index++) {
        NSIndexPath *addIndexPath = [NSIndexPath indexPathForRow:originIndex + index inSection:0];
        [addNewIndexPaths addObject:addIndexPath];
    }
    [self updateUIWithNewIndexPaths:addNewIndexPaths];
}

/**
 用户是否在操作评论列表

 @return 用户是否在滑动查看消息列表
 */
- (BOOL)isOperating{
    return self.tableView.dragging || self.tableView.decelerating || self.tableView.tracking;
}

/**
 界面上更新新的消息体

 @param newIndexPaths 新的ui行
 */
- (void)updateUIWithNewIndexPaths:(NSArray <NSIndexPath *>*)newIndexPaths{
    if ([self isOperating]) {
        [self.tableView insertRowsAtIndexPaths:newIndexPaths withRowAnimation:UITableViewRowAnimationNone];
    }else{
        [self.tableView insertRowsAtIndexPaths:newIndexPaths withRowAnimation:UITableViewRowAnimationLeft];
        NSIndexPath *lastIndexPath = newIndexPaths.lastObject;
        [self.tableView scrollToRowAtIndexPath:lastIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:true];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    static NSString *kCellIdentifier = @"cellIdentifier_AlivcMessageCell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
//    if (!cell) {
//        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
//    }
    AlivcMessageListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AlivcMessageListViewCellReuseidentifier];
    cell.backgroundColor = [UIColor clearColor];
    if (indexPath.row < self.dataArray.count) {
        AlivcMessage *object = self.dataArray[indexPath.row];
        cell.msgString = object.showText;
    }else{
        NSAssert(false, @"AlivcMessageList 数据越界");
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < self.dataArray.count) {
        AlivcMessage *message = self.dataArray[indexPath.row];
        if ([self.delegate respondsToSelector:@selector(messageListView:message:touchedWithUserId:)]) {
            [self.delegate messageListView:self message:message touchedWithUserId:message.userId];
        }
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    AlivcMessage *object = self.dataArray[indexPath.row];
    CGRect rect = [object.showText alivc_boundingRectWithSize:CGSizeMake(self.tableView.bounds.size.width-34, MAXFLOAT)];
    return rect.size.height+20;
}

@end
