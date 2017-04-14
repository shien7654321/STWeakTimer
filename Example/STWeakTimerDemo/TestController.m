//
//  TestController.m
//  STWeakTimerDemo
//
//  Created by Suta on 2017/4/14.
//  Copyright © 2017年 Suta. All rights reserved.
//

#import "TestController.h"
#import <STWeakTimer/STWeakTimer.h>

@interface TestController ()

@end

@implementation TestController {
    STWeakTimer *_timer;
    NSMutableArray <NSNumber *>*_testArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _testArray = [NSMutableArray array];
    __weak typeof(_testArray) weakTestArray = _testArray;
    __weak typeof(self) weakSelf = self;
    _timer = [STWeakTimer scheduledTimerWithTimeInterval:1 userInfo:nil repeats:YES handler:^(STWeakTimer * _Nullable timer) {
        CFTimeInterval timestamp = CACurrentMediaTime();
        NSLog(@"Timer handler: %f", timestamp);
        [weakTestArray addObject:@(timestamp)];
        [weakSelf.tableView reloadData];
    }];
}

#pragma mark - Event

- (IBAction)rightBarButtonItemClicked:(UIBarButtonItem *)sender {
    if ([sender.title isEqualToString:@"Pause"]) {
        sender.title = NSLocalizedString(@"Resume", );
        [_timer pause];
    } else if ([sender.title isEqualToString:@"Resume"]) {
        sender.title = NSLocalizedString(@"Pause", );
        [_timer resume];
    }
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _testArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TestCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TestCell class]) forIndexPath:indexPath];
    cell.lblMain.text = _testArray[indexPath.row].stringValue;
    return cell;
}

@end

#pragma mark -

@implementation TestCell

@end
