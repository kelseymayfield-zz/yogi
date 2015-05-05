//
//  FlowCVDataSource.m
//  Yogi
//
//  Created by Kelsey Mayfield on 4/26/15.
//  Copyright (c) 2015 Kelsey Mayfield. All rights reserved.
//

#import "FlowCVDataSource.h"
@interface FlowCVDataSource()
@property (strong, nonatomic) NSArray *flows;
@end
@implementation FlowCVDataSource

- (id)initWithFlows:(NSArray *)flows
{
	self = [super init];
	self.flows = flows;
	return self;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
	return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return [self.flows count];
}

- (FlowCVCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	FlowCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Posture Cell" forIndexPath:indexPath];
	
	NSDictionary *dict = self.flows[indexPath.row];
	cell.imageView.image = [UIImage imageNamed:dict[@"image"]];
	cell.imageView.backgroundColor = [CustomColors getColor:dict[@"color"]];

	cell.layer.cornerRadius = 5;
	cell.clipsToBounds = YES;
	return cell;
	
}

- (NSArray *)flows
{
	return _flows;
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
