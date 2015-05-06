//
//  SwipeableCellScrollView.m
//  Yogi
//
//  Created by Kelsey Mayfield on 5/5/15.
//  Copyright (c) 2015 Kelsey Mayfield. All rights reserved.
//

#import "SwipeableCellScrollView.h"

@implementation SwipeableCellScrollView

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
	if (gestureRecognizer == self.panGestureRecognizer) {
		CGPoint translation = [(UIPanGestureRecognizer *)gestureRecognizer translationInView:gestureRecognizer.view];
		return fabs(translation.y) <= fabs(translation.x);
	} else {
		return YES;
	}
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
	if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
		CGFloat yVelocity = [(UIPanGestureRecognizer *)gestureRecognizer velocityInView:gestureRecognizer.view].y;
		return fabs(yVelocity) <= 0.25;
	}
	
	return YES;
}

@end
