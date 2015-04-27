//
//  PracticeCollectionViewCell.m
//  Yogi
//
//  Created by Kelsey Mayfield on 4/16/15.
//  Copyright (c) 2015 Kelsey Mayfield. All rights reserved.
//

#import "PracticeCollectionViewCell.h"
#import <QuartzCore/QuartzCore.h>

@interface PracticeCollectionViewCell()
@property (strong, nonatomic) UILabel *titleLabel;
@property (readwrite, nonatomic) NSArray *flows;
@end

@implementation PracticeCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
	if (self) {
		UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
		view.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
		view.layer.cornerRadius = 10.0;
		view.clipsToBounds = YES;
		[self.contentView addSubview:view];
		
		self.layer.shadowColor = [UIColor blackColor].CGColor;
		self.layer.shadowOffset = CGSizeMake(0, -2);
		self.layer.shadowOpacity = .75;
		self.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:10].CGPath;
		
		self.clipsToBounds = NO;
		
		[self.contentView addSubview:self.titleLabel];
		[self.contentView addSubview:self.practiceView];
	}
	
	return self;
}

- (void)setLabel:(NSString *)label withColor:(UIColor *)color
{
	self.titleLabel.text = label;
	if ([label isEqualToString:@"New Practice"]) {
		self.titleLabel.userInteractionEnabled = YES;
	}
	self.titleLabel.textColor = color;
}

- (UILabel *)titleLabel
{
	if (!_titleLabel) {
		_titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 3, CGRectGetWidth(self.contentView.frame), 60)];
		_titleLabel.textAlignment = NSTextAlignmentLeft;
		_titleLabel.font = [UIFont systemFontOfSize:30];
		_titleLabel.textColor = [UIColor whiteColor];
		_titleLabel.backgroundColor = [UIColor clearColor];
	}
	return _titleLabel;
}

- (UIView *)practiceView
{
	if (!_practiceView) {
		_practiceView = [[UIView alloc] initWithFrame:CGRectMake(10, 70, CGRectGetWidth(self.contentView.frame)-20, CGRectGetHeight(self.contentView.frame)-80)];
		_practiceView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
		UIButton *btn = [UIButton new];
		btn.frame = CGRectMake(10, CGRectGetHeight(self.contentView.frame) - 150, CGRectGetWidth(self.contentView.frame)-20, 30);
		[btn setTitle:@"Start Practice" forState:UIControlStateNormal];
		[btn setTitleColor:self.contentView.tintColor forState:UIControlStateNormal];
		[btn addTarget:self action:@selector(didPressStartButton:) forControlEvents:UIControlEventTouchUpInside];
		[_practiceView addSubview:btn];
		[_practiceView addSubview:self.flowView];
	}
	return _practiceView;
}

- (void)didPressStartButton:(id)sender
{
	[[NSNotificationCenter defaultCenter] postNotificationName:@"Start Practice Notification" object:self];
}

- (BOOL)hasLabel
{
	return self.titleLabel.text != nil;
}

- (void)addFlows:(NSArray *)flows
{
	_flows = flows;
//	CGRect frame = CGRectMake(0, 0, self.practiceView.bounds.size.width, self.practiceView.bounds.size.height - 100);
//	NSLog(@"make layout");
//	UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//	NSLog(@"make flow view");
//
//	self.flowView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
//	NSLog(@"make data source and delegate");
//
////	FlowCVDataSource *dataSource = [[FlowCVDataSource alloc] initWithPostures:flows];
//	FlowCVDataSource *dataSource = [[FlowCVDataSource alloc] init];
//	FlowCVDelegate *delegate = [[FlowCVDelegate alloc] init];
//	
//	NSLog(@"set datasource and delegate");
//
//	self.flowView.dataSource = dataSource;
//	self.flowView.delegate = delegate;
//	[self.flowView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Posture Cell"];
//	self.flowView.backgroundColor = [UIColor greenColor];
//	NSLog(@"add subview");
//	[self.practiceView addSubview:self.flowView];
//	NSLog(@"done");
//	UITextView *textView = [[UITextView alloc] initWithFrame:frame textContainer:nil];
//	textView.backgroundColor = self.practiceView.backgroundColor;
//	NSString *string = @"";
//	for (NSDictionary *d in flows) {
//		NSString *flow = d[@"name"];
//		string = [string stringByAppendingString:[NSString stringWithFormat:@"%@\n", flow]];
//	}
//	textView.text = string;
//	[self.practiceView addSubview:textView];
}

+ (NSString *)reuseIdentifier
{
	return @"Practice Cell";
}

- (UICollectionView *)flowView
{
	if (!_flowView) {
		CGRect frame = CGRectMake(0, 0, self.practiceView.bounds.size.width, self.practiceView.bounds.size.height - 100);
		UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
		_flowView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
		[_flowView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Posture Cell"];
	}
	return _flowView;
}

- (FlowCVDataSource *)flowDataSource
{
	if (!_flowDataSource) {
		_flowDataSource = [[FlowCVDataSource alloc] initWithPostures:self.flows];
	}
	return _flowDataSource;
}

- (FlowCVDelegate *)flowDelegate
{
	if (!_flowDelegate) {
		_flowDelegate = [[FlowCVDelegate alloc] init];
	}
	return  _flowDelegate;
}
@end
