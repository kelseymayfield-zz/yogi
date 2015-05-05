//
//  PracticeCVDataSource.h
//  Yogi
//
//  Created by Kelsey Mayfield on 4/16/15.
//  Copyright (c) 2015 Kelsey Mayfield. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PracticeCollectionViewCell.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#import "CustomColors.h"

typedef NS_ENUM(NSInteger, CardState) {
	CardState_Normal,           // Display card stacked normally in the deck
	CardState_Selected,         // Display card on its own at top of CollectionView
	CardState_Collapsed         // Display card collapsed to bottom of CollectionView
};

@interface PracticeCVDataSource : NSObject<UICollectionViewDataSource>
-(CardState)cardStateAtIndexPath:(NSIndexPath *)indexPath;
-(void)selectCardAtIndexPath:(NSIndexPath *)indexPath;
-(NSArray *)practices;
@end
