//
//  DataManagement.h
//  SimpleCounter
//
//  Created by 陈浩贤 on 2017/3/1.
//  Copyright © 2017年 陈浩贤. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Note.h"
@interface DataManagement : NSObject

+(instancetype)shareDataManagement;
-(void)insertNote:(Note *)newNote;
-(NSMutableArray *)getNoteFormDataBase;
-(void)deleteNoteNumber:(int)number;
-(int)getNoteCount;
-(NSString *)getWeeksFromDate:(NSString *)dateStr;
-(NSArray *)getDataOfLastWeek;
@end
