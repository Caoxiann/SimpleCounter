//
//  ChartViewController.h
//  SimpleCounter
//
//  Created by 陈浩贤 on 2017/3/11.
//  Copyright © 2017年 陈浩贤. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChartViewController : UIViewController
@property (strong,nonatomic) NSArray *dataArray;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIView *graphView;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;


- (IBAction)didTapLineView:(UITapGestureRecognizer *)sender;
- (IBAction)segementDidChange:(id)sender;

@end
