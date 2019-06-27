//
//  BulletManager.h
//  CommentDemo
//
//  Created by DreamQ on 2019/6/17.
//  Copyright © 2019 dq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BulletView.h"

NS_ASSUME_NONNULL_BEGIN

@interface BulletManager : NSObject
-(void)start;
-(void)stop;
-(void)add;
/*block*/
@property(nonatomic, copy)void (^genralViewBlock)(BulletView *bview);
@property(nonatomic, strong)NSArray *Comments;
@end

NS_ASSUME_NONNULL_END
