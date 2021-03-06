//
//  OfficeManager.h
//  InOfficeTimer
//
//  Created by mookyung song on 9/9/15.
//  Copyright (c) 2015 moono. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// define the keys for dictionary
#define kDate @"date"			// NSString from NSDate
#define kStart @"start"			// NSString from NSDate
#define kEnd @"end"				// NSString from NSDate
#define kList @"list"			// NSString from NSDate
#define kIn @"in"				// NSString from NSDate
#define kOut @"out"				// NSString from NSDate
#define kDuration @"duration"	// integer

#define kInside @"inside"
#define kLast @"last"

#define kDurationThreshold 5    // 10 miniutes in seconds


@interface OfficeManager : NSObject

#pragma mark - properties

// flag to indicate whether the user is inside the building or not
@property (nonatomic) BOOL isInsideBuilding;

// for managing time
@property (nonatomic, strong) NSDateFormatter *dateTimeFormatter;   // represents date & time format
@property (nonatomic, strong) NSDateFormatter *dateFormatter;       // represents date format
@property (nonatomic, strong) NSDateFormatter *timeFormatter;       // represents time format

#pragma mark - class methods
// returns singleton
+ (OfficeManager *)defaultInstance;


#pragma mark - instance methods

// modifier
// add time stamp
- (BOOL)addTimeStamp:(NSDate *)time;

// remove item
- (BOOL)removeWholeDay:(NSDate *)date;

// accessor
- (NSArray *)getTimeList:(NSDate *)today;
- (NSString *)getStartTime:(NSDate *)today;
- (NSString *)getEndTime:(NSDate *)today;
- (NSInteger)getNumberOfHistoryCount;
- (NSDictionary *)getHistoryItemByIndex:(NSInteger)index;

// below will return time in minutes
- (NSNumber *)getOutsideDurationWholeDay:(NSDate *)today;
- (NSNumber *)getThisWeeksOutsideDuration:(NSDate *)today;
- (NSNumber *)getWorkDurationWholeDay:(NSDate *)today;
- (NSNumber *)getThisWeeksWorkDuration:(NSDate *)today;

// backup
- (void)saveAsFile;
- (void)loadData;

// UI related
- (void)setSwitch:(UISwitch *)mySwitch andLabel:(UILabel *)label;

@end
