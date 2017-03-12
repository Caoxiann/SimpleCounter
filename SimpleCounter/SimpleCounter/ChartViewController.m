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

@end

@implementation ChartViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    self.lineView.layer.cornerRadius=10;
    
    NSArray *dayArray=[NSArray arrayWithObjects:@"1",@"2",@"1",@"2",@"1",@"2",@"1", nil];
    NSArray *dataArray=[NSArray arrayWithObjects:@(120.11),@(0),@(211),@(32),@(25),@(16),@(22), nil];
    
    lineViewHeight=self.lineView.bounds.size.height;
    lineViewWidth=self.lineView.bounds.size.width;
    graphViewWidth=self.graphView.bounds.size.width;
    graphViewHeight=self.graphView.bounds.size.height;

    CGPoint result=[self calculatePricePerPixcialAndAverageWithDataArray:dataArray];
    
    
    [self drawFadeBackgroundView];
    [self drawAxis];
    [self drawDashLineWithResult:result];
    [self drawPointsWithResult:result data:dataArray];
    [self drawLinesWithResult:result data:dataArray];
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
    [axis moveToPoint:CGPointMake(10, 20)];
    [axis addLineToPoint:CGPointMake(10, lineViewHeight)];
    [axis addLineToPoint:CGPointMake(lineViewWidth+20, lineViewHeight)];
    axis.lineWidth=1.0f;
    axis.lineJoinStyle=kCGLineJoinRound;
    
    CAShapeLayer *axisLayer=[CAShapeLayer layer];
    axisLayer.path=axis.CGPath;
    axisLayer.fillColor=nil;
    axisLayer.strokeColor=[UIColor whiteColor].CGColor;
    [self.lineView.layer addSublayer:axisLayer];
}

-(void)creatLabelOnXwithData:(NSArray *)dataArray{
    CGFloat days=[dataArray count];
    CGFloat spacing=lineViewWidth/(days-1);
    
    for (int i=0; i<days; i++) {
        UILabel *dayLabel=[[UILabel alloc]initWithFrame:CGRectMake(10+spacing*i, lineViewHeight+5, spacing,15)];
        dayLabel.text=[dataArray objectAtIndex:i];
        dayLabel.textAlignment=NSTextAlignmentLeft;
        [dayLabel setFont:[UIFont systemFontOfSize:12 weight:0.1]];
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
    
    float ppp=(lineViewHeight-40)/(float)topPrice;
    float average=total/(float)[dataArray count];
    
    CGPoint result=CGPointMake(ppp, average);
    return result;
}

-(void)drawFadeBackgroundView{
    CAGradientLayer *gradientLayer=[CAGradientLayer layer];
    gradientLayer.frame=CGRectMake(0, 0, lineViewWidth+30, lineViewHeight+30);
    gradientLayer.startPoint=CGPointMake(0, 0.0);
    gradientLayer.endPoint=CGPointMake(1, 0.0);
    
    NSMutableArray *colors=[NSMutableArray arrayWithArray:@[(__bridge id)[UIColor colorWithRed:170.0/255.0 green:210.0/255.0 blue:1 alpha:1].CGColor,(__bridge id)[UIColor colorWithRed:45/255.0 green:192/255.0 blue:1 alpha:0.8].CGColor]];
    
    gradientLayer.colors=colors;
    [self.lineView.layer insertSublayer:gradientLayer atIndex:0];
    
}

-(void)drawDashLineWithResult:(CGPoint)result{
    CGFloat arr[]={10,1};
    
    UIBezierPath *dashLine=[UIBezierPath bezierPath];
    [dashLine moveToPoint:CGPointMake(10, lineViewHeight-result.x*result.y)];
    [dashLine addLineToPoint:CGPointMake(lineViewWidth,lineViewHeight-result.x*result.y)];
    [dashLine setLineDash:arr count:2 phase:0];
    
    [dashLine stroke];
    
    CAShapeLayer *dashLayer=[CAShapeLayer layer];
    dashLayer.strokeColor=[UIColor lightGrayColor].CGColor;
    dashLayer.lineDashPattern=@[@6,@3];
    dashLayer.path=dashLine.CGPath;
    dashLayer.fillColor=nil;
    
    [self.lineView.layer addSublayer:dashLayer];
}

-(void)drawPointsWithResult:(CGPoint)result data:(NSArray *)dataArray{
    CGFloat spacing=lineViewWidth/([dataArray count]-1);
    CGFloat ppp=result.x;
    UIBezierPath *points=[UIBezierPath bezierPath];
    CAShapeLayer *pointsLayer=[CAShapeLayer layer];
    for (int i=0; i<[dataArray count]; i++) {
        float price=[[dataArray objectAtIndex:i]floatValue];
        [points appendPath:[UIBezierPath bezierPathWithArcCenter:CGPointMake(10+spacing*i, lineViewHeight-ppp*price) radius:4 startAngle:0 endAngle:2*M_PI clockwise:0]];
    }
    pointsLayer.path=points.CGPath;
    pointsLayer.fillColor=[UIColor whiteColor].CGColor;
    [self.lineView.layer addSublayer:pointsLayer];
    
}

-(void)drawLinesWithResult:(CGPoint)result data:(NSArray *)dataArray{
    UIBezierPath *strokePath=[UIBezierPath bezierPath];
    CGFloat spacing=lineViewWidth/([dataArray count]-1);
    CGFloat ppp=result.x;
    [strokePath moveToPoint:CGPointMake(10, lineViewHeight-ppp*[[dataArray objectAtIndex:0]floatValue])];
    for (int i=1; i<[dataArray count]; i++) {
        float price=[[dataArray objectAtIndex:i]floatValue];
        [strokePath addLineToPoint:CGPointMake(10+i*spacing, lineViewHeight-ppp*price)];
        NSLog(@"line height:%f",strokePath.currentPoint.y);
    }
    CAShapeLayer *layer2=[CAShapeLayer layer];
    layer2.frame=self.lineView.bounds;
    layer2.path=strokePath.CGPath;
    layer2.lineWidth=1.0f;
    layer2.fillColor=nil;;
    
    layer2.lineJoin=kCALineCapRound;
    layer2.strokeColor=[UIColor whiteColor].CGColor;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
