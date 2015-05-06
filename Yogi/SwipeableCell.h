//
//  SwipeableCell.h
//  Yogi
//
//  Created by Kelsey Mayfield on 5/5/15.
//  Copyright (c) 2015 Kelsey Mayfield. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwipeableButtonView.h"

typedef NS_ENUM(NSInteger, CellState)
{
	kCellStateCenter,
	kCellStateLeft
};

@protocol SwipeableCellDelegate <NSObject>

@optional
- (void)swipeableTableViewCell:(SwipeableCell *)cell didTriggerLeftButtonWithIndex:(NSInteger)index;
- (void)swipeableTableViewCell:(SwipeableCell *)cell scrollingToState:(CellState)state;
- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SwipeableCell *)cell;
- (BOOL)swipeableTableViewCell:(SwipeableCell *)cell canSwipeToState:(CellState)state;
- (void)swipeableTableViewCellDidEndScrolling:(SwipeableCell *)cell;
- (void)swipeableTableViewCell:(SwipeableCell *)cell didScroll:(UIScrollView *)scrollView;

@end

@interface SwipeableCell : UITableViewCell<UIScrollViewDelegate, UIGestureRecognizerDelegate>
@property (strong, nonatomic) NSString *labelText;
@property (nonatomic, copy) UIButton *button;
@property (nonatomic, weak) id<SwipeableCellDelegate> delegate;

- (void)setButton:(UIButton *)button WithButtonWidth:(CGFloat) width;
- (void)hideButtonAnimated:(BOOL)animated;
- (void)showButtonAnimated:(BOOL)animated;

- (BOOL)isUtilityButtonsHidden;
@end
