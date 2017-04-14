//
//  TestController.h
//  STWeakTimerDemo
//
//  Created by Suta on 2017/4/14.
//  Copyright © 2017年 Suta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestController : UITableViewController

@end

#pragma mark -

@interface TestCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblMain;

@end
