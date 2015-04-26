//
//  PracticeCVLayout.h
//  Yogi
//
//  Created by Kelsey Mayfield on 4/16/15.
//  Copyright (c) 2015 Kelsey Mayfield. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PracticeCVDataSource.h"

@interface PracticeCVLayout : UICollectionViewLayout

@property (nonatomic, readwrite) NSUInteger visibleCellHeight;
@property (nonatomic, readwrite) NSUInteger actualCellHeight;

@end
