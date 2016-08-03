//
//  MainCell.m
//  Fysh
//
//  Created by QUAN on 16/7/15.
//  Copyright © 2016年 QUAN. All rights reserved.
//

#import "MainCell.h"

@interface MainCell ()


@end

@implementation MainCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _titleImag.width = _titleImag.height;
    
    _titleImag.layer.cornerRadius = _titleImag.height / 2;
    _titleImag.layer.borderWidth = 2;
    _titleImag.layer.masksToBounds = YES;

}

@end
