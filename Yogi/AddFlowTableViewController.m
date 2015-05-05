//
//  AddFlowTableViewController.m
//  Yogi
//
//  Created by Kelsey Mayfield on 5/5/15.
//  Copyright (c) 2015 Kelsey Mayfield. All rights reserved.
//

#import "AddFlowTableViewController.h"

@interface AddFlowTableViewController ()
@property (strong, nonatomic) NSArray *flows;
@property (strong, nonatomic) NSMutableDictionary *flowGroups;
@end

@implementation AddFlowTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	_flows = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"flows" ofType:@"plist"]];
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
    return [self.flowGroups count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	NSArray *keys = [self.flowGroups allKeys];
	NSString *key = keys[section];
	NSArray *flows = self.flowGroups[key];
    return [flows count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Add Flow Cell" forIndexPath:indexPath];
    
    // Configure the cell...
	NSArray *keys = [self.flowGroups allKeys];
	NSString *key = keys[indexPath.section];
	NSArray *flows = self.flowGroups[key];
	NSDictionary *dict = flows[indexPath.row];
	cell.textLabel.text = dict[@"name"];
	cell.imageView.image = [UIImage imageNamed:dict[@"image"]];
	cell.imageView.backgroundColor = [CustomColors getColor:dict[@"color"]];
	cell.accessoryType = UIButtonTypeContactAdd;
    return cell;
}


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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
