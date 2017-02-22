//
//  ViewController.m
//  SimpleCounter
//
//  Created by 陈浩贤 on 2017/2/22.
//  Copyright © 2017年 陈浩贤. All rights reserved.
//

#import "ViewController.h"
#import "NoteTableViewCell.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    self.tableView.rowHeight=100;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoteTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell=[NoteTableViewCell noteTableCelll];
    }
    return cell;
}

- (IBAction)segmentDidChange:(id)sender {
}

- (IBAction)didTapAddButton:(id)sender {
}
@end
