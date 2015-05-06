//
//  SwipeableCell.m
//  Yogi
//
//  Created by Kelsey Mayfield on 5/5/15.
//  Copyright (c) 2015 Kelsey Mayfield. All rights reserved.
//

#import "SwipeableCell.h"

#define kSectionIndexWidth 15
#define kAccessoryTrailingSpace 15
#define kLongPressMinimumDuration 0.16f

@interface SwipeableCell()
@property (nonatomic, weak) UITableView *containingTableView;
@property (nonatomic, strong) UIView *leftClipView;
@property (nonatomic, strong) SwipeableButtonView *leftButtonView;
@property (nonatomic, strong) NSLayoutConstraint *leftClipConstraint;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGestureRecognizer;
@property (nonatomic, strong) UIPanGestureRecognizer *tableViewPanGestureRecognizer;
@property (nonatomic, assign) CellState cellState;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;

@property (nonatomic, strong) UIScrollView *cellScrollView;

- (CGFloat)buttonWidth;
- (CGFloat)buttonPadding;

- (CGPoint)contentOffsetForCellState:(CellState)state;
- (void)updateCellState;

- (BOOL)shouldHighlight;

@end

@implementation SwipeableCell {
	UIView *_contentCellView;
	BOOL layoutUpdating;
}

- (id)init
{
	self = [super init];
	if (self) {
		[self initialize];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self initialize];
	}
	return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	[self initialize];
	return self;
}

- (void)initialize
{
	layoutUpdating = NO;
	_contentCellView = [UIView new];
	
	// Add the cell scroll view to the cell
	UIView *contentViewParent = self;
	UIView *clipViewParent = self.cellScrollView;
	if (![NSStringFromClass([[self.subviews objectAtIndex:0] class]) isEqualToString:@"UITableViewCellContentView"])
	{
		// iOS 7
		contentViewParent = [self.subviews objectAtIndex:0];
		clipViewParent = self;
	}
	
	NSArray *cellSubviews = [contentViewParent subviews];
	[self insertSubview:self.cellScrollView atIndex:0];
	for (UIView *subview in cellSubviews)
	{
		[_contentCellView addSubview:subview];
	}
	
	NSLog(@"add constraints");
	[self addConstraints:@[
						   [NSLayoutConstraint constraintWithItem:self.cellScrollView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0],
						   [NSLayoutConstraint constraintWithItem:self.cellScrollView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0],
						   [NSLayoutConstraint constraintWithItem:self.cellScrollView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0],
						   [NSLayoutConstraint constraintWithItem:self.cellScrollView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0]
						   ]];
	
	
	self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewTapped:)];
	self.tapGestureRecognizer.cancelsTouchesInView = NO;
	self.tapGestureRecognizer.delegate             = self;
	[self.cellScrollView addGestureRecognizer:self.tapGestureRecognizer];
	
	self.longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewPressed:)];
	self.longPressGestureRecognizer.cancelsTouchesInView = NO;
	self.longPressGestureRecognizer.minimumPressDuration = kLongPressMinimumDuration;
	self.longPressGestureRecognizer.delegate = self;
	[self.cellScrollView addGestureRecognizer:self.longPressGestureRecognizer];
	
	[clipViewParent addSubview:self.leftClipView];
	[self addConstraints:@[
						   [NSLayoutConstraint constraintWithItem:self.leftClipView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0],
						   [NSLayoutConstraint constraintWithItem:self.leftClipView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0],
						   [NSLayoutConstraint constraintWithItem:self.leftClipView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0],
						   self.leftClipConstraint
						   ]];
	[self.leftClipView addSubview:self.leftButtonView];
	[self addConstraints:@[
						   // Pin the button view to the appropriate outer edges of its clipping view.
						   [NSLayoutConstraint constraintWithItem:self.leftButtonView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.leftClipView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0],
						   [NSLayoutConstraint constraintWithItem:self.leftButtonView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.leftClipView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0],
						   [NSLayoutConstraint constraintWithItem:self.leftButtonView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.leftClipView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0],
						   
						   // Constrain the maximum button width so that at least a button's worth of contentView is left visible. (The button view will shrink accordingly.)
						   [NSLayoutConstraint constraintWithItem:self.leftButtonView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.contentView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:-kUtilityButtonWidthDefault],
						   ]];
}

