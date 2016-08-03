//
//  CategoryCell.m
//  Fysh
//
//  Created by QUAN on 16/7/15.
//  Copyright © 2016年 QUAN. All rights reserved.
//

#import "CategoryCell.h"

@interface CategoryCell ()


@end

@implementation CategoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _titleImg.layer.cornerRadius = 50;
    _titleImg.layer.borderWidth = 2;
    _titleImg.layer.masksToBounds = YES;
}

@end
