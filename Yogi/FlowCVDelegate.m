//
//  FlowCVDelegate.m
//  Yogi
//
//  Created by Kelsey Mayfield on 4/26/15.
//  Copyright (c) 2015 Kelsey Mayfield. All rights reserved.
//

#import "FlowCVDelegate.h"

@implementation FlowCVDelegate
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
	return CGSizeMake(50, 50);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	

}
@end
