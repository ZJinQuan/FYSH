//
//  ALActionSheetView.h
//  ALActionSheetView
//
//  Created by WangQi on 7/4/15.
//  Copyright (c) 2015 WangQi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ALActionSheetView;

typedef void (^ALActionSheetViewDidSelectButtonBlock)(ALActionSheetView *actionSheetView, NSInteger buttonIndex);

@interface ALActionSheetView : UIView

+ (ALActionSheetView *)showActionSheetWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles handler:(ALActionSheetViewDidSelectButtonBlock)block;

- (instancetype)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles handler:(ALActionSheetViewDidSelectButtonBlock)block;

- (void)show;
- (void)dismiss;

/**
 *  title text color
 */
@property (strong, nonatomic) UIColor *titleTextColor;
/**
 *  destructive title color
 */
@property (strong, nonatomic) UIColor *destructiveButtonTitleColor;
/**
 *  cancel title color
 */
@property (strong, nonatomic) UIColor *cancelButtonTitleColor;
/**
 *  just one botton in titles index
 */
@property (assign, nonatomic) NSInteger otherButtonTitlesIndex;
/**
 *  just one botton title text color
 */
@property (strong, nonatomic) UIColor *otherButtonTitlesIndexColor;

/**
 *  other title color  ----- unusable
 */
//@property (strong, nonatomic) NSMutableDictionary *otherButtonTitlesColor;

@end
