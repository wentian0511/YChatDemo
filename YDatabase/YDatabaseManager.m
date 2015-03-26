//
//  YDatabaseManager.m
//  YFMDatabase
//
//  Created by 严安 on 15/1/3.
//  Copyright (c) 2015年 严安. All rights reserved.
//

#import "YDatabaseManager.h"

#import "FMDatabase.h"
#import "YMosaicSql.h"

#define YDBINITOPENCLOSERELEASE(YSTUFF)    \
                    [self yInitDB];        \
                    [self yOpenDB];        \
                            YSTUFF;        \
                    [self yCloseDB];       \
                    [self yRelease_yFMDB];

#define YDELETETHISWARN(YSTUFF)                                         \
        do {
        #pragma clang diagnostic push                                   \
        #pragma clang diagnostic ignored "-Warc-performSelector-leaks"  \
        YSTUFF;                                                         \
        #pragma clang diagnostic pop                                    \
        }while(0);


@interface YDatabaseManager ()

@property (nonatomic, copy)FMDatabase *yFMDB;

/**
 *	@brief	数据库存放的完整路径(备份)
 */
@property (nonatomic ,copy)NSString *yDBBackupPath;

@end

@implementation YDatabaseManager

#pragma mark 字符串首字母大写，其他部分保持不变
- (NSString *)yFirstAlphabetUpper:(NSString *)yString {
    NSString *yFirstAlphabet = nil;
    if ([yString length] == 1) {
        yFirstAlphabet = [yString copy];
        if ([yFirstAlphabet compare:@"A"] >= 0 && [@"Z" compare:yFirstAlphabet] >= 0) {
            return yFirstAlphabet;
        } else {
            return [yFirstAlphabet uppercaseString];
        }
    } else {
        yFirstAlphabet = [yString substringToIndex:1];
        if ([yFirstAlphabet compare:@"A"] >= 0 && [@"Z" compare:yFirstAlphabet] >= 0) {
            return yString;
        } else {
            return [NSString stringWithFormat:@"%@%@",[yFirstAlphabet uppercaseString],[yString substringFromIndex:1]];
        }
    }
}

#pragma mark 创建数据库管理对象单例
static YDatabaseManager *yShareDBManager = nil;
+ (YDatabaseManager *)yShareDBManager {
    @synchronized (self) {
        if (!yShareDBManager) {
            yShareDBManager = [[YDatabaseManager alloc]init];
        }
        return yShareDBManager;
    }
}

#pragma mark 创建文件夹
- (BOOL)yCreateDirectory:(NSString *)yDocumentDirectoryPath {
    NSFileManager *yFileManager = [NSFileManager defaultManager];
    BOOL yIsDir = FALSE;
    if (![yFileManager fileExistsAtPath:yDocumentDirectoryPath isDirectory:&yIsDir]) {
        BOOL yIsPath = [yFileManager createDirectoryAtPath:yDocumentDirectoryPath withIntermediateDirectories:YES attributes:nil error:nil];
        if (yIsPath) {
            return TRUE;
        }
        return FALSE;
    }
    return TRUE;
}

#pragma mark 获取系统文件夹Documents主路径
- (NSString *)yGetDocumentDirectoryPath {
    NSArray *yArrayPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *yDocumentDirectory = [yArrayPaths firstObject];
    return yDocumentDirectory;
}

#pragma mark 创建系统文件夹Documents路径下的子路径
- (BOOL)yCreateDoucmentsSubDirectory:(NSString *)ySubDirectoryPath {
    NSString *ySubDirectoryPathCopy = [ySubDirectoryPath copy];
    NSArray *ySubDirectoryArray = [ySubDirectoryPathCopy componentsSeparatedByString:@"/"];
    NSString *yDocumentDirectoryPath = [self yGetDocumentDirectoryPath];
    for (NSString *ySubPath in ySubDirectoryArray) {
        if (![ySubPath hasSuffix:@".db"]) {
            if (ySubPath && ![ySubPath isEqualToString:@""]) {
                yDocumentDirectoryPath = [yDocumentDirectoryPath stringByAppendingPathComponent:ySubPath];
                if (![self yCreateDirectory:yDocumentDirectoryPath]) {
                    return FALSE;
                }
            }
        }
    }
    return TRUE;
}

#pragma mark 查看数据库是否存在
- (BOOL)yCheckIsExistenceDB {
    return [[NSFileManager defaultManager] fileExistsAtPath:_yDBPath];
}

