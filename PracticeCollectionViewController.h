//
//  PracticeCollectionViewController.h
//  Yogi
//
//  Created by Kelsey Mayfield on 4/16/15.
//  Copyright (c) 2015 Kelsey Mayfield. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PracticeCVDataSource.h"
#import "PracticeCVLayout.h"
#import "PracticeCollectionViewCell.h"
#import "FlowDetailTableViewController.h"

@interface PracticeCollectionViewController : UICollectionViewController
- (void)addFlows:(NSArray *)flows;
@end
