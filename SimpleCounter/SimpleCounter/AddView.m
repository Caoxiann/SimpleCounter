//
//  AddView.m
//  SimpleCounter
//
//  Created by 陈浩贤 on 2017/2/25.
//  Copyright © 2017年 陈浩贤. All rights reserved.
//

#import "AddView.h"

@implementation AddView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+(instancetype)initAddView{
    AddView *addView=[[NSBundle mainBundle]loadNibNamed:@"AddView" owner:nil options:nil][0];
    [addView setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-500, [UIScreen mainScreen].bounds.size.width,500 )];
    addView.layer.cornerRadius=10;
    

    return addView;
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
    NSLog(@"add");
}
@end
