//
//  ViewController.m
//  CommentDemo
//
//  Created by DreamQ on 2019/6/17.
//  Copyright © 2019 dq. All rights reserved.
//

#import "ViewController.h"
#import "BulletManager.h"

@interface ViewController ()
/*manager*/
@property(nonatomic, strong)BulletManager *manager;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.manager = [[BulletManager alloc] init];
    _manager.Comments = @[@"弹幕1~~~~~",
                          @"弹幕2~~~",
                          @"弹幕3~~~~~~~~~~~~",
                          @"弹幕4~~~~~",
                          @"弹幕5~~~",
                          @"弹幕6~~~~~~~~~~~~",
                          @"弹幕7~~~~~",
                          @"弹幕8~~~",
                          @"弹幕9~~~~~~~~~~~~",
                          @"弹幕10~~~~~",
                          @"弹幕11~~~",
                          @"弹幕12~~~~~~~~~~~~"];
    __weak typeof(self) weakSelf = self;
    self.manager.genralViewBlock = ^(BulletView * _Nonnull bview) {
        [weakSelf addBulletView:bview];
    };
}

-(void)addBulletView:(BulletView *)view {
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    view.frame = CGRectMake(screenW, 300 + view.trajectory * 40, CGRectGetWidth(view.bounds), CGRectGetHeight(view.bounds));
    [self.view addSubview:view];
    [view startAnimation];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.manager.Comments = @[@"弹幕22！~~~~~",
                              @"弹幕33~~~~~~~~~~~~~"];
    [self.manager start];
}

- (IBAction)clickStart:(UIButton *)sender {
    [self.manager start];
}

@end
