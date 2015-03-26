//
//  YMosaicSql.m
//  YFMDatabase
//
//  Created by 严安 on 15/1/3.
//  Copyright (c) 2015年 严安. All rights reserved.
//

#import "YMosaicSql.h"

#import <objc/runtime.h>

@implementation YMosaicSql

#pragma mark 创建表
+ (NSString *)yCreateTableSqlWithTableName:(NSString *)yTableName
                                 withClass:(Class)yClass{
    NSArray *yField = [self yPropertyKeys:yClass];
    NSUInteger yFieldNumber = [yField count];
    NSMutableString *ySqlMutStr = [NSMutableString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@",yTableName];
    for (NSUInteger yI = 0; yI < yFieldNumber; yI++) {
        if (yI == 0) {
            //将[yField firstObject]作为主键
            [ySqlMutStr appendFormat:@"(%@ INTEGER PRIMARY KEY,",[yField firstObject]];
        } else if (yI == yFieldNumber - 1) {
            [ySqlMutStr appendFormat:@"%@)",[yField lastObject]];
        } else {
            [ySqlMutStr appendFormat:@"%@,",[yField objectAtIndex:yI]];
        }
    }
    
    return ySqlMutStr;
}

#pragma mark 删除表
+ (NSString *)yDeleteTableSqlWithTableName:(NSString *)yTableName {
    return [NSString stringWithFormat:@"DROP TABLE %@",yTableName];
}

#pragma mark 清空表中的数据
+ (NSString *)yEmptyTableSqlWithTableName:(NSString *)yTableName {
    return [NSString stringWithFormat:@"DELETE FROM %@",yTableName];
}

#pragma mark 获得表的数据条数 
///select count(*) from
+ (NSString *)yGetTableNumberSqlWithTableName:(NSString *)yTableName {
    return [NSString stringWithFormat:@"SELECT count(*) as 'count' FROM %@",yTableName];
}

#pragma mark 获得该数据对象之前的数据条数
+ (NSString *)yGetObjectFrontNumberSqlWithTableName:(NSString *)yTableName
                                         withObject:(id)yObject {
    NSArray *yKeys = [self yPropertyKeys:[yObject class]];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    return [NSString stringWithFormat:@"SELECT count(*) as 'count' FROM %@ WHERE %@<%@",yTableName,[yKeys firstObject],[yObject performSelector:NSSelectorFromString([yKeys firstObject])]];
#pragma clang diagnostic pop
}

#pragma mark 根据条件获取满足条件的数据条数
+ (NSString *)yGetAccordingConditionNumberSqlWithTableName:(NSString *)yTableName
                                             withCondition:(NSString *)yCondition {
    NSArray *yArray = [yCondition componentsSeparatedByString:@"="];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    return [NSString stringWithFormat:@"SELECT count(*) as 'count' FROM %@ WHERE %@<%@",yTableName,[yArray firstObject],[yArray lastObject]];
#pragma clang diagnostic pop
}

#pragma mark 插入(增加)数据
+ (NSString *)yInsertDataSqlWithTableName:(NSString *)yTableName
                           withDataObject:(id)yObject {
    NSMutableString *ySqlMutStr = [NSMutableString stringWithFormat:@"INSERT INTO %@ ",yTableName];
    NSArray *yField = [self yPropertyKeys:[yObject class]];
    for (NSUInteger yI = 0; yI < [yField count]; yI++) {
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        NSString *yProperty = [yObject performSelector:NSSelectorFromString([yField objectAtIndex:yI])];
#pragma clang diagnostic pop
        
        if (yI == 0) {
            if ([yProperty isEqualToString:@""] || !yProperty) {
                [ySqlMutStr appendFormat:@"values(%@,",nil];
            } else {
                [ySqlMutStr appendFormat:@"values('%@',",yProperty];
            }
        } else if (yI == [yField count] - 1) {
            [ySqlMutStr appendFormat:@"'%@')",yProperty];
        } else {
            [ySqlMutStr appendFormat:@"'%@',",yProperty];
        }
    }
    return ySqlMutStr;
}

#pragma mark 删除数据
+ (NSString *)yDeleteDataSqlWithTableName:(NSString *)yTableName
                           withDataObject:(id)yObject {
    NSArray *yField = [self yPropertyKeys:[yObject class]];
    NSString *yPrimaryKeyProperty = [yField firstObject];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    NSString *ySqlString = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@=%@",yTableName,yPrimaryKeyProperty,[yObject performSelector:NSSelectorFromString(yPrimaryKeyProperty)]];
#pragma clang diagnostic pop
    
    return ySqlString;
}

#pragma mark 删除数据
+ (NSString *)yDeleteDataSqlWithTableName:(NSString *)yTableName
                                withRange:(NSString *)yRange
                            withCondition:(NSString *)yCondition {
    if (yRange) {
//        NSArray *yRangeArray = [self yAnalyzeRange:yRange];
        if (yCondition) {
            /** 保留 */
            return @"";
        } else {
            /** 保留 */
            return @"";
        }
    } else {
        if (yCondition) {
            NSString *ySqlString = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@",yTableName,yCondition];
            return ySqlString;
        } else {
            return [NSString stringWithFormat:@"DELETE FROM %@",yTableName];
        }
    }
}

#pragma mark 修改(更新)数据
+ (NSString *)yUpdateDataSqlWithTableName:(NSString *)yTableName
                           withDataObject:(id)yObject
                            withCondition:(NSString *)yCondition {
    NSArray *yRangeArray = [self yPropertyKeys:[yObject class]];
    NSMutableString *ySqlMutStr = [NSMutableString stringWithFormat:@"UPDATE %@ SET ",yTableName];
    for (int yI = 1; yI < [yRangeArray count]; yI++) {
        if (yI == 1) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [ySqlMutStr appendFormat:@"%@='%@'",[yRangeArray objectAtIndex:yI],[yObject performSelector:NSSelectorFromString([yRangeArray objectAtIndex:yI])]];
#pragma clang diagnostic pop
        } else if (yI == [yRangeArray count] - 1) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [ySqlMutStr appendFormat:@",%@='%@' ",[yRangeArray lastObject],[yObject performSelector:NSSelectorFromString([yRangeArray lastObject])]];
#pragma clang diagnostic pop
        } else if (yI != 0) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [ySqlMutStr appendFormat:@",%@='%@'",[yRangeArray objectAtIndex:yI],[yObject performSelector:NSSelectorFromString([yRangeArray objectAtIndex:yI])]];
#pragma clang diagnostic pop
        }
    }
    if (yCondition) {
        [ySqlMutStr appendFormat:@"WHERE %@",yCondition];
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [ySqlMutStr appendFormat:@"WHERE %@=%@",[yRangeArray firstObject],[yObject performSelector:NSSelectorFromString([yRangeArray firstObject])]];
#pragma clang diagnostic pop
    }
    return ySqlMutStr;
}

