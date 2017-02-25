//
//  NoteTableViewCell.h
//  SimpleCounter
//
//  Created by 陈浩贤 on 2017/2/22.
//  Copyright © 2017年 陈浩贤. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoteTableViewCell : UITableViewCell

+(instancetype)noteTableCelll;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;


@end
