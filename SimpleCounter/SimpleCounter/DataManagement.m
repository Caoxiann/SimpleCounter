//
//  DataManagement.m
//  SimpleCounter
//
//  Created by 陈浩贤 on 2017/3/1.
//  Copyright © 2017年 陈浩贤. All rights reserved.
//

#import "DataManagement.h"
#import <FMDatabase.h>
static DataManagement *instance=nil;

@interface DataManagement ()
{
    
}
@property FMDatabase *database;
@property NSDateFormatter *formatter;
@end

@implementation DataManagement

+(instancetype)shareDataManagement{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance=[[super allocWithZone:NULL]init];
    });
    return instance;
}
+(instancetype)allocWithZone:(struct _NSZone *)zone{
    return [DataManagement shareDataManagement];
}

-(instancetype)init{
    self=[super init];
    if (self) {
        [self openDataBase];
        _formatter=[[NSDateFormatter alloc]init];
        [_formatter setDateFormat:@"yyyy-MM-dd"];
    }
    return self;
}

-(BOOL)openDataBase{
    NSString *docPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *filename=[docPath stringByAppendingPathComponent:@"dataBase.sqlite"];
    _database=[FMDatabase databaseWithPath:filename];
    
    if ([_database open]) {
        BOOL result=[_database executeUpdate:@"CREATE TABLE IF NOT EXISTS t_note (id integer PRIMARY KEY AUTOINCREMENT,title text NOT NULL,type text NOT NULL,price float NOT NULL,date text NOT NULL);"];
        
        if (result) {
            NSLog(@"创建表成功");
        }
    }
    return [_database open];
}

-(void)insertNote:(Note *)newNote{
    [_database executeUpdate:@"INSERT INTO t_note (title,type,price,date) VALUES (?,?,?,?);",newNote.title,newNote.type,@(newNote.price),newNote.date];
}

-(NSMutableArray *)getNoteFormDataBase{
    int count=[self getNoteCount];
    NSDate *curDate=[NSDate date];
    NSMutableArray *dataArray=[[NSMutableArray alloc]init];
    int counter=0;
    for (int i=0; i<count;i=i+counter) {
        
        NSString *dateStr=[_formatter stringFromDate:curDate];
        FMResultSet *resultSet=[_database executeQuery:@"select * from t_note where date=?",dateStr];
        NSMutableArray *noteArray=[[NSMutableArray alloc]init];
        counter=0;
        while ([resultSet next]) {
            int number=[resultSet intForColumn:@"id"];
            NSString *title=[resultSet objectForColumnName:@"title"];
            NSString *type=[resultSet objectForColumnName:@"type"];
            double price=[resultSet doubleForColumn:@"price"];
            NSString *date=[resultSet objectForColumnName:@"date"];
            
            Note *note=[[Note alloc]initWithData:number title:title type:type price:price date:date];
            [noteArray addObject:note];
            counter++;
        }
        curDate=[curDate dateByAddingTimeInterval:-60*60*24];
        if ([noteArray count]!=0) {
            [dataArray addObject:noteArray];
        }
        
    }
    NSLog(@"note array:%@",dataArray);
    return dataArray;
}

-(int)getNoteCount{
    FMResultSet *result=[self.database executeQuery:@"SELECT count(*) as 'count' FROM t_note"];
    int count = 0;
    while ([result next]) {
        count=[result intForColumn:@"count"];
        return count;
    }
    return 0;
}

-(void)deleteNoteNumber:(int)number{
    [self.database executeUpdate:@"delete from t_note where id=?",@(number)];
}

-(NSString *)getWeeksFromDate:(NSString *)dateStr{
    NSDate *date=[self.formatter dateFromString:dateStr];
    NSCalendar *calendar=[[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSCalendarUnit calendarUnit=NSCalendarUnitWeekday;
    NSDateComponents *components=[calendar components:calendarUnit fromDate:date];
    NSArray *weekdays=[NSArray arrayWithObjects:@"不知道",@"星期天",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六", nil];
    
    return [weekdays objectAtIndex:components.weekday];
    
}



@end