#pragma mark 初始化FMDatabase
- (void)yInitDB {
    if (![self yCheckIsExistenceDB]) {
        NSArray *yArray = [_yDBPath componentsSeparatedByString:@"Documents/"];
        [self yCreateDoucmentsSubDirectory:[yArray lastObject]];
    }
    if (![_yDBBackupPath isEqualToString:_yDBPath]) {
        _yDBBackupPath = _yDBPath;
        [self yRelease_yFMDB];
        _yFMDB = [FMDatabase databaseWithPath:_yDBBackupPath];
    } else if (!_yFMDB) {
        _yFMDB = [FMDatabase databaseWithPath:_yDBBackupPath];
    } else {
        return;
    }
}

#pragma mark 释放 _yFMDB
- (void)yRelease_yFMDB {
    _yFMDB = nil;
}

#pragma mark 打开数据库
- (BOOL)yOpenDB {
    BOOL yOpenResult = [_yFMDB open];
    return yOpenResult;
}

#pragma mark 关闭数据库
- (BOOL)yCloseDB {
    BOOL yCloseResult = [_yFMDB close];
    if (yCloseResult) {
        return yCloseResult;
    } else {
        return yCloseResult;
    }
}

#pragma mark 删除数据库
- (BOOL)yDeleteDB {
    if ([self yCheckIsExistenceDB]) {
        NSError *yError;
        return [[NSFileManager defaultManager] removeItemAtPath:_yDBBackupPath error:&yError];
    }
    return TRUE;
}

#pragma mark 查看表是否存在
- (BOOL)yCheckIsExistenceTable {
    YDBINITOPENCLOSERELEASE(FMResultSet *yResultSet = [_yFMDB executeQuery:[YMosaicSql yGetTableNumberSqlWithTableName:_yTableName]];)
    if (yResultSet) {
        return TRUE;
    } else {
        return FALSE;
    }
}

#pragma mark 创建表
- (BOOL)yCreateTableWithClass:(Class)yClass {
    YDBINITOPENCLOSERELEASE(BOOL yResultSet = [_yFMDB executeUpdate:[YMosaicSql yCreateTableSqlWithTableName:_yTableName withClass:yClass]];)
    return yResultSet;
}

#pragma mark 删除表
- (BOOL)yDeleteTable {
    YDBINITOPENCLOSERELEASE(BOOL yResultSet = [_yFMDB executeUpdate:[YMosaicSql yDeleteTableSqlWithTableName:_yTableName]];)
    return yResultSet;
}

#pragma mark 增加(插入)数据
- (BOOL)yInsertWithDataObject:(id)yDataObject isModifyPrimaryKey:(YMODIFYPRIMARYKEY)yModify {
    BOOL yResult = FALSE;
    YDBINITOPENCLOSERELEASE(
    {
        switch (yModify) {
            case YDEFAULT: {
                yResult = [_yFMDB executeUpdate:[YMosaicSql yInsertDataSqlWithTableName:_yTableName withDataObject:yDataObject]];
            } break;
            case YMODIFY: {
                ///保留
            } break;
            case YACCORDINGTOOBJECT: {
                ///保留
            } break;
            default: break;
        }
    })
    return yResult;
}

#pragma mark 删除数据
- (BOOL)yDeleteWithDataObject:(id)yDataObject {
    BOOL yResult = FALSE;
    YDBINITOPENCLOSERELEASE(yResult = [_yFMDB executeUpdate:[YMosaicSql yDeleteDataSqlWithTableName:_yTableName withDataObject:yDataObject]];)
    return yResult;
}

#pragma mark 删除数据
- (BOOL)yDeleteWithRange:(NSString *)yRange withCondition:(NSString *)yCondition {
    BOOL yResult = FALSE;
    YDBINITOPENCLOSERELEASE(yResult = [_yFMDB executeUpdate:[YMosaicSql yDeleteDataSqlWithTableName:_yTableName withRange:yRange withCondition:yCondition]];)
    return yResult;
}

#pragma mark 修改(更新)数据
- (BOOL)yUpdateWithDataObject:(id)yDataObject withCondition:(NSString *)yCondition {
    BOOL yResult = FALSE;
    YDBINITOPENCLOSERELEASE(yResult = [_yFMDB executeUpdate:[YMosaicSql yUpdateDataSqlWithTableName:_yTableName withDataObject:yDataObject withCondition:yCondition]];)
    return yResult;
}

