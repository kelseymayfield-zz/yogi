//
//  PracticeCVDataSource.m
//  Yogi
//
//  Created by Kelsey Mayfield on 4/16/15.
//  Copyright (c) 2015 Kelsey Mayfield. All rights reserved.
//

#import "PracticeCVDataSource.h"

@interface PracticeCVDataSource()
@property (strong, nonatomic) NSMutableArray *cards;
@property (strong, nonatomic) NSArray *practices;
@end

@implementation PracticeCVDataSource
- (id)init
{
	self = [super init];
	if (self) {
		[self resetCards];
	}
	return self;
}

- (void)resetCards
{
	_cards = [[NSMutableArray alloc] initWithArray:
			@[ [NSNumber numberWithInteger:CardState_Normal],
			   [NSNumber numberWithInteger:CardState_Normal],
			   [NSNumber numberWithInteger:CardState_Normal],
			   [NSNumber numberWithInteger:CardState_Normal],
			   [NSNumber numberWithInteger:CardState_Normal],
			   [NSNumber numberWithInteger:CardState_Normal],
			   [NSNumber numberWithInteger:CardState_Normal],
			   [NSNumber numberWithInteger:CardState_Normal]]];
}

- (CardState)cardStateAtIndexPath:(NSIndexPath *)indexPath
{
	NSNumber *cardState = _cards[indexPath.row];
	return [cardState integerValue];
}

- (void)selectCardAtIndexPath:(NSIndexPath *)indexPath
{
	CardState cardState = [self cardStateAtIndexPath:indexPath];
	
	switch (cardState) {
		case CardState_Normal:
			[self collapseRows:indexPath.row];
			break;
			
		case CardState_Selected:
		case CardState_Collapsed:
			[self expandRows];
		default:
			break;
	}
}

- (void)expandRows
{
	[self resetCards];
}

- (void) collapseRows: (NSUInteger)selectedRow
{
	for (NSUInteger index=0; index < [_cards count]; index++) {
		if (index == selectedRow) {
			_cards[index] = [NSNumber numberWithInteger:CardState_Selected];
		}
		else {
			_cards[index] = [NSNumber numberWithInteger:CardState_Collapsed];
		}
	}
}

-(NSArray *)practices
{
	if (!_practices)
	 _practices = @[
					@{},
					@{
						@"title":@"Sun Salutation A",@"flows": @[@"sun salutation a"],@"color":UIColorFromRGB(0xff9500)},
					@{
						@"title":@"Sun Salutation B",@"flows": @[@"sun salutation b"],@"color":UIColorFromRGB(0xff3b30)
						},
					@{
						@"title":@"Full Sun Salutation",@"flows":@[@"sun salutation a", @"sun salutation a", @"sun salutation b", @"sun salutation b"],@"color":UIColorFromRGB(0x34aadc)
						},
					@{
						@"title":@"Bird of paradise practice",@"flows":@[@"sun salutation a", @"sun salutation b", @"warrior", @"bird of paradise", @"dandasana", @"plow"],@"color":[CustomColors greenColor]
						}
					];
	return _practices;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
	return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return [self.practices count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	PracticeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[PracticeCollectionViewCell reuseIdentifier] forIndexPath:indexPath];
	
	if (indexPath.row == 0) {
		cell.hasLabel = NO;
	} else {
		cell.hasLabel = YES;
	}
	
	NSDictionary *dict = self.practices[indexPath.row];
	if (dict[@"title"]) { // Normal cell
		[cell setLabel:dict[@"title"] withColor:dict[@"color"]];
		NSArray *flows = [self getFlows:indexPath];
		[cell addFlows:flows];
	} else {
		[cell setLabel:@"New Practice" withColor:[UIColor grayColor]];
	}
	
	cell.flowView.delegate = cell.flowDelegate;
	cell.flowView.dataSource = cell.flowDataSource;
	cell.flowView.backgroundColor = [CustomColors getColor:@"offWhiteColor"];
	
	[cell.flowView reloadData];
	
	return cell;
}

- (NSArray *)getFlows:(NSIndexPath *)indexPath
{
	NSMutableArray *flows = [NSMutableArray new];
	NSArray *flowNames = [self.practices[indexPath.row] objectForKey:@"flows"];
	
	NSArray *arr = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"flows" ofType:@"plist"]];
	
	for (NSString *flowName in flowNames) {
		for (NSDictionary *dict in arr) {
			if ([dict[@"name"] isEqualToString:flowName])
			[flows addObject:dict];
		}
//		NSArray *array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:flowName ofType:@"plist"]];
//		[flows addObjectsFromArray:array];
	}
	if ([flowNames count] == 0) {
		// add a + marker for adding a new flow
	}
	return [NSArray arrayWithArray:flows];
}

- (void)addPractice:(NSDictionary *)practice
{
	NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:_practices.count+1];
	[array addObjectsFromArray:_practices];
	[array addObject:practice];
	_practices = [NSArray arrayWithArray:array];
}

@end
