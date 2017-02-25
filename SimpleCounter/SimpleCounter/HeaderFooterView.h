//
//  HeaderFooterView.h
//  SimpleCounter
//
//  Created by 陈浩贤 on 2017/2/25.
//  Copyright © 2017年 陈浩贤. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderFooterView : UIView

+(instancetype)headerView;
+(instancetype)footerView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *consumeLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end


