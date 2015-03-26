//
//  YDatabaseManager.h
//  YFMDatabase
//
//  Created by 严安 on 15/1/3.
//  Copyright (c) 2015年 严安. All rights reserved.
//

/** 说明：
 *  1、在访问数据库之前必须初始化数据库管理对象（YDatabaseManager）的yDBPath和yTableName属性
 *  2、yDBPath的路径必须完整
 *  3、yTableName不能是纯的阿拉伯数字字符串
 */

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, YMODIFYPRIMARYKEY) {
    YDEFAULT           = 0, /** 不主动修改 */
    YMODIFY               , /** 主动修改 */
    YACCORDINGTOOBJECT    , /** 根据数据对象的是否有主键值，判断是否主动修改主键的值 */
};

@interface YDatabaseManager : NSObject

/**
 *	@brief	数据库存放的完整路径
 */
@property (nonatomic ,copy)NSString *yDBPath;

/**
 *	@brief	数据库中的表名
 */
@property (nonatomic ,copy)NSString *yTableName;

/**
 *	@brief	创建数据库管理对象单例
 *
 *	@return	对象单例
 */
+ (YDatabaseManager *)yShareDBManager;

/**
 *	@brief	查看数据库是否存在
 *
 *	@return	TRUE创建成功 FALSE创建失败
 */
- (BOOL)yCheckIsExistenceDB;

/**
 *	@brief	删除数据库
 *
 *	@return	TRUE删除数据库成功 FALSE删除数据库失败
 */
- (BOOL)yDeleteDB;

/**
 *	@brief	查看表是否存在
 *
 *	@return	TRUE表存在 FALSE表不存在
 */
- (BOOL)yCheckIsExistenceTable;

/**
 *	@brief	创建表
 *
 *	@param 	yClass 	反演类（根据该类的属性创建对应的表字段）
 *
 *	@return	TRUE创建成功 FALSE创建失败
 */
- (BOOL)yCreateTableWithClass:(Class)yClass;

/**
 *	@brief	删除表
 *
 *	@return	TRUE删除表成功 FALSE删除表失败
 */
- (BOOL)yDeleteTable;

/**
 *	@brief	增加(插入)数据
 *
 *	@param 	yDataObject 	数据对象
 *	@param 	yModify 	是否修改主键值
 *
 *	@return	TRUE增加(插入)成功 FALSE增加(插入)失败
 */
- (BOOL)yInsertWithDataObject:(id)yDataObject
           isModifyPrimaryKey:(YMODIFYPRIMARYKEY)yModify;

/**
 *	@brief	删除数据
 *
 *	@param 	yDataObject 	数据对象
 *
 *	@return	TRUE删除成功 FALSE删除失败
 */
- (BOOL)yDeleteWithDataObject:(id)yDataObject;

/**
 *	@brief	删除数据
 *
 *	@param 	yRange 	范围 eg: @"(10,20)" 表示在第10条(包括第10条)到第20条(包括第20条)范围内，根据条件yCondition删除数据；如果yCondition为nil，那么直接删除第10条(包括第10条)到第20条(包括第20条)数据；如果yRange为nil则在全范围内根据条件yCondition删除数据；当yRange和yCondition同时传入nil是表示清空表
 *	@param 	yCondition 	删除条件 eg: @"字段名=值" 也可以传入nil
 *
 *	@return	TRUE删除成功 FALSE删除失败
 */
- (BOOL)yDeleteWithRange:(NSString *)yRange
           withCondition:(NSString *)yCondition;

/**
 *	@brief	修改(更新)数据
 *
 *	@param 	yDataObject 	数据对象
 *	@param 	yCondition 	修改(更新)条件 一般传入主键 primarykey=条件值 不传(nil)的话则根据数据对象的主键值
 *
 *	@return	TRUE修改(更新)成功 FALSE修改(更新)失败
 */
- (BOOL)yUpdateWithDataObject:(id)yDataObject
                withCondition:(NSString *)yCondition;

/**
 *	@brief	查找(查询)数据
 *
 *	@param 	yClass 	数据类的class
 *	@param 	yRange 	范围 eg: @"(10,20)" 表示在第10条(包括第10条)到第20条(包括第20条)范围内，根据条件yCondition查找数据；如果yCondition为nil，那么就直接取出第10条(包括第10条)到第20条(包括第20条)数据；如果yRange为nil则在全范围内根据条件yCondition查找数据；当yRange和yCondition都为nil表示取出表中所有数据
 *	@param 	yCondition eg: @"字段名=值" 也可以传入nil
 *	@param 	yOrder 	排序规则 可传nil
 *
 *	@return	TRUE查找(查询)成功 FALSE查找(查询)失败
 */
- (NSArray *)yQueryWithClass:(Class)yClass
                   withRange:(NSString *)yRange
               withCondition:(NSString *)yCondition
                   withOrder:(NSString *)yOrder;

/**
 *	@brief	取表中最后一条数据
 *
 *	@param 	yClass 	类名的class
 *
 *	@return	数据集合
 */
- (NSArray *)yGetTableLastDataWithClass:(Class)yClass;

/**
 *	@brief	查看表中的数据总数
 *
 *	@return	数据总数
 */
- (NSUInteger)yGetTableDataNumber;

/**
 *	@brief	根据数据对象，定位该条数据在表中的位置
 *
 *	@param 	yObject 	数据对象(数据对象要设置主键)
 *
 *	@return	位置
 */
- (NSUInteger)yLocateObjectPositionWithObject:(id)yObject;

/**
 *	@brief	根据条件，定位该条数据在表中的位置
 *
 *  @param  yClass  类名的class
 *  @param  yRange  设定查询范围 eg. @"(10,20)"
 *	@param 	yCondition 	条件 eg.(key=value)
 *
 *	@return	位置数组集合
 */
- (NSArray *)yLocateObjectPositionWithClass:(Class)yClass
                                  withRange:(NSString *)yRange
                              withCondition:(NSString *)yCondition;

@end
