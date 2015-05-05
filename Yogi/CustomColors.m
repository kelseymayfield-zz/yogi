//
//  CustomColors.m
//  Yogi
//
//  Created by Kelsey Mayfield on 5/4/15.
//  Copyright (c) 2015 Kelsey Mayfield. All rights reserved.
//

#import "CustomColors.h"

@implementation CustomColors

+ (UIColor *)redColor {
	return [self getColor:@"redColor"];
}

+ (UIColor *)orangeColor {
	return [self getColor:@"orangeColor"];
}

+ (UIColor *)yellowColor {
	return [self getColor:@"yellowColor"];
}

+ (UIColor *)greenColor {
	return [self getColor:@"greenColor"];
}

+ (UIColor *)blueColor {
	return [self getColor:@"blueColor"];
}

+ (UIColor *)purpleColor {
	return [self getColor:@"purpleColor"];
}

+ (UIColor *)greyColor {
	return [self getColor:@"greyColor"];
}

+ (UIColor *)hotPinkColor {
	return [self getColor:@"hotPinkColor"];
}

+ (UIColor *)getColor:(NSString *)name {
	
	NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Label Colors" ofType:@"plist"]];
	NSNumber *n = dictionary[name];
	return UIColorFromRGB([n integerValue]);
}

@end
