//
//  YMosaicSql.h
//  YFMDatabase
//
//  Created by 严安 on 15/1/3.
//  Copyright (c) 2015年 严安. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YMosaicSql : NSObject

/**
 *	@brief	反演
 *
 *	@param 	yClass 	类
 *
 *	@return	属性集合
 */
+ (NSArray *)yPropertyKeys:(Class)yClass;

/**
 *	@brief	创建表
 *
 *	@param 	yTableName 	表名
 *	@param 	yField 	表中的字段名集合
 *
 *	@return 拼接好的sql语句
 */
+ (NSString *)yCreateTableSqlWithTableName:(NSString *)yTableName
                                 withClass:(Class)yClass;

/**
 *	@brief	删除表
 *
 *	@param 	yTableName 	表名
 *
 *	@return	拼接好的sql语句
 */
+ (NSString *)yDeleteTableSqlWithTableName:(NSString *)yTableName;

/**
 *	@brief	清空表中的数据
 *
 *	@param 	yTableName 	表名
 *
 *	@return	拼接好的sql语句
 */
+ (NSString *)yEmptyTableSqlWithTableName:(NSString *)yTableName;

/**
 *	@brief	获得表的数据条数
 *
 *	@param 	yTableName 	表名
 *
 *	@return	拼接好的sql语句
 */
+ (NSString *)yGetTableNumberSqlWithTableName:(NSString *)yTableName;

/**
 *	@brief	获得该数据对象之前的数据条数
 *
 *	@param 	yTableName 	表名
 *	@param 	yObject 	数据对象
 *
 *	@return	拼接好的sql语句
 */
+ (NSString *)yGetObjectFrontNumberSqlWithTableName:(NSString *)yTableName
                                         withObject:(id)yObject;

/**
 *	@brief	根据条件获取满足条件的数据条数
 *
 *	@param 	yTableName 	表名
 *	@param 	yCondition 	条件
 *
 *	@return	拼接好的sql语句
 */
+ (NSString *)yGetAccordingConditionNumberSqlWithTableName:(NSString *)yTableName
                                             withCondition:(NSString *)yCondition;


/**
 *	@brief	插入数据
 *
 *	@param 	yTableName 	表名
 *	@param 	yObject 	数据对象
 *
 *	@return	拼接好的sql语句
 */
+ (NSString *)yInsertDataSqlWithTableName:(NSString *)yTableName
                           withDataObject:(id)yObject;

/**
 *	@brief	删除数据
 *
 *	@param 	yTableName 	表名
 *	@param 	yObject 	数据对象
 *
 *	@return	拼接好的sql语句
 */
+ (NSString *)yDeleteDataSqlWithTableName:(NSString *)yTableName
                           withDataObject:(id)yObject;

/**
 *	@brief	删除数据
 *
 *	@param 	yTableName 	表名
 *	@param 	yRange 	范围 eg. @"(10,20)"
 *	@param 	yCondition 	条件
 *
 *	@return	拼接好的sql语句
 */
+ (NSString *)yDeleteDataSqlWithTableName:(NSString *)yTableName
                                withRange:(NSString *)yRange
                            withCondition:(NSString *)yCondition;

/**
 *	@brief	修改(更新)数据
 *
 *	@param 	yTableName 	表名
 *	@param 	yObject 	数据对象
 *	@param 	yCondition 	条件 eg. @"主键名=主键值"
 *
 *	@return	拼接好的sql语句
 */
+ (NSString *)yUpdateDataSqlWithTableName:(NSString *)yTableName
                           withDataObject:(id)yObject
                            withCondition:(NSString *)yCondition;

/**
 *	@brief	查找数据
 *
 *	@param 	yTableName 	表名
 *	@param 	yRange 	搜索范围 eg. @"(10,20)" 表示获取第10条（包括第10条）到第20条（包括第20条）数据
 *	@param 	yCondition 	搜索条件 一般情况下传 nil
 *	@param 	yOrder 	搜索遵循规则 一般情况下传主键名 没有传nil
 *
 *	@return	拼接好的sql语句
 */
+ (NSString *)yQueryDataSqlWithTableName:(NSString *)yTableName
                                withRange:(NSString *)yRange
                            withCondition:(NSString *)yCondition
                                withOrder:(NSString *)yOrder;

/**
 *	@brief	取表中最后一条数据
 *
 *	@param 	yTableName 	表名
 *	@param 	yCondition 	条件 eg. @"主键名"
 *
 *	@return	拼接好的sql语句
 */
+ (NSString *)yGetLastDataSqlWithTableName:(NSString *)yTableName
                             withCondition:(NSString *)yCondition;

@end
