//
//  BulletManager.m
//  CommentDemo
//
//  Created by DreamQ on 2019/6/17.
//  Copyright © 2019 dq. All rights reserved.
//

#import "BulletManager.h"
#import "BulletView.h"

@interface BulletManager()
/*数据源，存放所有弹幕内容*/
@property(nonatomic, strong)NSMutableArray *dataSrouce;
/*使用过程中的数组*/
@property(nonatomic, strong)NSMutableArray *bulletComent;
/*存储弹幕view的数量数组*/
@property(nonatomic, strong)NSMutableArray *bulletViews;

//是否停止了动画
@property BOOL bStopAnimation;
//用于标记新增加的弹道是否重复,记的是d上一条的弹道
@property NSInteger tra;
@end

@implementation BulletManager
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.bStopAnimation = YES;
        self.tra = 1;
    }
    return self;
}

//有新增弹幕的话，在这里接收
- (void)setComments:(NSArray *)Comments {
    _Comments = Comments;
    
    if (self.bStopAnimation) {
        [self.dataSrouce addObjectsFromArray:Comments];
    } else {
        [self.bulletComent addObjectsFromArray:Comments];
    }
}

- (void)start {
    if (!self.bStopAnimation) {
        return;
    }
    if (self.dataSrouce.count == 0) {
        return;
    }
    self.bStopAnimation = NO;
    [self.bulletComent removeAllObjects];
    [self.bulletComent addObjectsFromArray:self.dataSrouce];
    [self.dataSrouce removeAllObjects];
    [self initBulletComment];
}

- (void)stop {
    if (self.bStopAnimation) {
        return;
    }
    [self.bulletViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BulletView *view = obj;
        [view stopAnimation];
        view = nil;
    }];
    [self.bulletViews removeAllObjects];
}

-(void)add {
    
}

//初始化弹幕，随机分配弹道
-(void)initBulletComment {
    //设置弹幕只有三行
    NSMutableArray *trajectorys = [NSMutableArray arrayWithArray:@[@(0),@(1),@(2)]];
    for (NSInteger i = 0; i < 3; i++) {
        if (self.bulletComent.count > 0) {
            NSInteger index = arc4random()%trajectorys.count;
            NSInteger trajectory = [[trajectorys objectAtIndex:index] integerValue];
            [trajectorys removeObjectAtIndex:index];
            
            //从弹幕数组逐一取出弹幕
            NSString *comment = [self.bulletComent firstObject];
            [self.bulletComent removeObjectAtIndex:0];
            
            //创建弹幕view
            [self createBulletView:comment trajectory:trajectory];
        }
    }
}

-(void)createBulletView:(NSString *)comment trajectory:(NSInteger)trajectory {
    if (self.bStopAnimation) {
        return;
    }
    BulletView *bView = [[BulletView alloc] initWithComment:comment];
    bView.trajectory = trajectory;
//    [self.bulletViews addObject:bView];
    
    __weak typeof(bView) weakView = bView;
    __weak typeof(self) weakSelf = self;
    bView.moveStatusBlock = ^(MoveStatus status){
        if (weakSelf.bStopAnimation) {
            return;
        }
        //移除屏幕后释放
        switch (status) {
            case Start:
                //弹幕开始进入屏幕，将view加入弹幕view数组里面bulletViews中
                [weakSelf.bulletViews addObject:weakView];
                break;
            case Enter: {
                //弹幕完全进入屏幕，判断是否还有其他内容，如果有则在该轨迹中创建一个弹幕
                NSString *nextcomment = [weakSelf nextComment];
                if (nextcomment) {
                    [weakSelf createBulletView:nextcomment trajectory:trajectory];
                }
                break;
            }
            case AfterEnter:{
                NSString *nextcomment = [weakSelf nextComment];
                //这样做是避免两条弹幕重叠在一起
                NSInteger news;
                if (self.tra == trajectory) {
                    news = [self getTrajectory:trajectory];
                } else {
                    news = self.tra;
                    self.tra = trajectory;
                }
                if (nextcomment) {
                    [weakSelf createBulletView:nextcomment trajectory:news];
                }
                break;
            }
            case End: {
                //弹幕飞出屏幕后从bulletViews删除，释放资源
                if ([weakSelf.bulletViews containsObject:weakView]) {
                    [weakView stopAnimation];
                    [weakSelf.bulletViews removeObject:weakView];
                }
                if (weakSelf.bulletViews.count == 0) {
                    //说明已经没有弹幕了，开始循环，实际开发的话这里不会有这个操作
                    self.bStopAnimation = YES;
//                    [weakSelf start];
                }
                break;
            }
            default:
                break;
        }
    };
    
    if (self.genralViewBlock) {
        self.genralViewBlock(bView);
    }
}

//获取不同弹道，如有更好的写法，欢迎改进，本人渣渣，只懂这样写
-(NSInteger)getTrajectory:(NSInteger)oldTra {
    NSMutableArray *trajectorys = [NSMutableArray arrayWithArray:@[@(0),@(1),@(2)]];
    NSInteger index = arc4random()%trajectorys.count;
    NSInteger newtrajectory = [[trajectorys objectAtIndex:index] integerValue];
    if (newtrajectory == oldTra) {
        NSInteger index = arc4random()%trajectorys.count;
        newtrajectory = [[trajectorys objectAtIndex:index] integerValue];
    } else {
        [trajectorys removeObjectAtIndex:index];
    }
    return newtrajectory;
}

//判断有没有下一个内容
-(NSString *)nextComment {
    if (self.bulletComent.count == 0) {
        return nil;
    }
    NSString *comment = [self.bulletComent firstObject];
    if (comment) {
        [self.bulletComent removeObjectAtIndex:0];
    }
    return comment;
}

- (NSMutableArray *)dataSrouce {
    if (!_dataSrouce) {
        _dataSrouce = [NSMutableArray array];
    }
    return _dataSrouce;
}

- (NSMutableArray *)bulletComent {
    if (!_bulletComent) {
        _bulletComent = [NSMutableArray array];
    }
    return _bulletComent;
}

- (NSMutableArray *)bulletViews {
    if (!_bulletViews) {
        _bulletViews = [NSMutableArray array];
    }
    return _bulletViews;
}
@end
