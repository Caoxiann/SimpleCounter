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
#import <SVProgressHUD.h>
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
        self.dataManager=[DataManagement shareDataManagement];
        
    }
    return self;
}


-(void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    UIBezierPath *maskPath=[UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer=[[CAShapeLayer alloc]init];
    maskLayer.path=maskPath.CGPath;
    maskLayer.frame=self.bounds;
    self.layer.mask=maskLayer;
}

- (IBAction)didPressCancelButton:(id)sender {
    [self.mainVCDelegate removeAddView];
}

- (IBAction)didPressConfirmButton:(id)sender {
    if ([self.titleInput.text length]==0||[self.typeInput.text length]==0||[self.priceInput.text length]==0) {
        [SVProgressHUD setMaximumDismissTimeInterval:2.0];
        [SVProgressHUD showErrorWithStatus:@"请完整填写内容"];
    }else{
        NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSString *date=[formatter stringFromDate:[NSDate date]];
        Note *newNote=[[Note alloc]initWithData:0 title:self.titleInput.text type:self.typeInput.text price:[self.priceInput.text doubleValue] date:date];
        
        [self.dataManager insertNote:newNote];
        
        [_mainVCDelegate removeAddView];
        [_mainVCDelegate reloadTableView];
    }

    NSLog(@"add");
}

- (IBAction)didTapAddView:(id)sender {
    [self.titleInput resignFirstResponder];
    [self.typeInput resignFirstResponder];
    [self.priceInput resignFirstResponder];
}
@end
