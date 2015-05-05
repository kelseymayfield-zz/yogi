//
//  FlowCVDataSource.m
//  Yogi
//
//  Created by Kelsey Mayfield on 4/26/15.
//  Copyright (c) 2015 Kelsey Mayfield. All rights reserved.
//

#import "FlowCVDataSource.h"
@interface FlowCVDataSource()
@property (strong, nonatomic) NSArray *postures;
@end
@implementation FlowCVDataSource

- (id)initWithPostures:(NSArray *)postures
{
	self = [super init];
	self.postures = postures;
	return self;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
	return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return [self.postures count];
}

- (FlowCVCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	FlowCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Posture Cell" forIndexPath:indexPath];
	
	NSDictionary *dict = self.postures[indexPath.row];
	cell.imageView.image = [UIImage imageNamed:dict[@"image"]];
	cell.imageView.backgroundColor = [CustomColors getColor:dict[@"color"]];

	cell.layer.cornerRadius = 5;
	cell.clipsToBounds = YES;
	return cell;
	
}

//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//	UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Posture Cell" forIndexPath:indexPath];
//	
//	NSDictionary *dict = self.postures[indexPath.row];
//	UIImageView *imageView = [[UIImageView alloc] initWithFrame:cell.frame];
//	imageView.image = [UIImage imageNamed:dict[@"image"]];
//	
//	[cell addSubview:imageView];
////	cell.backgroundColor = [UIColor greenColor];
//	
//	cell.layer.cornerRadius = 5;
//	cell.clipsToBounds = YES;
//	return cell;
//}

@end
