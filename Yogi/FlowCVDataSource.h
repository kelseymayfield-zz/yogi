//
//  FlowCVDataSource.h
//  Yogi
//
//  Created by Kelsey Mayfield on 4/26/15.
//  Copyright (c) 2015 Kelsey Mayfield. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FlowCVCell.h"
#import "CustomColors.h"
@import UIKit;
@import QuartzCore;

@interface FlowCVDataSource : NSObject<UICollectionViewDataSource>
- (id)initWithFlows:(NSArray *)flows;
@end