static NSString * const kTableViewPanState = @"state";

- (void)removeOldTableViewPanObserver
{
	[_tableViewPanGestureRecognizer removeObserver:self forKeyPath:kTableViewPanState];
}

- (void)dealloc
{
	_cellScrollView.delegate = nil;
	[self removeOldTableViewPanObserver];
}

- (IBAction)didPressAddButton:(UIButton *)sender {
	
}

- (void)setContainingTableView:(UITableView *)containingTableView
{
	[self removeOldTableViewPanObserver];
	
	_tableViewPanGestureRecognizer = containingTableView.panGestureRecognizer;
	
	_containingTableView = containingTableView;
	
	if (containingTableView)
	{
		// Check if the UITableView will display Indices on the right. If that's the case, add a padding
//		if ([_containingTableView.dataSource respondsToSelector:@selector(sectionIndexTitlesForTableView:)])
//		{
//			NSArray *indices = [_containingTableView.dataSource sectionIndexTitlesForTableView:_containingTableView];
//			self.additionalRightPadding = indices == nil ? 0 : kSectionIndexWidth;
//		}
		
		_containingTableView.directionalLockEnabled = YES;
		
		[self.tapGestureRecognizer requireGestureRecognizerToFail:_containingTableView.panGestureRecognizer];
		
		[_tableViewPanGestureRecognizer addObserver:self forKeyPath:kTableViewPanState options:0 context:nil];
	}
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if([keyPath isEqualToString:kTableViewPanState] && object == _tableViewPanGestureRecognizer)
	{
		if(_tableViewPanGestureRecognizer.state == UIGestureRecognizerStateBegan)
		{
			CGPoint locationInTableView = [_tableViewPanGestureRecognizer locationInView:_containingTableView];
			
			BOOL inCurrentCell = CGRectContainsPoint(self.frame, locationInTableView);
			if(!inCurrentCell && _cellState != kCellStateCenter)
			{
				if ([self.delegate respondsToSelector:@selector(swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:)])
				{
					if([self.delegate swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:self])
					{
						[self hideButtonAnimated:YES];
					}
				}
			}
		}
	}
}

- (void)setButton:(UIButton *)button
{
	if (![button isEqual:self.button]) {
		_button = button;
		self.leftButtonView.button = button;
		
		[self.leftButtonView layoutIfNeeded];
		[self layoutIfNeeded];
	}
}

- (void)setButton:(UIButton *)button WithButtonWidth:(CGFloat)width
{
	_button = button;
	[self.leftButtonView setButton:button WithButtonWidth:width];
	
	[self.leftButtonView layoutIfNeeded];
	[self layoutIfNeeded];
}

#pragma mark - UITableViewCell

- (void)didMoveToSuperview
{
	self.containingTableView = nil;
	UIView *view = self.superview;
	
	do {
		if ([view isKindOfClass:[UITableView class]])
		{
			self.containingTableView = (UITableView *)view;
			break;
		}
	} while ((view = view.superview));
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	// Offset the contentView origin so that it appears correctly w/rt the enclosing scroll view (to which we moved it).
	CGRect frame = self.contentView.frame;
	frame.origin.x = [self buttonWidth];
	_contentCellView.frame = frame;
	
	self.cellScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.frame) + [self buttonPadding], CGRectGetHeight(self.frame));
	
	if (!self.cellScrollView.isTracking && !self.cellScrollView.isDecelerating)
	{
		self.cellScrollView.contentOffset = [self contentOffsetForCellState:_cellState];
	}
	
	[self updateCellState];
}

- (void)setFrame:(CGRect)frame
{
	layoutUpdating = YES;
	// Fix for new screen sizes
	// Initially, the cell is still 320 points wide
	// We need to layout our subviews again when this changes so our constraints clip to the right width
	BOOL widthChanged = (self.frame.size.width != frame.size.width);
	
	[super setFrame:frame];
	
	if (widthChanged)
	{
		[self layoutIfNeeded];
	}
	layoutUpdating = NO;
}

- (void)prepareForReuse
{
	[super prepareForReuse];
	
	[self hideButtonAnimated:NO];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
	// Work around stupid background-destroying override magic that UITableView seems to perform on contained buttons.
	
	[self.leftButtonView pushBackgroundColor];
	
	[super setSelected:selected animated:animated];
	
	[self.leftButtonView popBackgroundColor];
}

