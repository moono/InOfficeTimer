//
//  HomeViewController.h
//  InOfficeTimer
//
//  Created by mookyung song on 9/9/15.
//  Copyright (c) 2015 moono. All rights reserved.
//

#import <UIKit/UIKit.h>

// there are 5 sections
// 0: start time
// 1: total work duration
// 2: total duration of time that user have been gone out
// 3: list of times that the user went out
// 4: end time
typedef NS_ENUM(NSInteger, MySections) {
	START_TIME = 0,
	IN_OFFICE_DAY,
	OUT_OFFICE_DAY,
	OUT_OFFICE_LIST,
	END_TIME,
	NUMBER_OF_SECTIONS,
};

@interface HomeViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *inOutLabel;
@property (weak, nonatomic) IBOutlet UISwitch *inOutSwitch;

- (IBAction)inOutSwitchValueChanged:(id)sender;
- (IBAction)leftNavigationButtonClicked:(id)sender;
- (IBAction)rightNavigationButtonClicked:(id)sender;
- (IBAction)testButtonClicked:(id)sender;
@end
