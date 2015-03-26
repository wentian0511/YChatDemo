

#import <Foundation/Foundation.h>


@interface NSString (NSString_Hashing)

/**
 *	@brief	hash
 *
 *	@return	hash完的字符串
 */
- (NSString *)MD5Hash;

/**
 *	@brief	hash文件数据
 *
 *	@param 	path 	文件的存放路径
 *
 *	@return	hash的文件数据
 */
+ (NSString *)fileMD5:(NSString *)path;

/**
 *	@brief	二进制数据hash
 *
 *	@param 	data 	二进制数据
 *
 *	@return	hash完的二进制数据
 */
+ (NSString *)dataMD5:(NSData *)data;

@end
