//
//  HeaderFooterView.h
//  SimpleCounter
//
//  Created by 陈浩贤 on 2017/2/25.
//  Copyright © 2017年 陈浩贤. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface  HeaderView: UITableViewHeaderFooterView
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;



@end



@interface FooterView : UITableViewHeaderFooterView

@property (weak, nonatomic) IBOutlet UILabel *comsumLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end