#pragma mark 查找数据
- (NSArray *)yQueryWithClass:(Class)yClass
                   withRange:(NSString *)yRange
               withCondition:(NSString *)yCondition
                   withOrder:(NSString *)yOrder {
    NSArray *yKeys = [YMosaicSql yPropertyKeys:yClass];
    [self yInitDB];
    [self yOpenDB];
    FMResultSet *yResult = [_yFMDB executeQuery:[YMosaicSql yQueryDataSqlWithTableName:_yTableName withRange:yRange withCondition:yCondition withOrder:yOrder]];
    NSMutableArray *yResultMutArr = [[NSMutableArray alloc]init];
    while ([yResult next]) {
        id yResultObject = [yClass new];
        for (NSString *yKeysItem in yKeys) {
            NSString *yKeysNew = [NSString stringWithFormat:@"set%@:",[self yFirstAlphabetUpper:yKeysItem]];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            
            [yResultObject performSelector:NSSelectorFromString(yKeysNew) withObject:[yResult stringForColumn:yKeysItem]];
#pragma clang diagnostic pop
            
        }
        [yResultMutArr addObject:yResultObject];
    }
    [self yCloseDB];
    [self yRelease_yFMDB];
    return yResultMutArr;
}

#pragma mark 取表中最后一条数据
- (NSArray *)yGetTableLastDataWithClass:(Class)yClass {
    NSArray *yKeys = [YMosaicSql yPropertyKeys:yClass];
    [self yInitDB];
    [self yOpenDB];
    
    FMResultSet *yResult = [_yFMDB executeQuery:[YMosaicSql yGetLastDataSqlWithTableName:_yTableName withCondition:[yKeys firstObject]]];
    NSMutableArray *yResultMutArr = [[NSMutableArray alloc]init];
    while ([yResult next]) {
        id yResultObject = [yClass new];
        for (NSString *yKeysItem in yKeys) {
            NSString *yKeysNew = [NSString stringWithFormat:@"set%@:",[self yFirstAlphabetUpper:yKeysItem]];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            
            [yResultObject performSelector:NSSelectorFromString(yKeysNew) withObject:[yResult stringForColumn:yKeysItem]];
#pragma clang diagnostic pop
            
        }
        [yResultMutArr addObject:yResultObject];
    }
    [self yCloseDB];
    [self yRelease_yFMDB];
    return yResultMutArr;
}

#pragma mark 查看表中的数据总数
- (NSUInteger)yGetTableDataNumber {
    [self yInitDB];
    [self yOpenDB];
    FMResultSet *yResultSet = [_yFMDB executeQuery:[YMosaicSql yGetTableNumberSqlWithTableName:_yTableName]];
    
    NSInteger yNumber = 0;
    while ([yResultSet next]) {
        yNumber = [[yResultSet stringForColumn:@"count"] integerValue];
        break;
    }
    [self yCloseDB];
    [self yRelease_yFMDB];
    return yNumber;
}

#pragma mark 根据数据对象，定位该条数据在表中的位置
- (NSUInteger)yLocateObjectPositionWithObject:(id)yObject {
    [self yInitDB];
    [self yOpenDB];
    FMResultSet *yResultSet = [_yFMDB executeQuery:[YMosaicSql yGetObjectFrontNumberSqlWithTableName:_yTableName withObject:yObject]];
    
    NSInteger yNumber = 0;
    while ([yResultSet next]) {
        yNumber = [[yResultSet stringForColumn:@"count"] integerValue];
        break;
    }
    [self yCloseDB];
    [self yRelease_yFMDB];
    return yNumber + 1;
}

#pragma mark 根据条件，定位该条数据在表中的位置数组
- (NSArray *)yLocateObjectPositionWithClass:(Class)yClass
                                  withRange:(NSString *)yRange
                              withCondition:(NSString *)yCondition {
    [self yInitDB];
    [self yOpenDB];
    NSArray *yKeyArray = [YMosaicSql yPropertyKeys:yClass]; // 获取属性名集合
    NSArray *yArray = [self yQueryWithClass:yClass withRange:yRange withCondition:yCondition withOrder:nil];
    
    [self yInitDB];
    [self yOpenDB];
    NSMutableArray *yLocateMutArr = [[NSMutableArray alloc]init];
    if (yArray.count > 0) {
        for (id yDataModel in yArray) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            NSString *yPrimaryKeyValueStr = [yDataModel performSelector:NSSelectorFromString(((NSString *)[yKeyArray firstObject]))];
#pragma clang diagnostic pop
            FMResultSet *yResultSet = [_yFMDB executeQuery:[YMosaicSql yGetAccordingConditionNumberSqlWithTableName:_yTableName withCondition:[NSString stringWithFormat:@"%@=%@",[yKeyArray firstObject],yPrimaryKeyValueStr]]];
            
            while ([yResultSet next]) {
                [yLocateMutArr addObject:[NSString stringWithFormat:@"%d",([[yResultSet stringForColumn:@"count"] integerValue] + 1)]];
                break;
            }
        }
    } else {
        [self yCloseDB];
        [self yRelease_yFMDB];
        return nil;
    }
    
    [self yCloseDB];
    [self yRelease_yFMDB];
    return yLocateMutArr;
}

@end