- (void)didTransitionToState:(UITableViewCellStateMask)state {
	[super didTransitionToState:state];
	
	if (state == UITableViewCellStateDefaultMask) {
		[self layoutSubviews];
	}
}

#pragma mark - selection handling

- (BOOL)shouldHighlight
{
	BOOL shouldHighlight = YES;
	
	if ([self.containingTableView.delegate respondsToSelector:@selector(tableView:shouldHighlightRowAtIndexPath:)])
	{
		NSIndexPath *cellIndexPath = [self.containingTableView indexPathForCell:self];
		
		shouldHighlight = [self.containingTableView.delegate tableView:self.containingTableView shouldHighlightRowAtIndexPath:cellIndexPath];
	}
	
	return shouldHighlight;
}

- (void)scrollViewPressed:(UIGestureRecognizer *)gestureRecognizer
{
	if (gestureRecognizer.state == UIGestureRecognizerStateBegan && !self.isHighlighted && self.shouldHighlight)
	{
		[self setHighlighted:YES animated:NO];
	}
	
	else if (gestureRecognizer.state == UIGestureRecognizerStateEnded)
	{
		// Cell is already highlighted; clearing it temporarily seems to address visual anomaly.
		[self setHighlighted:NO animated:NO];
		[self scrollViewTapped:gestureRecognizer];
	}
	
	else if (gestureRecognizer.state == UIGestureRecognizerStateCancelled)
	{
		[self setHighlighted:NO animated:NO];
	}
}

- (void)scrollViewTapped:(UIGestureRecognizer *)gestureRecognizer
{
	if (_cellState == kCellStateCenter)
	{
		if (self.isSelected)
		{
			[self deselectCell];
		}
		else if (self.shouldHighlight) // UITableView refuses selection if highlight is also refused.
		{
			[self selectCell];
		}
	}
	else
	{
		// Scroll back to center
		[self hideButtonAnimated:YES];
	}
}

- (void)selectCell
{
	if (_cellState == kCellStateCenter)
	{
		NSIndexPath *cellIndexPath = [self.containingTableView indexPathForCell:self];
		
		if ([self.containingTableView.delegate respondsToSelector:@selector(tableView:willSelectRowAtIndexPath:)])
		{
			cellIndexPath = [self.containingTableView.delegate tableView:self.containingTableView willSelectRowAtIndexPath:cellIndexPath];
		}
		
		if (cellIndexPath)
		{
			[self.containingTableView selectRowAtIndexPath:cellIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
			
			if ([self.containingTableView.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)])
			{
				[self.containingTableView.delegate tableView:self.containingTableView didSelectRowAtIndexPath:cellIndexPath];
			}
		}
	}
}

- (UIScrollView *)cellScrollView
{
	if (!_cellScrollView) {
		_cellScrollView = [UIScrollView new];
		_cellScrollView.translatesAutoresizingMaskIntoConstraints = NO;
		_cellScrollView.delegate = self;
		_cellScrollView.showsHorizontalScrollIndicator = NO;
		_cellScrollView.scrollsToTop = NO;
		_cellScrollView.scrollEnabled = YES;
		
		[_cellScrollView addSubview:_contentCellView];
	}
	return _cellScrollView;
}

- (void)deselectCell
{
	if (_cellState == kCellStateCenter)
	{
		NSIndexPath *cellIndexPath = [self.containingTableView indexPathForCell:self];
		
		if ([self.containingTableView.delegate respondsToSelector:@selector(tableView:willDeselectRowAtIndexPath:)])
		{
			cellIndexPath = [self.containingTableView.delegate tableView:self.containingTableView willDeselectRowAtIndexPath:cellIndexPath];
		}
		
		if (cellIndexPath)
		{
			[self.containingTableView deselectRowAtIndexPath:cellIndexPath animated:NO];
			
			if ([self.containingTableView.delegate respondsToSelector:@selector(tableView:didDeselectRowAtIndexPath:)])
			{
				[self.containingTableView.delegate tableView:self.containingTableView didDeselectRowAtIndexPath:cellIndexPath];
			}
		}
	}
}

#pragma mark - button handling

- (void)leftButtonHandler:(id)sender
{
	NSLog(@"left button handler");
	if ([self.delegate respondsToSelector:@selector(swipeableTableViewCell:didTriggerLeftButtonWithIndex:)]) {
		NSLog(@"HI");
		[self.delegate swipeableTableViewCell:self didTriggerLeftButtonWithIndex:0];
	}
}

