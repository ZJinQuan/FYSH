//
//  CircleView.m
//  Fysh
//
//  Created by QUAN on 16/7/18.
//  Copyright © 2016年 QUAN. All rights reserved.
//

#import "CircleView.h"

@implementation CircleView


- (void)drawRect:(CGRect)rect {
    
    
    //获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //设置笔触颜色
    CGContextSetStrokeColorWithColor(ctx, [UIColor blackColor].CGColor);
    
    //设置线宽
    CGContextSetLineWidth(ctx, 1);
    
    //设置填充颜色
    CGContextSetFillColorWithColor(ctx, [UIColor lightGrayColor].CGColor);
    
    //设置拐点的模式
    CGContextSetLineJoin(ctx, kCGLineJoinBevel);
    
    //设置线尖的模式
    CGContextSetLineCap(ctx, kCGLineCapRound);

    [self drawCircle:ctx];
}


-(void) drawCircle: (CGContextRef) ctx {
    
    CGContextSetStrokeColorWithColor(ctx, RGBA(137, 137, 137, 1).CGColor);
    
    //画圆
    CGContextAddArc(ctx, self.width / 2, self.height / 2, 99, 0, M_PI * 2, 0);
    
    CGContextStrokePath(ctx);
    
    CGContextAddArc(ctx, self.width / 2, 30, 15, 0, M_PI * 2, 0);
    CGContextStrokePath(ctx);
    
}

@end
