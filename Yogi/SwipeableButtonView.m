//
//  SwipeableButtonView.m
//  Yogi
//
//  Created by Kelsey Mayfield on 5/5/15.
//  Copyright (c) 2015 Kelsey Mayfield. All rights reserved.
//

#import "SwipeableButtonView.h"

@interface SwipeableButtonView()
@property (nonatomic, strong) NSLayoutConstraint *widthConstraint;
@property (nonatomic, strong) UIColor *backgroundColor;
@end

@implementation SwipeableButtonView

#pragma mark - SwipeableButtonView initializers

- (id)initWithButton:(UIButton *)button parentCell:(SwipeableCell *)parentCell buttonSelector:(SEL)buttonSelector
{
	self = [self initWithFrame:CGRectZero button:button parentCell:parentCell buttonSelector:buttonSelector];
	return self;
}

- (id)initWithFrame:(CGRect)frame button:(UIButton *)button parentCell:(SwipeableCell *)parentCell buttonSelector:(SEL)buttonSelector
{
	self = [super initWithFrame:frame];
	if (self) {
		self.translatesAutoresizingMaskIntoConstraints = NO;
		self.widthConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:0.0];
		self.widthConstraint.priority = UILayoutPriorityDefaultHigh;
		[self addConstraint:self.widthConstraint];
		
		_parentCell = parentCell;
		self.buttonSelector = buttonSelector;
		self.button = button;
	}
	
	return self;
}

- (void)setButton:(UIButton *)button
{
	[self setButton:button WithButtonWidth:kUtilityButtonWidthDefault];
}

- (void)setButton:(UIButton *)button WithButtonWidth:(CGFloat)width
{
	[self.button removeFromSuperview];
	
	_button = button;
	
	if (button) {
		[self addSubview:button];
		[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[button]" options:0L metrics:nil views:NSDictionaryOfVariableBindings(button)]];
		[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[button]|" options:0L metrics:nil views:NSDictionaryOfVariableBindings(button)]];
		
		UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:_parentCell action:_buttonSelector];
		[button addGestureRecognizer:tapGestureRecognizer];
	}
	self.widthConstraint.constant = width;
	[self setNeedsLayout];
}

- (void)pushBackgroundColor
{
	self.backgroundColor = self.button.backgroundColor;
}

- (void)popBackgroundColor
{
	self.button.backgroundColor = self.backgroundColor;
	self.backgroundColor = nil;
}

@end
