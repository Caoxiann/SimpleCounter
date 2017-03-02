//
//  Note.h
//  SimpleCounter
//
//  Created by 陈浩贤 on 2017/3/1.
//  Copyright © 2017年 陈浩贤. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Note : NSObject

@property NSString *title;
@property NSString *type;
@property double price;
@property NSString *date;
@property int number;

-(instancetype)initWithData:(int)number title:(NSString *)title type:(NSString *)type price:(double)price date:(NSString *)date;
@end