- (void)hideButtonAnimated:(BOOL)animated
{
	if (_cellState != kCellStateCenter) {
		[self.cellScrollView setContentOffset:[self contentOffsetForCellState:kCellStateLeft] animated:animated];
		
		if ([self.delegate respondsToSelector:@selector(swipeableTableViewCell:scrollingToState:)]) {
			[self.delegate swipeableTableViewCell:self scrollingToState:kCellStateLeft];
		}
	}
}

- (void)showButtonAnimated:(BOOL)animated
{
	if (_cellState != kCellStateLeft)
	{
		[self.cellScrollView setContentOffset:[self contentOffsetForCellState:kCellStateLeft] animated:animated];
		
		if ([self.delegate respondsToSelector:@selector(swipeableTableViewCell:scrollingToState:)])
		{
			[self.delegate swipeableTableViewCell:self scrollingToState:kCellStateLeft];
		}
	}
}

- (BOOL)isUtilityButtonsHidden {
	return _cellState == kCellStateCenter;
}

#pragma mark - geometry

- (CGFloat)buttonWidth
{
#if CGFLOAT_IS_DOUBLE
	return round(CGRectGetWidth(self.leftButtonView.frame));
#else
	return roundf(CGRectGetWidth(self.leftButtonView.frame));
#endif
}

- (CGFloat)buttonPadding
{
	return [self buttonWidth];
}

- (CGPoint)contentOffsetForCellState:(CellState)state
{
	CGPoint scrollPt = CGPointZero;
	
	switch (state)
	{
		case kCellStateCenter:
			scrollPt.x = [self buttonWidth];
			break;
			
		case kCellStateLeft:
			scrollPt.x = 0;
			break;
	}
	
	return scrollPt;
}

