//
//  AddView.m
//  SimpleCounter
//
//  Created by 陈浩贤 on 2017/2/25.
//  Copyright © 2017年 陈浩贤. All rights reserved.
//

#import "AddView.h"
#import "DataManagement.h"
#import "ViewController.h"
@interface AddView ()
{
    
}
@property DataManagement *dataManager;

@end

@implementation AddView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initAddView{
    self=[super init];
    if (self) {
        self=[[NSBundle mainBundle]loadNibNamed:@"AddView" owner:nil options:nil][0];
        [self setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-500, [UIScreen mainScreen].bounds.size.width,500 )];
        self.layer.cornerRadius=10;
        self.dataManager=[DataManagement shareDataManagement];
        
    }
    return self;
}


-(void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    _shadowView=[[UIView alloc]initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64)];
    _shadowView.backgroundColor=[UIColor grayColor];
    _shadowView.alpha=0.4;
    [newSuperview addSubview:_shadowView];
    
}

- (IBAction)didPressCancelButton:(id)sender {
    [_shadowView removeFromSuperview];
    [self removeFromSuperview];
    
}

- (IBAction)didPressConfirmButton:(id)sender {
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *date=[formatter stringFromDate:[NSDate date]];
    Note *newNote=[[Note alloc]initWithData:0 title:self.titleInput.text type:self.typeInput.text price:[self.priceInput.text doubleValue] date:date];
    
    [self.dataManager insertNote:newNote];
    
    [_shadowView removeFromSuperview];
    [self removeFromSuperview];
    [_mainVCDelegate reloadTableView];
    NSLog(@"add");
}
@end
