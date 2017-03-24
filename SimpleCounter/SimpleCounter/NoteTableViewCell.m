//
//  NoteTableViewCell.m
//  SimpleCounter
//
//  Created by 陈浩贤 on 2017/2/22.
//  Copyright © 2017年 陈浩贤. All rights reserved.
//

#import "NoteTableViewCell.h"

@implementation NoteTableViewCell

+(instancetype)noteTableCelll{
    return [[NSBundle mainBundle]loadNibNamed:@"NoteTableViewCell" owner:nil options:nil][0];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.typeLabel.layer.cornerRadius=self.typeLabel.bounds.size.width/2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
