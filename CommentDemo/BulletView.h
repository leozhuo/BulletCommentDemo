//
//  BulletView.h
//  CommentDemo
//
//  Created by DreamQ on 2019/6/17.
//  Copyright © 2019 dq. All rights reserved.
//

#import <UIKit/UIKit.h>

//弹幕的状态
typedef NS_ENUM(NSInteger, MoveStatus) {
    Start,//弹幕开始生成
    Enter,//弹幕动画过程中,刚好完全全部出来的那个状态
    AfterEnter,//继上个状态之后的所有过程，也是动画过程中，只不过这个过程是属于完全出来之后的动画
    End//弹幕结束
};

NS_ASSUME_NONNULL_BEGIN

@interface BulletView : UIView
/*弹道*/
@property(nonatomic, assign)NSInteger trajectory;
/*弹幕状态回调*/
@property(nonatomic, copy) void(^moveStatusBlock)(MoveStatus status);


-(instancetype)initWithComment:(NSString *)comment;

-(void)startAnimation;
-(void)stopAnimation;
@end

NS_ASSUME_NONNULL_END
