//
//  ChartViewController.m
//  SimpleCounter
//
//  Created by 陈浩贤 on 2017/3/11.
//  Copyright © 2017年 陈浩贤. All rights reserved.
//

#import "ChartViewController.h"

@interface ChartViewController ()
<CAAnimationDelegate>
{
    CGFloat lineViewHeight;
    CGFloat lineViewWidth;
    CGFloat graphViewHeight;
    CGFloat graphViewWidth;
}
@property CGPoint result;
@property UILabel *dataLabel;
@end

@implementation ChartViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    self.lineView.layer.cornerRadius=10;
    

}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    lineViewHeight=self.lineView.bounds.size.height;
    lineViewWidth=self.lineView.bounds.size.width;
    graphViewWidth=self.graphView.bounds.size.width;
    graphViewHeight=self.graphView.bounds.size.height;

    NSArray *dayArray=[NSArray arrayWithObjects:@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日", nil];
    self.dataArray=[NSArray arrayWithObjects:@(120.11),@(0),@(211),@(32),@(25),@(16),@(22), nil];
    
    self.result=[self calculatePricePerPixcialAndAverageWithDataArray:self.dataArray];
    
    
    [self drawFadeBackgroundView];
    [self drawAxis];
    [self drawDashLineWithResult:self.result];
    [self drawPointsWithResult:self.result data:self.dataArray];
    [self drawLinesWithResult:self.result data:self.dataArray];
    [self calculateTotalLabel];
    [self creatLabelOnXwithData:dayArray];
}
- (IBAction)segementDidChange:(id)sender {
    [self performSegueWithIdentifier:@"showTableVC" sender:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)drawAxis{
    UIBezierPath *axis=[UIBezierPath bezierPath];
    [axis moveToPoint:CGPointMake(10, 32)];
    [axis addLineToPoint:CGPointMake(lineViewWidth-10, 32)];
    [axis moveToPoint:CGPointMake(10, lineViewHeight-20)];
    [axis addLineToPoint:CGPointMake(lineViewWidth-10, lineViewHeight-20)];
    axis.lineWidth=1.0f;
    axis.lineJoinStyle=kCGLineJoinRound;
    
    CAShapeLayer *axisLayer=[CAShapeLayer layer];
    axisLayer.path=axis.CGPath;
    axisLayer.fillColor=nil;
    axisLayer.strokeColor=[UIColor whiteColor].CGColor;
    axisLayer.opacity=0.5;
    [self.lineView.layer addSublayer:axisLayer];
}

-(void)creatLabelOnXwithData:(NSArray *)dataArray{
    CGFloat days=[dataArray count];
    CGFloat spacing=lineViewWidth/days;
    
    for (int i=0; i<days; i++) {
        UILabel *dayLabel=[[UILabel alloc]initWithFrame:CGRectMake(10+spacing*i, lineViewHeight-15, spacing,15)];
        dayLabel.text=[dataArray objectAtIndex:i];
        dayLabel.textAlignment=NSTextAlignmentLeft;
        [dayLabel setFont:[UIFont systemFontOfSize:12 weight:0.1]];
        dayLabel.textColor=[UIColor whiteColor];
        [self.lineView addSubview:dayLabel];
    }
}

-(CGPoint)calculatePricePerPixcialAndAverageWithDataArray:(NSArray *)dataArray{
    int topPrice=0,total=0;
    for (int i=0; i<[dataArray count]; i++) {
        int price=[[dataArray objectAtIndex:i]intValue];
        
        if (price>=topPrice) {
            topPrice=price;
        }
        total=total+price;
    }
    topPrice=topPrice+(50-topPrice%50);
    
    float ppp=(lineViewHeight-60)/(float)topPrice;
    float average=total/(float)[dataArray count];
    
    CGPoint result=CGPointMake(ppp, average);
    return result;
}

-(void)drawFadeBackgroundView{
    CAGradientLayer *gradientLayer=[CAGradientLayer layer];
    gradientLayer.frame=self.lineView.bounds;
    gradientLayer.startPoint=CGPointMake(0, 0.0);
    gradientLayer.endPoint=CGPointMake(1, 0.0);
    
    NSMutableArray *colors=[NSMutableArray arrayWithArray:@[(__bridge id)[UIColor colorWithRed:170.0/255.0 green:210.0/255.0 blue:1 alpha:1].CGColor,(__bridge id)[UIColor colorWithRed:45/255.0 green:192/255.0 blue:1 alpha:0.8].CGColor]];
    
    gradientLayer.colors=colors;
    [self.lineView.layer insertSublayer:gradientLayer atIndex:0];
    
}

-(void)drawDashLineWithResult:(CGPoint)result{
    CGFloat arr[]={10,1};
    
    UIBezierPath *dashLine=[UIBezierPath bezierPath];
    [dashLine moveToPoint:CGPointMake(10, lineViewHeight-result.x*result.y-20)];
    [dashLine addLineToPoint:CGPointMake(lineViewWidth-30,lineViewHeight-result.x*result.y-20)];
    [dashLine setLineDash:arr count:2 phase:0];
    
    
    CAShapeLayer *dashLayer=[CAShapeLayer layer];
    dashLayer.strokeColor=[UIColor lightGrayColor].CGColor;
    dashLayer.lineDashPattern=@[@6,@3];
    dashLayer.path=dashLine.CGPath;
    dashLayer.fillColor=nil;
    
    UILabel *averageLabel=[[UILabel alloc]initWithFrame:CGRectMake(lineViewWidth-30, lineViewHeight-result.x*result.y-30, 30, 20)];
    averageLabel.text=[NSString stringWithFormat:@"% .1f",result.y];
    [averageLabel setFont:[UIFont systemFontOfSize:10]];
    averageLabel.textColor=[UIColor lightGrayColor];
    
    [self.lineView.layer addSublayer:dashLayer];
    [self.lineView addSubview:averageLabel];
}

-(void)drawPointsWithResult:(CGPoint)result data:(NSArray *)dataArray{
    CGFloat spacing=lineViewWidth/[dataArray count];
    CGFloat ppp=result.x;
    UIBezierPath *points=[UIBezierPath bezierPath];
    CAShapeLayer *pointsLayer=[CAShapeLayer layer];
    for (int i=0; i<[dataArray count]; i++) {
        float price=[[dataArray objectAtIndex:i]floatValue];
        [points appendPath:[UIBezierPath bezierPathWithArcCenter:CGPointMake(10+spacing*i, lineViewHeight-ppp*price-20) radius:4 startAngle:0 endAngle:2*M_PI clockwise:0]];
    }
    pointsLayer.path=points.CGPath;
    pointsLayer.fillColor=[UIColor whiteColor].CGColor;
    pointsLayer.opacity=0.8;
    pointsLayer.frame=self.lineView.bounds;
    
    NSLog(@"layer:%@,lineview:%@",NSStringFromCGRect (pointsLayer.frame),NSStringFromCGRect( _lineView.bounds));
    
    CASpringAnimation *springAni=[CASpringAnimation animationWithKeyPath:@"position.y"];
    springAni.mass=1;
    springAni.stiffness=100;
    springAni.damping=15;
    springAni.duration=springAni.settlingDuration;
    springAni.fromValue=@(1.5*lineViewHeight);
    springAni.toValue=@(0.5*lineViewHeight);
    springAni.fillMode=kCAFillModeForwards;
    springAni.removedOnCompletion=NO;
    springAni.delegate=self;
    
    [self.lineView.layer addSublayer:pointsLayer];
    [pointsLayer addAnimation:springAni forKey:@"springAni"];
    
}

-(void)drawLinesWithResult:(CGPoint)result data:(NSArray *)dataArray{
    UIBezierPath *strokePath=[UIBezierPath bezierPath];
    CGFloat spacing=lineViewWidth/[dataArray count];
    CGFloat ppp=result.x;
    [strokePath moveToPoint:CGPointMake(10, lineViewHeight-ppp*[[dataArray objectAtIndex:0]floatValue]-20)];
    for (int i=1; i<[dataArray count]; i++) {
        float price=[[dataArray objectAtIndex:i]floatValue];
        [strokePath addLineToPoint:CGPointMake(10+i*spacing, lineViewHeight-ppp*price-20)];
        NSLog(@"line height:%f",strokePath.currentPoint.y);
    }
    CAShapeLayer *layer2=[CAShapeLayer layer];
    layer2.frame=self.lineView.bounds;
    layer2.path=strokePath.CGPath;
    layer2.lineWidth=2.0f;
    layer2.fillColor=nil;;
    
    layer2.lineJoin=kCALineCapRound;
    layer2.strokeColor=[UIColor whiteColor].CGColor;
    layer2.opacity=0.8;
    [self.lineView.layer addSublayer:layer2];
    
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration=1.0f;
    animation.delegate=self;
    animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    animation.fromValue=@(0.0f);
    animation.toValue=@(1.0f);
    animation.fillMode=kCAFillModeForwards;
    animation.removedOnCompletion=NO;
    [layer2 addAnimation:animation forKey:@"pathAni"];
}

-(void)animationDidStart:(CAAnimation *)anim{
    NSLog(@"animate start:%@",anim);
}


- (IBAction)didTapLineView:(UITapGestureRecognizer *)sender {
    CGPoint tapPoint=[sender locationInView:self.lineView];
    CGPoint hitData=[self getDataIfHitPoint:tapPoint withData:self.dataArray AndResult:self.result];
    if (hitData.x!=-1&&hitData.y!=-1) {
        [self showHitPrice:hitData];
    }
}

-(CGPoint)getDataIfHitPoint:(CGPoint)tapPoint withData:(NSArray *)dataArray AndResult:(CGPoint)result{
    CGFloat positionX,price;
    CGFloat spacing=lineViewWidth/[dataArray count];
    for (int i=0; i<[dataArray count]; i++) {
        price=[[dataArray objectAtIndex:i]floatValue];
        positionX=i*spacing+10;
        
        if (tapPoint.x>positionX-10&&tapPoint.x<positionX+10) {
            return CGPointMake(positionX, price);
        }
    }
    return CGPointMake(-1, -1);
}

-(void)showHitPrice:(CGPoint)data{
    if (!_dataLabel) {
        _dataLabel=[[UILabel alloc]init];
        [self.lineView addSubview:_dataLabel];
    }
    if (data.x<=10)data.x=30;
    [_dataLabel setFrame:CGRectMake(data.x-20, 20, 40, 20)];
    _dataLabel.text=[NSString stringWithFormat:@"%.2f",data.y];
    [_dataLabel setFont:[UIFont systemFontOfSize:12]];
    _dataLabel.textColor=[UIColor whiteColor];
    
    CABasicAnimation *positionAni=[CABasicAnimation animationWithKeyPath:@"position.y"];
    positionAni.fromValue=@(100);
    positionAni.toValue=@(45);
    positionAni.removedOnCompletion=NO;
    positionAni.fillMode=kCAFillModeForwards;
    positionAni.delegate=self;
    
    CABasicAnimation *opacityAni=[CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAni.fromValue=@(0);
    opacityAni.toValue=@(1.0);
    opacityAni.removedOnCompletion=NO;
    positionAni.fillMode=kCAFillModeForwards;
    
    [_dataLabel.layer addAnimation:positionAni forKey:@"labelAni"];
    [_dataLabel.layer addAnimation:opacityAni forKey:@"opacityAni"];
}

-(void)calculateTotalLabel{
    float total=0;
    for (int i=0; i<[_dataArray count]; i++) {
        total+=[[_dataArray objectAtIndex:i]floatValue];
    }
    self.totalLabel.text=[NSString stringWithFormat:@"总额:%.2f元",total];
    self.totalLabel.textColor=[UIColor whiteColor];
    
    
}
@end
