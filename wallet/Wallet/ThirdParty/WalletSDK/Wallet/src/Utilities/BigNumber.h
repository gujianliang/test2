

#import <Foundation/Foundation.h>

@interface BigNumber : NSObject


+ (BigNumber*)constantNegativeOne;
+ (BigNumber*)constantZero;
+ (BigNumber*)constantOne;
+ (BigNumber*)constantTwo;
+ (BigNumber*)constantWeiPerEther;

// BigNumber 只适用于整数间的计算

+ (instancetype)bigNumberWithDecimalString: (NSString*)decimalString;   // 10进制 整数值 字符串,
+ (instancetype)bigNumberWithHexString: (NSString*)hexString;           // 16进制 数值 字符串
+ (instancetype)bigNumberWithBase36String: (NSString*)base36String;

+ (instancetype)bigNumberWithData: (NSData*)data;
+ (instancetype)bigNumberWithNumber: (NSNumber*)number;
+ (instancetype)bigNumberWithInteger: (NSInteger)integer;


- (BigNumber*)add: (BigNumber*)other;

- (BigNumber*)sub: (BigNumber*)other;

- (BigNumber*)mul: (BigNumber*)other;

- (BigNumber*)div: (BigNumber*)other;

- (BigNumber*)mod: (BigNumber*)other;

- (NSUInteger)hash;
- (NSComparisonResult)compare: (id)other;
- (BOOL)isEqual:(id)object;

- (BOOL)lessThan: (BigNumber*)other;
- (BOOL)lessThanEqualTo: (BigNumber*)other;
- (BOOL)greaterThan: (BigNumber*)other;
- (BOOL)greaterThanEqualTo: (BigNumber*)other;

@property (nonatomic, readonly) NSString *decimalString;
@property (nonatomic, readonly) NSString *hexString;
@property (nonatomic, readonly) NSString *base36String;

@property (nonatomic, readonly) BOOL isSafeUnsignedIntegerValue;
@property (nonatomic, readonly) NSUInteger unsignedIntegerValue;

@property (nonatomic, readonly) BOOL isSafeIntegerValue;
@property (nonatomic, readonly) NSInteger integerValue;

@property (nonatomic, readonly) NSData *data;


@property (nonatomic, readonly) BOOL isZero;
@property (nonatomic, readonly) BOOL isNegative;

@end
