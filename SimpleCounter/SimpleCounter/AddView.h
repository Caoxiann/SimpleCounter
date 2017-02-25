//
//  AddView.h
//  SimpleCounter
//
//  Created by 陈浩贤 on 2017/2/25.
//  Copyright © 2017年 陈浩贤. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddView : UIView

+(instancetype)initAddView;
@property UIView *shadowView;

- (IBAction)didPressCancelButton:(id)sender;
- (IBAction)didPressConfirmButton:(id)sender;


@end
