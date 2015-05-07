//
//  FlowDetailTableViewController.h
//  Yogi
//
//  Created by Kelsey Mayfield on 5/7/15.
//  Copyright (c) 2015 Kelsey Mayfield. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PracticeCollectionViewController.h"
#import "CustomColors.h"

@interface FlowDetailTableViewController : UITableViewController<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) NSArray *flows;
@end
