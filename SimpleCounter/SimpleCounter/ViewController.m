//
//  ViewController.m
//  SimpleCounter
//
//  Created by 陈浩贤 on 2017/2/22.
//  Copyright © 2017年 陈浩贤. All rights reserved.
//

#import "ViewController.h"
#import "NoteTableViewCell.h"
#import "HeaderFooterView.h"
#import "AddView.h"
#import "Note.h"
#import "DataManagement.h"
@interface ViewController ()
<MainVCDelegate>
{
    
}
@property AddView *addView;
@property UIView *shadowView;
@property DataManagement *dataManager;
@property NSDateFormatter *formatter;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    self.tableView.rowHeight=100;
    
    self.dataManager=[DataManagement shareDataManagement];
    self.dataArray=[self.dataManager getNoteFormDataBase];
    self.formatter=[[NSDateFormatter alloc]init];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.dataArray count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[self.dataArray objectAtIndex:section]count];
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoteTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell=[NoteTableViewCell noteTableCelll];
    }
    Note *note=[[self.dataArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    cell.titleLabel.text=note.title;
    cell.typeLabel.text=note.type;
    cell.priceLabel.text=[NSString stringWithFormat:@"-%.2f 元",note.price];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 40;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    HeaderFooterView *headerView=[HeaderFooterView headerView];
    Note *note=[[self.dataArray objectAtIndex:section]firstObject];
    NSString *weekStr=[self.dataManager getWeeksFromDate:note.date];
    NSString *dateStr=[note.date stringByReplacingCharactersInRange:NSMakeRange(0, 5) withString:@" "];
    
    dateStr=[dateStr stringByReplacingCharactersInRange:NSMakeRange(3, 1) withString:@"月"];
    dateStr=[dateStr stringByAppendingString: @"日   "];
    dateStr=[dateStr stringByAppendingString:weekStr];
    headerView.dateLabel.text=dateStr;
    return headerView;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    HeaderFooterView *footerView=[HeaderFooterView footerView];
    double total=0;
    for (Note *note in [self.dataArray objectAtIndex:section]) {
        total=total+note.price;
    }
    NSString *priceStr=[[NSString alloc]initWithFormat:@"%.2f 元",total];
    
    NSLog(@"footer:%@",footerView.priceLabel);
    footerView.priceLabel.text=priceStr;
   
    
    return footerView;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    Note *deleteNote=[[self.dataArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    
    [self.dataManager deleteNoteNumber:deleteNote.number];
    
//    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    [self reloadTableView];
}

- (IBAction)segmentDidChange:(id)sender {
}

- (IBAction)didTapAddButton:(id)sender {
    _addView=[[AddView alloc]initAddView];
    _addView.mainVCDelegate=self;
    [self.view addSubview:_addView];    
}

-(void)reloadTableView{
    self.dataArray=[self.dataManager getNoteFormDataBase];
    [self.tableView reloadData];
}
@end
