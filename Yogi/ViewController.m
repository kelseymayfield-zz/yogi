//
//  ViewController.m
//  Yogi
//
//  Created by Kelsey Mayfield on 4/10/15.
//  Copyright (c) 2015 Kelsey Mayfield. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *postureView;
@property (weak, nonatomic) IBOutlet UILabel *postureLabel;
@property (strong, nonatomic) NSArray *flow;
@property (nonatomic) NSInteger idx;
@property (nonatomic) NSInteger breathsLeft;
@property (strong, nonatomic) InstructionReader *instructionReader;
@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	_idx = 0, _breathsLeft = 0;
	Posture *p = self.flow[_idx];

	[_postureView setImage:p.image];
	[_postureView.layer setMasksToBounds:YES];
	[_postureView.layer setCornerRadius:10.0];
	_postureLabel.text = p.name;
	[self.instructionReader addInstruction:p.instructions];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUI) name:@"FinishedSpeechNotification" object:nil];
}

- (void)updateUI
{
	if (_breathsLeft > 0)
		_breathsLeft--;
	else {
		_idx++;
		if (_idx < [self.flow count]) {
	//		NSLog(@"%f", _postureView.layer.cornerRadius);
			Posture *p = self.flow[_idx];
			_postureLabel.text = p.name;
			if (!p.numBreaths) {
				[self.instructionReader addInstruction:p.instructions];
				_breathsLeft = 0;
			}
			else {
				[self.instructionReader addInstruction:p.instructions withBreaths:p.numBreaths];
				_breathsLeft = p.numBreaths*2;
			}

			if (![p.image isEqual:_postureView.image]) {
				_postureView.image = p.image;

				CATransition *transition = [CATransition animation];
				transition.startProgress = 0;
				transition.endProgress = 1.0;
				transition.type = kCATransitionPush;
				transition.subtype = kCATransitionFromRight;
				transition.duration = 0.3;

				[_postureView.layer addAnimation:transition forKey:@"transition"];
			}
		}
		
	}
}

- (void)viewWillDisappear:(BOOL)animated
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[super viewWillDisappear:animated];
}

- (NSArray *)flow
{
	if (!_flow) {
		NSMutableArray *array = [NSMutableArray new];
		for (NSDictionary *d in self.practiceInfo) {
			Posture *p = [[Posture alloc] initWithName:d[@"name"] imageName:d[@"image"] instructions:d[@"instructions"]];
			NSInteger breaths = [d[@"breaths"] integerValue];
			if (breaths)
				p.numBreaths = breaths;
			[array addObject:p];
		}
		
		_flow = [NSArray arrayWithArray:array];
	}
	return _flow;
}

- (InstructionReader *)instructionReader
{
	if (!_instructionReader) {
		_instructionReader = [[InstructionReader alloc] init];
	}
	return _instructionReader;
}

@end
