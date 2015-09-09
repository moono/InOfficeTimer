//
//  HomeViewController.h
//  InOfficeTimer
//
//  Created by mookyung song on 9/9/15.
//  Copyright (c) 2015 moono. All rights reserved.
//

#import <UIKit/UIKit.h>

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
