//
//  Posture.m
//  Yogi
//
//  Created by Kelsey Mayfield on 4/10/15.
//  Copyright (c) 2015 Kelsey Mayfield. All rights reserved.
//

#import "Posture.h"

@implementation Posture

- (instancetype)initWithName:(NSString *)name imageName:(NSString *)imageName instructions:(NSString *)instructions
{
	if (!self) {
		self = [super init];
	}
	self.name = name;
	self.image = [UIImage imageNamed:imageName];
	self.instructions = instructions;
	
	return self;
}

@end
