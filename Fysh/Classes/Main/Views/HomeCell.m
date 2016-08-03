//
//  HomeCell.m
//  Fysh
//
//  Created by QUAN on 16/7/19.
//  Copyright © 2016年 QUAN. All rights reserved.
//

#import "HomeCell.h"


@interface HomeCell ()

@property (weak, nonatomic) IBOutlet UIButton *homeImg;

@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@end

@implementation HomeCell

-(void)setFyshM:(FyshModel *)fyshM{
    
    _fyshM = fyshM;
    
    _nameLab.text = fyshM.fName;
    
    if (![fyshM.imgPath isEqualToString:@"(null)"]) {
        [_homeImg setImage:[UIImage imageWithContentsOfFile:fyshM.imgPath] forState:UIControlStateNormal];
    }else{
        [_homeImg setImage:[UIImage imageNamed:fyshM.imageName] forState:UIControlStateNormal];
    }

}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _homeImg.layer.cornerRadius = 50;
    _homeImg.layer.masksToBounds = YES;
    _homeImg.layer.borderColor = [UIColor darkGrayColor].CGColor;
    _homeImg.layer.borderWidth = 1;
}

@end
