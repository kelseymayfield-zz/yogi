//
//  Posture.h
//  Yogi
//
//  Created by Kelsey Mayfield on 4/10/15.
//  Copyright (c) 2015 Kelsey Mayfield. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Posture : NSObject

@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *instructions;

@property (nonatomic) NSInteger numBreaths;

- (instancetype)initWithName:(NSString *)name imageName:(NSString *)imageName instructions:(NSString *)instructions;

@end
