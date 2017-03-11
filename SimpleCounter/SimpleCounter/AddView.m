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
<CAAnimationDelegate,UIGestureRecognizerDelegate>
{
    CGFloat screenHeight;
    CGFloat height;
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
        self.panGesture.delegate=self;
        
        screenHeight=[UIScreen mainScreen].bounds.size.height;
        height=self.bounds.size.height;
    }
    return self;
}

-(void)showWithAnimate{
    [self showWithAnimateFrom:screenHeight+height/2];
}

-(void)showWithAnimateFrom:(float)from{

    CASpringAnimation *springAni=[CASpringAnimation animationWithKeyPath:@"position.y"];
    springAni.damping=15;
    springAni.stiffness=100;
    springAni.mass=1;
    springAni.fromValue=@(from);
    springAni.toValue=@(screenHeight-height/2);
    
    springAni.initialVelocity=0;
    springAni.duration=springAni.settlingDuration;
    springAni.fillMode=kCAFillModeForwards;
    springAni.removedOnCompletion=YES;
    springAni.delegate=self;
    
    self.layer.position=CGPointMake(self.center.x, screenHeight-height/2);
    [self.layer addAnimation:springAni forKey:@"springAni"];
}

-(void)dismissWithAnimationFrom:(float)from{

    
    CABasicAnimation *positionAni=[CABasicAnimation animationWithKeyPath:@"position.y"];
    positionAni.fromValue=@(from);
    positionAni.toValue=@(screenHeight+height/2);
    positionAni.duration=0.2f;
    positionAni.delegate=self;
    positionAni.removedOnCompletion=NO;
    positionAni.fillMode=kCAFillModeForwards;
    [self.layer addAnimation:positionAni forKey:@"dismissAni"];
    
}
-(void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    UIBezierPath *maskPath=[UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer=[[CAShapeLayer alloc]init];
    maskLayer.path=maskPath.CGPath;
    maskLayer.frame=self.bounds;
    self.layer.mask=maskLayer;
}

-(void)animationDidStart:(CAAnimation *)anim{
    NSLog(@"animate start");
}


-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if ([self.layer animationForKey:@"dismissAni"]==anim) {
        [self.mainVCDelegate removeAddView];
    }
}

- (IBAction)didPressCancelButton:(id)sender {
    [self dismissWithAnimationFrom:screenHeight-height/2];
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
        
        [self dismissWithAnimationFrom:screenHeight-height/2];
        [_mainVCDelegate reloadTableView];
    }

}

- (IBAction)didTapAddView:(id)sender {
    [self.titleInput resignFirstResponder];
    [self.typeInput resignFirstResponder];
    [self.priceInput resignFirstResponder];
    
    
    NSLog(@"did tap subview");
}

- (IBAction)handlePanGesture:(UIPanGestureRecognizer *)sender {
    
    CGPoint point=[sender translationInView:self];
    if (self.center.y+point.y>screenHeight-height/2) {
        self.center=CGPointMake(self.center.x, self.center.y+point.y);
    }
    CGPoint speed=[sender velocityInView:self];
    
    [sender setTranslation:CGPointMake(0, 0) inView:self];
    
    if (sender.state==UIGestureRecognizerStateEnded&&speed.y>200) {
        [self dismissWithAnimationFrom:self.center.y];
    }else if (sender.state==UIGestureRecognizerStateEnded&&speed.y<200){
        [self showWithAnimateFrom:self.center.y];
    }
    
}



@end
