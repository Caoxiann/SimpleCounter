//
//  HeaderFooterView.m
//  SimpleCounter
//
//  Created by 陈浩贤 on 2017/2/25.
//  Copyright © 2017年 陈浩贤. All rights reserved.
//

#import "HeaderFooterView.h"

@implementation HeaderFooterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+(instancetype)headerView{
    return [[NSBundle mainBundle]loadNibNamed:@"HeaderFooterView" owner:nil options:nil][0];
    
}

+(instancetype)footerView{
    return [[NSBundle mainBundle]loadNibNamed:@"HeaderFooterView" owner:nil options:nil][1];
}

@end