- (void)updateCellState
{
	if(layoutUpdating == NO)
	{
		// Update the cell state according to the current scroll view contentOffset.
		for (NSNumber *numState in @[
									 @(kCellStateCenter),
									 @(kCellStateLeft),
									 ])
		{
			CellState cellState = numState.integerValue;
			
			if (CGPointEqualToPoint(self.cellScrollView.contentOffset, [self contentOffsetForCellState:cellState]))
			{
				_cellState = cellState;
				break;
			}
		}
		
		// Update the clipping on the utility button views according to the current position.
		CGRect frame = [self.contentView.superview convertRect:self.contentView.frame toView:self];
		frame.size.width = CGRectGetWidth(self.frame);
		
		self.leftClipConstraint.constant = MAX(0, CGRectGetMinX(frame) - CGRectGetMinX(self.frame));
		
		if (self.isEditing) {
			self.leftClipConstraint.constant = 0;
			self.cellScrollView.contentOffset = CGPointMake([self buttonWidth], 0);
			_cellState = kCellStateCenter;
		}
		
		self.leftClipView.hidden = (self.leftClipConstraint.constant == 0);
		
		if (self.accessoryType != UITableViewCellAccessoryNone && !self.editing) {
			UIView *accessory = [self.cellScrollView.superview.subviews lastObject];
			
			CGRect accessoryFrame = accessory.frame;
			accessoryFrame.origin.x = CGRectGetWidth(frame) - CGRectGetWidth(accessoryFrame) - kAccessoryTrailingSpace + CGRectGetMinX(frame);
			accessory.frame = accessoryFrame;
		}
		
		// Enable or disable the gesture recognizers according to the current mode.
		if (!self.cellScrollView.isDragging && !self.cellScrollView.isDecelerating)
		{
			self.tapGestureRecognizer.enabled = YES;
			self.longPressGestureRecognizer.enabled = (_cellState == kCellStateCenter);
		}
		else
		{
			self.tapGestureRecognizer.enabled = NO;
			self.longPressGestureRecognizer.enabled = NO;
		}
		
		self.cellScrollView.scrollEnabled = !self.isEditing;
	}
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
	if (velocity.x >= 0.5f)
	{
		_cellState = kCellStateCenter;
	}
	else if (velocity.x <= -0.5f)
	{
		_cellState = kCellStateLeft;
	}
	else
	{
		CGFloat leftThreshold = [self contentOffsetForCellState:kCellStateLeft].x + (self.buttonWidth / 2);
//		CGFloat rightThreshold = [self contentOffsetForCellState:kCellStateRight].x - (self.rightUtilityButtonsWidth / 2);
		
//		if (targetContentOffset->x > rightThreshold)
//		{
//			_cellState = kCellStateRight;
//		}
//		else
		if (targetContentOffset->x < leftThreshold)
		{
			_cellState = kCellStateLeft;
		}
		else
		{
			_cellState = kCellStateCenter;
		}
	}
	
	if ([self.delegate respondsToSelector:@selector(swipeableTableViewCell:scrollingToState:)])
	{
		[self.delegate swipeableTableViewCell:self scrollingToState:_cellState];
	}
	
	if (_cellState != kCellStateCenter)
	{
		if ([self.delegate respondsToSelector:@selector(swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:)])
		{
			for (SwipeableCell *cell in [self.containingTableView visibleCells]) {
				if (cell != self && [cell isKindOfClass:[SwipeableCell class]] && [self.delegate swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:cell]) {
					[cell hideButtonAnimated:YES];
				}
			}
		}
	}
	
	*targetContentOffset = [self contentOffsetForCellState:_cellState];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	if (scrollView.contentOffset.x > [self buttonWidth])
	{
		[scrollView setContentOffset:CGPointMake([self buttonWidth], 0)];
		self.tapGestureRecognizer.enabled = YES;
	}
	else
	{
		// Expose the left button view
		if ([self buttonWidth] > 0)
		{
			if (self.delegate && [self.delegate respondsToSelector:@selector(swipeableTableViewCell:canSwipeToState:)])
			{
				BOOL shouldScroll = [self.delegate swipeableTableViewCell:self canSwipeToState:kCellStateLeft];
				if (!shouldScroll)
				{
					scrollView.contentOffset = CGPointMake([self buttonWidth], 0);
				}
			}
		}
		else
		{
			[scrollView setContentOffset:CGPointMake(0, 0)];
			self.tapGestureRecognizer.enabled = YES;
		}
	}
	
	[self updateCellState];
	
	if (self.delegate && [self.delegate respondsToSelector:@selector(swipeableTableViewCell:didScroll:)]) {
		[self.delegate swipeableTableViewCell:self didScroll:scrollView];
	}
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	[self updateCellState];
	
	if (self.delegate && [self.delegate respondsToSelector:@selector(swipeableTableViewCellDidEndScrolling:)]) {
		[self.delegate swipeableTableViewCellDidEndScrolling:self];
	}
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
	[self updateCellState];
	
	if (self.delegate && [self.delegate respondsToSelector:@selector(swipeableTableViewCellDidEndScrolling:)]) {
		[self.delegate swipeableTableViewCellDidEndScrolling:self];
	}
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	if (!decelerate)
	{
		self.tapGestureRecognizer.enabled = YES;
	}
	
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
	if ((gestureRecognizer == self.containingTableView.panGestureRecognizer && otherGestureRecognizer == self.longPressGestureRecognizer)
		|| (gestureRecognizer == self.longPressGestureRecognizer && otherGestureRecognizer == self.containingTableView.panGestureRecognizer))
	{
		// Return YES so the pan gesture of the containing table view is not cancelled by the long press recognizer
		return YES;
	}
	else
	{
		return NO;
	}
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
	return ![touch.view isKindOfClass:[UIControl class]];
}

- (UIView *)leftClipView
{
	if (!_leftClipView) {
		_leftClipView = [UIView new];
		_leftClipView.translatesAutoresizingMaskIntoConstraints = NO;
		_leftClipView.clipsToBounds = YES;
	}
	return _leftClipView;
}

- (NSLayoutConstraint *)leftClipConstraint
{
	if (!_leftClipConstraint) {
		_leftClipConstraint = [NSLayoutConstraint constraintWithItem:self.leftClipView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0];
		_leftClipConstraint.priority = UILayoutPriorityDefaultHigh;
	}
	return _leftClipConstraint;
}

- (SwipeableButtonView *)leftButtonView
{
	if (!_leftButtonView) {
		_leftButtonView = [[SwipeableButtonView alloc] initWithButton:nil parentCell:self buttonSelector:@selector(leftButtonHandler:)];
	}
	return _leftButtonView;
}

- (void)addScrollView
{
	
}

@end