#pragma mark 查找数据
///select * from 表名 where 你的条件 order by 某个字段顺序 LIMIT X OFFSET X*n
+ (NSString *)yQueryDataSqlWithTableName:(NSString *)yTableName
                                withRange:(NSString *)yRange
                            withCondition:(NSString *)yCondition
                                withOrder:(NSString *)yOrder {
    if (yRange) {
        NSArray *yRangeArray = [self yAnalyzeRange:yRange];
        NSString *ySqlString = nil;
        if (yCondition && yOrder) {
            ySqlString = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ ORDER BY %@ LIMIT %d OFFSET %d",yTableName,yCondition,yOrder, [[yRangeArray lastObject] intValue] - [[yRangeArray firstObject] intValue] + 1,[[yRangeArray firstObject] intValue] - 1];
        } else if (!yCondition && yOrder){
            ySqlString = [NSString stringWithFormat:@"SELECT * FROM %@ ORDER by %@ LIMIT %d OFFSET %d",yTableName,yOrder, [[yRangeArray lastObject] intValue] - [[yRangeArray firstObject] intValue] + 1,[[yRangeArray firstObject] intValue] - 1];
        } else if (yCondition && !yOrder) {
            ySqlString = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ LIMIT %d OFFSET %d",yTableName,yCondition, [[yRangeArray lastObject] intValue] - [[yRangeArray firstObject] intValue] + 1,[[yRangeArray firstObject] intValue] - 1];
        } else {
            ySqlString = [NSString stringWithFormat:@"SELECT * FROM %@ LIMIT %d OFFSET %d",yTableName, [[yRangeArray lastObject] intValue] - [[yRangeArray firstObject] intValue] + 1,[[yRangeArray firstObject] intValue] - 1];
        }
        return (ySqlString ? ySqlString : nil);
    } else if (yCondition) {
        NSString *ySqlString = nil;
        if (yOrder) {
            ySqlString = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ ORDER BY %@",yTableName,yCondition,yOrder];
        } else {
            ySqlString = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@",yTableName,yCondition];
        }
        return ySqlString;
    } else if (yOrder){
        NSString *ySqlString = nil;
        ySqlString = [NSString stringWithFormat:@"SELECT * FROM %@ ORDER BY %@",yTableName,yOrder];
        return ySqlString;
    } else {
        NSString *ySqlString = nil;
        ySqlString = [NSString stringWithFormat:@"SELECT * FROM %@",yTableName];
        return ySqlString;
    }
}

#pragma mark 取表中最后一条数据
+ (NSString *)yGetLastDataSqlWithTableName:(NSString *)yTableName
                             withCondition:(NSString *)yCondition {
    return [NSString stringWithFormat:@"SELECT * FROM %@ ORDER by %@ DESC LIMIT 1 OFFSET 0",yTableName,yCondition];
}

#pragma mark 反射出类的属性
+ (NSArray *)yPropertyKeys:(Class)yClass {
    unsigned int yOutCount, i;
    objc_property_t *yProperties = class_copyPropertyList(yClass, &yOutCount);
    NSMutableArray *yKeys = [[NSMutableArray alloc] initWithCapacity:yOutCount];
    for (i = 0; i < yOutCount; i++) {
        objc_property_t yProperty = yProperties[i];
        NSString *yPropertyName = [[NSString alloc] initWithCString:property_getName(yProperty) encoding:NSUTF8StringEncoding];
        [yKeys addObject:yPropertyName];
    }
    free(yProperties);
    return yKeys;
}

#pragma mark 解析yRange
+ (NSArray *)yAnalyzeRange:(NSString *)yRange {
    NSString *yRangeStr = [yRange copy];
    yRangeStr = [yRangeStr substringWithRange:NSMakeRange(1, [yRangeStr length] - 2)];
    NSArray *yRangeArray = [yRangeStr componentsSeparatedByString:@","];
    return yRangeArray;
}

@end
