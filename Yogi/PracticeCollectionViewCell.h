//
//  PracticeCollectionViewCell.h
//  Yogi
//
//  Created by Kelsey Mayfield on 4/16/15.
//  Copyright (c) 2015 Kelsey Mayfield. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlowCVDataSource.h"
#import "FlowCVDelegate.h"
#import "FlowCVCell.h"
#import "CustomColors.h"
#import <POP/POP.h>

@interface PracticeCollectionViewCell : UICollectionViewCell<UIGestureRecognizerDelegate, UITextFieldDelegate>
- (void)setLabel:(NSString *)label withColor:(UIColor *)color;
- (void)addFlows:(NSArray *)flows;
- (void)setButtonLabel:(NSString *)label;
+ (NSString *)reuseIdentifier;
@property (strong, nonatomic) UIView *practiceView;
@property (nonatomic) BOOL hasLabel;
@property (readonly, nonatomic) NSArray *flows;
@property (strong, nonatomic) UICollectionView *flowView;
@property (strong, nonatomic) FlowCVDataSource *flowDataSource;
@property (strong, nonatomic) FlowCVDelegate *flowDelegate;

#define POSTURE_CELL @"Posture Cell"
@end
