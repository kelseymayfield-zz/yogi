//
//  AddFlowTableViewController.m
//  Yogi
//
//  Created by Kelsey Mayfield on 5/5/15.
//  Copyright (c) 2015 Kelsey Mayfield. All rights reserved.
//

#import "AddFlowTableViewController.h"

@interface AddFlowTableViewController ()
@property (strong, nonatomic) NSMutableArray *userFlows;
@property (strong, nonatomic) NSArray *flows;
@property (strong, nonatomic) NSMutableDictionary *flowGroups;
@property (strong, nonatomic) NSIndexPath *expandedIndexPath;
@end

@implementation AddFlowTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	_userFlows = [NSMutableArray new];
	_flows = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"flows" ofType:@"plist"]];
	_flowGroups = [NSMutableDictionary new];
	[self sortFlows];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)sortFlows
{
	for (NSDictionary *dict in self.flows) {
		NSMutableArray *arr;
		NSString *color = dict[@"color"];
		if (![_flowGroups objectForKey:color]) {
			arr = [NSMutableArray new];
			_flowGroups[color] = arr;
		} else {
			arr = _flowGroups[color];
		}
		[arr addObject:dict];
	}
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [[self.flowGroups allKeys] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	NSArray *keys = [self.flowGroups allKeys];
	NSString *key = keys[section];
	NSArray *flows = self.flowGroups[key];
    return [flows count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SwipeableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Add Flow Cell" forIndexPath:indexPath];
    
    // Configure the cell...
	UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, cell.frame.size.height)];
	[addButton setTitle:@"Add" forState:UIControlStateNormal];
	[addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	addButton.backgroundColor = [CustomColors greenColor];
	[cell setButton:addButton WithButtonWidth:100.0];
	cell.delegate = self;
	
	UIButton *accessoryButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
	[accessoryButton setUserInteractionEnabled:NO];
	cell.accessoryView = accessoryButton;
	
	NSArray *keys = [self.flowGroups allKeys];
	NSString *key = keys[indexPath.section];
	NSArray *flows = self.flowGroups[key];
	NSDictionary *dict = flows[indexPath.row];
	
	cell.tintColor = [CustomColors purpleColor];
	cell.textLabel.text = dict[@"name"];
	cell.imageView.image = [UIImage imageNamed:dict[@"image"]];
	cell.imageView.backgroundColor = [CustomColors getColor:dict[@"color"]];
	cell.accessoryType = UIButtonTypeContactAdd;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	NSArray *keys = [self.flowGroups allKeys];
	NSString *key = keys[section];
	if ([key isEqualToString:@"redColor"]) {
		return @"Warm up";
	} else if ([key isEqualToString:@"orangeColor"]) {
		return @"Primary series";
	} else if ([key isEqualToString:@"yellowColor"]) {
		return @"Intermediate series";
	} else if ([key isEqualToString:@"greenColor"]) {
		return @"Peak poses";
	} else if ([key isEqualToString:@"blueColor"]) {
		return @"Cool down";
	} else {
		return @"Final relaxation";
	}
}

- (void)swipeableTableViewCell:(SwipeableCell *)cell scrollingToState:(CellState)state
{
	switch (state) {
		case 0:
			NSLog(@"utility buttons closed");
			break;
		case 1:
			NSLog(@"left utility buttons open");
			break;
		default:
			break;
	}
}

- (void)swipeableTableViewCell:(SwipeableCell *)cell didTriggerLeftButtonWithIndex:(NSInteger)index
{
	switch (index) {
		case 0:
			NSLog(@"left button 0 was pressed");
			NSDictionary *d = self.flows[[self.tableView indexPathForCell:cell].row];
			[self.userFlows addObject:d];
			break;
//		case 1:
//			NSLog(@"left button 1 was pressed");
//			break;
//		case 2:
//			NSLog(@"left button 2 was pressed");
//			break;
//		case 3:
//			NSLog(@"left btton 3 was pressed");
//		default:
//			break;
	}
}

- (BOOL)swipeableTableViewCellShouldHideButtonOnSwipe:(SwipeableCell *)cell
{
	// allow just one cell's utility button to be open at once
	return YES;
}

- (BOOL)swipeableTableViewCell:(SwipeableCell *)cell canSwipeToState:(CellState)state
{
	switch (state) {
		case 1:
			// set to NO to disable all left utility buttons appearing
			return YES;
			break;
		default:
			break;
	}
	
	return YES;
}

/*
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView beginUpdates];
	if ([indexPath compare:self.expandedIndexPath] == NSOrderedSame) {
		self.expandedIndexPath = nil;
	} else {
		self.expandedIndexPath = indexPath;
	}
	
	[tableView endUpdates];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if ([indexPath compare:self.expandedIndexPath] == NSOrderedSame) {
		return 100.0;
	}
	
	return 44.0;
}
 */

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.destinationViewController isKindOfClass:[PracticeCollectionViewController class]]) {
		PracticeCollectionViewController *vc = (PracticeCollectionViewController *)segue.destinationViewController;
		[vc addFlows:self.userFlows];
	}
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
