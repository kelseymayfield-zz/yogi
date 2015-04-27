//
//  FlowCVCell.m
//  Yogi
//
//  Created by Kelsey Mayfield on 4/27/15.
//  Copyright (c) 2015 Kelsey Mayfield. All rights reserved.
//

#import "FlowCVCell.h"

@implementation FlowCVCell
- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		_imageView = [[UIImageView alloc] init];
		_imageView.contentMode = UIViewContentModeScaleAspectFill;
		_imageView.frame = self.contentView.frame;
		[self.contentView addSubview:_imageView];
	}
	return self;
}
@end
