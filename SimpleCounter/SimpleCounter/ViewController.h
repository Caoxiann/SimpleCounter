//
//  ViewController.h
//  SimpleCounter
//
//  Created by 陈浩贤 on 2017/2/22.
//  Copyright © 2017年 陈浩贤. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface ViewController : UIViewController
<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property NSMutableArray *dataArray;

- (IBAction)segmentDidChange:(id)sender;
- (IBAction)didTapAddButton:(id)sender;

-(void)reloadTableView;
@end


@interface ChartViewController : UIViewController
- (IBAction)segementDidChange:(id)sender;

@end
