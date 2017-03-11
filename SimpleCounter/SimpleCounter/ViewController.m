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
#import <IQKeyboardReturnKeyHandler.h>

@interface ViewController ()
<MainVCDelegate>
{

}
@property AddView *addView;
@property UIView *shadowView;
@property DataManagement *dataManager;
@property NSDateFormatter *formatter;
@property IQKeyboardReturnKeyHandler *returnKey;
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
    
    self.returnKey=[[IQKeyboardReturnKeyHandler alloc]initWithViewController:self];
    
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
    
    HeaderView *header=[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
    if (header==nil) {
        header=[[NSBundle mainBundle]loadNibNamed:@"HeaderFooterView" owner:nil options:nil][0];
    }
    Note *note=[[self.dataArray objectAtIndex:section]firstObject];
    NSString *weekStr=[self.dataManager getWeeksFromDate:note.date];
    NSString *dateStr=[note.date stringByReplacingCharactersInRange:NSMakeRange(0, 5) withString:@" "];
    
    dateStr=[dateStr stringByReplacingCharactersInRange:NSMakeRange(3, 1) withString:@"月"];
    dateStr=[dateStr stringByAppendingString: @"日   "];
    dateStr=[dateStr stringByAppendingString:weekStr];
    header.dateLabel.text=dateStr;
    
    return header;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    FooterView *footer=[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"footer"];
    if (footer==nil) {
        footer=[[NSBundle mainBundle]loadNibNamed:@"HeaderFooterView" owner:nil options:nil][1];
    }
    
    double total=0;
    for (Note *note in [self.dataArray objectAtIndex:section]) {
        total=total+note.price;
    }
    
    NSString *priceStr=[[NSString alloc]initWithFormat:@"-%.2f 元",total];
    footer.priceLabel.text=priceStr;
    
    return footer;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    Note *deleteNote=[[self.dataArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    
    [self.dataManager deleteNoteNumber:deleteNote.number];
    
    
//    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    [self reloadTableView];
}

-(void)removeAddView{
    [self.addView removeFromSuperview];
    [self.shadowView removeFromSuperview];
}

- (IBAction)segmentDidChange:(id)sender {
    [self performSegueWithIdentifier:@"showChartVC" sender:self];
}

- (IBAction)didTapAddButton:(id)sender {
    _addView=[[AddView alloc]initAddView];
    _addView.mainVCDelegate=self;
    
    
    _shadowView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    _shadowView.backgroundColor=[UIColor grayColor];
    _shadowView.alpha=0.4;
    [self.view addSubview:_shadowView];
    [self.view addSubview:_addView];
    [_addView showWithAnimate];
    
}

- (IBAction)didTapVC:(id)sender {
    NSLog(@"did tap super view");
}

-(void)reloadTableView{
    self.dataArray=[self.dataManager getNoteFormDataBase];
    [self.tableView reloadData];
}

@end


@implementation ChartViewController

-(void)viewDidLoad{
    [super viewDidLoad];
}


- (IBAction)segementDidChange:(id)sender {
    [self performSegueWithIdentifier:@"showTableVC" sender:self];
}
@end
