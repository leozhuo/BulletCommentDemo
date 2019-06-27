//
//  BulletView.m
//  CommentDemo
//
//  Created by DreamQ on 2019/6/17.
//  Copyright © 2019 dq. All rights reserved.
//

#import "BulletView.h"

@interface BulletView()
/*弹幕label*/
@property(nonatomic, strong)UILabel *lbComment;
@end
@implementation BulletView

-(instancetype)initWithComment:(NSString *)comment {
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        
        NSDictionary *attr = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
        CGFloat width = [comment sizeWithAttributes:attr].width;
        
        self.bounds = CGRectMake(0, 0, width + 20, 30);
        
        self.lbComment.text = comment;
        self.lbComment.frame = CGRectMake(10, 0, width, 30);
    }
    return self;
}

- (void)startAnimation {
    //弹幕越长，s速度越快
    //v = s/t
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    CGFloat duration = 4.0;
    CGFloat wholeWidth = screenW + CGRectGetWidth(self.bounds);
    
    if (self.moveStatusBlock) {
        self.moveStatusBlock(Start);
    }

//    t = s/v
    CGFloat speed = wholeWidth / duration;
    //这个时间是弹幕完全进入屏幕的时候，也就刚刚全部进入的那一刻所用的时间
    CGFloat enterDuration = CGRectGetWidth(self.bounds) / speed;
    [self performSelector:@selector(EnterScreen) withObject:nil afterDelay:enterDuration];
    
    __block CGRect frame = self.frame;
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        frame.origin.x -= wholeWidth;
        self.frame = frame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        
        [NSTimer cancelPreviousPerformRequestsWithTarget:self];
        if (self.moveStatusBlock) {
            self.moveStatusBlock(End);
        }
    }];
}

-(void)EnterScreen {
    if (self.moveStatusBlock) {
        self.moveStatusBlock(Enter);
    }

}

- (void)stopAnimation {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self.layer removeAllAnimations];
    [self removeFromSuperview];
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(afterEnter) userInfo:nil repeats:YES];
}

- (void)afterEnter {
    if (self.moveStatusBlock) {
        self.moveStatusBlock(AfterEnter);
    }
}

- (UILabel *)lbComment {
    if (!_lbComment) {
        _lbComment = [[UILabel alloc] initWithFrame:CGRectZero];
        _lbComment.font = [UIFont systemFontOfSize:14];
        _lbComment.textColor = [UIColor blackColor];
        _lbComment.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_lbComment];
    }
    return _lbComment;
}

@end
