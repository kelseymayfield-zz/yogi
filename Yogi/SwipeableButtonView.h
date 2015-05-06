//
//  SwipeableButtonView.h
//  Yogi
//
//  Created by Kelsey Mayfield on 5/5/15.
//  Copyright (c) 2015 Kelsey Mayfield. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SwipeableCell;

#define kUtilityButtonWidthDefault 90

@interface SwipeableButtonView : UIView

- (id)initWithButton:(UIButton *)button parentCell:(SwipeableCell *)parentCell buttonSelector:(SEL)buttonSelector;
- (id)initWithFrame:(CGRect)frame button:(UIButton *)button parentCell:(SwipeableCell *)parentCell buttonSelector:(SEL)buttonSelector;

@property (nonatomic, weak, readonly) SwipeableCell *parentCell;
@property (nonatomic, copy) UIButton *button;
@property (nonatomic, assign) SEL buttonSelector;

- (void)setButton:(UIButton *)button WithButtonWidth:(CGFloat)width;
- (void)pushBackgroundColor;
- (void)popBackgroundColor;
@end
