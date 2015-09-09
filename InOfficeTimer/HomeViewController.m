//
//  HomeViewController.m
//  InOfficeTimer
//
//  Created by mookyung song on 9/9/15.
//  Copyright (c) 2015 moono. All rights reserved.
//

#import "HomeViewController.h"
#import "OfficeManager.h"
#import "HomeTableViewCell.h"

@interface HomeViewController () <UITableViewDataSource, UITableViewDelegate> {
	// there are 5 sections
	// 0: start time
	// 1: total work duration
	// 2: total duration of time that user have been gone out
	// 3: list of times that the user went out
	// 4: end time
	enum mySections {
		START_TIME = 0,
		IN_OFFICE_DAY,
		OUT_OFFICE_DAY,
		OUT_OFFICE_LIST,
		END_TIME,
		NUMBER_OF_SECTIONS,
	};
}

@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *endTime;
@property (nonatomic, strong) NSString *totalWorkDurationDay;
@property (nonatomic, strong) NSString *totalWorkDurationWeek;
@property (nonatomic, strong) NSString *totalOffDurationDay;
@property (nonatomic, strong) NSString *totalOffDurationWeek;

@property (nonatomic, strong) NSArray *todaysList;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	// set refresh control to table view
	UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
	[refreshControl addTarget:self action:@selector(refreshTableView:) forControlEvents:UIControlEventValueChanged];
	[_tableView addSubview:refreshControl];
	
	// initialize date formatter
	_dateFormatter = [[NSDateFormatter alloc] init];
	[_dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	
	// create or load WorkTimeManager
	OfficeManager *manager = [OfficeManager defaultInstance];
	[manager loadData];
	
	// start showing current time
	[self showDateTime:self];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	// update UI
	[self refreshUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshTableView:(UIRefreshControl *)refreshControl {
	// do refreshing job
	[self refreshUI];
	
	[refreshControl endRefreshing];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

#pragma mark - table view protocols
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	// Return NO if you do not want the specified item to be editable.
	return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	return UITableViewCellEditingStyleDelete;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		// Delete the row from the data source
//		OfficeManager *manager = [OfficeManager defaultInstance];
//		NSDictionary *item = [manager getHistoryItemByIndex:indexPath.row];
//		NSDate *currentDate = [[manager dateTimeFormatter] dateFromString:[item valueForKey:kDate]];
//		[manager removeWholeDay:currentDate];
		
		//[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
	}
	//    else if (editingStyle == UITableViewCellEditingStyleInsert) {
	//        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
	//    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	//DetailTableViewCell *cell = (DetailTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
	
	// perform segue for detail view
	//[self performSegueWithIdentifier:<#(NSString *)#> sender:self];
	
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	NSString *sectionName;
	switch (section)
	{
		case START_TIME:
			sectionName = @"You came to office at...";
			break;
		case IN_OFFICE_DAY:
			sectionName = @"You've been working for...";
			break;
		case OUT_OFFICE_DAY:
			sectionName = @"You were off around...";
			break;
		case OUT_OFFICE_LIST:
			sectionName = @"Off office list";
			break;
		case END_TIME:
			sectionName = @"You've previously left the office at...";
			break;
		default:
			sectionName = @"";
			break;
	}
	return sectionName;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return NUMBER_OF_SECTIONS;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSInteger rows = 0;
	switch (section) {
		case START_TIME:
			rows = 1;
			break;
		case IN_OFFICE_DAY:
			rows = 1;
			break;
		case OUT_OFFICE_DAY:
			rows = 1;
			break;
		case OUT_OFFICE_LIST:
			rows = [_todaysList count];
			break;
		case END_TIME:
			rows = 1;
			break;
		default:
			rows = 0;
			break;
	}
	return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"homeViewCell";
	HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	// initialize cell color & text first
	cell.textLabel.backgroundColor = [UIColor whiteColor];
	cell.textLabel.textColor = [UIColor blackColor];
	cell.textLabel.text = @"";
	
	switch (indexPath.section) {
		case START_TIME:
			if ([_startTime isEqualToString:@""]) {
				cell.textLabel.text = @"Not yet specified!!";
			}
			else {
				cell.textLabel.text = _startTime;
			}
			break;
		case IN_OFFICE_DAY:
			if ([_totalWorkDurationDay isEqualToString:@""]) {
				cell.textLabel.text = @"Not yet specified!!";
			}
			else {
				cell.textLabel.text = _totalWorkDurationDay;
			}
			break;
		case OUT_OFFICE_DAY:
			if ([_totalOffDurationDay isEqualToString:@""]) {
				cell.textLabel.text = @"Not yet specified!!";
			}
			else {
				cell.textLabel.text = _totalOffDurationDay;
			}
			break;
		case OUT_OFFICE_LIST:
		{
			// customize cell
			NSDictionary *data = _todaysList[indexPath.row];
			if (data) {
				OfficeManager *manager = [OfficeManager defaultInstance];
				NSDateFormatter *managerDateTimeFormatter = [manager dateTimeFormatter];
				NSDateFormatter *managerTimeFormatter = [manager timeFormatter];
				NSDate *inDate = [managerDateTimeFormatter dateFromString:[data valueForKey:kIn]];
				NSDate *outDate = [managerDateTimeFormatter dateFromString:[data valueForKey:kOut]];
				NSString *displayString = [NSString stringWithFormat:@"[%@s]: %@ ~ %@", [data[kDuration] stringValue], [managerTimeFormatter stringFromDate:inDate], [managerTimeFormatter stringFromDate:outDate]];
				[cell.textLabel setText:displayString];
				
				// change color if needed
				if ([data[kDuration] intValue] > kDurationThreshold) {
					cell.textLabel.backgroundColor = [UIColor redColor];
					cell.textLabel.textColor = [UIColor whiteColor];
				}
			}
			break;
		}
		case END_TIME:
			if ([_endTime isEqualToString:@""]) {
				cell.textLabel.text = @"Not yet specified!!";
			}
			else {
				cell.textLabel.text = _endTime;
			}
			break;
		default:
			break;
	}
	
	
	return cell;
}

#pragma mark - UI display
- (void)showDateTime:(id)sender {
	// to get current date
	NSDate *today = [NSDate date];
	
	// set time & date to label
	[_dateLabel setText:[_dateFormatter stringFromDate:today]];
	
	// tell controller to call this method for every second
	[self performSelector:@selector(showDateTime:) withObject:self afterDelay:1.0];
}

- (void)refreshUI {
	// get current date
	NSDate *currentDate = [NSDate date];
	
	// get todays array
	OfficeManager *manager = [OfficeManager defaultInstance];
	
	// get starting time
	_startTime = [manager getStartTime:currentDate];
	if (_startTime == nil) {
		_startTime = @"";
	}
	
	// get end time
	_endTime = [manager getEndTime:currentDate];
	if (_endTime == nil) {
		_endTime = @"";
	}
	
	// get total in office duration: day
	NSNumber *workDurationDay = [manager getWorkDurationWholeDay:currentDate];
	if (workDurationDay == nil) {
		_totalWorkDurationDay = @"";
	}
	else {
		_totalWorkDurationDay = [NSString stringWithFormat:@"%@ m", [workDurationDay stringValue]];
	}
	
	// get total off office duration: day
	NSNumber *outsideDurationDay = [manager getOutsideDurationWholeDay:currentDate];
	if(outsideDurationDay == nil) {
		_totalOffDurationDay = @"";
	}
	else {
		_totalOffDurationDay = [NSString stringWithFormat:@"%@ m", [outsideDurationDay stringValue]];
	}
	
	// get list of all off office list
	_todaysList = [manager getTimeList:currentDate];
	if (_todaysList == nil) {
		_todaysList = [[NSArray alloc] init];
	}
	
	//    // get total in office duration: week
	//    NSNumber *workDurationWeek = [manager getThisWeeksWorkDuration:currentDate];
	//    if (workDurationWeek == nil) {
	//        _totalWorkDurationWeek = @"";
	//    }
	//    else {
	//        _totalWorkDurationWeek = [NSString stringWithFormat:@"%@ m", [workDurationWeek stringValue]];
	//    }
	//
	//    // get total off office duration: week
	//    NSNumber *outsideDurationWeek = [manager getThisWeeksOutsideDuration:currentDate];
	//    if(outsideDurationWeek == nil) {
	//        _totalOffDurationWeek = @"";
	//    }
	//    else {
	//        _totalOffDurationWeek = [NSString stringWithFormat:@"%@ m", [outsideDurationWeek stringValue]];
	//    }
	
	// set switch control
	[manager setSwitch:_inOutSwitch andLabel:_inOutLabel];
	
	// refresh table view
	[_tableView reloadData];
}

#pragma mark - Action events
- (IBAction)inOutSwitchValueChanged:(id)sender {
	OfficeManager *manager = [OfficeManager defaultInstance];
	if ([sender isOn]) {
		[manager setIsInsideBuilding:YES];
	}
	else {
		[manager setIsInsideBuilding:NO];
	}
	
	[manager setSwitch:_inOutSwitch andLabel:_inOutLabel];
}

- (IBAction)leftNavigationButtonClicked:(id)sender {
}

- (IBAction)rightNavigationButtonClicked:(id)sender {
}

- (IBAction)testButtonClicked:(id)sender {
	OfficeManager *manager = [OfficeManager defaultInstance];
	BOOL isAppropriate = [manager addTimeStamp:[NSDate date]];
	if (isAppropriate == FALSE) {
		UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Something Wrong!!" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
		[alert show];
	}
	
	// update UI
	[self refreshUI];
}
@end
