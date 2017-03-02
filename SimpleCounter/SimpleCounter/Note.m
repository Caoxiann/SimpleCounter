//
//  Note.m
//  SimpleCounter
//
//  Created by 陈浩贤 on 2017/3/1.
//  Copyright © 2017年 陈浩贤. All rights reserved.
//

#import "Note.h"

@implementation Note

-(instancetype)initWithData:(int)number title:(NSString *)title type:(NSString *)type price:(double)price date:(NSString *)date{
    self=[super init];
    if (self) {
        self.number=number;
        self.title=title;
        self.type=type;
        self.price=price;
        self.date=date;
        
    }
    return self;
}
@end
